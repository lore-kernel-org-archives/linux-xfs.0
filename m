Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 01:44:18 -0700 (PDT)
Received: from stitch.e-626.net (60.153.216.81.static.spa.siw.siwnet.net [81.216.153.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5B8iDWt018430
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 01:44:15 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Johan Andersson <johan@e-626.net>
In-Reply-To: <20070611073559.GA26257@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070611073559.GA26257@tuatara.stupidest.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 10:43:29 +0200
Message-Id: <1181551409.19145.57.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

But xfs_fsr sorts inodes by number of extents in order to optimise free
space. If you run the "find ..." on a badly fragmented file system, it
won't optimise much at all, since there won't be free chunks large
enough for big files. I tried to just copy one file and remove the
original in the file system mentioned, but it only got worse. Running
running xfs_fsr on the whole file system got it down to 0% file frag, 1
extent/file. So xfs_fsr on a whole file system is much more effective
than xfs_fsr on each file in the file system. Especially if the file
system is near full.

/Johan Andersson

On Mon, 2007-06-11 at 00:35 -0700, Chris Wedgwood wrote:
> On Mon, Jun 11, 2007 at 08:51:32AM +0200, Johan Andersson wrote:
> 
> > So I run some tests. And as Chris pointed out, when running xfs_fsr
> > on a badly fragmented filesystem, it completely destroys the
> > locality of files.
> 
> You can always do something like:
> 
>    find path/to/defrag/ -type f -print0 | xargs -r0 xfs_fsr -v
> 
> and check /var/log/daemon.log (or whatever) for a progress report.
> 
> This will of course only make one pass, so you might want to wrap it.
> But unless you're really low on space it's probably not useful to make
> many passes anyhow.
> 
> You might always want the -d argument (not sure if the man page has
> this).
> 
> 
