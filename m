Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A6AC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59D024954
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zmznMPem"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgEIRNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:13:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37894 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgEIRNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:13:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GxTmf047032;
        Sat, 9 May 2020 17:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3bmvqR5jtI5Cpcv56SFrli529qGYV8e7LU7R30DcEjQ=;
 b=zmznMPem7jbh8wk3/TrQtJMgxdN/+lXHN+2Cb/ib722FDgpWcK/sRAaRhHajBf2zkOoX
 KRz9MaGBAkLlKjfJmS1lDCrkEQ3TkmzoDbSi2KxrqabiXcW49w50A1YluDAOF7ewXco3
 NGLdkFqG6bClDWKXlBvbNC32T6XWFeUO/hGGCCaowLpsHSZO/dKnWS0+Uuoc1AqBmW7o
 y+gYNB9TyTKPvf+XzQjDq+QooBZDdImlMSSxSR00wrN+02CqeHsSsqkeA+nD0zGi7TvT
 h/qdqOfnmBjkxDXBK/6Mqv9lQjik82G1PGSkV8p77LRxSXi0lm9nnHeYSKXpzDkkfnfK xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30wmfm17q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:13:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049HAD1M182408;
        Sat, 9 May 2020 17:11:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30wwwprtp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 17:11:08 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 049HB70u032675;
        Sat, 9 May 2020 17:11:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 10:11:07 -0700
Date:   Sat, 9 May 2020 10:11:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] repair: cleanup build_agf_agfl
Message-ID: <20200509171106.GU6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509170125.952508-8-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=1 malwarescore=0 mlxlogscore=832 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=870
 suspectscore=1 clxscore=1015 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 07:01:24PM +0200, Christoph Hellwig wrote:
> No need to have two variables for the AGFL block number array.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/phase5.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 17b57448..677297fe 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2149,18 +2149,15 @@ build_agf_agfl(
>  
>  	/* setting to 0xff results in initialisation to NULLAGBLOCK */
>  	memset(agfl, 0xff, mp->m_sb.sb_sectsize);

/me wonders why this memset isn't sufficient to null out the freelist,
but a better cleanup would be to rip all this out in favor of adapting
the nearly identical functions in xfs_ag.c.

In the meantime we don't need duplicate variables, and:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	freelist = xfs_buf_to_agfl_bno(agfl_buf);
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		__be32 *agfl_bno = xfs_buf_to_agfl_bno(agfl_buf);
> -
>  		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
>  		agfl->agfl_seqno = cpu_to_be32(agno);
>  		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
>  		for (i = 0; i < libxfs_agfl_size(mp); i++)
> -			agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
> +			freelist[i] = cpu_to_be32(NULLAGBLOCK);
>  	}
>  
> -	freelist = xfs_buf_to_agfl_bno(agfl_buf);
> -
>  	/*
>  	 * do we have left-over blocks in the btree cursors that should
>  	 * be used to fill the AGFL?
> -- 
> 2.26.2
> 
