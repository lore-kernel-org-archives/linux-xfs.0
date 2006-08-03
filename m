Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 04:29:46 -0700 (PDT)
Received: from otto.lonx.net (work.lonx.net [195.243.240.241])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k73BTXDW024685
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 04:29:33 -0700
Received: from localhost (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id 052FF261C
	for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:26:59 +0200 (CEST)
Received: from otto.lonx.net ([127.0.0.1])
 by localhost (otto [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 23806-05 for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:26:56 +0200 (CEST)
Received: from otto.lonx.net (localhost [127.0.0.1])
	by otto.lonx.net (Postfix) with ESMTP id 4ABC2261B
	for <xfs@oss.sgi.com>; Thu,  3 Aug 2006 12:26:56 +0200 (CEST)
Message-ID: <28749.62.159.242.114.1154600816.squirrel@otto.lonx.net>
Date: Thu, 3 Aug 2006 12:26:56 +0200 (CEST)
Subject: "xfs_io -c chattr +i " on a symlink
From: "Dan Am" <xfs@lonx.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

(resend, since I used the wrong account to send the initial mail, sorry)

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
