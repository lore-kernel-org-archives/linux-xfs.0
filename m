Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641A1CA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4F920717
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I/LepH61"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfKDUxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:53:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKDUxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:53:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kmjmw147831;
        Mon, 4 Nov 2019 20:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=f48SJ+WdYU+9ItM1a8hM2SZJPdAWVHaf3RkO0Zd20RI=;
 b=I/LepH61lK5ORQS13/Za3YR1xZK4hdtVfFaHyGm/LIwjRWCLM5bCd5XEFE6aKK8G+xS0
 DXQX8GnHJ9a3JrIg9GaaIDeljMflEEAkoAY86rDyZbRDGMCde8kwYdej7amBBG0xUIAq
 pey29sLVzXCNottLyBWZV5FK4Fk3xYUP2wA22Qo4byp14zQmnVtc+8Y7qJfxVeJNpkli
 f7DwPJYQobgJ697lYZKetLCsM9cS+A8nt9jWf13acPJuSZAyA7cfR/8DfDdCgAL32mov
 cZE7WyyDqL3wuNUjlb3KDOOrDjNV9DWQyQ1fHz87gJ+RPrvk5zsd1cMOwjOo9l19CVaa xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117tt2sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:53:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KmeTG152804;
        Mon, 4 Nov 2019 20:53:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxn1kku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:53:48 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KrlaD024773;
        Mon, 4 Nov 2019 20:53:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:53:47 -0800
Date:   Mon, 4 Nov 2019 12:53:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/34] xfs: always pass a valid hdr to
 xfs_dir3_leaf_check_int
Message-ID: <20191104205345.GJ4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-35-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-35-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:19PM -0700, Christoph Hellwig wrote:
> Move the code for extracting the incore header to the only caller that
> didn't already do that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Well, that was quite the cleanup.  Even more surprisingly it didn't
clash too badly with the health reporting patch series I sent yesterday.
:)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 6912264e081e..fecec1ac8e40 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -137,20 +137,14 @@ xfs_dir3_leaf_check(
>  
>  xfs_failaddr_t
>  xfs_dir3_leaf_check_int(
> -	struct xfs_mount	*mp,
> -	struct xfs_dir3_icleaf_hdr *hdr,
> -	struct xfs_dir2_leaf	*leaf)
> +	struct xfs_mount		*mp,
> +	struct xfs_dir3_icleaf_hdr	*hdr,
> +	struct xfs_dir2_leaf		*leaf)
>  {
> -	xfs_dir2_leaf_tail_t	*ltp;
> -	int			stale;
> -	int			i;
> -	struct xfs_dir3_icleaf_hdr leafhdr;
> -	struct xfs_da_geometry	*geo = mp->m_dir_geo;
> -
> -	if (!hdr) {
> -		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
> -		hdr = &leafhdr;
> -	}
> +	struct xfs_da_geometry		*geo = mp->m_dir_geo;
> +	xfs_dir2_leaf_tail_t		*ltp;
> +	int				stale;
> +	int				i;
>  
>  	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
>  
> @@ -190,17 +184,18 @@ xfs_dir3_leaf_check_int(
>   */
>  static xfs_failaddr_t
>  xfs_dir3_leaf_verify(
> -	struct xfs_buf		*bp)
> +	struct xfs_buf			*bp)
>  {
> -	struct xfs_mount	*mp = bp->b_mount;
> -	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> -	xfs_failaddr_t		fa;
> +	struct xfs_mount		*mp = bp->b_mount;
> +	struct xfs_dir3_icleaf_hdr	leafhdr;
> +	xfs_failaddr_t			fa;
>  
>  	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
>  	if (fa)
>  		return fa;
>  
> -	return xfs_dir3_leaf_check_int(mp, NULL, leaf);
> +	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, bp->b_addr);
> +	return xfs_dir3_leaf_check_int(mp, &leafhdr, bp->b_addr);
>  }
>  
>  static void
> -- 
> 2.20.1
> 
