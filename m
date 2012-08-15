Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F29f5b050826 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 21:09:41 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MeXTLpfoUJ5u7XVS for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 19:09:39 -0700 (PDT)
Date: Wed, 15 Aug 2012 12:09:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v6 PATCH 3/5] xfs: Add pquotaino to on-disk super block
Message-ID: <20120815020936.GS2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230241.20477.50076.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120720230241.20477.50076.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 20, 2012 at 06:02:41PM -0500, Chandra Seetharaman wrote:
> Add a new field to the superblock to add support for seperate pquota
> with a specific version.
> 
> Define a macro to differentiate superblock with and without OQUOTA.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_itable.c       |    3 +-
>  fs/xfs/xfs_mount.c        |   58 ++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_qm.c           |   18 +++++++++----
>  fs/xfs/xfs_qm_syscalls.c  |   30 +++++++++++++++++-----
>  fs/xfs/xfs_quota.h        |    8 ------
>  fs/xfs/xfs_sb.h           |   20 ++++++++++++---
>  fs/xfs/xfs_super.c        |   15 +++++++----
>  fs/xfs/xfs_trans_dquot.c  |    4 ++-
>  include/linux/dqblk_xfs.h |    1 +
>  9 files changed, 123 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index eff577a..0fa60b4 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -42,7 +42,8 @@ xfs_internal_inum(
>  {
>  	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
>  		(xfs_sb_version_hasquota(&mp->m_sb) &&
> -		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
> +		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
> +		  ino == mp->m_sb.sb_pquotino)));
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 22f23fd..992ec29 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -108,6 +108,7 @@ static const struct {
>      { offsetof(xfs_sb_t, sb_logsunit),	 0 },
>      { offsetof(xfs_sb_t, sb_features2),	 0 },
>      { offsetof(xfs_sb_t, sb_bad_features2), 0 },
> +    { offsetof(xfs_sb_t, sb_pquotino), 0 },

Can you line up the "0 }," part with the rest of the structure?

>      { sizeof(xfs_sb_t),			 0 }
>  };
>  
> @@ -618,6 +619,35 @@ xfs_sb_from_disk(
>  	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
>  	to->sb_features2 = be32_to_cpu(from->sb_features2);
>  	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
> +
> +	if (xfs_sb_version_has_no_oquota(to)) {

<crash>

My brain just core dumped on that name - "has no old quota"?  "old
quota" could mean anything, and it doesn't describe the change in
on-disk format being made.

The feature being added is a "separate project quota inode", so the
feature bit and related functions need to reflect that.  Hence I
think a better name is something like "has project quota inode" i.e
XFS_SB_VERSION2_PQUOTINO, xfs_sb_version_has_pquotino() and so on,
which matches the above addition to the superblock fields...

> +		if (to->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
> +			xfs_notice(mp, "Super block has XFS_OQUOTA bits with "
> +			"version NO_OQUOTA. Fixing it.\n");
> +			to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +		}
> +		to->sb_pquotino = be64_to_cpu(from->sb_pquotino);

So we have a feature bit set, but old quota bits set. How can that
happen?

If it does occur, doesn't that mean we cannot trust the group or
project quotas to be correct, so at minimum this case needs to
trigger a quotacheck for both group and project quotas?

And if we can't enumerate how it can happen, then should we even
allow it to be "fixed" automatically?

> +	} else {
> +		if (to->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
> +			xfs_notice(mp, "Super block has XFS_[G|P]UOTA bits in "
> +				"older version. Fixing it.\n");
> +			to->sb_qflags &= ~(XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
> +					XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD);

Again, how can that happen, and why isn't it a sign of corruption
that requires external intervention? If those bits are set, we can't
trust the quota to be correct, so at minimum we need to force a
quota check.

> +		}
> +		if (to->sb_qflags & XFS_OQUOTA_ENFD)
> +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
> +		if (to->sb_qflags & XFS_OQUOTA_CHKD)
> +			to->sb_qflags |= (to->sb_qflags & XFS_PQUOTA_ACCT) ?
> +					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;

what do you do if both XFS_PQUOTA_ACCT and XFS_GQUOTA_ACCT are set?
i.e. both quotas were active even though the feature bit wasn't set?

This "fix it automatically" issue seems to be problematic to me
because it isn't clear whether we can get into these states, or if
we do, what the correct resolution of the problem is....


> +		to->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
> +
> +		if (to->sb_qflags & XFS_PQUOTA_ACCT) {
> +			to->sb_pquotino = to->sb_gquotino;
> +			to->sb_gquotino = NULLFSINO;
> +		}

This needs a comment explaining that the in-memory code will use the
sb_pquotino for project quotas (i.e. behave as though the feature
bit is always set), so we ahve to set up the in-memory image that
way and convert it back to the old format when writing out the
superblock.

> +	}
>  }
>  
>  /*
> @@ -637,11 +667,22 @@ xfs_sb_to_disk(
>  	int		first;
>  	int		size;
>  	 __uint16_t	tmp16;
> +	xfs_ino_t	gquotino;
>  
>  	ASSERT(fields);
>  	if (!fields)
>  		return;
>  
> +	/*
> +	 * On-disk version earlier than NO_OQUOTA doesn't have sb_pquotino.
> +	 * so, we need to copy the value to gquotino field.
> +	 */
> +	if (!xfs_sb_version_has_no_oquota(from) &&

<boom>

Double negative! (not has no old quota).

Another reason for naming it PQUOTINO....

> +			(from->sb_qflags & (XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD)))
> +		gquotino = from->sb_pquotino;
> +	else
> +		gquotino = from->sb_gquotino;

