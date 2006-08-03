Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 05:19:48 -0700 (PDT)
Received: from otto.lonx.net (work.lonx.net [195.243.240.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k73CJXDW001640
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 05:19:34 -0700
Received: from localhost (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id 61DE0261D
	for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:18:42 +0200 (CEST)
Received: from otto.lonx.net ([127.0.0.1])
 by localhost (otto [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 23913-04 for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:18:40 +0200 (CEST)
Received: from otto.lonx.net (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id A73F8261C
	for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:18:40 +0200 (CEST)
Message-ID: <15447.62.159.242.114.1154600320.squirrel@otto.lonx.net>
Date: Thu, 3 Aug 2006 12:18:40 +0200 (CEST)
Subject: "xfs_io -c chattr +i " on a symlink
From: "Daniel Amthor" <da@lonx.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
References: 
In-Reply-To: 
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dear list,

I am trying to make a symlink immutable with chattr, however the command
seems to follow the link, which point to a NFS Mount.
Setting xattr works on symlink btw, which is useful.
More data below
Any ideas ?

Best Regards
Dan

Heres the situation from my machine's view:
/data > ls -l bin
lrwxrwxrwx  1 root root 48 Aug  2 15:53 bin -> /archive/l01abnfs07/bin

/data> xfs_io  -c "chattr +i" bin
xfs_io: specified file ["bin"] is not on an XFS filesystem

~ > xfs_io -V
xfs_io version 2.8.4

~ > cat /etc/SuSE-release
SUSE LINUX Enterprise Server 9 (i586)
VERSION = 9
PATCHLEVEL = 3
