Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA09C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C22206F0
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k6NhU/pD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgAZWUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:20:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41160 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZWUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:20:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJd9m031053;
        Sun, 26 Jan 2020 22:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ZAA1v6SK2LEkajnDQ+Pt7ZWZNx/H+NGDfBIerqDq08o=;
 b=k6NhU/pDYw4wCteAz1rbxLs2o6Cz+sGdrx/oMm9n+uCxxKYfBS0T3RThOkwZBCtuCFxY
 tUMexqAbYr57+OqYejQm/YY/tIPEwha+C/yNXQmddwk8jT619j9gufeGr55RO06Ehwam
 RM5bRzmcnflNjcxekbpCWl8gruYc7DS6U65LIizCg8sEzGE5kHY9RGU4T+c7y/JYwHvY
 8eGq4xxKX1rjvcr+0BMYx0MyqE+nU5Bp8d11XmMQD3oOg8e8fduBUrTusCBQyngT+GJ+
 84KloJm9ikmIRZYZr62jVa1UjG3pQyqQiVUsmgwqOW6YIXry7rjlW4bJfd2ilNqChSNB sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xrdmq4fdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:20:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJXsu163257;
        Sun, 26 Jan 2020 22:20:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xryu830sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:20:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00QMK1x2017012;
        Sun, 26 Jan 2020 22:20:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:20:01 -0800
Date:   Sun, 26 Jan 2020 14:20:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] repair: remove BITS_PER_LONG cpp checks in bmap.[ch]
Message-ID: <20200126222000.GG3447196@magnolia>
References: <20200126113541.787884-1-hch@lst.de>
 <20200126113541.787884-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126113541.787884-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 12:35:39PM +0100, Christoph Hellwig wrote:
> Add a little helper to validate the nex count so that we can use compile
> time magic checks for sizeof long directly.  Also don't print the max
> in case of an overflow as the value will always be the same.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/bmap.c | 29 +++++++++++++++++++++--------
>  repair/bmap.h | 13 -------------
>  2 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/repair/bmap.c b/repair/bmap.c
> index 44e43ab4..0d717cd3 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -22,6 +22,22 @@
>  pthread_key_t	dblkmap_key;
>  pthread_key_t	ablkmap_key;
>  
> +/*
> + * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
> + * limits the number of extents in an inode we can check. If we don't limit the
> + * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
> + * memory than we think we needed, and hence walk off the end of the array and
> + * corrupt memory.
> + */
> +static inline bool
> +blkmap_nex_valid(
> +	xfs_extnum_t	nex)
> +{
> +	if (sizeof(long) < 64 && nex >= INT_MAX / sizeof(bmap_ext_t))

sizeof(long) < 8

Frankly I suspect the maximum array length on 32 bit platforms is far
less than 2^31 bytes...

--D

> +		return false;
> +	return true;
> +}
> +
>  blkmap_t *
>  blkmap_alloc(
>  	xfs_extnum_t	nex,
> @@ -35,8 +51,7 @@ blkmap_alloc(
>  	if (nex < 1)
>  		nex = 1;
>  
> -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> -	if (nex > BLKMAP_NEXTS_MAX) {
> +	if (!blkmap_nex_valid(nex)) {
>  		do_warn(
>  	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
>  	  "If this is not a corruption, then you will need a 64 bit system\n"
> @@ -44,7 +59,6 @@ blkmap_alloc(
>  			nex);
>  		return NULL;
>  	}
> -#endif
>  
>  	key = whichfork ? ablkmap_key : dblkmap_key;
>  	blkmap = pthread_getspecific(key);
> @@ -278,20 +292,19 @@ blkmap_grow(
>  		ASSERT(pthread_getspecific(key) == blkmap);
>  	}
>  
> -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> -	if (new_naexts > BLKMAP_NEXTS_MAX) {
> +	if (!blkmap_nex_valid(new_naexts)) {
>  		do_error(
>  	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
>  	  "You need a 64 bit system to repair this filesystem.\n"),
>  			new_naexts);
>  		return NULL;
>  	}
> -#endif
> +
>  	if (new_naexts <= 0) {
>  		do_error(
>  	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
> -	  "maximum number of supported extents (%d).\n"),
> -			new_naexts, BLKMAP_NEXTS_MAX);
> +	  "maximum number of supported extents.\n"),
> +			new_naexts);
>  		return NULL;
>  	}
>  
> diff --git a/repair/bmap.h b/repair/bmap.h
> index 4b588df8..df9602b3 100644
> --- a/repair/bmap.h
> +++ b/repair/bmap.h
> @@ -28,19 +28,6 @@ typedef	struct blkmap {
>  #define	BLKMAP_SIZE(n)	\
>  	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
>  
> -/*
> - * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
> - * limits the number of extents in an inode we can check. If we don't limit the
> - * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
> - * memory than we think we needed, and hence walk off the end of the array and
> - * corrupt memory.
> - */
> -#if BITS_PER_LONG == 32
> -#define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
> -#else
> -#define BLKMAP_NEXTS_MAX	INT_MAX
> -#endif
> -
>  extern pthread_key_t dblkmap_key;
>  extern pthread_key_t ablkmap_key;
>  
> -- 
> 2.24.1
> 
