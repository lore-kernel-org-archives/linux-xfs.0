Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 21:53:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA95rnXx021081
	for <linux-xfs@oss.sgi.com>; Thu, 8 Nov 2007 21:53:51 -0800
Message-ID: <4733F301.9020706@sgi.com>
Date: Fri, 09 Nov 2007 16:41:21 +1100
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

Hi Andreas,

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

I applied attr patch and tried it out on xfstests/062
(which I believe was based on one of your tests).

==========================================================
--- 062.out     2006-03-28 12:52:32.000000000 +1000
+++ 062.out.bad 2007-11-09 15:38:09.000000000 +1100
@@ -526,6 +526,10 @@
  user.name=0xbabe
  user.name3=0xdeface

+# file: SCRATCH_MNT/lnk
+trusted.name=0xbabe
+trusted.name3=0xdeface
+
  # file: SCRATCH_MNT/dev/b
  trusted.name=0xbabe
  trusted.name3=0xdeface
@@ -562,6 +566,10 @@
  user.1=0x3233
  user.x=0x797a

+# file: SCRATCH_MNT/descend/and/ascend
+trusted.9=0x3837
+trusted.a=0x6263
+

  *** directory descent without following symlinks
  # file: SCRATCH_MNT/reg
==========================================================

So for the following of symlinks with getfattr -L
i.e.
   echo "*** directory descent with us following symlinks"
   getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT

Looking at the 2nd difference...
It now picks up descend/and/ascend which contains the symlink
of descend/and --> here/up.
So that makes sense, it is following a symlink which it
didn't before and finding a dir, "up" in the linked dir.
Good.

Looking at 1st difference...
It is now showing up "lnk" which is a symlink: lnk --> dir
So why is it showing this up
and yet it is not showing descend/and (which is a link to here/up)?
So yes we are following symlinks but are we supposed
to just do the symlinks themselves as well?

BTW, do we not allow user EAs on symlinks? (I've forgotten)

--Tim
