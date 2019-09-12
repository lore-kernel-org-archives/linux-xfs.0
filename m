Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06912C4CEC6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7165206CD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 23:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IJhXHGv1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfILXmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 19:42:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfILXma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Sep 2019 19:42:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNdMGI032016;
        Thu, 12 Sep 2019 23:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4TMcrsGrRXhPwqAqxMzGM2izuCZaB2GJZJVpMkaltWg=;
 b=IJhXHGv1mwpTrApRgKUCZ0Zrp6q0KcmS0qi/WrNbWU0TJyb3lpV3LRZOACi2PJ0QAdmr
 K1am0G8woYz3yeWH9FJKpdbM/xFOx0LwvBqWLRzqxYV50eLBTcdBChmFDYED0iMmeM1T
 q+F8uBzT4DJpm5vTQZP4wj2AdDj3fm5BFkcqf8fu9lz28E5fo71NdZTNVdAQkbqVrka+
 GImh0llwu3PXDLPOLofo5LdZ+0AB0kYPYGCd8ypvRcYngqh5NG7CE46oWjWcys5cima4
 gUDmu5vA6JlC/+CFbnM8if1IpCe/QQosyama3nYL7LznsXCCh5w/8eaDcRi563Y8Pu01 Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uytd31gx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:42:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CNcHSB124924;
        Thu, 12 Sep 2019 23:42:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uytdhjms3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 23:42:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8CNgQXX028466;
        Thu, 12 Sep 2019 23:42:26 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Sep 2019 16:42:26 -0700
Subject: Re: [PATCH 1/3] xfs_scrub: implement background mode for phase 6
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156774123336.2646704.1827381294403838403.stgit@magnolia>
 <156774123948.2646704.14264815195950334701.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <15e7c844-bb2e-64eb-66de-5662b1322a77@oracle.com>
Date:   Thu, 12 Sep 2019 16:42:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156774123948.2646704.14264815195950334701.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909120242
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909120242
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks ok to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 9/5/19 8:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Phase 6 doesn't implement background mode, which means that it doesn't
> run in single-threaded mode with one -b and it doesn't sleep between
> calls with multiple -b like every other phase does.  Wire up the
> necessary pieces to make it behave like the man page says it should.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   scrub/read_verify.c |   21 +++++++++++++++++----
>   1 file changed, 17 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/scrub/read_verify.c b/scrub/read_verify.c
> index 834571a7..414d25a6 100644
> --- a/scrub/read_verify.c
> +++ b/scrub/read_verify.c
> @@ -32,7 +32,19 @@
>    * because that's the biggest SCSI VERIFY(16) we dare to send.
>    */
>   #define RVP_IO_MAX_SIZE		(33554432)
> -#define RVP_IO_MAX_SECTORS	(RVP_IO_MAX_SIZE >> BBSHIFT)
> +
> +/*
> + * If we're running in the background then we perform IO in 128k chunks
> + * to reduce the load on the IO subsystem.
> + */
> +#define RVP_BACKGROUND_IO_MAX_SIZE	(131072)
> +
> +/* What's the real maximum IO size? */
> +static inline unsigned int
> +rvp_io_max_size(void)
> +{
> +	return bg_mode > 0 ? RVP_BACKGROUND_IO_MAX_SIZE : RVP_IO_MAX_SIZE;
> +}
>   
>   /* Tolerate 64k holes in adjacent read verify requests. */
>   #define RVP_IO_BATCH_LOCALITY	(65536)
> @@ -84,7 +96,7 @@ read_verify_pool_alloc(
>   	 */
>   	if (miniosz % disk->d_lbasize)
>   		return EINVAL;
> -	if (RVP_IO_MAX_SIZE % miniosz)
> +	if (rvp_io_max_size() % miniosz)
>   		return EINVAL;
>   
>   	rvp = calloc(1, sizeof(struct read_verify_pool));
> @@ -92,7 +104,7 @@ read_verify_pool_alloc(
>   		return errno;
>   
>   	ret = posix_memalign((void **)&rvp->readbuf, page_size,
> -			RVP_IO_MAX_SIZE);
> +			rvp_io_max_size());
>   	if (ret)
>   		goto out_free;
>   	ret = ptcounter_alloc(verifier_threads, &rvp->verified_bytes);
> @@ -177,7 +189,7 @@ read_verify(
>   	if (rvp->errors_seen)
>   		return;
>   
> -	io_max_size = RVP_IO_MAX_SIZE;
> +	io_max_size = rvp_io_max_size();
>   
>   	while (rv->io_length > 0) {
>   		io_error = 0;
> @@ -253,6 +265,7 @@ read_verify(
>   			verified += sz;
>   		rv->io_start += sz;
>   		rv->io_length -= sz;
> +		background_sleep();
>   	}
>   
>   	free(rv);
> 
