Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 23:39:27 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA97dJSV032511
	for <linux-xfs@oss.sgi.com>; Thu, 8 Nov 2007 23:39:20 -0800
Message-ID: <47340ECC.4000205@sgi.com>
Date: Fri, 09 Nov 2007 18:39:56 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: acl and attr: Fix path walking code
References: <200710281858.24428.agruen@suse.de>
In-Reply-To: <200710281858.24428.agruen@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-xfs@oss.sgi.com, Gerald Bringhurst <gbringhurst@novell.com>, Brandon Philips <bphilips@suse.de>

Andreas Gruenbacher wrote:
> Hello,
> 
> the tree walking code in acl and attr broke when resolve_symlinks() was 
> introduced (by me, unfortunately). Following symlinks passed in on the 
> command line is the intended behavior for the tools (unless in -P mode). The 
> first version was buggy, and so someone "fixed" it by replacing readlink() 
> with realpath() in resolve_symlinks().
> 
> The result is that the output of getfattr and getfacl will show pathnames that 
> may point anywhere. When processing a directory tree it sometimes is helpful 
> to treat symlinks as regular files, but resolving the pathnames is totally 
> wrong.
> 
> After runnig into problem after problem with nftw and never ending up with 
> even half-way clean code, I think it's time to ditch it altogether and 
> replace it with sane code. So here are two patches, one for attr and one for 
> acl, that does that.
> 
> Files include/walk_tree.h and libmisc/walk_tree.c are identical in both 
> patches; that code is shared between the two packages.
> 
> Okay to apply?
> 
> Thanks,
> Andreas
> 

You mention -L/-P is like chown.
However, -P for getattr isn't about not walking symlinks
to directories,
it's about skipping symlinks altogether, right?

--Tim
