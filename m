Return-Path: <SRS0=POS4=YF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6B8C47404
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B9B20663
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VXRp2VhD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfJLAcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 20:32:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfJLAcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 20:32:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0U1Oj084727;
        Sat, 12 Oct 2019 00:32:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=pVfNMcCUNI30nZzzLdWcMT3/DlVVy+njhYn9h8eGiHw=;
 b=VXRp2VhDkW+EhlB8bF0GietmWkE/wmW7ALfHfVQQKqAiuZD8EBvlslms7BxGV510ht9R
 mCxx/Ehga1j/nAOZ6T9EFTLSnCd2nJIg1jyed9CFHdk4dFPMyL5xpeoVszMRMbRB8MHs
 EpeIOBT6d/gvuSnwQgBso8/1nS6bznesED2nseIhBI//t6Tkbvsw50epepzG5Zcsc4x8
 9DLhWS5LAHa9mpOj++NIDD2eyb1+E8uUx+MZGQJoh3kRkp3lGyvHF3YJMuT3dvAouDxt
 IPd0fxeNSZsg36PKXYnaBSG44n3jzj/SCOx/s0KaI5wsVKMzyC4rpE3MulGF9KwR4Kq2 sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4r4kbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:32:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0TetW096468;
        Sat, 12 Oct 2019 00:32:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vje301ham-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:32:28 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9C0WR6Z026262;
        Sat, 12 Oct 2019 00:32:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 17:32:26 -0700
Date:   Fri, 11 Oct 2019 17:32:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: ignore extent size hints for always COW inodes
Message-ID: <20191012003226.GN13108@magnolia>
References: <20191011130316.13373-1-hch@lst.de>
 <20191011130316.13373-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130316.13373-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 06:03:16AM -0700, Christoph Hellwig wrote:
> There is no point in applying extent size hints for always COW inodes,
> as we would just have to COW any extra allocation beyond the data
> actually written.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, I guess?

By the way, what's the plan for always_cow inodes, seeing as it's still
only a debugging feature?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 18f4b262e61c..2e94deb4610a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -55,6 +55,12 @@ xfs_extlen_t
>  xfs_get_extsz_hint(
>  	struct xfs_inode	*ip)
>  {
> +	/*
> +	 * No point in aligning allocations if we need to COW to actually
> +	 * write to them.
> +	 */
> +	if (xfs_is_always_cow_inode(ip))
> +		return 0;
>  	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
>  		return ip->i_d.di_extsize;
>  	if (XFS_IS_REALTIME_INODE(ip))
> -- 
> 2.20.1
> 
