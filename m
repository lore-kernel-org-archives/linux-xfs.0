Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0QGD34Z252991 for <xfs@oss.sgi.com>; Thu, 26 Jan 2012 10:13:03 -0600
Message-ID: <4F217B8E.60601@sgi.com>
Date: Thu, 26 Jan 2012 10:13:02 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 04/12] xfs: cleanup xfs_log_space_wake
References: <20111212141346.986825692@bombadil.infradead.org>	<20111212141434.065702206@bombadil.infradead.org>	<4F1DB36E.3060207@sgi.com>
	<20120125161041.GB8360@infradead.org> <4F205358.5070702@sgi.com>
In-Reply-To: <4F205358.5070702@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 01/25/12 13:09, Mark Tinguely wrote:
> On 01/25/12 10:10, Christoph Hellwig wrote:
>> On Mon, Jan 23, 2012 at 01:22:22PM -0600, Mark Tinguely wrote:
>>> On 01/-10/63 13:59, Christoph Hellwig wrote:
>>>> Remove the now unused opportunistic parameter, and use the the
>>>> xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
>>>> to care about the opportunistic wakeups.
>>>>
>>>> Signed-off-by: Christoph Hellwig<hch@lst.de>
>>>
>>> Looks good. My only concern is the way that xlog_grant_push_ail()
>>> tries to kick start the writing of the log. It seems to me that a
>>> combination of very large log requests could plug the log until the
>>> next sync.
>>
>> How exactly?
>>
>
> Thanks for giving me enough rope to hang myself :)
>
> I looked at it again and it could plug for a while, but not necessarily
> until the next sync.
>
> I was looking at the fact that when the log is full,
> xlog_grant_push_ail() will overlap cleaning threshold lsn for a bunch of
> requests come in. This is because xlog_grant_push_ail() uses the current
> tail when calculating cleaning threshold. This cleaning overlap will
> happen until xfs_ail_push() cleans the space and the moves the log tail.
>
> If a (unrealistically) big request sized greater than MAX(log size/4,
> 256) follows some other requests then the big request determines the
> amount cleaned out of the queue. When the space is cleaned out, the
> earlier processes waiting for the log are awoken and use up the cleaned
> space, and there will not be enough space for the big request. Future
> requests will clean up to MAX(their request size, log size/4, 256). This
> will not be enough to satisfy the big request at the front of the
> request queue. We will have to wait another cleaning cycle for the tail
> to move and another log space request but even this big request would
> eventually get satisfied.
>
>
>
>
> --Mark Tinguely


Would it be out of line to kick start the cleaning process when we know 
there are more processes sleeping but there is not enough available 
space to wake them?

This would eliminate all my "plugging" concerns and does not require 
changes elsewhere.

STATIC bool
xlog_grant_head_wake(
         struct log              *log,
         struct xlog_grant_head  *head,
         int                     *free_bytes)
{
         struct xlog_ticket      *tic;
         int                     need_bytes;

         list_for_each_entry(tic, &head->waiters, t_queue) {
                 need_bytes = xlog_ticket_reservation(log, head, tic);
-               if (*free_bytes < need_bytes)
+               if (*free_bytes < need_bytes) {
+                       xlog_grant_push_ail(log, need_bytes);
                         return false;
+               }

                 *free_bytes -= need_bytes;
                 trace_xfs_log_grant_wake_up(log, tic);
                 wake_up_process(tic->t_task);
         }

         return true;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
