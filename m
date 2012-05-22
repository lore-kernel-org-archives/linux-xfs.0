Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MMxHnq022666
	for <linux-xfs@oss.sgi.com>; Tue, 22 May 2012 17:59:17 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	n7JQ38FIKFhXuzs6 for <linux-xfs@oss.sgi.com>;
	Tue, 22 May 2012 15:59:15 -0700 (PDT)
Date: Wed, 23 May 2012 08:59:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120522225912.GI25351@dastard>
References: <CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
	<loom.20120510T180646-433@post.gmane.org>
	<20120516184231.GK16099@sgi.com> <4FB3FA1D.6050102@canonical.com>
	<4FB41C1D.8000808@sgi.com> <20120518101010.GW25351@dastard>
	<4FB65FDD.3000500@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FB65FDD.3000500@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: linux-xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Chris J Arges <chris.j.arges@canonical.com>

On Fri, May 18, 2012 at 09:42:37AM -0500, Mark Tinguely wrote:
> On 05/18/12 05:10, Dave Chinner wrote:
> >Still, this doesn't explain the hang at all - the CIL forms a new
> >list every time a checkpoint occurs, and this corruption would cause
> >a crash trying to walk the li_lv list when pushed. So it comes back
> >to why hasn't the CIL been pushed? what does the CIL context
> >structure look like?
> 
> The CIL context on the machine that was running 3+ days before hanging.
> 
> struct xfs_cil_ctx {
>   cil = 0xffff88034a8c5240,
>   sequence = 1241833,
>   start_lsn = 0,
>   commit_lsn = 0,
>   ticket = 0xffff88034e0ebc08,
>   nvecs = 237,
>   space_used = 39964,
>   busy_extents = {
>     next = 0xffff88034b287958,
>     prev = 0xffff88034d10c698
>   },
>   lv_chain = 0x0,
>   log_cb = {
>     cb_next = 0x0,
>     cb_func = 0,
>     cb_arg = 0x0
>   },
>   committing = {
>     next = 0xffff88034c84d120,
>     prev = 0xffff88034c84d120
>   }
> }

And the struct xfs_cil itself?

> Start the cleaning of the log when still full after last clean.
> ---
>  fs/xfs/xfs_log.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_log.c
> ===================================================================
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -191,8 +191,10 @@ xlog_grant_head_wake(
>  
>  	list_for_each_entry(tic, &head->waiters, t_queue) {
>  		need_bytes = xlog_ticket_reservation(log, head, tic);
> -		if (*free_bytes < need_bytes)
> +		if (*free_bytes < need_bytes) {
> +			xlog_grant_push_ail(log, need_bytes);

Ok, so that means every time the log tail is moved or a transaction
completes and returns unused space to the grant head, it pushes the
AIL target along.  But if we are hanging with an empty AIL, this is
not actually doing anything of note, just changing timing to make
whatever problem we have less common.  I'd remove this patch to make
reproducing the problem easier....

We've almost certainly got a CIL hang, and it looks like it is being
caused by an accounting leak. i.e.  if the CIL hasn't reached it's
push threshold (12.5% of the log space), but the AIL is empty and we
have the grant heads indicating that there is less than 25% of the
log space free, we are slowly leaking log space somewhere in the CIL
commit or checkpoint path.  Given that we've done 1.24 million
checkpoints in the above example, it's not a common thing. Given the
size of log, it may be related to log wrap commits, and it is also
worth noting that if this an accounting leak, it will eventually
result in a hard hang.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
