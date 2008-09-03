Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 23:48:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m836mJBc015349
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 23:48:19 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA00568 for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 16:49:45 +1000
Subject: Re: REVIEW: Zero rest of superblock sector always
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Sep 2008 16:52:09 +1000
Message-ID: <op.ugv707p33jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

BTW. If it wasn't obvious, it's for xfs_repair :)

On Wed, 03 Sep 2008 16:51:19 +1000, Barry Naujok <bnaujok@sgi.com> wrote:

> I found that zeroing the "garbage" beyond the end of the superblock in
> the first sector of each AG rather inconsistant. It depended on some
> obscure combination of version bits to be set.
>
> The following code zeroes the unused portion of all superblocks if
> there is any garbage at all in them.
>
> ---
>   xfsprogs/repair/agheader.c |  196  
> ++++++++++++++++-----------------------------
>   1 file changed, 74 insertions(+), 122 deletions(-)
>
> Index: ci/xfsprogs/repair/agheader.c
> ===================================================================
> --- ci.orig/xfsprogs/repair/agheader.c
> +++ ci/xfsprogs/repair/agheader.c
> @@ -213,82 +213,66 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb
>    *
>    * And everything else in the buffer beyond either sb_width,
>    * sb_dirblklog (v2 dirs), or sb_logsectsize can be zeroed.
> - *
> - * Note: contrary to the name, this routine is called for all
> - * superblocks, not just the secondary superblocks.
>    */
> -int
> -secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
> -	xfs_agnumber_t i)
> +static int
> +sb_whack(
> +	xfs_mount_t	*mp,
> +	xfs_sb_t	*sb,		/* translated superblock */
> +	xfs_buf_t	*sbuf,		/* disk buffer with superblock */
> +	xfs_agnumber_t	agno)
>   {
> -	int do_bzero;
> -	int size;
> -	char *ip;
> -	int rval;
> -
> -	rval = do_bzero = 0;
> +	int		rval = 0;
> +	int		do_zero = 0;
> +	int		size;
> +	char		*ip;
>
>   	/*
> -	 * mkfs's that stamped a feature bit besides the ones in the mask
> -	 * (e.g. were pre-6.5 beta) could leave garbage in the secondary
> -	 * superblock sectors.  Anything stamping the shared fs bit or better
> -	 * into the secondaries is ok and should generate clean secondary
> -	 * superblock sectors.  so only run the zero check on the
> -	 * potentially garbaged secondaries.
> +	 * Check for garbage beyond the last field.
> +	 * Use field addresses instead so this code will still
> +	 * work against older filesystems when the superblock
> +	 * gets rev'ed again with new fields appended.
>   	 */
> -	if (pre_65_beta ||
> -	    (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK) == 0 ||
> -	    sb->sb_versionnum < XFS_SB_VERSION_4)  {
> -		/*
> -		 * Check for garbage beyond the last field.
> -		 * Use field addresses instead so this code will still
> -		 * work against older filesystems when the superblock
> -		 * gets rev'ed again with new fields appended.
> -		 */
> -		if (XFS_SB_VERSION_HASMOREBITS(sb))
> -			size = (__psint_t)&sb->sb_features2
> -				+ sizeof(sb->sb_features2) - (__psint_t)sb;
> -		else if (XFS_SB_VERSION_HASLOGV2(sb))
> -			size = (__psint_t)&sb->sb_logsunit
> +	if (xfs_sb_version_hasmorebits(sb))
> +		size = (__psint_t)&sb->sb_bad_features2
> +				+ sizeof(sb->sb_bad_features2) - (__psint_t)sb;
> +	else if (xfs_sb_version_haslogv2(sb))
> +		size = (__psint_t)&sb->sb_logsunit
>   				+ sizeof(sb->sb_logsunit) - (__psint_t)sb;
> -		else if (XFS_SB_VERSION_HASSECTOR(sb))
> -			size = (__psint_t)&sb->sb_logsectsize
> +	else if (xfs_sb_version_hassector(sb))
> +		size = (__psint_t)&sb->sb_logsectsize
>   				+ sizeof(sb->sb_logsectsize) - (__psint_t)sb;
> -		else if (XFS_SB_VERSION_HASDIRV2(sb))
> -			size = (__psint_t)&sb->sb_dirblklog
> +	else if (xfs_sb_version_hasdirv2(sb))
> +		size = (__psint_t)&sb->sb_dirblklog
>   				+ sizeof(sb->sb_dirblklog) - (__psint_t)sb;
> -		else
> -			size = (__psint_t)&sb->sb_width
> +	else
> +		size = (__psint_t)&sb->sb_width
>   				+ sizeof(sb->sb_width) - (__psint_t)sb;
> -		for (ip = (char *)((__psint_t)sb + size);
> -		     ip < (char *)((__psint_t)sb + mp->m_sb.sb_sectsize);
> -		     ip++)  {
> -			if (*ip)  {
> -				do_bzero = 1;
> -				break;
> -			}
> -		}
>
> -		if (do_bzero)  {
> -			rval |= XR_AG_SB_SEC;
> -			if (!no_modify)  {
> -				do_warn(
> -		_("zeroing unused portion of %s superblock (AG #%u)\n"),
> -					!i ? _("primary") : _("secondary"), i);
> -				memset((void *)((__psint_t)sb + size), 0,
> -					mp->m_sb.sb_sectsize - size);
> -			} else
> -				do_warn(
> -		_("would zero unused portion of %s superblock (AG #%u)\n"),
> -					!i ? _("primary") : _("secondary"), i);
> +	for (ip = XFS_BUF_PTR(sbuf) + size;
> +	     ip < XFS_BUF_PTR(sbuf) + mp->m_sb.sb_sectsize; ip++) {
> +		if (*ip)  {
> +			do_zero = 1;
> +			break;
>   		}
>   	}
>
> +	if (do_zero)  {
> +		rval |= XR_AG_SB_SEC;
> +		if (!no_modify) {
> +			do_warn(_("zeroing unused portion of %s superblock "
> +				"(AG #%u)\n"), !agno ? _("primary") :
> +				_("secondary"), agno);
> +			memset(XFS_BUF_PTR(sbuf) + size, 0,
> +				mp->m_sb.sb_sectsize - size);
> +		} else
> +			do_warn(_("would zero unused portion of %s superblock "
> +				"(AG #%u)\n"), !agno ? _("primary") :
> +				_("secondary"), agno);
> +	}
> +
>   	/*
> -	 * now look for the fields we can manipulate directly.
> -	 * if we did a zero and that zero could have included
> -	 * the field in question, just silently reset it.  otherwise,
> -	 * complain.
> +	 * now look for the fields we can manipulate directly that
> +	 * may not have been zeroed above.
>   	 *
>   	 * for now, just zero the flags field since only
>   	 * the readonly flag is used
> @@ -296,11 +280,8 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
>   	if (sb->sb_flags)  {
>   		if (!no_modify)
>   			sb->sb_flags = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(_("bad flags field in superblock %d\n"), i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("bad flags field in superblock %d\n"), agno);
>   	}
>
>   	/*
> @@ -312,38 +293,24 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
>   	if (sb->sb_inprogress == 1 && sb->sb_uquotino)  {
>   		if (!no_modify)
>   			sb->sb_uquotino = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(
> -		_("non-null user quota inode field in superblock %d\n"),
> -				i);
> -
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("non-null user quota inode field in superblock %d\n"),
> +			agno);
>   	}
>
>   	if (sb->sb_inprogress == 1 && sb->sb_gquotino)  {
>   		if (!no_modify)
>   			sb->sb_gquotino = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(
> -		_("non-null group quota inode field in superblock %d\n"),
> -				i);
> -
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("non-null group quota inode field in superblock %d\n"),
> +			agno);
>   	}
>
>   	if (sb->sb_inprogress == 1 && sb->sb_qflags)  {
>   		if (!no_modify)
>   			sb->sb_qflags = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(_("non-null quota flags in superblock %d\n"),
> -				i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("non-null quota flags in superblock %d\n"), agno);
>   	}
>
>   	/*
> @@ -352,44 +319,31 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
>   	 * written at mkfs time (and the corresponding sb version bits
>   	 * are set).
>   	 */
> -	if (!XFS_SB_VERSION_HASSHARED(sb) && sb->sb_shared_vn != 0)  {
> +	if (!xfs_sb_version_hasshared(sb) && sb->sb_shared_vn)  {
>   		if (!no_modify)
>   			sb->sb_shared_vn = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(
> -		_("bad shared version number in superblock %d\n"),
> -				i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("bad shared version number in superblock %d\n"),
> +			agno);
>   	}
>
> -	if (!XFS_SB_VERSION_HASALIGN(sb) && sb->sb_inoalignmt != 0)  {
> +	if (!xfs_sb_version_hasalign(sb) && sb->sb_inoalignmt)  {
>   		if (!no_modify)
>   			sb->sb_inoalignmt = 0;
> -		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(
> -		_("bad inode alignment field in superblock %d\n"),
> -				i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("bad inode alignment field in superblock %d\n"),
> +			agno);
>   	}
>
> -	if (!XFS_SB_VERSION_HASDALIGN(sb) &&
> -	    (sb->sb_unit != 0 || sb->sb_width != 0))  {
> +	if (!xfs_sb_version_hasdalign(sb) && (sb->sb_unit || sb->sb_width)) {
>   		if (!no_modify)
>   			sb->sb_unit = sb->sb_width = 0;
> -		if (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK || !do_bzero)  {
> -			rval |= XR_AG_SB;
> -			do_warn(
> -		_("bad stripe unit/width fields in superblock %d\n"),
> -				i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +		rval |= XR_AG_SB;
> +		do_warn(_("bad stripe unit/width fields in superblock %d\n"),
> +			agno);
>   	}
>
> -	if (!XFS_SB_VERSION_HASSECTOR(sb) &&
> +	if (!xfs_sb_version_hassector(sb) &&
>   	    (sb->sb_sectsize != BBSIZE || sb->sb_sectlog != BBSHIFT ||
>   	     sb->sb_logsectsize != 0 || sb->sb_logsectlog != 0))  {
>   		if (!no_modify)  {
> @@ -398,13 +352,11 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
>   			sb->sb_logsectsize = 0;
>   			sb->sb_logsectlog = 0;
>   		}
> -		if (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK || !do_bzero)  {
> +		if (!do_zero)  {
>   			rval |= XR_AG_SB;
> -			do_warn(
> -		_("bad log/data device sector size fields in superblock %d\n"),
> -				i);
> -		} else
> -			rval |= XR_AG_SB_SEC;
> +			do_warn(_("bad log/data device sector size fields in "
> +				"superblock %d\n"), agno);
> +		}
>   	}
>
>   	return(rval);
> @@ -463,7 +415,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs
>   		rval |= XR_AG_SB;
>   	}
>
> -	rval |= secondary_sb_wack(mp, sbuf, sb, i);
> +	rval |= sb_whack(mp, sb, sbuf, i);
>
>   	rval |= verify_set_agf(mp, agf, i);
>   	rval |= verify_set_agi(mp, agi, i);
