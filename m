Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 16:44:40 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K0iYLJ029005
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:44:37 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45CEE5F577D
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:45:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 5b67EvPaNVor2srl for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 16:45:00 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id BD48818005BE1
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 18:44:59 -0600 (CST)
Message-ID: <47BB780A.5090705@sandeen.net>
Date: Tue, 19 Feb 2008 18:44:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, Updated] remove shouting-indirection macros from xfs_sb.h
References: <47AD44D3.4060503@sandeen.net> <47AE0419.6050000@sandeen.net>
In-Reply-To: <47AE0419.6050000@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> (missed one instance of XFS_SB_VERSION_HASLOGV2)
> 
> Remove macro-to-small-function indirection from xfs_sb.h,
> and remove some which are completely unused.
> 
> Some day I'll get them all...

Christoph likes it.  does sgi?

Thanks,
-Eric

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> ---
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -1052,7 +1052,7 @@ xfs_ioctl(
>  		 * Only allow the sys admin to reserve space unless
>  		 * unwritten extents are enabled.
>  		 */
> -		if (!XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
> +		if (!xfs_sb_version_hasextflgbit(&mp->m_sb) &&
>  		    !capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  
