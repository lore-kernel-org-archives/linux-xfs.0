Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 22:27:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m256RGDi023443
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 22:27:21 -0800
Message-ID: <47CE3EBA.2040900@sgi.com>
Date: Wed, 05 Mar 2008 17:33:30 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [REVIEW #4] bad_features2 support in userspace
References: <op.t7i0f5123jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t7i0f5123jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good to me.

Barry Naujok wrote:
> Due to the issue of mounting filesystem with older kernels and
> potentially reading sb_features2 from the wrong location. It
> seems the best course of action is to always make sb_features2
> and sb_bad_features2 the same. This is pretty important as
> new bits in this are supposed to stop older kernels from
> mounting filesystems with unsupported features.
> 
> If sb_bad_features2 is zero, and the old kernel tries to read
> sb_features2 from this location during mount, it will succeed
> as it will read zero.
> 
> So, this patch changes mkfs.xfs to set sb_bad_features2 to
> the same as sb_features2, xfs_check and xfs_repair now also
> makes sure they are the same.
> 
> Barry.
> 
> -- 
> 
> 
> ===========================================================================
> xfsprogs/db/check.c
> ===========================================================================
> 
> --- a/xfsprogs/db/check.c    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/db/check.c    2008-03-05 15:28:58.638097511 +1100
> @@ -869,6 +869,14 @@ blockget_f(
>                  mp->m_sb.sb_frextents, frextents);
>          error++;
>      }
> +    if (mp->m_sb.sb_bad_features2 != mp->m_sb.sb_features2) {
> +        if (!sflag)
> +            dbprintf("sb_features2 (0x%x) not same as "
> +                "sb_bad_features2 (0x%x)\n",
> +                mp->m_sb.sb_features2,
> +                mp->m_sb.sb_bad_features2);
> +        error++;
> +    }
>      if ((sbversion & XFS_SB_VERSION_ATTRBIT) &&
>          !XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
>          if (!sflag)
> 
> ===========================================================================
> xfsprogs/db/sb.c
> ===========================================================================
> 
> --- a/xfsprogs/db/sb.c    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/db/sb.c    2008-02-29 17:16:33.770423296 +1100
> @@ -108,6 +108,7 @@ const field_t    sb_flds[] = {
>      { "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, 
> TYP_NONE },
>      { "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
>      { "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
> +    { "bad_features2", FLDT_UINT32X, OI(OFF(bad_features2)), C1, 0, 
> TYP_NONE },
>      { NULL }
>  };
> 
> 
> ===========================================================================
> xfsprogs/include/xfs_sb.h
> ===========================================================================
> 
> --- a/xfsprogs/include/xfs_sb.h    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/include/xfs_sb.h    2008-02-29 17:16:33.814417687 +1100
> @@ -151,6 +151,7 @@ typedef struct xfs_sb
>      __uint16_t    sb_logsectsize;    /* sector size for the log, bytes */
>      __uint32_t    sb_logsunit;    /* stripe unit size for the log */
>      __uint32_t    sb_features2;    /* additional feature bits */
> +    __uint32_t    sb_bad_features2; /* unusable space */
>  } xfs_sb_t;
> 
>  /*
> @@ -169,7 +170,7 @@ typedef enum {
>      XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
>      XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
>      XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
> -    XFS_SBS_FEATURES2,
> +    XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
>      XFS_SBS_FIELDCOUNT
>  } xfs_sb_field_t;
> 
> 
> ===========================================================================
> xfsprogs/libxfs/xfs_mount.c
> ===========================================================================
> 
> --- a/xfsprogs/libxfs/xfs_mount.c    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/libxfs/xfs_mount.c    2008-02-29 17:16:33.834415138 +1100
> @@ -140,6 +140,7 @@ static struct {
>      { offsetof(xfs_sb_t, sb_logsectsize),0 },
>      { offsetof(xfs_sb_t, sb_logsunit),     0 },
>      { offsetof(xfs_sb_t, sb_features2),     0 },
> +    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
>      { sizeof(xfs_sb_t),             0 }
>  };
> 
> 
> ===========================================================================
> xfsprogs/mkfs/xfs_mkfs.c
> ===========================================================================
> 
> --- a/xfsprogs/mkfs/xfs_mkfs.c    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/mkfs/xfs_mkfs.c    2008-03-05 15:27:37.568461787 +1100
> @@ -2103,6 +2103,13 @@ an AG size that is one stripe unit small
>              dirversion == 2, logversion == 2, attrversion == 1,
>              (sectorsize != BBSIZE || lsectorsize != BBSIZE),
>              sbp->sb_features2 != 0);
> +    /*
> +     * Due to a structure alignment issue, sb_features2 ended up in one
> +     * of two locations, the second "incorrect" location represented by
> +     * the sb_bad_features2 field. To avoid older kernels mounting
> +     * filesystems they shouldn't, set both field to the same value.
> +     */
> +    sbp->sb_bad_features2 = sbp->sb_features2;
> 
>      if (force_overwrite)
>          zero_old_xfs_structures(&xi, sbp);
> 
> ===========================================================================
> xfsprogs/repair/phase1.c
> ===========================================================================
> 
> --- a/xfsprogs/repair/phase1.c    2008-03-05 15:30:54.000000000 +1100
> +++ b/xfsprogs/repair/phase1.c    2008-03-05 15:19:09.513415413 +1100
> @@ -91,6 +91,19 @@ phase1(xfs_mount_t *mp)
>          primary_sb_modified = 1;
>      }
> 
> +    /*
> +     * Check bad_features2 and make sure features2 the same as
> +     * bad_features (ORing the two together). Leave bad_features2
> +     * set so older kernels can still use it and not mount unsupported
> +     * filesystems when it reads bad_features2.
> +     */
> +    if (sb->sb_bad_features2 != sb->sb_features2) {
> +        sb->sb_features2 |= sb->sb_bad_features2;
> +        sb->sb_bad_features2 = sb->sb_features2;
> +        primary_sb_modified = 1;
> +        do_warn(_("superblock has a features2 mismatch, correcting\n"));
> +    }
> +
>      if (primary_sb_modified)  {
>          if (!no_modify)  {
>              do_warn(_("writing modified primary superblock\n"));
> 
