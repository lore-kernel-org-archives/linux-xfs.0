Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2ABCA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DDD32080F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 19:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hr4WwQ2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfJ3TgV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 15:36:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfJ3TgU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 15:36:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJYQ6o049786;
        Wed, 30 Oct 2019 19:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=2703Jov37aDGXoWlafzZxdI6Ah+Hc8gLXtoB3pRdDLw=;
 b=hr4WwQ2F1DiIdRsVO3M3zijFW7iJZWvzc8fdbmYNxl+W20EISTILmtgiysVaZ9qdlZi5
 YnKbXLFILmkyIMUexYbkF5M1hYyS350dbKVnaVN02Ddt3+hNj4mQVNsOIOAJdUfYuKpz
 ct5IpzqCsOOrXPM3rS1+Cwxa3FUapJ1YvVz0gvs42InBum+CHCrS7nmQ36CyxwKyubRA
 gDusw4hREm5P1ZaNXmV0rarDIfsZx46pe1UPa/Yv/HkpnRWTNii4WTYMSZN6u63cgWgI
 XSUiBK0A/Wlolrrf2xAJPNeZsrQobF0QlhCgsqBgSt/IHpowAKPMFaH4vXXwSCm9GUeU Pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vxwhfek3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:36:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UJY6OK097348;
        Wed, 30 Oct 2019 19:36:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vxwj7cn17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 19:36:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UJaEgC006389;
        Wed, 30 Oct 2019 19:36:14 GMT
Received: from localhost (/10.145.178.60)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 12:36:14 -0700
Date:   Wed, 30 Oct 2019 12:36:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: remove the extsize argument to xfs_eof_alignment
Message-ID: <20191030193613.GT15222@magnolia>
References: <20191030180419.13045-1-hch@lst.de>
 <20191030180419.13045-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030180419.13045-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 11:04:13AM -0700, Christoph Hellwig wrote:
> And move the code dependent on it to the one caller that cares
> instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 02526cffc5a3..c21c4f7a7389 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -118,8 +118,7 @@ xfs_iomap_end_fsb(
>  
>  static xfs_extlen_t
>  xfs_eof_alignment(
> -	struct xfs_inode	*ip,
> -	xfs_extlen_t		extsize)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_extlen_t		align = 0;
> @@ -142,17 +141,6 @@ xfs_eof_alignment(
>  			align = 0;
>  	}
>  
> -	/*
> -	 * Always round up the allocation request to an extent boundary
> -	 * (when file on a real-time subvolume or has di_extsize hint).
> -	 */
> -	if (extsize) {
> -		if (align)
> -			align = roundup_64(align, extsize);
> -		else
> -			align = extsize;
> -	}
> -
>  	return align;
>  }
>  
> @@ -167,12 +155,22 @@ xfs_iomap_eof_align_last_fsb(
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
> -	xfs_extlen_t		align = xfs_eof_alignment(ip, extsz);
> +	xfs_extlen_t		align = xfs_eof_alignment(ip);
>  	struct xfs_bmbt_irec	irec;
>  	struct xfs_iext_cursor	icur;
>  
>  	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
>  
> +	/*
> +	 * Always round up the allocation request to the extent hint boundary.
> +	 */
> +	if (extsz) {
> +		if (align)
> +			align = roundup_64(align, extsz);
> +		else
> +			align = extsz;
> +	}
> +
>  	if (align) {
>  		xfs_fileoff_t	aligned_end_fsb = roundup_64(end_fsb, align);
>  
> @@ -992,7 +990,7 @@ xfs_buffered_write_iomap_begin(
>  			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
>  					prealloc_blocks;
>  
> -			align = xfs_eof_alignment(ip, 0);
> +			align = xfs_eof_alignment(ip);
>  			if (align)
>  				p_end_fsb = roundup_64(p_end_fsb, align);
>  
> -- 
> 2.20.1
> 
