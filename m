Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A48C2B9F8
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 11:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8369C6140F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 11:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhEYLzk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 07:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231770AbhEYLzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 07:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621943648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B4qIlqQSAhcNvFbfWS7RtkH8SmEoxOL0RY+lfACFKqw=;
        b=Z9WhWUk7RrbTGHIo/4ayZP9Ox/EvjYaQqEslVrUXF5bJR5cMLmwt+5NurN7Tb+lSGW5umc
        kn0lWmoK6BYLquRbmxKepRPFL3+j/GXVd+CNrvtPVyb7doK0PePFWjxVEL7XlkewM84g3q
        mUrNeukECuG6p2atjcrYhcwSPQJQ/9M=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-JFSXcU9ROdC_Vo705JXnmg-1; Tue, 25 May 2021 07:54:07 -0400
X-MC-Unique: JFSXcU9ROdC_Vo705JXnmg-1
Received: by mail-qv1-f72.google.com with SMTP id f17-20020a0cf3d10000b02901eda24e6b92so30246663qvm.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 04:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B4qIlqQSAhcNvFbfWS7RtkH8SmEoxOL0RY+lfACFKqw=;
        b=M0Wos3al2wJHUnbsungQbqMpfvNvEHnf5yAkjfy42SpAncHzDV5BLzkaBf9hWaDXWQ
         /UOSHLZLYeef6j5sHAU48HRtaUETWUHCmYC/p2hIUwy9GOZevmB9gfJOKFgt/mdYZAe8
         Pg/EmGU7WtjOXZhnHb2m9iBExZFnsbZTYXwEAXyluPZQEMQKiEQb53x+w9mi6SN9lKAu
         HhtRwJi6yk1YpAM/Q2MiMXkxV11wgSQgHsAy9yddvcJwKuDwDlUq8wQXEBRFgViHpARh
         DqwJGdgnstT2WvQqa6V95JCNvlMWDmjtSQ54X86WKXOsFkuMd7L4IJBQCIdq70a7Xo7Y
         aklA==
X-Gm-Message-State: AOAM532EDTU7CTOdFab5Y7woMAIcQTc9IUofp/bqsl+gU2Hg+Iad01Hx
        L17NMqPnsTJIMyS7XWCYxAz9Ewm8Cg85T5/AzxZdbyhXok3c0hvcQkAGsHaXPHJLtzPFaFxCwIa
        yWG4qMZTYmZV+PThj13uJ
X-Received: by 2002:a05:6214:288:: with SMTP id l8mr35409612qvv.21.1621943646509;
        Tue, 25 May 2021 04:54:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyo0/n+uye1GgHxBBwB8yEodz0nMdMgcYJ5ekALsm28r/Rv9crmHMcPz9V52Pm7SvOz+oyCA==
X-Received: by 2002:a05:6214:288:: with SMTP id l8mr35409589qvv.21.1621943646242;
        Tue, 25 May 2021 04:54:06 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id i11sm11860510qtv.8.2021.05.25.04.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 04:54:06 -0700 (PDT)
Date:   Tue, 25 May 2021 07:54:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v3] xfs: validate extsz hints against rt extent size when
 rtinherit is set
Message-ID: <YKzlXJ7XegjEi5JB@bfoster>
References: <20210525061531.GF202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525061531.GF202121@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 24, 2021 at 11:15:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The RTINHERIT bit can be set on a directory so that newly created
> regular files will have the REALTIME bit set to store their data on the
> realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> the directory, the hint will also be copied into the new file.
> 
> As pointed out in previous patches, for realtime files we require the
> extent size hint be an integer multiple of the realtime extent, but we
> don't perform the same validation on a directory with both RTINHERIT and
> EXTSZINHERIT set, even though the only use-case of that combination is
> to propagate extent size hints into new realtime files.  This leads to
> inode corruption errors when the bad values are propagated.
> 
> Because there may be existing filesystems with such a configuration, we
> cannot simply amend the inode verifier to trip on these directories and
> call it a day because that will cause previously "working" filesystems
> to start throwing errors abruptly.  Note that it's valid to have
> directories with rtinherit set even if there is no realtime volume, in
> which case the problem does not manifest because rtinherit is ignored if
> there's no realtime device; and it's possible that someone set the flag,
> crashed, repaired the filesystem (which clears the hint on the realtime
> file) and continued.
> 
> Therefore, mitigate this issue in several ways: First, if we try to
> write out an inode with both rtinherit/extszinherit set and an unaligned
> extent size hint, turn off the hint to correct the error.  Second, if
> someone tries to misconfigure a directory via the fssetxattr ioctl, fail
> the ioctl.  Third, reverify both extent size hint values when we
> propagate heritable inode attributes from parent to child, to prevent
> misconfigurations from spreading.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: disable incorrect hints at runtime instead of whacking filesystems
>     with verifier errors
> v3: revise the comment in the verifier to describe the source of the
>     problem, the observable symptoms, and how the solution fits the
>     historical context
> ---

I agree with Carlos in that I'd prefer to see some kind of one-shot
warning to indicate that the problem has been identified in the fs. Some
users may want to run a repair sequence (or would otherwise have no idea
they should consider one) just to put things back in a correct state.
(Perhaps putting the clearing code in a common helper with a flag to
toggle between extszhint and cowextszhint would facilitate?).

