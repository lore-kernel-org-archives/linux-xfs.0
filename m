Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851E3C433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6245B20758
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wpo65Ydr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIBR7F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:59:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43166 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgIBR7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:59:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HwtkG155663;
        Wed, 2 Sep 2020 17:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=WhKtwFMy0azSP5IsG5kJM029U6/WmvTASU4IqlQ2mNw=;
 b=wpo65YdrmL2RqtVHmsq4A4Ir2WIG9QolPBs0tDeq2l/50u0J0zHx1Q70aOJOUce/6HaK
 9Bq7g4Iurfej75Y1Jp9h/w92sLYn2vFJu0+GgRWPtupIAvDJ5OyCaoAuGibV8IwjWFEM
 OgenCISG2C3vMFB7bas+4+fHm73HcHMKlhKFuBoAf0PVOAdJKKgxzguSqOBylKd73T60
 AVRDZ5Wc9X+Fxlgdqn3Fdog74l6B6/Y0DIND6cr06YszAngbILrqejibdRswvRWUe5k3
 UdYpOKnpiC0WkIvNTrpVt5Uc2nLxaYHlUejEeKaRhcjvle3Sd+3ZycPzOyqpjvaPYkyU Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eer4a2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:58:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Ht43O117226;
        Wed, 2 Sep 2020 17:58:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380suehmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:58:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082HwqIh016758;
        Wed, 2 Sep 2020 17:58:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:58:52 -0700
Date:   Wed, 2 Sep 2020 10:58:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, ira.weiny@intel.com
Subject: Re: [PATCH v2] xfs: Add check for unsupported xflags
Message-ID: <20200902175851.GY6096@magnolia>
References: <20200902040601.10293-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902040601.10293-1-yangx.jy@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 12:06:01PM +0800, Xiao Yang wrote:
> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
> so it is not clear for user to know unsupported xflags.
> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
> v4.4 which doesn't support dax flag:
> --------------------------------
> 0
> ----------------X testfile
> --------------------------------
> 
> Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..e188e81961bd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
>  	return 0;
>  }
>  
> +#define XFS_SUPPORTED_FS_XFLAGS \
> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
> +	 FS_XFLAG_HASATTR)
> +
>  STATIC int
>  xfs_ioctl_setattr(
>  	xfs_inode_t		*ip,
> @@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> +	/* Check if fsx_xflags has unsupported xflags */
> +	if (fa->fsx_xflags & ~XFS_SUPPORTED_FS_XFLAGS)
> +                return -EOPNOTSUPP;
> +
>  	code = xfs_ioctl_setattr_check_projid(ip, fa);
>  	if (code)
>  		return code;
> -- 
> 2.25.1
> 
> 
> 
