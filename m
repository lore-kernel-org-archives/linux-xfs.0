Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33285CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04EE421721
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 17:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngAkQQMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbfJ1ROf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 13:14:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56186 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfJ1ROf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 13:14:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHA5Np076942;
        Mon, 28 Oct 2019 17:14:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vmQkBgUPJ+sygKYJPxE0/XanA66JMvZNv4eMzMb3raY=;
 b=ngAkQQMhQ5PYnYFzk22kJdKY/YVFFCjKC63yQgzc8+5OkgNrN7D3r2tUfEvsxhKOs1Vr
 XXLaQGTjRY2hQYrl0SV33umVDmN5hEjoJ5HY+r5VKPPiikjDOnzMR8J2A1GNHmn8qjsf
 BR7trC8cM4ZWEj9cZjmMKODEDBbJSN5Hs9kZojxEMLhBbbjOvYz9iQTIlHZJLm9C0vBZ
 ol1/+tosOzPPL3NGsO2q6drY1I13OfDW5BmJePfoStHn/XkWDsvMINrVb+VWKXVmGalR
 FbKvDRu5gDhxLZhoua9cIzJu8rJszrvwftgmE/7JmVuLHyyeRD783dvtebGCMYswsexY WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vvumf8b52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:14:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SHBoY4164531;
        Mon, 28 Oct 2019 17:14:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vvyks8nef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 17:14:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9SHERgd000728;
        Mon, 28 Oct 2019 17:14:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 10:14:27 -0700
Date:   Mon, 28 Oct 2019 10:14:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 12/12] xfs: merge xfs_showargs into xfs_fs_show_options
Message-ID: <20191028171426.GU15222@magnolia>
References: <20191027145547.25157-1-hch@lst.de>
 <20191027145547.25157-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027145547.25157-13-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 27, 2019 at 03:55:47PM +0100, Christoph Hellwig wrote:
> No need for a trivial wrapper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0e8942bbf840..bcb1575a5652 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -406,10 +406,10 @@ struct proc_xfs_info {
>  	char		*str;
>  };
>  
> -STATIC void
> -xfs_showargs(
> -	struct xfs_mount	*mp,
> -	struct seq_file		*m)
> +static int
> +xfs_fs_show_options(
> +	struct seq_file		*m,
> +	struct dentry		*root)
>  {
>  	static struct proc_xfs_info xfs_info_set[] = {
>  		/* the few simple ones we can get from the mount struct */
> @@ -427,6 +427,7 @@ xfs_showargs(
>  		{ XFS_MOUNT_DAX,		",dax" },
>  		{ 0, NULL }
>  	};
> +	struct xfs_mount	*mp = XFS_M(root->d_sb);
>  	struct proc_xfs_info	*xfs_infop;
>  
>  	for (xfs_infop = xfs_info_set; xfs_infop->flag; xfs_infop++) {
> @@ -478,6 +479,8 @@ xfs_showargs(
>  
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
>  		seq_puts(m, ",noquota");
> +
> +	return 0;
>  }
>  
>  static uint64_t
> @@ -1378,15 +1381,6 @@ xfs_fs_unfreeze(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_fs_show_options(
> -	struct seq_file		*m,
> -	struct dentry		*root)
> -{
> -	xfs_showargs(XFS_M(root->d_sb), m);
> -	return 0;
> -}
> -
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock _has_ now been read in.
> -- 
> 2.20.1
> 
