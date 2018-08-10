Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbeHJLvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 07:51:47 -0400
Date: Fri, 10 Aug 2018 12:22:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Missing security_inode_readlink() in xfs_file_ioctl()
Message-ID: <20180810092229.rq7m4zdq75tsggqv@mwanda>
References: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org
Cc: "security@kernel.org>" <security@kernel.org>, darrick.wong@oracle.com, wenbo.s@samsung.com, ahmedmoneeb@gmail.com

Hi XFS devs,

We received this email on security@kernel.org.  This is under
CAP_SYS_ADMIN, but it maybe should also check with selinux?

regards,
dan carpenter

On Thu, Aug 09, 2018 at 05:59:50PM -0700, TongZhang wrote:
> [1.] One line summary of the problem:
> 
> Possible missing security_inode_readlink() in xfs_file_ioctl()
> 
> [2.] Full description of the problem/report:
> 
> We noticed a use of vfs_readlink() in xfs_file_ioctl(), which should have been checked by 
> security_inode_readlink().
> 
> The callgraph is:
> 	xfs_file_ioctl()->xfs_readlink_by_handle()->vfs_readlink()
> 
> This path allows user to do things similar to SyS_readlinkat(), and the parameters are
> user controllable.
> 
> 
> [3.] Keywords: LSM check
> [4.] Kernel information
> [4.1] Kernel Version: 4.14.61
> 
> 
> - Tong
