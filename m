Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:17068 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbeI3FBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 01:01:47 -0400
Date: Sun, 30 Sep 2018 08:31:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] libxfs: fix xfs_trans_alloc reservation abuse
Message-ID: <20180929223131.GI31060@dastard>
References: <153809666117.32548.6836488790026631787.stgit@magnolia>
 <153809668914.32548.55544268146936270.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153809668914.32548.55544268146936270.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Sep 27, 2018 at 06:04:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Various xfsprogs tools have been abusing the transaction reservation
> system by allocating the transaction with zero reservation.  This has
> always worked in the past because userspace transactions do not require
> reservations.  However, once we merge deferred ops into the transaction
> structure, we will need to use a permanent reservation type to set up
> any transaction that can roll.  tr_itruncate has all we need, so use
> that as the reservation dummy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/proto.c    |   19 +++++++++----------
>  mkfs/xfs_mkfs.c |    4 ++--
>  repair/phase5.c |    4 ++--
>  repair/phase6.c |   20 ++++++++------------
>  repair/rmap.c   |    7 +++----
>  5 files changed, 24 insertions(+), 30 deletions(-)
> 
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 07d019d6..9da0587e 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -123,9 +123,8 @@ getres(
>  	uint		r;
>  
>  	for (i = 0, r = MKFS_BLOCKRES(blocks); r >= blocks; r--) {
> -		struct xfs_trans_res    tres = {0};
> -
> -		i = -libxfs_trans_alloc(mp, &tres, r, 0, 0, &tp);
> +		i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,

I'm wondering if this should explicitly call out that it's a dummy
reservation rather than using the itruncate reservation? e.g. these
places use:

	i = -libxfs_trans_alloc_perm(mp, blks, rtblks, flags, &tp);

And the implementation of this function then goes and uses the
itruncate reservation with a comment explaining what thay is used

(open to a better name - "dummy" doesn't seem right - perm, rolling,
deferred, etc all seem appropriate to indicate that it's an
allocation for a permanent transaction type for rolling/defered
transactions).

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
