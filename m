Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 20:12:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m194Cgfu025679
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 20:12:44 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 240C55B9B2A
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 20:13:05 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9IGZrKOlTZOhW8kh for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 20:13:05 -0800 (PST)
Message-ID: <47AD284F.7080603@sandeen.net>
Date: Fri, 08 Feb 2008 22:13:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25
References: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com>
In-Reply-To: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> This will update the following files:
> 
>  fs/xfs/Makefile-linux-2.6      |    1 -

Is there a reason the other various makefile updates still haven't been
pushed?  They're a lot tidier now, and they facilitate out-of-tree
building...

Thanks,
-Eric

Remove Makefile wrappers in XFS

Makefile (and Kbuild) would include Makefile-linux-26
I doubt XFS will really still compile on 2.4; so drop that. This
moves Makefile-linux-26 into Makefile and drops Kbuild.
Also having wrappers as both Kbuild and Makefile seemed redundant
anyways.

The patch is relatively large because it renames a file, but
no functional changes.

Signed-off-by: Andi Kleen <ak@suse.de>
Merge of xfs-linux-melb:xfs-kern:29781a by kenmcd.

  Remove Makefile wrappers in XFS.

Fix up xfs out-of-tree builds. (a.k.a. external modules)

Change -I include directives to find headers in the out-of-tree spot.
This allows a directory containing only xfs files to be built as:

  # make -C /path/to/kernel M=`pwd`

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Merge of xfs-linux-melb:xfs-kern:29878a by kenmcd.

  fix up out-of-tree xfs builds.
