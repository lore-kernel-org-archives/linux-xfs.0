Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB50C3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72D832133F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gwwUndfn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHQBmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 21:42:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59980 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfHQBmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 21:42:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1dVS9028901;
        Sat, 17 Aug 2019 01:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sX9upFGCxbtsszFLuOMwuF09QNpbyXeYG6bKMbWJjxU=;
 b=gwwUndfnbULAqAXCZ+QmgW2grPZysegripm+vOPWxL4VBHAb/Qj47rlAuRzByn+xa7AD
 UHpU+Y9PtDJK5VPLbewZbM7toOVUjUa2XLl+nZftRtJSWtxKVz+vrPsHAlCJN8W8Yshr
 +6y+b4YBc2uMvIAzAmeMTGMFEQrETD+vdlTHfshPid9lnTno/DfgJRSYAReZJCxwW6KA
 YWE8sQ7iLTHfLnRE6aM2YwRAerEHPpdqnGedw3lOKLpUyHQU9dRMgsUnD76PLtmsNo+9
 YLnNnl0lfswrvdY3cs0+mfPzFv152jBoTjkVjsXPCoejLUSraYcKUndVUS+ebXdY5b9+ Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvpuebd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:42:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1bnO7153775;
        Sat, 17 Aug 2019 01:42:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2udscpybqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:42:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7H1g79b001952;
        Sat, 17 Aug 2019 01:42:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 18:42:07 -0700
Date:   Fri, 16 Aug 2019 18:42:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs: fall back to native ioctls for unhandled compat
 ones
Message-ID: <20190817014206.GC752159@magnolia>
References: <20190816063547.1592-1-hch@lst.de>
 <20190816063547.1592-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816063547.1592-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 08:35:46AM +0200, Christoph Hellwig wrote:
> Always try the native ioctl if we don't have a compat handler.  This
> removes a lot of boilerplate code as 'modern' ioctls should generally
> be compat clean, and fixes the missing entries for the recently added
> FS_IOC_GETFSLABEL/FS_IOC_SETFSLABEL ioctls.
> 
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl32.c | 54 ++------------------------------------------
>  1 file changed, 2 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 7fcf7569743f..bae08ef92ac3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -553,57 +553,6 @@ xfs_file_compat_ioctl(
>  	trace_xfs_file_compat_ioctl(ip);
>  
>  	switch (cmd) {
> -	/* No size or alignment issues on any arch */
> -	case XFS_IOC_DIOINFO:
> -	case XFS_IOC_FSGEOMETRY_V4:
> -	case XFS_IOC_FSGEOMETRY:
> -	case XFS_IOC_AG_GEOMETRY:
> -	case XFS_IOC_FSGETXATTR:
> -	case XFS_IOC_FSSETXATTR:
> -	case XFS_IOC_FSGETXATTRA:
> -	case XFS_IOC_FSSETDM:
> -	case XFS_IOC_GETBMAP:
> -	case XFS_IOC_GETBMAPA:
> -	case XFS_IOC_GETBMAPX:
> -	case XFS_IOC_FSCOUNTS:
> -	case XFS_IOC_SET_RESBLKS:
> -	case XFS_IOC_GET_RESBLKS:
> -	case XFS_IOC_FSGROWFSLOG:
> -	case XFS_IOC_GOINGDOWN:
> -	case XFS_IOC_ERROR_INJECTION:
> -	case XFS_IOC_ERROR_CLEARALL:
> -	case FS_IOC_GETFSMAP:
> -	case XFS_IOC_SCRUB_METADATA:
> -	case XFS_IOC_BULKSTAT:
> -	case XFS_IOC_INUMBERS:
> -		return xfs_file_ioctl(filp, cmd, p);
> -#if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
> -	/*
> -	 * These are handled fine if no alignment issues.  To support x32
> -	 * which uses native 64-bit alignment we must emit these cases in
> -	 * addition to the ia-32 compat set below.
> -	 */
> -	case XFS_IOC_ALLOCSP:
> -	case XFS_IOC_FREESP:
> -	case XFS_IOC_RESVSP:
> -	case XFS_IOC_UNRESVSP:
> -	case XFS_IOC_ALLOCSP64:
> -	case XFS_IOC_FREESP64:
> -	case XFS_IOC_RESVSP64:
> -	case XFS_IOC_UNRESVSP64:
> -	case XFS_IOC_FSGEOMETRY_V1:
> -	case XFS_IOC_FSGROWFSDATA:
> -	case XFS_IOC_FSGROWFSRT:
> -	case XFS_IOC_ZERO_RANGE:
> -#ifdef CONFIG_X86_X32
> -	/*
> -	 * x32 special: this gets a different cmd number from the ia-32 compat
> -	 * case below; the associated data will match native 64-bit alignment.
> -	 */
> -	case XFS_IOC_SWAPEXT:
> -#endif
> -		return xfs_file_ioctl(filp, cmd, p);
> -#endif
>  #if defined(BROKEN_X86_ALIGNMENT)
>  	case XFS_IOC_ALLOCSP_32:
>  	case XFS_IOC_FREESP_32:
> @@ -705,6 +654,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_FSSETDM_BY_HANDLE_32:
>  		return xfs_compat_fssetdm_by_handle(filp, arg);
>  	default:
> -		return -ENOIOCTLCMD;
> +		/* try the native version */
> +		return xfs_file_ioctl(filp, cmd, p);
>  	}
>  }
> -- 
> 2.20.1
> 
