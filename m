Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 11:03:43 -0700 (PDT)
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.180])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l86I3d4p010763
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 11:03:41 -0700
Received: by el-out-1112.google.com with SMTP id y26so53772ele
        for <xfs@oss.sgi.com>; Thu, 06 Sep 2007 11:03:39 -0700 (PDT)
Message-ID: <170b1bd40709061005t787494b6lca283320cace6c31@mail.gmail.com>
Date: Thu, 6 Sep 2007 18:05:29 +0100
From: "Mark Goodall" <mark.goodall@gmail.com>
Subject: Bug Report
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Not sure what caused this bug, how much more information do you need?

        - 18:01:15: check for inodes claiming duplicate blocks - 198528 of
198528 inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ...
corrupt dinode 25809974, extent total = 16, nblocks = 0.  This is a bug.
Please report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x8d65fd0)
couldn't map inode 25809974, err = 117
entry "gobo_3.3-6_i386.deb" in shortform directory inode 1770978822 points
to free inode 1770978825
would junk entry "gobo_3.3-6_i386.deb"
        - 18:01:48: traversing filesystem - 32 of 32 allocation groups done
        - traversal finished ...
        - traversing all unattached subtrees ...
Segmentation fault (core dumped)

OS: Ubuntu Linux mserve 2.6.20-16-386 #2 Fri Aug 31 00:51:58 UTC 2007 i686
GNU/Linux
fully patched from official repositories


[[HTML alternate version deleted]]
