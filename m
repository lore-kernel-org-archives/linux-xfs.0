Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IEgeOS193939
	for <linux-xfs@oss.sgi.com>; Fri, 18 May 2012 09:42:40 -0500
Message-ID: <4FB65FDD.3000500@sgi.com>
Date: Fri, 18 May 2012 09:42:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
	<20120516184231.GK16099@sgi.com>
	<4FB3FA1D.6050102@canonical.com> <4FB41C1D.8000808@sgi.com>
	<20120518101010.GW25351@dastard>
In-Reply-To: <20120518101010.GW25351@dastard>
Content-Type: multipart/mixed; boundary="------------050700040006090501030703"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Chris J Arges <chris.j.arges@canonical.com>

This is a multi-part message in MIME format.
--------------050700040006090501030703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/18/12 05:10, Dave Chinner wrote:

> On Wed, May 16, 2012 at 04:29:01PM -0500, Mark Tinguely wrote:

>> What I know so far:
>> I have log cleaner kicker added to xlog_grant_head_wake(). This

The reserve space waiter list has perl scripts and the flusher.

>
> What's a "log cleaner"? I've never heard that term before use for
> XFS, so I can only assume you are talking about waking the xfsaild.
> If that's the case, can you just say "pushing the AIL" rather
> than making up new terminology?

You are right. I borrowed the term from the comments in the code to 
"kick the dirty buffers out".

>
>> kicker at best would prevent waiting for the next sync before
>> starting the log cleaner.
>
> Can you post the patch?

Sure. This test has a small log, the transactions are large proportional 
to the log, and the processes are related. This results in the perl 
scripts quickly filling the log but the processes in the test become 
blocked. With no transactions coming in to push the cleaning of the AIL, 
the IO stalls until the next sync. After the sync, the backlog of 
waiters will quickly fill the log and everything stalls again until the 
next sync. We knew this could happen theory, but logs are generally not 
this small to see it in reality. The patch just keeps cleaning while 
there are waiters for log space. If another transaction has already 
started the cleaning process, this new request to clean is ignored.

>
>> I have one machine that has been running for 2 days without hanging.
>> Actually, now I would prefer it to hurry up and hang.
>>

The machine running the test for 3+ day finally hung. It has the same 
pattern as the other hangs: 200-250K of the reserved space left, an 
empty AIL and small amount of reserved space on the CIL.

>> Here is what see on the machine that is hung:
>>
>> A few processes (4-5) are hung waiting to get space on the log.
>> There isn't enough free space on the log for the first transaction
>> and it waits. All other processes will have to wait behind the first
>> process. 251,811 bytes of the original 589,842 bytes should still be
>> free (if my hand free space calculations are correct).
>>
>> The AIL is empty.
>
> So the CIL has consumed ~50% of the log, and the background flusher
> has not triggered? Why didn't the background CIL flush fire?
>
>> There is nothing to clean. Any new transaction at
>> this point will kick the cleaner, and it still can't start the first
>> waiter, so it joins the wait list.
>
> Assuming you mean the cleaner is the xfsaild, then if the AIL is
> empty, waking the xfsaild will do nothing because there is nothing
> for it to act on.

Yes, the AIL is empty.


>> The only XFS traffic at this point is inode reclaim worker. This is
>> to be expected.
>>
>> The CIL has entries, nothing is waiting on the CIL.
>> xc_current_sequence = 117511 xc_push_seq = 117510. So there is
>> nothing for the CIL worker to do.
>
> It means that we're stalled on the CIL, not on the AIL. The question
> is, as I asked above, why didn't the background flusher fire when
> the last transaction completed and saw the CIL over the hard flush
> threshold?
>
> If you dump the CIL context structure, you can find out how much
> space has been consumed by the items queued on the CIL.

The CIL seems to have only 30-70K reserved (depending on which hang you
look at). it does not meet the XLOG_CIL_SPACE_LIMIT for the background
worker to push the CIL.

Since this does not match up with the approx 300-350K that is reported 
to be reserved, I traversed the log_item list to see if that CIL amount 
seemed reasonable, and it does.

