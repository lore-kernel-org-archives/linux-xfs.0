Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46F6C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B802495C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 13:34:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S41jX3i9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgEANeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 09:34:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20332 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730046AbgEANeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 09:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588340045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BlqInBPPeTPN+lHZJRtJX3LzKtRsxEcsy2gLocYBBEg=;
        b=S41jX3i9l9UvhmcRl+aAIgvAiGWYjfZCDlnVZZQmylZ9Q2DbW96saj+jjc9WXN+epFJVMi
        vAzvIzZDIghLgh4zuKE2ggH3xe3YkoNbIlUocYJY7ddjmAVQBZJvhI687ZDS7/WfmqywAG
        s+8alFBhSDfo1p1px+e97bxHWHTWadM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-JJ5qnVyAMkWXbfyhJF-KBQ-1; Fri, 01 May 2020 09:34:01 -0400
X-MC-Unique: JJ5qnVyAMkWXbfyhJF-KBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B1FE8014C1;
        Fri,  1 May 2020 13:34:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF6B605CE;
        Fri,  1 May 2020 13:33:59 +0000 (UTC)
Date:   Fri, 1 May 2020 09:33:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: call xfs_iformat_fork from xfs_inode_from_disk
Message-ID: <20200501133357.GI40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501081424.2598914-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 10:14:14AM +0200, Christoph Hellwig wrote:
> We always need to fill out the fork structures when reading the inode,
> so call xfs_iformat_fork from the tail of xfs_inode_from_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c | 7 ++++---
>  fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
>  fs/xfs/xfs_log_recover.c      | 4 +---
>  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 39c5a6e24915c..02f06dec0a5a6 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -186,7 +186,7 @@ xfs_imap_to_bp(
>  	return 0;
>  }
>  
> -void
> +int
>  xfs_inode_from_disk(
>  	struct xfs_inode	*ip,
>  	struct xfs_dinode	*from)
> @@ -247,6 +247,8 @@ xfs_inode_from_disk(
>  		to->di_flags2 = be64_to_cpu(from->di_flags2);
>  		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
>  	}
> +
> +	return xfs_iformat_fork(ip, from);
>  }
>  
>  void
> @@ -647,8 +649,7 @@ xfs_iread(
>  	 * Otherwise, just get the truly permanent information.
>  	 */
>  	if (dip->di_mode) {
> -		xfs_inode_from_disk(ip, dip);
> -		error = xfs_iformat_fork(ip, dip);
> +		error = xfs_inode_from_disk(ip, dip);
>  		if (error)  {
>  #ifdef DEBUG
>  			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 9b373dcf9e34d..081230faf7bdc 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -54,7 +54,7 @@ int	xfs_iread(struct xfs_mount *, struct xfs_trans *,
>  void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
> -void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
> +int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
>  void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
>  			       struct xfs_dinode *to);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b13..464388125d20b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2870,9 +2870,7 @@ xfs_recover_inode_owner_change(
>  
>  	/* instantiate the inode */
>  	ASSERT(dip->di_version >= 3);
> -	xfs_inode_from_disk(ip, dip);
> -
> -	error = xfs_iformat_fork(ip, dip);
> +	error = xfs_inode_from_disk(ip, dip);
>  	if (error)
>  		goto out_free_ip;
>  
> -- 
> 2.26.2
> 

