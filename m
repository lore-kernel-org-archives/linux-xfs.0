Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9354429DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 12:40:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18B49AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:40:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bHqO5ruSjNGJ7rbN for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 10:39:59 -0700 (PDT)
Message-ID: <5331BF53.6000300@redhat.com>
Date: Tue, 25 Mar 2014 10:39:31 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
References: <532CFA12.4040104@redhat.com>
	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
	<5331A930.9030402@sandeen.net>
	<20140325172508.GA4446@infradead.org>
In-Reply-To: <20140325172508.GA4446@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/25/14, 10:25 AM, Christoph Hellwig wrote:
> On Tue, Mar 25, 2014 at 09:05:04AM -0700, Eric Sandeen wrote:
>>>> Out of curiosity, is there any major reason we don't use 0 here
>>>> unconditionally? Are we worried about I/O completing before we have a
>>>> chance to decrement the reference?
>>>
>>> I think this should unconditionally avoid the schedule, and while we're
>>> at it we should kill _xfs_buf_ioend and opencode it here and at the
>>> other callsite.
>>
>> And then remove the flag from xfs_buf_ioend which is always 0 at that
>> point ...
> 
> Is it?  xfs_buf_bio_end_io should stil be passing 1, the bio end_io
> handler is the place we really need the workqueue for anyway.

These are the callers of xfs_buf_ioend:

  File              Function                 Line
0 xfs_buf.c         xfs_bioerror             1085 xfs_buf_ioend(bp, 0);
1 xfs_buf.c         _xfs_buf_ioend           1177 xfs_buf_ioend(bp, schedule);
2 xfs_buf_item.c    xfs_buf_item_unpin        494 xfs_buf_ioend(bp, 0);
3 xfs_buf_item.c    xfs_buf_iodone_callbacks 1138 xfs_buf_ioend(bp, 0);
4 xfs_inode.c       xfs_iflush_cluster       3015 xfs_buf_ioend(bp, 0);
5 xfs_log.c         xlog_bdstrat             1644 xfs_buf_ioend(bp, 0);
6 xfs_log_recover.c xlog_recover_iodone       386 xfs_buf_ioend(bp, 0);

so only _xfs_buf_ioend *might* pass something other than 0, and:

  File      Function           Line
0 xfs_buf.c xfs_buf_bio_end_io 1197 _xfs_buf_ioend(bp, 1);
1 xfs_buf.c xfs_buf_iorequest  1377 _xfs_buf_ioend(bp, bp->b_error ? 0 : 1);

At least up until now that was always called with "1"

>> Yeah I have a patch to do that as well; I wanted to separate the
>> bugfix from the more invasive cleanup, though - and I wanted to
>> get the fix out for review sooner.
> 
> Sure, feel free to leave all the cleanups to another patch.
> 
>> But yeah, I was unsure about whether or not to schedule at all here.
>> We come here from a lot of callsites and I'm honestly not sure what
>> the implications are yet.
> 
> I think the the delayed completion is always wrong from the submission
> path.  The error path is just a special case of a completion happening
> before _xfs_buf_ioapply returns.  The combination of incredibly fast
> hardware and bad preemption could cause the same bug you observed.

I wondered about that.

I'm not sure; I don't think it was the buf_rele inside xfs_buf_iorequest
that freed it, I think it was specifically the error path afterwards -
in my case, in xfs_trans_read_buf_map():

                                xfs_buf_	(bp);
					// xfs_buf_iorequest code below
					xfs_buf_hold(bp);
					atomic_set(&bp->b_io_remaining, 1);
					_xfs_buf_ioapply(bp); <-- gets error
					if (atomic_dec_and_test(&bp->b_io_remaining)
						xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
					xfs_buf_rele(bp); <- releases our hold
                        }

                        error = xfs_buf_iowait(bp); <-- sees error; would have waited otherwise
                        if (error) {
                                xfs_buf_ioerror_alert(bp, __func__);
                                xfs_buf_relse(bp); <--- freed here ?

but my bp refcounting & lifetime knowledge is lacking :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
