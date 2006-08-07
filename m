Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 21:56:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k774tYDW015848
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 21:55:45 -0700
Date: Mon, 7 Aug 2006 14:54:43 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: "xfs_io -c chattr +i " on a symlink
Message-ID: <20060807145443.C2501392@wobbly.melbourne.sgi.com>
References: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net> <44D20473.3010304@sandeen.net> <20060804102949.B2401829@wobbly.melbourne.sgi.com> <48367.62.159.242.114.1154691452.squirrel@otto.lonx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48367.62.159.242.114.1154691452.squirrel@otto.lonx.net>; from xfs@lonx.net on Fri, Aug 04, 2006 at 01:37:32PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan Am <xfs@lonx.net>
Cc: xfs@oss.sgi.com

On Fri, Aug 04, 2006 at 01:37:32PM +0200, Dan Am wrote:
> On Fri, August 4, 2006 2:29 am, Nathan Scott wrote:
> 
> > ... I think you just set immutable on /tmp.  Try a broken symlink,
> > instead of one that points to an existing inode.
> Nope:

Eh?

> /data/tara-test > ls -l test
> lrwxr-xr-x  1 root root 13 Aug  4 13:33 test -> /archive/no-such-file
> 
> /data/tara-test > xfs_io -c "chattr +i" test
> test: No such file or directory

Right, that was my point.  As I said, you're out of luck - there
is currently no way to do what you want.

cheers.

-- 
Nathan
