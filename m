Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 21:21:01 -0700 (PDT)
Received: from smtp109.sbc.mail.mud.yahoo.com (smtp109.sbc.mail.mud.yahoo.com [68.142.198.208])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k744KZDW019952
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 21:20:39 -0700
Date: Thu, 3 Aug 2006 21:20:03 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: "xfs_io -c chattr +i " on a symlink
Message-ID: <20060804042003.GA9271@tuatara.stupidest.org>
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net> <20060804102814.A2401829@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060804102814.A2401829@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Dan Am <xfs@lonx.net>, xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 10:28:14AM +1000, Nathan Scott wrote:

> Its not possible to open(2) a symbolic link (see
> fs/namei.c::may_open), which means you cannot get a file descriptor
> for a symlink, which means you cannot issue an ioctl(2) to a symlink
> (which is how the inode flags are set), which means you're out of
> luck on this one, sorry.

I always disliked open/ioctl for this.  I think we should actually
have a separate syscall for chattr, etc. (FreeBSD does this I think?)
