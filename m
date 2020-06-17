Return-Path: <SRS0=Ja7n=76=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2FDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4921E208B3
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Jun 2020 12:09:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cEeNBX5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgFQMJh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 08:09:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56719 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725894AbgFQMJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 08:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592395775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G90JV74TGV7cHA9aeU1C+5X7E/Hly3CozqjAaaPK/dU=;
        b=cEeNBX5gkwHEytyktOAJeo/MK5R4aOfEwQTyu4aJD2MHzxaxbjC/y40pz/S1ioTPmGmiQ4
        FUH6B6THVoRYt+QzqfUJzzF9+ri0pAG3oHZIEgvuyWES3ZCNNXbu/ZBUcxA6dGcR3CkkmT
        faeSu00fg61UeWdLiXy5n/uzWHZa1bA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-5KcrEWwSMh2E5N6wGQqcxw-1; Wed, 17 Jun 2020 08:09:31 -0400
X-MC-Unique: 5KcrEWwSMh2E5N6wGQqcxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76816107B473;
        Wed, 17 Jun 2020 12:09:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08BE6709D7;
        Wed, 17 Jun 2020 12:09:29 +0000 (UTC)
Date:   Wed, 17 Jun 2020 08:09:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs_repair: rename the agfl index loop variable in
 build_agf_agfl
Message-ID: <20200617120928.GB27169@bfoster>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
 <159107202579.315004.8068578556584944834.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159107202579.315004.8068578556584944834.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 09:27:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The variable 'i' is used to index the AGFL block list, so change the
> name to make it clearer what this is to be used for.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  repair/phase5.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index c9b278bd..169a2d89 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2055,7 +2055,7 @@ build_agf_agfl(
>  {
>  	struct extent_tree_node	*ext_ptr;
>  	struct xfs_buf		*agf_buf, *agfl_buf;
> -	int			i;
> +	unsigned int		agfl_idx;
>  	struct xfs_agfl		*agfl;
>  	struct xfs_agf		*agf;
>  	xfs_fsblock_t		fsb;
> @@ -2153,8 +2153,8 @@ build_agf_agfl(
>  		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  		agfl->agfl_seqno = cpu_to_be32(agno);
>  		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
> -		for (i = 0; i < libxfs_agfl_size(mp); i++)
> -			freelist[i] = cpu_to_be32(NULLAGBLOCK);
> +		for (agfl_idx = 0; agfl_idx < libxfs_agfl_size(mp); agfl_idx++)
> +			freelist[agfl_idx] = cpu_to_be32(NULLAGBLOCK);
>  	}
>  
>  	/*
> @@ -2165,19 +2165,21 @@ build_agf_agfl(
>  		/*
>  		 * yes, now grab as many blocks as we can
>  		 */
> -		i = 0;
> -		while (bno_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> +		agfl_idx = 0;
> +		while (bno_bt->num_free_blocks > 0 &&
> +		       agfl_idx < libxfs_agfl_size(mp))
>  		{
> -			freelist[i] = cpu_to_be32(
> +			freelist[agfl_idx] = cpu_to_be32(
>  					get_next_blockaddr(agno, 0, bno_bt));
> -			i++;
> +			agfl_idx++;
>  		}
>  
> -		while (bcnt_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
> +		while (bcnt_bt->num_free_blocks > 0 &&
> +		       agfl_idx < libxfs_agfl_size(mp))
>  		{
> -			freelist[i] = cpu_to_be32(
> +			freelist[agfl_idx] = cpu_to_be32(
>  					get_next_blockaddr(agno, 0, bcnt_bt));
> -			i++;
> +			agfl_idx++;
>  		}
>  		/*
>  		 * now throw the rest of the blocks away and complain
> @@ -2200,9 +2202,9 @@ _("Insufficient memory saving lost blocks.\n"));
>  		}
>  
>  		agf->agf_flfirst = 0;
> -		agf->agf_fllast = cpu_to_be32(i - 1);
> -		agf->agf_flcount = cpu_to_be32(i);
> -		rmap_store_agflcount(mp, agno, i);
> +		agf->agf_fllast = cpu_to_be32(agfl_idx - 1);
> +		agf->agf_flcount = cpu_to_be32(agfl_idx);
> +		rmap_store_agflcount(mp, agno, agfl_idx);
>  
>  #ifdef XR_BLD_FREE_TRACE
>  		fprintf(stderr, "writing agfl for ag %u\n", agno);
> 

