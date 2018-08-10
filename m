Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbeHJSkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 14:40:17 -0400
Date: Fri, 10 Aug 2018 09:09:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Missing security_inode_readlink() in xfs_file_ioctl()
Message-ID: <20180810160931.GF12194@magnolia>
References: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu>
 <20180810092229.rq7m4zdq75tsggqv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810092229.rq7m4zdq75tsggqv@mwanda>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, "security@kernel.org>" <security@kernel.org>, wenbo.s@samsung.com, ahmedmoneeb@gmail.com

On Fri, Aug 10, 2018 at 12:22:29PM +0300, Dan Carpenter wrote:
> Hi XFS devs,
> 
> We received this email on security@kernel.org.  This is under
> CAP_SYS_ADMIN, but it maybe should also check with selinux?

Hmm, so the point of adding a security_inode_readlink call would be to
restrict userland access xfs_readlink_by_handle further in case the
system has a policy whereby even possessing CAP_SYS_ADMIN is not by
itself sufficient to be able to read a symlink?

IOWs, are there security policies where CAP_SYS_ADMIN isn't a "get
access to everything" wildcard?  I imagine the answer is "yes" and
therefore xfs needs the call, but I thought I'd ask first.

--D

> regards,
> dan carpenter
> 
> On Thu, Aug 09, 2018 at 05:59:50PM -0700, TongZhang wrote:
> > [1.] One line summary of the problem:
> > 
> > Possible missing security_inode_readlink() in xfs_file_ioctl()
> > 
> > [2.] Full description of the problem/report:
> > 
> > We noticed a use of vfs_readlink() in xfs_file_ioctl(), which should have been checked by 
> > security_inode_readlink().
> > 
> > The callgraph is:
> > 	xfs_file_ioctl()->xfs_readlink_by_handle()->vfs_readlink()
> > 
> > This path allows user to do things similar to SyS_readlinkat(), and the parameters are
> > user controllable.
> > 
> > 
> > [3.] Keywords: LSM check
> > [4.] Kernel information
> > [4.1] Kernel Version: 4.14.61
> > 
> > 
> > - Tong
