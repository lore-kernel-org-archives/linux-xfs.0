Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DA2D03B
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710870852; cv=none; b=mMDk9lAMFQhtHdJlNNZg49c7RLzlUIC/EUt1d7L7AdKl3XN5hWoCmBL3/XkYsBydlxNnT2azBI9d5nEP5mGQoFS6cQhEGBjP2xhQh8FTrAYktQyNCkfMOkJwVA2Kh/qCo/L3xHzuaWmApqkdLC+oMbO4TeIviAgimZ7YvQJ6Fd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710870852; c=relaxed/simple;
	bh=vhGYCFZtXZ3Z4fKbsA7FZ8gxOR0WTJhLWpuwd1PBNz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2iuj5YRye/DXQKAvU+SeWJwiuQp5jIeVlLcJak5QNmU5r2sTOuMsmEa20zIsiqkGPf0c7U87k0Tw8xCc5A/J9BN5cRSUOSdKXD4yOsWoexW0WHLk8sHmKNM+cE6PX0bcAT+GnFAoLzLKfxTc6wX2t26dZRk3yMaMdPstFTuZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EL+i9lf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EL+i9lf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB35C433F1;
	Tue, 19 Mar 2024 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710870852;
	bh=vhGYCFZtXZ3Z4fKbsA7FZ8gxOR0WTJhLWpuwd1PBNz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EL+i9lf+O+Sw/Dzz/s/H3U/hsRQMgGuwVNw+HrOGatv0Cffi5+/paxjumzCMOqrUW
	 iByrxImG7MiBGux+JbfNbHhTZGtstJ4mx7h2SsA4ogVDe/5uqq4eFkQi51AZ1htWDT
	 Zke8f1GGr7A+olgJD3+I1mLAtY9S3YKgBwpo6N0p6EuaCQpgigH8y9DvkwDMpkZkcs
	 VL9UPqmo5azBp7qaln5yoTEup5vzOlr4gr8/5NIK+QNOBEMVvuEjclaDtCaCe/E/Do
	 rUAXUim8EGHpM7CvLUN0+Js5E9qNJFKc4DHEA/cQLHhcammtzUhvt9qTui2bj+Cwh4
	 Xbi8kKNW4jBiw==
Date: Tue, 19 Mar 2024 10:54:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: internalise all remaining i_version support
Message-ID: <20240319175411.GW1927156@frogsfrogsfrogs>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240318225406.3378998-3-david@fromorbit.com>

