Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 08:07:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l55F75Wt021248
	for <linux-xfs@oss.sgi.com>; Tue, 5 Jun 2007 08:07:06 -0700
Message-ID: <46657C17.1090105@sandeen.net>
Date: Tue, 05 Jun 2007 10:07:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: building xfstests
References: <5d96567b0706050749o74bc7701g154e836c43a511be@mail.gmail.com>
In-Reply-To: <5d96567b0706050749o74bc7701g154e836c43a511be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com

Raz Ben-Jehuda(caro) wrote:
> Hello
> I have downloaded from the web the cvs repository of the
> module xfs-cmds.
> 
> I failing to build it.  the bellow is the "make" output.
...

> Wrote: 
> /d1/rt/raz/downloads/xfs-cmds/xfsdump/build/xfsdump-2.2.45.src.tar.gz
> Wrote: 
> /d1/rt/raz/downloads/xfs-cmds/xfsdump/build/tar/xfsdump-2.2.45.tar.gz

So, everything built - but it just did not build rpms - which is maybe 
fine with you?

> for d in attr acl xfsprogs dmapi xfsdump; do \
>        ( cd /d1/rt/raz/downloads/xfs-cmds && /bin/cp
> $d/build/rpm/*.src.rpm /d1/rt/raz/downloads/xfs-cmds/SRPMS ) \
> done
> /bin/cp: cannot stat `attr/build/rpm/*.src.rpm': No such file or directory
> /bin/cp: cannot stat `acl/build/rpm/*.src.rpm': No such file or directory
> /bin/cp: cannot stat `xfsprogs/build/rpm/*.src.rpm': No such file or 
> directory
> /bin/cp: cannot stat `dmapi/build/rpm/*.src.rpm': No such file or directory
> /bin/cp: cannot stat `xfsdump/build/rpm/*.src.rpm': No such file or 
> directory

It's just trying to copy rpms to a central location, and they didn't 
build for you (maybe you're on debian or similar?)

So kind of a dumb top-level makefile (hmm who wrote that stuff... ;-) 
but it looks like all of your packages built as tarballs.

-Eric

> make: *** [cmds] Error 1
> 
> anyone ?
> 
> 
