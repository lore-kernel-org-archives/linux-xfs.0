Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622AAC10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3263824699
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="io7cyark"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgCJLXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:23:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29992 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgCJLXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583839402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LS0rA4e1NQfzwiPKiIjehw2LHJnwTML9kimcD4RWQV8=;
        b=io7cyarkyGvLSUiU8kzWDLux7r0gSl1k8qTKCWJ66QNS2lF3JLf6ZInqBsM7OAuBQ06mkm
        4MgL/cqsIdBa63sHQrERwmlbocXT9BF5+m2ljKUzAaZOW4pUJc4oe9wKcAnV9UyAKmv1II
        STgwdaU/2L0phVpOkbtc7f34QCMXc/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-dDXKXYYrNt2pl4pTIS8-MQ-1; Tue, 10 Mar 2020 07:23:18 -0400
X-MC-Unique: dDXKXYYrNt2pl4pTIS8-MQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D535A8017DF;
        Tue, 10 Mar 2020 11:23:17 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C622D8D553;
        Tue, 10 Mar 2020 11:23:14 +0000 (UTC)
Date:   Tue, 10 Mar 2020 07:23:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/6] xfs: remove the xfs_agfl_t typedef
Message-ID: <20200310112312.GB50276@bfoster>
References: <20200306145220.242562-1-hch@lst.de>
 <20200306145220.242562-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145220.242562-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:52:16AM -0700, Christoph Hellwig wrote:
> There is just a single user left, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_format.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 8c7aea7795da..11a450e00231 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -783,15 +783,15 @@ typedef struct xfs_agi {
>   */
>  #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
>  #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
> -#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
> +#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
>  
> -typedef struct xfs_agfl {
> +struct xfs_agfl {
>  	__be32		agfl_magicnum;
>  	__be32		agfl_seqno;
>  	uuid_t		agfl_uuid;
>  	__be64		agfl_lsn;
>  	__be32		agfl_crc;
> -} __attribute__((packed)) xfs_agfl_t;
> +} __attribute__((packed));
>  
>  #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
>  
> -- 
> 2.24.1
> 

