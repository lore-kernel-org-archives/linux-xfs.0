Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA64FC2BA1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA3E620801
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 22:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MA6iz8Qa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgDFWHX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 18:07:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWHW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 18:07:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M30rX071070;
        Mon, 6 Apr 2020 22:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yp3G+77rb41TPGnWRIg4E4B1ReubpYlXORWJ9pUZE3k=;
 b=MA6iz8QaHWMTt7FxF7pXaHFFK6b+IYd0V4TnyCniWwMaUDjFClFs3H+VhvzxdJe04Hbx
 t8XIWx/7WWy2oReI4dcqglrW2WaTUH8oznt6fq1J6fikINjaPn1y3Pi1NZvk7xaWVfUS
 rce7/S+8Q3Z/lj7nLWIvxOu/N54rrZp8WSbBldZS5+WTEmqrwlsLDvslCouoh0ub/NzY
 iEGqDeBPZbAZRF5eJxMaD2UH3qA1EmJNv/AWG89BKYAU9DYxttkeMN4F9+ZwO7ctQPVB
 PL+kLPY24KKkH0uJIbhUsNpsAYWHH1DA6NMUhPO3zMEIb3ZAb4iHfhZ4P/TBDSu0ZnN/ 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 306jvn1g8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:07:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036M1QWr087733;
        Mon, 6 Apr 2020 22:07:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30741bvswc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 22:07:10 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 036M79Hj030207;
        Mon, 6 Apr 2020 22:07:09 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 15:07:09 -0700
Subject: Re: [PATCH 3/5] xfs_db: clean up the salvage read callsites in
 set_cur()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619916259.469742.7875972212442996405.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <234282da-2f4e-d256-1f03-4a7f11941885@oracle.com>
Date:   Mon, 6 Apr 2020 15:07:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158619916259.469742.7875972212442996405.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/6/20 11:52 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Clean up the LIBXFS_READBUF_SALVAGE call sites in set_cur so that we
> use the return value directly instead of scraping it out later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Looks ok:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   db/io.c |   16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/db/io.c b/db/io.c
> index 384e4c0f..6628d061 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -516,6 +516,7 @@ set_cur(
>   	xfs_ino_t	ino;
>   	uint16_t	mode;
>   	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
> +	int		error;
>   
>   	if (iocur_sp < 0) {
>   		dbprintf(_("set_cur no stack element to set\n"));
> @@ -542,20 +543,21 @@ set_cur(
>   		if (!iocur_top->bbmap)
>   			return;
>   		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
> -		libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b, bbmap->nmaps,
> -				LIBXFS_READBUF_SALVAGE, &bp, ops);
> +		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
> +				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
> +				ops);
>   	} else {
> -		libxfs_buf_read(mp->m_ddev_targp, blknum, len,
> +		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
>   				LIBXFS_READBUF_SALVAGE, &bp, ops);
>   		iocur_top->bbmap = NULL;
>   	}
>   
>   	/*
> -	 * Keep the buffer even if the verifier says it is corrupted.
> -	 * We're a diagnostic tool, after all.
> +	 * Salvage mode means that we still get a buffer even if the verifier
> +	 * says the metadata is corrupt.  Therefore, the only errors we should
> +	 * get are for IO errors or runtime errors.
>   	 */
> -	if (!bp || (bp->b_error && bp->b_error != -EFSCORRUPTED &&
> -				   bp->b_error != -EFSBADCRC))
> +	if (error)
>   		return;
>   	iocur_top->buf = bp->b_addr;
>   	iocur_top->bp = bp;
> 