Also, only do this transformation if we are modifying the group
quota inode.....

> +
>  	while (fields) {
>  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
>  		first = xfs_sb_info[f].offset;
> @@ -651,7 +692,8 @@ xfs_sb_to_disk(
>  
>  		if (size == 1 || xfs_sb_info[f].type == 1) {
>  			memcpy(to_ptr + first, from_ptr + first, size);
> -		} else if (f == XFS_SBS_QFLAGS) {
> +		} else if ((f == XFS_SBS_QFLAGS) &&

[ no need for the extra (). ]

> +				 !xfs_sb_version_has_no_oquota(from)) {
>  			/*
>  			 * The in-core version of sb_qflags do not have
>  			 * XFS_OQUOTA_* flags, whereas the on-disk version
> @@ -671,6 +713,8 @@ xfs_sb_to_disk(
>  				tmp16 |= XFS_OQUOTA_CHKD;
>  
>  			*(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
> +		} else if (f == XFS_SBS_GQUOTINO) {
> +			*(__be64 *)(to_ptr + first) = cpu_to_be64(gquotino);

.... i.e. here.

>  		} else {
>  			switch (size) {
>  			case 2:
> @@ -759,6 +803,12 @@ reread:
>  		goto reread;
>  	}
>  
> +	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
> +			XFS_IS_PQUOTA_ON(mp)) {
> +		mp->m_sb.sb_pquotino = mp->m_sb.sb_gquotino;
> +		mp->m_sb.sb_gquotino = NULLFSINO;
> +	}

why this is necessary? Didn't the earlier xfs_sb_from_disk() call
deal with this?

> +
>  	/* Initialize per-cpu counters */
>  	xfs_icsb_reinit_counters(mp);
>  
> @@ -1646,6 +1696,12 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
>  	first = sizeof(xfs_sb_t);
>  	last = 0;
>  
> +	if (!xfs_sb_version_has_no_oquota(&mp->m_sb) &&
> +			XFS_IS_PQUOTA_ON(mp)) {
> +		fields &= (__int64_t)~XFS_SB_PQUOTINO;
> +		fields |= (__int64_t)XFS_SB_GQUOTINO;
> +	}

This will set the XFS_SB_GQUOTINO unconditionally. It only needs to
be set this if the XFS_SB_PQUOTINO field is set.

> @@ -838,19 +840,22 @@ xfs_qm_qino_alloc(
>  		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
>  				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
>  		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
> -			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
> +			XFS_SB_GQUOTINO | XFS_SB_PQUOTINO | XFS_SB_QFLAGS));

Did you test this with CONFIG_XFS_DEBUG=y? It will always fail
because you didn't add XFS_SB_PQUOTINO to the sbfields mask....

> @@ -1156,7 +1161,8 @@ xfs_qm_dqusage_adjust(
>  	 * rootino must have its resources accounted for, not so with the quota
>  	 * inodes.
>  	 */
> -	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
> +	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino ||
> +				ino == mp->m_sb.sb_pquotino) {

	if (ino == mp->m_sb.sb_uquotino ||
	    ino == mp->m_sb.sb_gquotino ||
	    ino == mp->m_sb.sb_pquotino) {

> @@ -413,17 +414,18 @@ xfs_qm_scall_getqstat(
>  	struct fs_quota_stat	*out)
>  {
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	struct xfs_inode	*uip, *gip;
> -	boolean_t		tempuqip, tempgqip;
> +	struct xfs_inode	*uip, *gip, *pip;
> +	boolean_t		tempuqip, tempgqip, temppqip;
>  
> -	uip = gip = NULL;
> -	tempuqip = tempgqip = B_FALSE;
> +	uip = gip = pip = NULL;
> +	tempuqip = tempgqip = temppqip = B_FALSE;

Line per declaration and initialisation.

> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index 8fd7894..7373108 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -81,11 +81,15 @@ struct xfs_mount;
>  #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
>  #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* parent pointers */
>  #define XFS_SB_VERSION2_PROJID32BIT	0x00000080	/* 32 bit project id */
> +#define XFS_SB_VERSION2_NO_OQUOTA	0x00000100	/* No OQUOTA and     *
> +							 * separate project  *
> +							 * quota field       */

see my comments about naming this above.

> @@ -250,7 +255,7 @@ typedef enum {
>  	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
>  	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
>  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
> -	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
> +	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_PQUOTINO,

You got the name right here ;)

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 595f5ac..b475057 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -399,12 +399,6 @@ xfs_parseargs(
>  	}
>  #endif
>  
> -	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> -	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE))) {
> -		xfs_warn(mp, "cannot mount with both project and group quota");
> -		return EINVAL;
> -	}
> -
>  	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
>  		xfs_warn(mp, "sunit and swidth must be specified together");
>  		return EINVAL;
> @@ -1330,6 +1324,15 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_destroy_counters;
>  
> +	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
> +	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
> +	    !xfs_sb_version_has_no_oquota(&mp->m_sb)) {
> +		xfs_warn(mp, "Super block does not support "
> +				 "project and group quota together");
> +		error = EINVAL;
> +		goto out_free_sb;
> +	}

This check belongs in xfs_finish_flags().

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
