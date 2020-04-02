Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BE3C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C7120719
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 14:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BrVfT0jf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388704AbgDBO47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 10:56:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388239AbgDBO47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 10:56:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032EdbIn085548;
        Thu, 2 Apr 2020 14:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=R/1qEM+z8rmzy2kCmQ1W6Cp7FklzjcM4Q7pfqyDa9Ec=;
 b=BrVfT0jfVyP6OJG8Ze7tTbWBFUcTzfCRTlwB1x/mFWqgiYLQXuh4ugjPSsnrDVjVXp/r
 1rv5kQi4z/RiBYszBa9afAmFstWJztH9ZkkJ3hbyMOhe1yrYfEOrZ8eyoeQC/KpgFnNo
 zRRZK8Nj6p9PYgWqGu17PqXpnoX0CWOuIKJYvB1ftBw/WPP12sqEsFNimJs8OZdtjsKi
 7bm9AzuDZrrVg62TT6xKnOD3fhG5Y8M2k7Iro5mpqt1xPWm9nexhLjrdvVWpTbWcFavr
 tbkMkJUY91ziAZ3R6ysUkx4GaYUkYeM4hI/p/V0vUb8jHo8zBR9BPvouTFB90+SgyPny TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yunejj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 14:56:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Eb64R113256;
        Thu, 2 Apr 2020 14:56:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 302g2jqwc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 14:56:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032EunbU015308;
        Thu, 2 Apr 2020 14:56:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 07:56:49 -0700
Date:   Thu, 2 Apr 2020 07:56:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix inode number overflow in ifree cluster helper
Message-ID: <20200402145648.GF80283@magnolia>
References: <20200402105718.609-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402105718.609-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=7 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=7 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 06:57:18AM -0400, Brian Foster wrote:
> Qian Cai reports seemingly random buffer read verifier errors during
> filesystem writeback. This was isolated to a recent patch that
> factored out some inode cluster freeing code and happened to cast an
> unsigned inode number type to a signed value. If the inode number
> value overflows, we can skip marking in-core inodes associated with
> the underlying buffer stale at the time the physical inodes are
> freed. If such an inode happens to be dirty, xfsaild will eventually
> attempt to write it back over non-inode blocks. The invalidation of
> the underlying inode buffer causes writeback to read the buffer from
> disk. This fails the read verifier (preventing eventual corruption)
> if the buffer no longer looks like an inode cluster. Analysis by
> Dave Chinner.
> 
> Fix up the helper to use the proper type for inode number values.
> 
> Fixes: 5806165a6663 ("xfs: factor inode lookup from xfs_ifree_cluster")
> Reported-by: Qian Cai <cai@lca.pw>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Fixes the problem described here[1]. I wasn't sure if we planned on
> fixing the original patch in for-next or wanted a separate patch. Feel
> free to commit standalone or fold into the original...
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/990EDC4E-1A4E-4AC3-84D9-078ACF5EB9CC@lca.pw/

Looks ok, I'll probably just attach it to the end rather than rebase
for-next at this super late point...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0cac0d37e3ae..ae86c870da92 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2511,7 +2511,7 @@ static struct xfs_inode *
>  xfs_ifree_get_one_inode(
>  	struct xfs_perag	*pag,
>  	struct xfs_inode	*free_ip,
> -	int			inum)
> +	xfs_ino_t		inum)
>  {
>  	struct xfs_mount	*mp = pag->pag_mount;
>  	struct xfs_inode	*ip;
> -- 
> 2.21.1
> 
