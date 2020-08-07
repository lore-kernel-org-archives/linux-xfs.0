Return-Path: <SRS0=4IRk=BR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C61C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 15:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1905822C9F
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 15:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHGP6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Aug 2020 11:58:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:35038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgHGP6m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Aug 2020 11:58:42 -0400
IronPort-SDR: ZX+aDiT3QwS1et9WC+S6ZqQcoE9CSUIdBGYtT/BY3b/5VNqSA48LFoz25/g5F6ztMgWEdS0IjZ
 na41mEVV/5VQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="133188925"
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="133188925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 08:58:41 -0700
IronPort-SDR: 84GhESYlMVxCqdFLFQUJbDMjzi+st2B04wkoIaGMyw6B6LsVtdOlCoCKS3/QKhs0JKgz/N5wwD
 VFCLylzdQPXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="325784410"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Aug 2020 08:58:41 -0700
Date:   Fri, 7 Aug 2020 08:58:41 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can
 set/get inode DAX on XFS.
Message-ID: <20200807155841.GP1573827@iweiny-DESK2.sc.intel.com>
References: <20200727092744.2641-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727092744.2641-1-yangx.jy@cn.fujitsu.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 27, 2020 at 05:27:44PM +0800, Xiao Yang wrote:
> 1) FS_DAX_FL has been introduced by commit b383a73f2b83.
> 2) In future, chattr/lsattr command from e2fsprogs can set/get
>    inode DAX on XFS by calling ioctl(SETXFLAGS/GETXFLAGS).
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Wow sorry for the delay.  This looks good.  thanks!

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  fs/xfs/xfs_ioctl.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a190212ca85d..6f22a66777cd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1075,13 +1075,18 @@ xfs_merge_ioc_xflags(
>  		xflags |= FS_XFLAG_NODUMP;
>  	else
>  		xflags &= ~FS_XFLAG_NODUMP;
> +	if (flags & FS_DAX_FL)
> +		xflags |= FS_XFLAG_DAX;
> +	else
> +		xflags &= ~FS_XFLAG_DAX;
>  
>  	return xflags;
>  }
>  
>  STATIC unsigned int
>  xfs_di2lxflags(
> -	uint16_t	di_flags)
> +	uint16_t	di_flags,
> +	uint64_t	di_flags2)
>  {
>  	unsigned int	flags = 0;
>  
> @@ -1095,6 +1100,9 @@ xfs_di2lxflags(
>  		flags |= FS_NOATIME_FL;
>  	if (di_flags & XFS_DIFLAG_NODUMP)
>  		flags |= FS_NODUMP_FL;
> +	if (di_flags2 & XFS_DIFLAG2_DAX) {
> +		flags |= FS_DAX_FL;
> +	}
>  	return flags;
>  }
>  
> @@ -1565,7 +1573,7 @@ xfs_ioc_getxflags(
>  {
>  	unsigned int		flags;
>  
> -	flags = xfs_di2lxflags(ip->i_d.di_flags);
> +	flags = xfs_di2lxflags(ip->i_d.di_flags, ip->i_d.di_flags2);
>  	if (copy_to_user(arg, &flags, sizeof(flags)))
>  		return -EFAULT;
>  	return 0;
> @@ -1588,7 +1596,7 @@ xfs_ioc_setxflags(
>  
>  	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \
> -		      FS_SYNC_FL))
> +		      FS_SYNC_FL | FS_DAX_FL))
>  		return -EOPNOTSUPP;
>  
>  	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
> -- 
> 2.21.0
> 
> 
> 
