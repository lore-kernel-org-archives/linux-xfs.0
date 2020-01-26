Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF11C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 21:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B64206F0
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 21:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8hjiwqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAZVYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 16:24:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49134 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZVYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 16:24:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QLB3GR007000;
        Sun, 26 Jan 2020 21:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=GWUGCD0+mHk42ck+2XTRwWOErLiItM0BlznOPgZlPXU=;
 b=N8hjiwqn9UWdRuEf5bmSWxAyk8uRfNULWAewjmN/TLK3uqXKImNPSDVqUvAWzDPyCwYY
 MQmlnMqx8FXpx00AAn7io4eXdP7UcAUxMhGKbx3fX3Lod0SBzdLSEHZ1Eh4QOGHmhwod
 OekZ2+5GCWOj/q95InEskrkjcdue7yHLhPuJQVB3gBKTeyKLKYEpHuGaR4wJT95x5xjA
 NGn9mCRERTJqvX/rpF6M+/phSIVtHn1szND8ej+QXdE9SPB9P547i6oNvgO/Rg3fMJsQ
 ZUMdQ/ops5W1dwBIDRsTlew3BZvxMJN3BowN6aarA2tCbZOsVd7NetZUbs6ZD2Da0vFb Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xreaqva31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 21:24:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QL8u4I173837;
        Sun, 26 Jan 2020 21:24:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xry4sxh35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 21:24:16 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QLOAMC029606;
        Sun, 26 Jan 2020 21:24:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 13:24:10 -0800
Date:   Sun, 26 Jan 2020 13:24:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: turn the xfs_buf_incore stub into an inline
 function
Message-ID: <20200126212409.GA3447196@magnolia>
References: <20200126091717.516904-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126091717.516904-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 10:17:17AM +0100, Christoph Hellwig wrote:
> Replace the macro with an inline function to avoid compiler warnings with new
> backports of kernel code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

HAH YES, thank you!!!  <giddy dance>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/libxfs_priv.h | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 03edf0d3..2b73963c 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -369,14 +369,12 @@ roundup_64(uint64_t x, uint32_t y)
>  #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
>  #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
>  
> -/* avoid gcc warning */
> -#define xfs_buf_incore(bt,blkno,len,lockit) ({		\
> -	typeof(blkno) __foo = (blkno);			\
> -	typeof(len) __bar = (len);			\
> -	(blkno) = __foo;				\
> -	(len) = __bar; /* no set-but-unused warning */	\
> -	NULL;						\
> -})
> +static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
> +		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
> +{
> +	return NULL;
> +}
> +
>  #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
>  #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
>  #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
> -- 
> 2.24.1
> 
