Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B98FC10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E5A824697
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hRyu5w4V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJLX2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:23:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgCJLX2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583839407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V/T4wOV9EMHB1mvdRVrp3VUEScFhi8aE0vZYediJmJM=;
        b=hRyu5w4VryonJQhzwXMVbc5i1USclgJzKcp5W8KNuQQXUy1mrhby4xV3JK4dNI0z3y9i0D
        +NlyYvU6EBxFETb1R6uT4LAn3vtsNAlTJR4cdHUUPQbLfyyKPbJblejn7RmX84SVcf8Ykk
        5FveMzUg1rCBNsiDqE8s4QP0qejCe/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-anDsuOcWPymddW5n7R5S-w-1; Tue, 10 Mar 2020 07:23:25 -0400
X-MC-Unique: anDsuOcWPymddW5n7R5S-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF218801E66;
        Tue, 10 Mar 2020 11:23:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8718F369;
        Tue, 10 Mar 2020 11:23:24 +0000 (UTC)
Date:   Tue, 10 Mar 2020 07:23:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/6] xfs: remove XFS_BUF_TO_AGFL
Message-ID: <20200310112322.GC50276@bfoster>
References: <20200306145220.242562-1-hch@lst.de>
 <20200306145220.242562-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145220.242562-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:52:17AM -0700, Christoph Hellwig wrote:
> Just dereference bp->b_addr directly and make the code a little
> simpler and more clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c         | 2 +-
>  fs/xfs/libxfs/xfs_alloc.c      | 7 ++++---
>  fs/xfs/libxfs/xfs_format.h     | 1 -
>  fs/xfs/scrub/agheader_repair.c | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 831bdd035900..32ceba66456f 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -291,7 +291,7 @@ xfs_agflblock_init(
>  	struct xfs_buf		*bp,
>  	struct aghdr_init_data	*id)
>  {
> -	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(bp);
> +	struct xfs_agfl		*agfl = bp->b_addr;
>  	__be32			*agfl_bno;
>  	int			bucket;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f668e62acc56..58874150b0ce 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -588,7 +588,7 @@ xfs_agfl_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_mount;
> -	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
> +	struct xfs_agfl	*agfl = bp->b_addr;
>  	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
>  	int		i;
>  
> @@ -620,7 +620,7 @@ xfs_agfl_verify(
>  			return __this_address;
>  	}
>  
> -	if (!xfs_log_check_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
> +	if (!xfs_log_check_lsn(mp, be64_to_cpu(agfl->agfl_lsn)))
>  		return __this_address;
>  	return NULL;
>  }
> @@ -656,6 +656,7 @@ xfs_agfl_write_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_agfl		*agfl = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
>  	/* no verification of non-crc AGFLs */
> @@ -669,7 +670,7 @@ xfs_agfl_write_verify(
>  	}
>  
>  	if (bip)
> -		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +		agfl->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
>  
>  	xfs_buf_update_cksum(bp, XFS_AGFL_CRC_OFF);
>  }
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 11a450e00231..fe685ad91e0f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -783,7 +783,6 @@ typedef struct xfs_agi {
>   */
>  #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
>  #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
> -#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
>  
>  struct xfs_agfl {
>  	__be32		agfl_magicnum;
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 68ee1ce1ae36..6da2e87d19a8 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -580,7 +580,7 @@ xrep_agfl_init_header(
>  	__be32			*agfl_bno;
>  	struct xfs_bitmap_range	*br;
>  	struct xfs_bitmap_range	*n;
> -	struct xfs_agfl		*agfl;
> +	struct xfs_agfl		*agfl = agfl_bp->b_addr;
>  	xfs_agblock_t		agbno;
>  	unsigned int		fl_off;
>  
> @@ -590,7 +590,6 @@ xrep_agfl_init_header(
>  	 * Start rewriting the header by setting the bno[] array to
>  	 * NULLAGBLOCK, then setting AGFL header fields.
>  	 */
> -	agfl = XFS_BUF_TO_AGFL(agfl_bp);
>  	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
>  	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  	agfl->agfl_seqno = cpu_to_be32(sc->sa.agno);
> -- 
> 2.24.1
> 