>>
>> 117511 is the largest sequence number that I have found so far in
>> the xfs_log_item list. There are a few entries with smaller sequence
>> numbers and the following strange entry:
>>
>> 77th entry in the xfs_log_item list:
>>
>> crash>  struct xfs_log_item ffff88083222b5b8
>> struct xfs_log_item {
>>    li_ail = {
>>      next = 0xffff88083222b5b0,
>
> that points 8 bytes backwards.
>
>>      prev = 0x0
>
> And that indicates that this was never part of a log item as the
> list head is always initialised.
>
>>    },
>>    li_lsn = 0,
>
> never committed
>
>>    li_desc = 0x9f5d9f5d,
>
> that's supposed to be a pointer
>
>>    li_mountp = 0xffff88083116e300,
>>    li_ailp = 0x0,
>
> Never initialised as a log item.
>
>>    li_type = 0,
>
> Impossible.
>
>>    li_flags = 0,
>>    li_bio_list = 0x0,
>>    li_cb = 0,
>>    li_ops = 0xffff88083105de00,
>>    li_cil = {
>>      next = 0xffff880832ad9f08,
>>      prev = 0xffff880831751448
>>    },
>>    li_lv = 0xc788c788,
>
> supposed to be a pointer
>
>>    li_seq = -131906182637504
>
> That's a pointer: 0xFFFF880832D71840
>
> So this looks like it some form of memory corruption - either a use
> after free, the memory has been been overwritten or the list has
> been pointed off into lala land.

>> Everything in this entry is bad except the li_cil.next and
>> li_cil.prev. It looks like li_ail.next is really part of a list that
>> starts at 0xffff88083222b5b0. The best explanation is a junk
>> addresses was inserted into the li_cil chain.
>
> It seems unlikely, but if you turn on kmemleak it might find a
> memory leak or overwrite that is causing this.
>
>>
>> This is a single data point which could be anything including bad
>> hardware. I will continue to traverse this list until I can get the
>> other box to hang. If someone want to traverse their xfs_log_item
>> list ...
>
> Given how little it looks like a log item, I'm not sure you can
> follow those pointers - do they even link up with other log items?

Yes, this was the second to last entry. The next/previous links were 
correct, but everything else in this structure is bad. That is why I 
suspect the wrong address was inserted into the log_item list.

I came to the same conclusion that this does not explain the problem, 
the other hangs do not have a corrupted entry. As strange as this entry 
is, I decided to ignore this entry and go back and try to account for 
all the reserved space.


> Still, this doesn't explain the hang at all - the CIL forms a new
> list every time a checkpoint occurs, and this corruption would cause
> a crash trying to walk the li_lv list when pushed. So it comes back
> to why hasn't the CIL been pushed? what does the CIL context
> structure look like?

The CIL context on the machine that was running 3+ days before hanging.

struct xfs_cil_ctx {
   cil = 0xffff88034a8c5240,
   sequence = 1241833,
   start_lsn = 0,
   commit_lsn = 0,
   ticket = 0xffff88034e0ebc08,
   nvecs = 237,
   space_used = 39964,
   busy_extents = {
     next = 0xffff88034b287958,
     prev = 0xffff88034d10c698
   },
   lv_chain = 0x0,
   log_cb = {
     cb_next = 0x0,
     cb_func = 0,
     cb_arg = 0x0
   },
   committing = {
     next = 0xffff88034c84d120,
     prev = 0xffff88034c84d120
   }
}


--Mark Tinguely.



--------------050700040006090501030703
Content-Type: text/plain;
 name="xfs_ail_clean.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_ail_clean.patch"

Start the cleaning of the log when still full after last clean.
---
 fs/xfs/xfs_log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -191,8 +191,10 @@ xlog_grant_head_wake(
 
 	list_for_each_entry(tic, &head->waiters, t_queue) {
 		need_bytes = xlog_ticket_reservation(log, head, tic);
-		if (*free_bytes < need_bytes)
+		if (*free_bytes < need_bytes) {
+			xlog_grant_push_ail(log, need_bytes);
 			return false;
+		}
 
 		*free_bytes -= need_bytes;
 		trace_xfs_log_grant_wake_up(log, tic);

--------------050700040006090501030703
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------050700040006090501030703--
