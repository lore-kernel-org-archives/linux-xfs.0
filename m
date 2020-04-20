Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2A4C54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B59420672
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lzf1UofV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgDTWmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:42:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgDTWmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:42:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMdj9J143916;
        Mon, 20 Apr 2020 22:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xPg5/aLWQ3sLoV69dcyz2kxP3tv+p13n9nS37DrRfGs=;
 b=Lzf1UofV6oQI02kWAUXxUlX5vz7X6LGnKuBkeUU5ye1T2ZUHd8+Xt09qV63hhXsbV+3E
 uteNFsAOWGBYYlr0vSgbGb7Xf9DPPNWaeJCqvhCceI6CTNOdMaSVz2HKosW45GgaNyOB
 Rhpb9nIdAZDFTTdkrDCjJhfUMBlWaLC+s7f50y0ZPu/cnFHHd5v+XSUjZz0B67Ascm45
 yGRJRh7pLr806URTB7l6Ck2ymVcX2SXLo+G8+gASOO0AtCQwRjoNLGueUDQYD4XziOUt
 7wfz0BcbDhRNG12b/QAX3b5iz+fEJ8shYOToU1ZR10PsPlbKYza1NDHEjDT61dIw4lXE Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n1wcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:42:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMbeet150360;
        Mon, 20 Apr 2020 22:42:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3r7mah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:42:10 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KMg9TJ020929;
        Mon, 20 Apr 2020 22:42:09 GMT
Received: from [10.65.145.61] (/10.65.145.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 15:42:09 -0700
Subject: Re: [PATCH 12/12] xfs: random buffer write failure errortag
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-13-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <93e1457d-d341-5d40-4c8f-9b2cf482c0d8@oracle.com>
Date:   Mon, 20 Apr 2020 15:42:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200417150859.14734-13-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/17/20 8:08 AM, Brian Foster wrote:
> Introduce an error tag to randomly fail async buffer writes. This is
> primarily to facilitate testing of the XFS error configuration
> mechanism.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, I think it looks ok:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>   fs/xfs/xfs_buf.c             | 6 ++++++
>   fs/xfs/xfs_error.c           | 3 +++
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 79e6c4fb1d8a..2486dab19023 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -55,7 +55,8 @@
>   #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
>   #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
>   #define XFS_ERRTAG_IUNLINK_FALLBACK			34
> -#define XFS_ERRTAG_MAX					35
> +#define XFS_ERRTAG_BUF_IOERROR				35
> +#define XFS_ERRTAG_MAX					36
>   
>   /*
>    * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -95,5 +96,6 @@
>   #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
>   #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
>   #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
> +#define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>   
>   #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5120fed06075..a305db779156 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1289,6 +1289,12 @@ xfs_buf_bio_end_io(
>   	struct bio		*bio)
>   {
>   	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> +	struct xfs_mount	*mp = bp->b_mount;
> +
> +	if (!bio->bi_status &&
> +	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> +	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
> +		bio->bi_status = errno_to_blk_status(-EIO);
>   
>   	/*
>   	 * don't overwrite existing errors - otherwise we can lose errors on
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index a21e9cc6516a..7f6e20899473 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -53,6 +53,7 @@ static unsigned int xfs_errortag_random_default[] = {
>   	XFS_RANDOM_FORCE_SCRUB_REPAIR,
>   	XFS_RANDOM_FORCE_SUMMARY_RECALC,
>   	XFS_RANDOM_IUNLINK_FALLBACK,
> +	XFS_RANDOM_BUF_IOERROR,
>   };
>   
>   struct xfs_errortag_attr {
> @@ -162,6 +163,7 @@ XFS_ERRORTAG_ATTR_RW(buf_lru_ref,	XFS_ERRTAG_BUF_LRU_REF);
>   XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>   XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>   XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
> +XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>   
>   static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -199,6 +201,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>   	XFS_ERRORTAG_ATTR_LIST(force_repair),
>   	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>   	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
> +	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>   	NULL,
>   };
>   
> 
