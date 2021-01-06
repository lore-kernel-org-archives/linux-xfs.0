Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1124AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 14:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFBE022B45
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 14:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbhAFO6g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 09:58:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbhAFO6g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 09:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609945028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQ7MDtTpbHog1vh4T74qII2qf7xREiHwPooUiSvPtfU=;
        b=WdhSotJHj9vy0FDH9JBXkeVP1H+K9AsHdWIiDhy7XkzMgHiNp6VIBJeUnsSZa3G8+Kwnal
        pJI7Y9mxaqFqci+MRAGwD226n72ZQLzbhqy0MX2/rABkbMGp8WV0BF/XmTtqwN1exAW+v4
        XbjrUu1yTnC9wwZf9MIyk8JTk8YeSy0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-l0jXqaiCNgivEvIxvS6otA-1; Wed, 06 Jan 2021 09:57:07 -0500
X-MC-Unique: l0jXqaiCNgivEvIxvS6otA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72C951800D41
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 14:57:06 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16C556087C;
        Wed,  6 Jan 2021 14:57:02 +0000 (UTC)
Date:   Wed, 6 Jan 2021 09:57:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: cosmetic changes to libxfs_inode_alloc
Message-ID: <20210106145701.GC361175@bfoster>
References: <a06e071c-be56-2e7d-cceb-82030f55e1f3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a06e071c-be56-2e7d-cceb-82030f55e1f3@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 05, 2021 at 04:02:18PM -0600, Eric Sandeen wrote:
> This pre-patch helps make the next libxfs-sync for 5.11 a bit
> more clear.
> 
> In reality, the libxfs_inode_alloc function matches the kernel's
> xfs_dir_ialloc so rename it for clarity before the rest of the
> sync, and change several variable names for the same reason.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
...
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 252cf91e..62eadaea 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
...
> @@ -559,25 +561,25 @@ libxfs_inode_alloc(
>  
>  	if (ialloc_context) {
>  
> -		xfs_trans_bhold(*tp, ialloc_context);
> +		xfs_trans_bhold(tp, ialloc_context);
>  
> -		error = xfs_trans_roll(tp);
> -		if (error) {
> +		code = xfs_trans_roll(tpp);

The subsequent uses of tp no longer refer to the right transaction after
this roll. FWIW, there is a subtle difference with the kernel code where
this call passes &tp and then updates tpp on return, but we could also
just update tp here if that's still good enough to facilitate the libxfs
sync.

Brian

> +		if (code) {
>  			fprintf(stderr, _("%s: cannot duplicate transaction: %s\n"),
> -				progname, strerror(error));
> +				progname, strerror(code));
>  			exit(1);
>  		}
> -		xfs_trans_bjoin(*tp, ialloc_context);
> -		error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
> +		xfs_trans_bjoin(tp, ialloc_context);
> +		code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr,
>  				   fsx, &ialloc_context, &ip);
>  		if (!ip)
> -			error = -ENOSPC;
> -		if (error)
> -			return error;
> +			code = -ENOSPC;
> +		if (code)
> +			return code;
>  	}
>  
>  	*ipp = ip;
> -	return error;
> +	return code;
>  }
>  
>  void
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 0fa6ffb0..8439efc4 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -453,7 +453,7 @@ parseproto(
>  	case IF_REGULAR:
>  		buf = newregfile(pp, &len);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					   &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -477,7 +477,7 @@ parseproto(
>  		}
>  		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
>  
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
>  					  &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode pre-allocation failed"), error);
> @@ -498,7 +498,7 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error) {
>  			fail(_("Inode allocation failed"), error);
> @@ -513,7 +513,7 @@ parseproto(
>  		tp = getres(mp, 0);
>  		majdev = getnum(getstr(pp), 0, 0, false);
>  		mindev = getnum(getstr(pp), 0, 0, false);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
>  				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -525,7 +525,7 @@ parseproto(
>  
>  	case IF_FIFO:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -537,7 +537,7 @@ parseproto(
>  		buf = getstr(pp);
>  		len = (int)strlen(buf);
>  		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -548,7 +548,7 @@ parseproto(
>  		break;
>  	case IF_DIRECTORY:
>  		tp = getres(mp, 0);
> -		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
> +		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
>  				&creds, fsxp, &ip);
>  		if (error)
>  			fail(_("Inode allocation failed"), error);
> @@ -640,7 +640,7 @@ rtinit(
>  
>  	memset(&creds, 0, sizeof(creds));
>  	memset(&fsxattrs, 0, sizeof(fsxattrs));
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rbmip);
>  	if (error) {
>  		fail(_("Realtime bitmap inode allocation failed"), error);
> @@ -657,7 +657,7 @@ rtinit(
>  	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
>  	libxfs_log_sb(tp);
>  	mp->m_rbmip = rbmip;
> -	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
> +	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
>  					&creds, &fsxattrs, &rsumip);
>  	if (error) {
>  		fail(_("Realtime summary inode allocation failed"), error);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 682356f0..f69afac9 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
>  		do_error(_("%d - couldn't iget root inode to make %s\n"),
>  			i, ORPHANAGE);*/
>  
> -	error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR,
> +	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
>  					1, 0, &zerocr, &zerofsx, &ip);
>  	if (error) {
>  		do_error(_("%s inode allocation failed %d\n"),
> 

