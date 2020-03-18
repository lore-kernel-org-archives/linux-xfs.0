Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401A9C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 135FD20724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yqTYK14B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgCRPbi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:31:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRPbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:31:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFMx7D107028;
        Wed, 18 Mar 2020 15:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WKXeD42SKInVuX3g80nLM3efZ0JrSbly8FJaslbjMQA=;
 b=yqTYK14B438MfDV0lLn5jnB6LG7sS1iAOkg+d8s95bYDkcEGRwHnTbXrRKaa5Uk/0D/d
 Spe4QbDwV1v3M5wWVRGuPcg2jANRvejQlctJuXc+6mPwU+qo70gQyYrpp79jpVd9rxJw
 y26rg/cT0jV7wRDqMfPvQZC4bTp1y8Qn0PuXnG54vuIJVg6yFqWNQ9ueX10lOV/8euSN
 6lqXGzyNp+2ZMLHbBDGkmNRSFwCKjXjCTyM8eafckjiR68EEuVHF07rjwOANre3iBcAD
 Y2ox2paveAZoJNbIwC/QMJCYI/gd/n/V8a2yd6rkIUvrMOZwKRJIz2kV4MYg0PVJHhXC ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yrpprbcgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:31:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFLeZ0133381;
        Wed, 18 Mar 2020 15:31:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92gqd3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:31:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02IFVTDA021879;
        Wed, 18 Mar 2020 15:31:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:31:29 -0700
Date:   Wed, 18 Mar 2020 08:31:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 3/5] xfs: simplify di_flags2 inheritance in xfs_ialloc
Message-ID: <20200318153128.GZ256767@magnolia>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=810
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=855 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 07:57:54PM +0100, Christoph Hellwig wrote:
> di_flags2 is initialized to zero for v4 and earlier file systems.  This
> means di_flags2 can only be non-zero for a v5 file systems, in which
> case both the parent and child inodes can store the field.  Remove the
> extra di_version check, and also remove the rather pointless local
> di_flags2 variable while at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d65d2509d5e0..dfb0a452a87d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -907,20 +907,13 @@ xfs_ialloc(
>  
>  			ip->i_d.di_flags |= di_flags;
>  		}
> -		if (pip &&
> -		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
> -		    pip->i_d.di_version == 3 &&
> -		    ip->i_d.di_version == 3) {
> -			uint64_t	di_flags2 = 0;
> -
> +		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
> -				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
>  			}
>  			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
> -				di_flags2 |= XFS_DIFLAG2_DAX;
> -
> -			ip->i_d.di_flags2 |= di_flags2;
> +				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
>  		}
>  		/* FALLTHROUGH */
>  	case S_IFLNK:
> -- 
> 2.24.1
> 
