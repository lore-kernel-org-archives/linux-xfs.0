Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEB3C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 17:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DAC02083E
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 17:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bjSn654y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgHaRZJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:25:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbgHaRZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 13:25:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHIts7052626;
        Mon, 31 Aug 2020 17:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EjvK2pFpOLxW6MRxILxqRUbLzoCGpKZjQR+Srv/gIak=;
 b=bjSn654yr0BM9YuN+XCefKJokdJR+M+Gl0/WKD9C7TBK2RSh2ep76wKyE9oo5TsBJn0h
 uI35z9OaF4CU26L2//miJeUP1Rjr3otnHWlDMhoAvbl5KoTy9fgfFxoPfG1SYXkQTuw4
 q/ioFYvSrjSQsBCxPpgzwHJJmqfW/kndcbN4VCbPUppQ5jfIF6skSj2psr6TJqNI90vE
 znlI80vcqGJoQvceb9NhpVNlVt07Qc3o2r7MqlzoBzjCxXd2qBRDu2uk3uYCsckrkbIB
 E3EofX8P6CBkIvwH3zXJYsIdRFUZe6LG7Lr7QH2Sk9oPUX6/8qT9NuQnTSLmWHUAi/1L Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqqhwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:24:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHLcTQ019213;
        Mon, 31 Aug 2020 17:22:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380xv301d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:22:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VHMnJv000335;
        Mon, 31 Aug 2020 17:22:49 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:22:48 -0700
Date:   Mon, 31 Aug 2020 10:22:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, ira.weiny@intel.com
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
Message-ID: <20200831172250.GT6107@magnolia>
References: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 09:37:45PM +0800, Xiao Yang wrote:
> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
> so it it not clear for user to know unsupported xflags.
> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
> v4.4 which doesn't support dax flag:
> --------------------------------
> # xfs_io -f -c "chattr +x" testfile;echo $?
> 0
> # xfs_io -c "lsattr" testfile
> ----------------X testfile
> --------------------------------
> 
> Add check to report unsupported info as ioctl(SETXFLAGS) does.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> ---
>  fs/xfs/xfs_ioctl.c      | 4 ++++
>  include/uapi/linux/fs.h | 8 ++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..cfe7f20c94fe 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> +	/* Check if fsx_xflags have unsupported xflags */
> +	if (fa->fsx_xflags & ~FS_XFLAG_ALL)
> +                return -EOPNOTSUPP;

Shouldn't this be in vfs_ioc_fssetxattr_check, since we're checking
against all the vfs defined XFLAGS?

--D

> +
>  	code = xfs_ioctl_setattr_check_projid(ip, fa);
>  	if (code)
>  		return code;
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index f44eb0a04afd..31b6856f6877 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -142,6 +142,14 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>  
> +#define FS_XFLAG_ALL \
> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
> +	 FS_XFLAG_HASATTR)
> +
>  /* the read-only stuff doesn't really belong here, but any other place is
>     probably as bad and I don't want to create yet another include file. */
>  
> -- 
> 2.25.1
> 
> 
> 