On Tue, Mar 19, 2024 at 09:51:01AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we don't support SB_I_VERSION, completely internalise the
> remaining usage of inode->i_version. We use our own internal change
> counter now, and leave inode->i_version completely unused. This
> grows the xfs_inode by 8 bytes, but also allows us to use a normal
> uint64_t rather than an expensive atomic64_t for the counter.
> 
> This clears the way for implementing different inode->i_version
> functionality in the future whilst still maintaining the internal
> XFS change counters as they currently stand.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 7 ++-----
>  fs/xfs/libxfs/xfs_trans_inode.c | 5 +----
>  fs/xfs/xfs_icache.c             | 4 ----
>  fs/xfs/xfs_inode.c              | 4 +---
>  fs/xfs/xfs_inode.h              | 1 +
>  fs/xfs/xfs_inode_item.c         | 4 +---
>  fs/xfs/xfs_iops.c               | 1 -
>  7 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 68989f4bf793..cadd8be83cc4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -20,8 +20,6 @@
>  #include "xfs_dir2.h"
>  #include "xfs_health.h"
>  
> -#include <linux/iversion.h>
> -
>  /*
>   * If we are doing readahead on an inode buffer, we might be in log recovery
>   * reading an inode allocation buffer that hasn't yet been replayed, and hence
> @@ -244,8 +242,7 @@ xfs_inode_from_disk(
>  		xfs_iflags_set(ip, XFS_IPRESERVE_DM_FIELDS);
>  
>  	if (xfs_has_v3inodes(ip->i_mount)) {
> -		inode_set_iversion_queried(inode,
> -					   be64_to_cpu(from->di_changecount));
> +		ip->i_changecount = be64_to_cpu(from->di_changecount);
>  		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
>  		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
> @@ -339,7 +336,7 @@ xfs_inode_to_disk(
>  
>  	if (xfs_has_v3inodes(ip->i_mount)) {
>  		to->di_version = 3;
> -		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> +		to->di_changecount = cpu_to_be64(ip->i_changecount);
>  		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
>  		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index b82f9c7ff2d5..f9196eff6bab 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -15,8 +15,6 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
>  
> -#include <linux/iversion.h>
> -
>  /*
>   * Add a locked inode to the transaction.
>   *
> @@ -87,7 +85,6 @@ xfs_trans_log_inode(
>  	uint			flags)
>  {
>  	struct xfs_inode_log_item *iip = ip->i_itemp;
> -	struct inode		*inode = VFS_I(ip);
>  
>  	ASSERT(iip);
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> @@ -101,7 +98,7 @@ xfs_trans_log_inode(
>  	 */
>  	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags) &&
>  	    xfs_has_crc(ip->i_mount)) {
> -		atomic64_inc(&inode->i_version);
> +		ip->i_changecount++;
>  		flags |= XFS_ILOG_IVERSION;
>  	}
>  
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 74f1812b03cb..6c87b90754c4 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -26,8 +26,6 @@
>  #include "xfs_log_priv.h"
>  #include "xfs_health.h"
>  
> -#include <linux/iversion.h>
> -
>  /* Radix tree tags for incore inode tree. */
>  
>  /* inode is to be reclaimed */
> @@ -309,7 +307,6 @@ xfs_reinit_inode(
>  	int			error;
>  	uint32_t		nlink = inode->i_nlink;
>  	uint32_t		generation = inode->i_generation;
> -	uint64_t		version = inode_peek_iversion(inode);
>  	umode_t			mode = inode->i_mode;
>  	dev_t			dev = inode->i_rdev;
>  	kuid_t			uid = inode->i_uid;
> @@ -319,7 +316,6 @@ xfs_reinit_inode(
>  
>  	set_nlink(inode, nlink);
>  	inode->i_generation = generation;
> -	inode_set_iversion_queried(inode, version);
>  	inode->i_mode = mode;
>  	inode->i_rdev = dev;
>  	inode->i_uid = uid;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e7a724270423..3ca8e905dbd4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3,8 +3,6 @@
>   * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/iversion.h>
> -
>  #include "xfs.h"
>  #include "xfs_fs.h"
>  #include "xfs_shared.h"
> @@ -828,7 +826,7 @@ xfs_init_new_inode(
>  	ip->i_diflags = 0;
>  
>  	if (xfs_has_v3inodes(mp)) {
> -		inode_set_iversion(inode, 1);
> +		ip->i_changecount = 1;
>  		ip->i_cowextsize = 0;
>  		ip->i_crtime = tv;
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ab46ffb3ac19..0f9d32cbae72 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -42,6 +42,7 @@ typedef struct xfs_inode {
>  	struct rw_semaphore	i_lock;		/* inode lock */
>  	atomic_t		i_pincount;	/* inode pin count */
>  	struct llist_node	i_gclist;	/* deferred inactivation list */
> +	uint64_t		i_changecount;	/* # of attribute changes */

Now that we've separated this from i_version, should we export this via
bulkstat or something?

The code itself looks fine so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  	/*
>  	 * Bitsets of inode metadata that have been checked and/or are sick.
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index f28d653300d1..9ec88a84edfa 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -21,8 +21,6 @@
>  #include "xfs_error.h"
>  #include "xfs_rtbitmap.h"
>  
> -#include <linux/iversion.h>
> -
>  struct kmem_cache	*xfs_ili_cache;		/* inode log item */
>  
>  static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
> @@ -546,7 +544,7 @@ xfs_inode_to_log_dinode(
>  
>  	if (xfs_has_v3inodes(ip->i_mount)) {
>  		to->di_version = 3;
> -		to->di_changecount = inode_peek_iversion(inode);
> +		to->di_changecount = ip->i_changecount;
>  		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
>  		to->di_flags2 = ip->i_diflags2;
>  		to->di_cowextsize = ip->i_cowextsize;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 3940ad1ee66e..8a145ca7d380 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -28,7 +28,6 @@
>  
>  #include <linux/posix_acl.h>
>  #include <linux/security.h>
> -#include <linux/iversion.h>
>  #include <linux/fiemap.h>
>  
>  /*
> -- 
> 2.43.0
> 
> 
