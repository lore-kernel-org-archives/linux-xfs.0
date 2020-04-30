Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2ADC4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA3620787
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iv4QJWZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgD3S7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:59:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgD3S7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:59:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIncgU064028;
        Thu, 30 Apr 2020 18:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IMoKR4JCbCKDQb1NLj833pv/Q51YUzCyblebDZmLi8o=;
 b=Iv4QJWZme+PMl8N8tCPlrOqUJq8sHirtSzF5oaokWynWfV/b2E1ndgYQbzAOe8iXqHKb
 n2bV4Hu245GvuWBZBxl/Uj5j+R/YX2gx0v0np63L4lRNEpfyf7yd2D0feBLe4TNMWE8S
 otNfPjyAGryoiDnZS0DR4DjnxC71Uuj/xxZD9dkx/RlpkmfDHDleZWPTHcKSoHYB7WOP
 8X+qLlfijbxlJeIdPjzXczApoStEqYFoORU1v9iAVIssEIe5qI0G93wrHPg0Dvihu8Su
 tC4nW0h5dgER+dzN6uhRPnfkL4hxhjw0/TwYmdCqeeUH6C33ak6fX/HpYJJ1sccwqlOt lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30p2p0jrd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:59:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIks98112495;
        Thu, 30 Apr 2020 18:59:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30qtf899yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:59:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UIxIWT016939;
        Thu, 30 Apr 2020 18:59:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:59:18 -0700
Date:   Thu, 30 Apr 2020 11:59:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 15/17] xfs: random buffer write failure errortag
Message-ID: <20200430185917.GP6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-16-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-16-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:51PM -0400, Brian Foster wrote:
> Introduce an error tag to randomly fail async buffer writes. This is
> primarily to facilitate testing of the XFS error configuration
> mechanism.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_buf.c             | 6 ++++++
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 79e6c4fb1d8a..2486dab19023 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -55,7 +55,8 @@
>  #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>  #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>  #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> -#define XFS_ERRTAG_MAX					35
> +#define XFS_ERRTAG_BUF_IOERROR				35
> +#define XFS_ERRTAG_MAX					36
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -95,5 +96,6 @@
>  #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>  #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>  #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> +#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8f0f605de579..61629efd56ee 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1289,6 +1289,12 @@ xfs_buf_bio_end_io(
>  	struct bio		*bio)
>  {
>  	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> +	struct xfs_mount	*mp = bp->b_mount;
> +
> +	if (!bio->bi_status &&
> +	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> +	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
> +		bio->bi_status = BLK_STS_IOERR;
>  
>  	/*
>  	 * don't overwrite existing errors - otherwise we can lose errors on
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index a21e9cc6516a..7f6e20899473 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_FORCE_SCRUB_REPAIR,
>  	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>  	XFS_RANDOM_IUNLINK_FALLBACK,
> +	XFS_RANDOM_BUF_IOERROR,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
>  XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> +XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(force_repair),
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> +	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>  	NULL,
>  };
>  
> -- 
> 2.21.1
> 
