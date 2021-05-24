Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748ADC04FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 10:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B036044F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 10:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhEXKoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 06:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232397AbhEXKoE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 06:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621852953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mWbglNuDlh0e5Gk8vb/7ZdkbPTDB14ow0pk7gb6N8lw=;
        b=FBe0M40RiKhJxftDCYs8L6s6R6clJc5nsyyyO47suqlm22Wa+9qYYBSQaFfezeoPZDDa6K
        R1pu9yBoqaHVwQiJZ93a6jk6OCeOdUWJvDtXFSL/gIj05/IyQOh4o8Jv4BgwDd0UZQWuAX
        D9D9lVxxP2P/uBK5akBTZjzSuE+EnG4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-mvt7Xi-wO8S6elnps2Fn_g-1; Mon, 24 May 2021 06:42:31 -0400
X-MC-Unique: mvt7Xi-wO8S6elnps2Fn_g-1
Received: by mail-qv1-f71.google.com with SMTP id a29-20020a0ca99d0000b02901ec0ad2c871so27088590qvb.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 May 2021 03:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mWbglNuDlh0e5Gk8vb/7ZdkbPTDB14ow0pk7gb6N8lw=;
        b=fQOrZ2hHiA/Z7xyWLK7uN3dNYUzPB1B0y76i4ggc2rJ5V3Vh5LVLigW9A17yuTOsQ4
         Ji6xoba3Gh1Vbi2jXSc5iq/e/8Tl5RIJHfiLk8cIB8cjNPhcVzJh1Q2NobAT5TCOuaEX
         PmpCu12yBntnHJok0KNt0ivRo96hU5OlzDhm2c92LnPf0m+E0SwruT8YuNocDfhcWczU
         XsLxuLAZ4tbN+IKIXVO9l6wWBXF37vcy9uep/+70qnYMwqECwG6Ntx837Ka250RcOHj8
         kCaJi6b5hF27rM2+rDystnZPlQ5CMyaaKBRvKZlmxKA5y5PJWqcAHV1Ep/gszJFZstsH
         BhGg==
X-Gm-Message-State: AOAM5306AqxwXLZOgYsCatEH8aFVIOhkfTZRuQItztGBNTGqcVObWOFi
        gIZgyY1/p0L2ymPsyloBL9TgI31MGHM1RsxBD/b1gi2fyShqyi4dOhGK5PcJ0uJ/Mpq6TKFTHOX
        5uI1bYPoVwHbHR8iacVfY
X-Received: by 2002:a37:9b51:: with SMTP id d78mr27845906qke.441.1621852950774;
        Mon, 24 May 2021 03:42:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZYMQfmI7u/rTxx4xfSyKoZM1u8Poe4q+yqvJy4QzxmDPlGPW9Uy8jKoUUSpk/xMTr93CMFw==
X-Received: by 2002:a37:9b51:: with SMTP id d78mr27845878qke.441.1621852950494;
        Mon, 24 May 2021 03:42:30 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id f7sm3325308qtm.18.2021.05.24.03.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 03:42:30 -0700 (PDT)
Date:   Mon, 24 May 2021 06:42:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <YKuDFNdxIqLKfIbg@bfoster>
References: <162181807472.202929.18194381144862527586.stgit@locust>
 <162181808584.202929.10474310046605173335.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162181808584.202929.10474310046605173335.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 23, 2021 at 06:01:25PM -0700, Darrick J. Wong wrote:
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
> extent size hint, we'll simply turn off the hint to correct the error.
> Second, if someone tries to misconfigure a file via the fssetxattr
> ioctl, we'll fail the ioctl.  Third, we reverify both extent size hint
> values when we propagate heritable inode attributes from parent to
> child, so that we prevent misconfigurations from spreading.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |   13 +++++++++++++
>  fs/xfs/libxfs/xfs_trans_inode.c |   15 +++++++++++++++
>  fs/xfs/xfs_inode.c              |   29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl.c              |   15 +++++++++++++++
>  4 files changed, 72 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 045118c7bf78..23c19e632c2d 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -589,6 +589,19 @@ xfs_inode_validate_extsize(
>  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
>  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
>  
> +	/*
> +	 * This comment describes a historic gap in this verifier function.
> +	 * On older kernels, XFS doesnt't check that the extent size hint is
> +	 * an integer multiple of the rt extent size on a directory with both
> +	 * RTINHERIT and EXTSZINHERIT flags set.  This results in corruption
> +	 * shutdowns when the misaligned hint propagates into new realtime
> +	 * files, since they do check the rextsize alignment of the hint for
> +	 * files with the REALTIME flag set.  There could be filesystems with
> +	 * misconfigured directories in the wild, so we cannot add it to the
> +	 * verifier now because that would cause new corruption shutdowns on
> +	 * the directories.
> +	 */
> +

One of the things that confused me about the previous version is whether
the verifier changes would have triggered corruption on read of a
misconfigured inode. If so, that seems to conflict with propagation
mitigation if we can't read such a pre-existing inode in the first
place. Is that not still a factor here too?

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

Hmm.. if we're going to also clear the state from preexisting
directories (vs. just mitigate propagation), it kind of makes me wonder
why we wouldn't just clear the bad settings from in-core inodes on read.
Wouldn't that also prevent the state from propagating and/or clear it
from directories on next modification?

Brian

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

