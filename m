Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3586C35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C61D521927
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bEUASc4s";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PKwHkY3j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgBFTiH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:38:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFTiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:38:07 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016Jc4Et001869;
        Thu, 6 Feb 2020 19:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YILBPqkZwSXYG8Ji552u99jCZsh61MKM+wlO6ROxl5c=;
 b=bEUASc4sR/IpNjsnc5X/6K9NnZXVIxnKX4KXGO6la102xO6gO5ETwz6EGIgW8ud7oEr+
 BrpE4aF44X6o7yU7gow2bjA8Q5jhoh/kMIlLaXDmxlGAQm0kWO5RZZMxJtJkBSWQZO5o
 t+W3nf9sguEIV9XT8pFC0f2xmApAS7/21+DsIfiHQ6DxKy1spsZ1IqdtC7XTizeth4ER
 /gfiIqc1G9BLRz0KsS0LUJ18IvZX01DpQPArTDjrZkcijNRqFCxIOitAVnrtFnUh+5gq
 9SVYqiDosozmLa43+KO5cuIAqHfAyMkSTk7GxJ4+yf95XsG8/LxpoqEUpgxRzDiI4RgO Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YILBPqkZwSXYG8Ji552u99jCZsh61MKM+wlO6ROxl5c=;
 b=PKwHkY3jgDgRvLacmW+vHH0KWmdh6eQxH0JN0ZweP1u3rVOs6nyDX93d+pMMRQNhMXWO
 18l5RrorD/iSEbsS5sre+6eZ8Axb1WUx/DQB0vVFF4I9IImAErbVookTO9JiM13QfLgL
 GdTB91581ML8bURwom8MGhwoAJQxZhZXEgsHNpQYW27XE7CgK9iRzCD0IolXRIyPjMHz
 JwuHoKdQa4v98SGiktX49/hOgJ9ieb+i1cD8TuSpEtWgGS36OLTwWUSqQmJy50rpXTtR
 63vIS4wKHoDOgk1e/E8aTWpf6nAiCdgDblfwJdlROcxFQVFzCSG5JWFE1A64ov4Mgbtr 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xykbpkxhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016JSnIp138833;
        Thu, 6 Feb 2020 19:38:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y0mnkbk8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:38:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016Jc3QS023108;
        Thu, 6 Feb 2020 19:38:03 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 11:38:03 -0800
Subject: Re: [PATCH 2/4] libxfs: complain when write IOs fail
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
 <158086365728.2079905.9556999948179065078.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b3746c06-9269-cad2-360d-26d3aec23d91@oracle.com>
Date:   Thu, 6 Feb 2020 12:38:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <158086365728.2079905.9556999948179065078.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/4/20 5:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Complain whenever a metadata write fails.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks good:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/rdwr.c |    7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 2e9f66cc..8b47d438 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1149,7 +1149,12 @@ libxfs_writebufr(xfs_buf_t *bp)
>   			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
>   			(long long)bp->b_bn, bp, bp->b_error);
>   #endif
> -	if (!bp->b_error) {
> +	if (bp->b_error) {
> +		fprintf(stderr,
> +	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
> +			__func__, bp->b_ops->name,
> +			(long long)bp->b_bn, bp->b_bcount, -bp->b_error);
> +	} else {
>   		bp->b_flags |= LIBXFS_B_UPTODATE;
>   		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_EXIT |
>   				 LIBXFS_B_UNCHECKED);
> 