That aside, the patch looks Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c   |   22 ++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_trans_inode.c |   15 +++++++++++++++
>  fs/xfs/xfs_inode.c              |   29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c              |   15 +++++++++++++++
>  4 files changed, 81 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 045118c7bf78..f3254a4f4cb4 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -589,6 +589,28 @@ xfs_inode_validate_extsize(
>  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
>  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
>  
> +	/*
> +	 * This comment describes a historic gap in this verifier function.
> +	 *
> +	 * On older kernels, the extent size hint verifier doesn't check that
> +	 * the extent size hint is an integer multiple of the realtime extent
> +	 * size on a directory with both RTINHERIT and EXTSZINHERIT flags set.
> +	 * The verifier has always enforced the alignment rule for regular
> +	 * files with the REALTIME flag set.
> +	 *
> +	 * If a directory with a misaligned extent size hint is allowed to
> +	 * propagate that hint into a new regular realtime file, the result
> +	 * is that the inode cluster buffer verifier will trigger a corruption
> +	 * shutdown the next time it is run.
> +	 *
> +	 * Unfortunately, there could be filesystems with these misconfigured
> +	 * directories in the wild, so we cannot add a check to this verifier
> +	 * at this time because that will result a new source of directory
> +	 * corruption errors when reading an existing filesystem.  Instead, we
> +	 * permit the misconfiguration to pass through the verifiers so that
> +	 * callers of this function can correct and mitigate externally.
> +	 */
> +
>  	if (rt_flag)
>  		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
>  	else
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 78324e043e25..325f2dceec13 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -142,6 +142,21 @@ xfs_trans_log_inode(
>  		flags |= XFS_ILOG_CORE;
>  	}
>  
> +	/*
> +	 * Inode verifiers on older kernels don't check that the extent size
> +	 * hint is an integer multiple of the rt extent size on a directory
> +	 * with both rtinherit and extszinherit flags set.  If we're logging a
> +	 * directory that is misconfigured in this way, clear the hint.
> +	 */
> +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> +				   XFS_DIFLAG_EXTSZINHERIT);
> +		ip->i_extsize = 0;
> +		flags |= XFS_ILOG_CORE;
> +	}
> +
>  	/*
>  	 * Record the specific change for fdatasync optimisation. This allows
>  	 * fdatasync to skip log forces for inodes that are only timestamp
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0369eb22c1bb..e4c2da4566f1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -690,6 +690,7 @@ xfs_inode_inherit_flags(
>  	const struct xfs_inode	*pip)
>  {
>  	unsigned int		di_flags = 0;
> +	xfs_failaddr_t		failaddr;
>  	umode_t			mode = VFS_I(ip)->i_mode;
>  
>  	if (S_ISDIR(mode)) {
> @@ -729,6 +730,24 @@ xfs_inode_inherit_flags(
>  		di_flags |= XFS_DIFLAG_FILESTREAM;
>  
>  	ip->i_diflags |= di_flags;
> +
> +	/*
> +	 * Inode verifiers on older kernels only check that the extent size
> +	 * hint is an integer multiple of the rt extent size on realtime files.
> +	 * They did not check the hint alignment on a directory with both
> +	 * rtinherit and extszinherit flags set.  If the misaligned hint is
> +	 * propagated from a directory into a new realtime file, new file
> +	 * allocations will fail due to math errors in the rt allocator and/or
> +	 * trip the verifiers.  Validate the hint settings in the new file so
> +	 * that we don't let broken hints propagate.
> +	 */
> +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags);
> +	if (failaddr) {
> +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> +				   XFS_DIFLAG_EXTSZINHERIT);
> +		ip->i_extsize = 0;
> +	}
>  }
>  
>  /* Propagate di_flags2 from a parent inode to a child inode. */
> @@ -737,12 +756,22 @@ xfs_inode_inherit_flags2(
>  	struct xfs_inode	*ip,
>  	const struct xfs_inode	*pip)
>  {
> +	xfs_failaddr_t		failaddr;
> +
>  	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
>  		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  		ip->i_cowextsize = pip->i_cowextsize;
>  	}
>  	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
>  		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> +
> +	/* Don't let invalid cowextsize hints propagate. */
> +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> +	if (failaddr) {
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> +		ip->i_cowextsize = 0;
> +	}
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6407921aca96..1fe4c1fc0aea 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1291,6 +1291,21 @@ xfs_ioctl_setattr_check_extsize(
>  
>  	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
>  
> +	/*
> +	 * Inode verifiers on older kernels don't check that the extent size
> +	 * hint is an integer multiple of the rt extent size on a directory
> +	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
> +	 * misconfigure directories.
> +	 */
> +	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
> +	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
> +		unsigned int	rtextsize_bytes;
> +
> +		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> +		if (fa->fsx_extsize % rtextsize_bytes)
> +			return -EINVAL;
> +	}
> +
>  	failaddr = xfs_inode_validate_extsize(ip->i_mount,
>  			XFS_B_TO_FSB(mp, fa->fsx_extsize),
>  			VFS_I(ip)->i_mode, new_diflags);
> 

