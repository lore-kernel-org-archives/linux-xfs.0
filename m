Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2367FC43461
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 07:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6D2E20716
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 07:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgICHqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 03:46:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54069 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgICHqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 03:46:39 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CCCA33A6F7B;
        Thu,  3 Sep 2020 17:46:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kDjx2-0003S3-L4; Thu, 03 Sep 2020 17:46:32 +1000
Date:   Thu, 3 Sep 2020 17:46:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        ira.weiny@intel.com
Subject: Re: [PATCH v3] xfs: Add check for unsupported xflags
Message-ID: <20200903074632.GD12131@dread.disaster.area>
References: <20200903035713.60962-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903035713.60962-1-yangx.jy@cn.fujitsu.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=XJ9OtjpE c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=omOdbC7AAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=f0sNnPsp7uHFUmI9i1kA:9 a=CjuIK1q_8ugA:10
        a=-RoEEKskQ1sA:10 a=baC4JDFNLZpnPwus_NF9:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 11:57:13AM +0800, Xiao Yang wrote:
> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
> so it is not clear for user to know unsupported xflags.
> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
> v4.4 which doesn't support dax flag:
> --------------------------------
> # xfs_io -f -c "chattr +x" testfile;echo $?
> 0
> # xfs_io -c "lsattr" testfile
> ----------------X testfile
> --------------------------------
> 
> Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f22a66777cd..59f9a86f29f7 100644
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

I don't think we can do this as it may break existing applications
that have been working on XFS for many, many years that don't
correctly initialise fsx_xflags....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
