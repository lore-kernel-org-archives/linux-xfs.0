Return-Path: <SRS0=EAe2=4B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD28C2BA83
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 17:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA238218AC
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Feb 2020 17:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wIqs09io"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbgBMRqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 12:46:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54436 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgBMRqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Feb 2020 12:46:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DHVIo7156836;
        Thu, 13 Feb 2020 17:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IA8QPDgV651730kDP1WE96CZR8GoGgs0h7LEtbDw3HA=;
 b=wIqs09iow0mRbsI0OtynMW6u3eFALqPivl0n3hzJoqJ3eEq+n//HTUdhFoTjv8+1/zWv
 xNi+Tloy1TxqRrkYY7U+pbBdKTOPMRBWMSLgfKipfeQgexvemg/LEjc4N+rNV/ibkJWE
 IVjYngO+0wI7Jtxs4EBZVJOv6+WMbUCPbO+04efLcOs0FY58i98tOpfSjBeI3XuUdQY5
 gYqzEjLOLe9VD675O0V26VKk5tduxWDxM6clwJkUWkLwc1gKx2LD2TGKOhAFLmDpvciK
 lYzeXdJM2K6sKpoc5VPYjWzFVZqmDPXMwsdXvB6SZfm7iKmBONJ5cuud2VlkVShtBEft Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3sv12k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 17:46:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DHRUG2082493;
        Thu, 13 Feb 2020 17:44:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y4k37e5ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 17:44:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01DHiVgp022206;
        Thu, 13 Feb 2020 17:44:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Feb 2020 09:44:31 -0800
Date:   Thu, 13 Feb 2020 09:44:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-xfs@vger.kernel.org,
        renxudong1@huawei.com
Subject: Re: [PATCH] xfs: add agf freeblocks verify in xfs_agf_verify
Message-ID: <20200213174429.GE6870@magnolia>
References: <1581587639-130771-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581587639-130771-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 13, 2020 at 05:53:59PM +0800, Zheng Bin wrote:
> We recently used fuzz(hydra) to test XFS and automatically generate
> tmp.img(XFS v5 format, but some metadata is wrong)
> 
> Test as follows:
> mount tmp.img tmpdir
> cp file1M tmpdir
> sync
> 
> tmpdir/file1M size is 1M, but its data can not sync to disk.
> 
> This is because tmp.img has some problems, using xfs_repair detect
> information as follows:
> 
> agf_freeblks 0, counted 3224 in ag 0
> agf_longest 536874136, counted 3224 in ag 0
> sb_fdblocks 613, counted 3228
> 
> Add these agf freeblocks checks:
> 1. agf_longest < agf_freeblks
> 2. agf_freeblks < sb_fdblocks

Uh... what problem did you encounter?  Did block allocation loop
forever?  Did errors come pouring out of dmesg?  Did other strange
behaviors erupt?  What is the smallest number of steps needed to go from
a fresh format to ... whatever went wrong here?

That's what this commit message ought to capture. :)

--D

> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> Signed-off-by: Ren Xudong <renxudong1@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d8053bc..0f4b4d1 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2858,6 +2858,10 @@ xfs_agf_verify(
>  	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
>  		return __this_address;
> 
> +	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
> +	    be32_to_cpu(agf->agf_freeblks) >= mp->m_sb.sb_fdblocks)
> +		return __this_address;
> +
>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
>  	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
> --
> 2.7.4
> 
