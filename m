Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1691C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC2A2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 22:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h3m0Iat1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKGWeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 17:34:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGWeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 17:34:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7MXfsW080437;
        Thu, 7 Nov 2019 22:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pJ6YgsRpxAoLnKewMftTjzNcfW1sr4AnF9ftaN1HPh4=;
 b=h3m0Iat1VMDA455fkCbbzpzcQ99L+o5Jk5UWSFqBSFVsNHLUG4c6wfBZBH9ntv1MInbJ
 UooX2Ag+FSBiQEX6TFgZjw0KPfqNF9QU1NG5zcq01ZqTjZJIcao+YLcq5Bwa5qoaiyOL
 Lz/5xHXITuOgDCcFtwZgfBbHrA2I+EcwZnhSSllkl16ziQZwVsWOXE0EXW+2sQildx+Y
 SLrYZCyhtumnjOvBvn6sgKl1sVBz+i4reo9HaIObsk1wsR/4ssUwm9plqF6GGkbTuwMq
 xwMzB+nz6WliXKiq6UA/sBzgTtyROhRsNxTGvZWM/N+Wb3Tnn+sUdIwqKruVG89fgFF3 rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w19fgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:33:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7MXVUG042371;
        Thu, 7 Nov 2019 22:33:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w41wg1n2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 22:33:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7MXtrx002799;
        Thu, 7 Nov 2019 22:33:55 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 14:33:54 -0800
Date:   Thu, 7 Nov 2019 14:33:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/46] xfs: use unsigned int for all size values in
 struct xfs_da_geometry
Message-ID: <20191107223354.GK6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:26PM +0100, Christoph Hellwig wrote:
> None of these can ever be negative, so use unsigned types.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 02f7a21ab3a5..01b0bbe8b266 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -18,12 +18,12 @@ struct xfs_dir_ops;
>   * structures will be attached to the xfs_mount.
>   */
>  struct xfs_da_geometry {
> -	int		blksize;	/* da block size in bytes */
> -	int		fsbcount;	/* da block size in filesystem blocks */
> +	unsigned int	blksize;	/* da block size in bytes */
> +	unsigned int	fsbcount;	/* da block size in filesystem blocks */
>  	uint8_t		fsblog;		/* log2 of _filesystem_ block size */
>  	uint8_t		blklog;		/* log2 of da block size */
> -	uint		node_ents;	/* # of entries in a danode */
> -	int		magicpct;	/* 37% of block size in bytes */
> +	unsigned int	node_ents;	/* # of entries in a danode */
> +	unsigned int	magicpct;	/* 37% of block size in bytes */
>  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
> -- 
> 2.20.1
> 
