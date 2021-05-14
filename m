Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5D3C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEB46145B
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhENMjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 08:39:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhENMjn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 May 2021 08:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620995912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zlTiVCLBrfx6YeGbeO0CnV2V9SddxIT2nQAwNUCUI50=;
        b=Tg+cTVcl0PudLur62N1SYp4o6S4YcKVYqsHanbm3rt8l9A6DGh5QdYSo12OGpe84Gkr+Ei
        RD0h13wplxerN35yHvo9Tb3ngo2iVjOv7oxLiy8vtpKBoi9gLDTC1w3yhSs542BjeHEbbb
        T+UsoTKVeakUiuwl5D/oHUA1qIeyNiY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-Mswhw8KxMCmJ-zEyJ-gRYg-1; Fri, 14 May 2021 08:38:30 -0400
X-MC-Unique: Mswhw8KxMCmJ-zEyJ-gRYg-1
Received: by mail-qt1-f200.google.com with SMTP id d10-20020a05622a100ab02901b8224bae03so20073026qte.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 05:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zlTiVCLBrfx6YeGbeO0CnV2V9SddxIT2nQAwNUCUI50=;
        b=IhDsrnAOPXRgDTPCBnkIK6RWYzuf0MDK3trH5gjK0aMCGYgzDRLldD9GbTo5yDLUBV
         fMyjpzXCjZjrDRM5yej3pqB1Yb3eaWyufnZiPmxuKpZ4dpYq1b4B8Bz+fgFSeV+4ZH3c
         ULwk019B+U2yy1RojPp05CVJFm9Sk0W6Q498xXMk5J2htogCOxIuEbGqR+1zLXu1g95l
         S+mQ9p6WpS9ubDr8wlBNWGHjyDm2GuUaCcpUB/NYRS8IcmEhNytQbwbdwNTW/2r/fC1j
         V5yjyC4r+zc1//sWQMC/RiGXZy+iU8tacefhZs+hK86il+mdbjIWamPfkmCkjE3f+0N+
         21HQ==
X-Gm-Message-State: AOAM531zz+LRT+AMQTk3d2gQ9r/W1cDTUqmJLdOCLE/XycpciVnTXJew
        m1uU2JvaQgCuMkaZjKopV+Amb9/NKsyEAPN4JIfCg47PDFsQhH3a7ClPJoFXcVSEt+j2NSQc1cv
        ab35Pu7lQUpAYWtlw4Chb
X-Received: by 2002:a05:620a:10b4:: with SMTP id h20mr42568471qkk.341.1620995909918;
        Fri, 14 May 2021 05:38:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzekrNn4YmapTcccp8TFDxSsMgdYJxGnwwXt5nk07/9lEza20qlfYJz9vtTZcb5hgqCQED9Zw==
X-Received: by 2002:a05:620a:10b4:: with SMTP id h20mr42568456qkk.341.1620995909750;
        Fri, 14 May 2021 05:38:29 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id t11sm4601667qkm.123.2021.05.14.05.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:38:29 -0700 (PDT)
Date:   Fri, 14 May 2021 08:38:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't propagate invalid extent size hints to
 new files
Message-ID: <YJ5vQ2GHFw2EilJO@bfoster>
References: <162086770193.3685783.14418051698714099173.stgit@magnolia>
 <162086771324.3685783.12562187598352097487.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086771324.3685783.12562187598352097487.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Under the current inode extent size hint validation rules, it's possible
> to set extent size hints on directories along with an 'inherit' flag so
> that the values will be propagated to newly created regular files.  (The
> directories themselves do not care about the hint values.)
> 
> For these directories, the alignment of the hint is checked against the
> data device even if the directory also has the rtinherit hint set, which
> means that one can set a directory's hint value to something that isn't
> an integer multiple of the realtime extent size.  This isn't a problem
> for the directory itself, but the validation routines require rt extent
> alignment for realtime files.
> 
> If the unaligned hint value and the realtime bit are both propagated
> into a newly created regular realtime file, we end up writing out an
> incorrect hint that trips the verifiers the next time we try to read the
> inode buffer, and the fs shuts down.  Fix this by cancelling the hint
> propagation if it would cause problems.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hmm.. this seems a bit unfortunate. Is the purpose of this flag
cancellation behavior basically to accommodate existing filesystems that
might have this incompatible combination in place?

Brian

>  fs/xfs/xfs_inode.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0369eb22c1bb..db81e8c22708 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -689,6 +689,7 @@ xfs_inode_inherit_flags(
>  	struct xfs_inode	*ip,
>  	const struct xfs_inode	*pip)
>  {
> +	xfs_failaddr_t		failaddr;
>  	unsigned int		di_flags = 0;
>  	umode_t			mode = VFS_I(ip)->i_mode;
>  
> @@ -728,6 +729,14 @@ xfs_inode_inherit_flags(
>  	if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
>  		di_flags |= XFS_DIFLAG_FILESTREAM;
>  
> +	/* Make sure the extsize actually validates properly. */
> +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags);
> +	if (failaddr) {
> +		di_flags &= ~(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT);
> +		ip->i_extsize = 0;
> +	}
> +
>  	ip->i_diflags |= di_flags;
>  }
>  
> @@ -737,12 +746,22 @@ xfs_inode_inherit_flags2(
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
> +	/* Make sure the cowextsize actually validates properly. */
> +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> +	if (failaddr) {
> +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> +		ip->i_cowextsize = 0;
> +	}
>  }
>  
>  /*
> 

