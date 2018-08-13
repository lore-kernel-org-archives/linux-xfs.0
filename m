Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33198 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeHMLMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Aug 2018 07:12:22 -0400
Date: Mon, 13 Aug 2018 11:30:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Missing security_inode_readlink() in xfs_file_ioctl()
Message-ID: <20180813083047.plcvj4k5qkoxr26l@mwanda>
References: <41DC519D-83A7-4964-A6C8-B16CFEEDB65F@vt.edu>
 <20180810092229.rq7m4zdq75tsggqv@mwanda>
 <20180810160931.GF12194@magnolia>
 <20180810190217.uhiyp4totxrem5lw@mwanda>
 <20180813073528.s5hck4bmwmg6pvoq@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813073528.s5hck4bmwmg6pvoq@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, "security@kernel.org>" <security@kernel.org>, wenbo.s@samsung.com, ahmedmoneeb@gmail.com

On Mon, Aug 13, 2018 at 09:35:28AM +0200, Carlos Maiolino wrote:
> On Fri, Aug 10, 2018 at 10:02:17PM +0300, Dan Carpenter wrote:
> > On Fri, Aug 10, 2018 at 09:09:31AM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 10, 2018 at 12:22:29PM +0300, Dan Carpenter wrote:
> > > > Hi XFS devs,
> > > > 
> > > > We received this email on security@kernel.org.  This is under
> > > > CAP_SYS_ADMIN, but it maybe should also check with selinux?
> > > 
> > > Hmm, so the point of adding a security_inode_readlink call would be to
> > > restrict userland access xfs_readlink_by_handle further in case the
> > > system has a policy whereby even possessing CAP_SYS_ADMIN is not by
> > > itself sufficient to be able to read a symlink?
> > > 
> > > IOWs, are there security policies where CAP_SYS_ADMIN isn't a "get
> > > access to everything" wildcard?  I imagine the answer is "yes" and
> > > therefore xfs needs the call, but I thought I'd ask first.
> > >
> > 
> > Yeah...  Forget about it.  I pushed this out to you without really
> > thinking about it, just to get it off my todo list and that wasn't the
> > right thing.
> > 
> 
> Just thought it was worth to mention...
> 
> A long time ago, I've seen implementations where the system administration was
> split between a sys admin and a 'security admin', where the security admin
> removed some root permissions, and so, some very specific tasks could only be
> done by the security admin.
> All these were enforced by selinux.
> Although, I don't see such implementations in ages, I still think they are out
> there.

That seems like a crazy thing.  Sys admin can write to firmware, so you
can't really separate root from sys admin.  There are so many other
things that you can do with sys admin.

Another possibility is that maybe the NSA uses selinux for logging, to
try out what files Snowden accessed.  But it's sort of weird for us to
try support some application which might not exist.  TongZhang, try
emailing these things directly to the selinux devs.
selinux@tycho.nsa.gov  They're really the best qualified to talk about
missing LSM checks.

regards,
dan carpenter
