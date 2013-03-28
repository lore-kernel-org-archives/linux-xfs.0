Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B4727F55
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 19:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D92AAAC010
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 17:51:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	d1rVtZAtnfJn6GvG for <xfs@oss.sgi.com>;
	Wed, 27 Mar 2013 17:51:18 -0700 (PDT)
Date: Thu, 28 Mar 2013 11:51:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
Message-ID: <20130328005106.GY6369@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130320004405.GC17758@dastard>
	<CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
	<20130321010149.GF17758@dastard>
	<CAEDdjHcP_An=CXSo3sL0w373wFfb=Zr-T7C2fUMuDbmrm6DDHQ@mail.gmail.com>
	<CAEDdjHdj9QD3OybyJwahpBDA=i8nxeLufaHDT0c9EEfdotp1Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEDdjHdj9QD3OybyJwahpBDA=i8nxeLufaHDT0c9EEfdotp1Pw@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 27, 2013 at 09:58:43PM +0000, Pedro Ribeiro wrote:
> Hi Dave (and others),
> 
> I've pretty much established the responsible: commit
> 437a255aa23766666aec78af63be4c253faa8d57
> (
> http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tree/releases/3.7.2/xfs-fix-direct-io-nested-transaction-deadlock.patch?id=HEAD
> ).

Seems completely unrelated to the problem you saw.

> Without this patch, the computer does not lock up in hibernate. So I
> understand that this is most likely a bug in ToI, not in xfs. Does this
> give you a better idea of how to solve the problem?

No.

> The only xfs-specific
> patch in ToI is below:
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 0eda725..55de808 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -511,6 +511,7 @@ xfsaild(
>   struct xfs_ail *ailp = data;
>   long tout = 0; /* milliseconds */
> 
> + set_freezable();
>   current->flags |= PF_MEMALLOC;

We do not ever set the PF_NOFREEZE, so set_freezable() is a no-op.
If ToI has introduced new freeze API dependencies, then I'm not
going to try to understand or fix them.

>   while (!kthread_should_stop()) {
> 
> Looking at the code blindly, it appears to be similar to what goes on in
> other filesystems...

That loop has a call to try_to_freeze() in it, which is how such
kthreads are supposed to handle freezing. i.e. once they enter a
state in which they can freeze, they call try_to_freeze() and then
get moved to the refrigerator.

You need to talk to the ToI developers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
