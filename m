Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E129C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD37621D41
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 05:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GGfgm6UU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505913AbgJ0Fft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 01:35:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505912AbgJ0Fft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 01:35:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5ZBRr028903;
        Tue, 27 Oct 2020 05:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dbcz4wfVd4s87Cg4JGuf8cchK6K9y6FsA31fpBLRVK8=;
 b=GGfgm6UUCFqJHTMdGqF1aaCSxyBwDrnJH9Bn7I78J4MSqa/4ZIn9H+fna1bdK/UBk8/D
 OZgDg64CUTUXWnPU2vuNXJXw5aRw4lRUW4HoNnfsPy0OCi0hF+c0ebbV22lW7k0jR8Tz
 EM0nWl/iwmPsqqrqFYSLhnsDhqe4/TD/uM3yKBMaWxDLORL65f0xPRlVDnpneVL07fMp
 UZKxno1HJZCoUueQgdTeFwHYintXg0f4Q1XdAAzKxP735DBopNJC6KkRJZMy4tcCdA32
 n5nfV3mzDXoyUfICV0vkpK/hjKUjdQ7r/hId97nwytW4mKn8D6cd8E0pOCipWUp2w9Zp rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9sar2h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 05:35:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R5Q0b3009495;
        Tue, 27 Oct 2020 05:35:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wq59b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 05:35:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R5Zi1T025528;
        Tue, 27 Oct 2020 05:35:45 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 22:35:44 -0700
Subject: Re: [PATCH 1/5] mkfs: allow users to specify rtinherit=0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <feecba0a-04a0-1bf5-343c-fb3c63364165@oracle.com>
Date:   Mon, 26 Oct 2020 22:35:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160375511989.879169.8816363379781873320.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270037
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/26/20 4:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs has quite a few boolean options that can be specified in several
> ways: "option=1" (turn it on), "option" (turn it on), or "option=0"
> (turn it off).  For whatever reason, rtinherit sticks out as the only
> mkfs parameter that doesn't behave that way.  Let's make it behave the
> same as all the other boolean variables.
> 
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   mkfs/xfs_mkfs.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d74b0a..908d520df909 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -349,7 +349,7 @@ static struct opt_params dopts = {
>   		},
>   		{ .index = D_RTINHERIT,
>   		  .conflicts = { { NULL, LAST_CONFLICT } },
> -		  .minval = 1,
> +		  .minval = 0,
>   		  .maxval = 1,
>   		  .defaultval = 1,
>   		},
> @@ -1429,6 +1429,8 @@ data_opts_parser(
>   	case D_RTINHERIT:
>   		if (getnum(value, opts, subopt))
>   			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
> +		else
> +			cli->fsx.fsx_xflags &= ~FS_XFLAG_RTINHERIT;
>   		break;
>   	case D_PROJINHERIT:
>   		cli->fsx.fsx_projid = getnum(value, opts, subopt);
> 
