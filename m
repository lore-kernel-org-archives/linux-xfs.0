Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BB2C10F27
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE6BB2468E
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 11:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hwf3K7Ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgCJLXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 07:23:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725937AbgCJLXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 07:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583839390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rs8N9EJ3loIbTAcujbTpeiPR0IOtDhDfpq3rm1jh/eM=;
        b=hwf3K7ObT1wMd4AX4i1AZXAyffaRuhjZFXNK7rZWWfiiHQte7ZXezNVqu8N8xwnleurfeK
        YLBXZxXLNvdcnhStWMXZSRMdhfd0TSiRdPkMOUkAbaSPI767RGEKJqulIhVMibXU+bHg/w
        Z20bM1Z6a6s6TZFH65VUQYS1aG7gBv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-UV-F2mHeNdSfeaKVmzQuJQ-1; Tue, 10 Mar 2020 07:23:08 -0400
X-MC-Unique: UV-F2mHeNdSfeaKVmzQuJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D080B801E53;
        Tue, 10 Mar 2020 11:23:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC65910013A1;
        Tue, 10 Mar 2020 11:23:04 +0000 (UTC)
Date:   Tue, 10 Mar 2020 07:23:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
Message-ID: <20200310112302.GA50276@bfoster>
References: <20200306145220.242562-1-hch@lst.de>
 <20200306145220.242562-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306145220.242562-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:52:15AM -0700, Christoph Hellwig wrote:
> struct xfs_agfl is a header in front of the AGFL entries that exists
> for CRC enabled file systems.  For not CRC enabled file systems the AGFL
> is simply a list of agbno.  Make the CRC case similar to that by just
> using the list behind the new header.  This indirectly solves a problem
> with modern gcc versions that warn about taking addresses of packed
> structures (and we have to pack the AGFL given that gcc rounds up
> structure sizes).  Also replace the helper macro to get from a buffer
> with an inline function in xfs_alloc.h to make the code easier to
> read.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c         |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c      | 11 ++++++-----
>  fs/xfs/libxfs/xfs_alloc.h      |  9 +++++++++
>  fs/xfs/libxfs/xfs_format.h     |  6 ------
>  fs/xfs/scrub/agheader_repair.c |  2 +-
>  5 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 08d6beb54f8c..831bdd035900 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -301,7 +301,7 @@ xfs_agflblock_init(
>  		uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
>  	}
>  
> -	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
> +	agfl_bno = xfs_buf_to_agfl_bno(bp);
>  	for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
>  		agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
>  }
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 183dc2587092..f668e62acc56 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -589,6 +589,7 @@ xfs_agfl_verify(
>  {
>  	struct xfs_mount *mp = bp->b_mount;
>  	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
> +	__be32		*agfl_bno = xfs_buf_to_agfl_bno(bp);
>  	int		i;
>  
>  	/*
> @@ -614,8 +615,8 @@ xfs_agfl_verify(
>  		return __this_address;
>  
>  	for (i = 0; i < xfs_agfl_size(mp); i++) {
> -		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
> -		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
> +		if (be32_to_cpu(agfl_bno[i]) != NULLAGBLOCK &&
> +		    be32_to_cpu(agfl_bno[i]) >= mp->m_sb.sb_agblocks)
>  			return __this_address;
>  	}
>  
> @@ -2684,7 +2685,7 @@ xfs_alloc_get_freelist(
>  	/*
>  	 * Get the block number and update the data structures.
>  	 */
> -	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> +	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
>  	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
>  	be32_add_cpu(&agf->agf_flfirst, 1);
>  	xfs_trans_brelse(tp, agflbp);
> @@ -2820,7 +2821,7 @@ xfs_alloc_put_freelist(
>  
>  	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
>  
> -	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> +	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
>  	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
>  	*blockp = cpu_to_be32(bno);
>  	startoff = (char *)blockp - (char *)agflbp->b_addr;
> @@ -3424,7 +3425,7 @@ xfs_agfl_walk(
>  	unsigned int		i;
>  	int			error;
>  
> -	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> +	agfl_bno = xfs_buf_to_agfl_bno(agflbp);
>  	i = be32_to_cpu(agf->agf_flfirst);
>  
>  	/* Nothing to walk in an empty AGFL. */
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 7380fbe4a3ff..a851bf77f17b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -236,4 +236,13 @@ typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
>  int xfs_agfl_walk(struct xfs_mount *mp, struct xfs_agf *agf,
>  		struct xfs_buf *agflbp, xfs_agfl_walk_fn walk_fn, void *priv);
>  
> +static inline __be32 *
> +xfs_buf_to_agfl_bno(
> +	struct xfs_buf		*bp)
> +{
> +	if (xfs_sb_version_hascrc(&bp->b_mount->m_sb))
> +		return bp->b_addr + sizeof(struct xfs_agfl);
> +	return bp->b_addr;
> +}
> +
>  #endif	/* __XFS_ALLOC_H__ */
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 77e9fa385980..8c7aea7795da 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -785,18 +785,12 @@ typedef struct xfs_agi {
>  #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
>  #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
>  
> -#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
> -	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
> -		(__be32 *)(bp)->b_addr)
> -
>  typedef struct xfs_agfl {
>  	__be32		agfl_magicnum;
>  	__be32		agfl_seqno;
>  	uuid_t		agfl_uuid;
>  	__be64		agfl_lsn;
>  	__be32		agfl_crc;
> -	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
>  } __attribute__((packed)) xfs_agfl_t;
>  
>  #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index d5e6db9af434..68ee1ce1ae36 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -602,7 +602,7 @@ xrep_agfl_init_header(
>  	 * step.
>  	 */
>  	fl_off = 0;
> -	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agfl_bp);
> +	agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
>  	for_each_xfs_bitmap_extent(br, n, agfl_extents) {
>  		agbno = XFS_FSB_TO_AGBNO(mp, br->start);
>  
> -- 
> 2.24.1
> 

