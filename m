Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 17:29:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k740T5DW011773
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 17:29:17 -0700
Date: Fri, 4 Aug 2006 10:28:14 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: "xfs_io -c chattr +i " on a symlink
Message-ID: <20060804102814.A2401829@wobbly.melbourne.sgi.com>
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>; from xfs@lonx.net on Thu, Aug 03, 2006 at 12:26:56PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan Am <xfs@lonx.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 03, 2006 at 12:26:56PM +0200, Dan Am wrote:
> (resend, since I used the wrong account to send the initial mail, sorry)
> 
> Dear list,
> 
> I am trying to make a symlink immutable with chattr, however the command
> seems to follow the link, which point to a NFS Mount.
> Setting xattr works on symlink btw, which is useful.
> More data below
> Any ideas ?

Its not possible to open(2) a symbolic link (see fs/namei.c::may_open),
which means you cannot get a file descriptor for a symlink, which means
you cannot issue an ioctl(2) to a symlink (which is how the inode flags
are set), which means you're out of luck on this one, sorry.

cheers.

-- 
Nathan
