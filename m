Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FD0C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571E320772
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 17:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pamQf/Kw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390519AbgF3R64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 13:58:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50662 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389365AbgF3R64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:58:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHrVt4176871;
        Tue, 30 Jun 2020 17:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=konH3+DUtg6Jm6eT0CAsUUmF+YWBBQGRs77cTYIZqIU=;
 b=pamQf/KwueP+DuCjWwf06+xC8NNuXymN6mWLc0ObiyTaGGFUNi6l7h5qtioftTKeuchc
 a9saf680z9l3yfOD2Qn8wHhirksRudUgl4sY4tJG1E36DUe3759NsZ2T9/+fmxAeSUFE
 P4QyDupARyUhI58HXOGWR1VEvker52UKsEcwgy5WLiOw0x6sw7P/AMvBe0JD5WOoXgvC
 0NxvFPZdCPeehABbovT1tuRZdeohw9PkBW6iRWEpXd0tVgjmjbALwXWUwN350XoOZwZS
 oy9TR31vmSRrgC1+9A1n1NgDWoLk/r5jGLHghyCf8yd1hOLdSlkS4vgj7jv5YCI60+eQ FA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrbma8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:58:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqaFN166904;
        Tue, 30 Jun 2020 17:58:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31y52j8keb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:58:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHwoHR018728;
        Tue, 30 Jun 2020 17:58:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:58:50 +0000
Date:   Tue, 30 Jun 2020 10:58:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/15] xfs: don't clear the "dinode core" in
 xfs_inode_alloc
Message-ID: <20200630175849.GM7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-2-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:10:48AM +0200, Christoph Hellwig wrote:
> The xfs_icdinode structure just contains a random mix of inode field,
> which are all read from the on-disk inode and mostly not looked at
> before reading the inode or initializing a new inode cluster.  The
> only exceptions are the forkoff and blocks field, which are used
> in sanity checks for freshly allocated inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me thinks this looks ok, though I'm leaning on Chandan probably having
done a more thorough examination than I did...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0a5ac6f9a58349..660e7abd4e8b76 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -66,7 +66,8 @@ xfs_inode_alloc(
>  	memset(&ip->i_df, 0, sizeof(ip->i_df));
>  	ip->i_flags = 0;
>  	ip->i_delayed_blks = 0;
> -	memset(&ip->i_d, 0, sizeof(ip->i_d));
> +	ip->i_d.di_nblocks = 0;
> +	ip->i_d.di_forkoff = 0;
>  	ip->i_sick = 0;
>  	ip->i_checked = 0;
>  	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
> -- 
> 2.26.2
> 
