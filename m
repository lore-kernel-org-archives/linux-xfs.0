Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbeHJVdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Aug 2018 17:33:38 -0400
Date: Fri, 10 Aug 2018 22:02:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Missing security_inode_readlink() in xfs_file_ioctl()
Message-ID: <20180810190217.uhiyp4totxrem5lw@mwanda>
References: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu>
 <20180810092229.rq7m4zdq75tsggqv@mwanda>
 <20180810160931.GF12194@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810160931.GF12194@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, "security@kernel.org>" <security@kernel.org>, wenbo.s@samsung.com, ahmedmoneeb@gmail.com

On Fri, Aug 10, 2018 at 09:09:31AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 10, 2018 at 12:22:29PM +0300, Dan Carpenter wrote:
> > Hi XFS devs,
> > 
> > We received this email on security@kernel.org.  This is under
> > CAP_SYS_ADMIN, but it maybe should also check with selinux?
> 
> Hmm, so the point of adding a security_inode_readlink call would be to
> restrict userland access xfs_readlink_by_handle further in case the
> system has a policy whereby even possessing CAP_SYS_ADMIN is not by
> itself sufficient to be able to read a symlink?
> 
> IOWs, are there security policies where CAP_SYS_ADMIN isn't a "get
> access to everything" wildcard?  I imagine the answer is "yes" and
> therefore xfs needs the call, but I thought I'd ask first.
>

Yeah...  Forget about it.  I pushed this out to you without really
thinking about it, just to get it off my todo list and that wasn't the
right thing.

regards,
dan carpenter
