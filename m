Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41438 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbeJEDxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 23:53:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id x12-v6so11362757wru.8
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 13:57:58 -0700 (PDT)
Received: from dyn.cm.kabsi.at (h081217199198.dyn.cm.kabsi.at. [81.217.199.198])
        by smtp.gmail.com with ESMTPSA id x2-v6sm2003171wrs.47.2018.10.04.13.57.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 13:57:56 -0700 (PDT)
From: Stefan Ring <stefanrin@gmail.com>
Subject: [PATCH 0/1] Try to squash metadump data leaks
Date: Thu,  4 Oct 2018 22:57:48 +0200
Message-Id: <20181004205749.2042-1-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is inspired by a thread last year when someone intended to
collect metadata about filesystems and I would have been happy to
help, except that I noticed lots of left-over data in the dump that
should never have been there. I would not have worried that much about
some fragments of Python code or directory listings, but the
possibility of recognizable customer data (potentially even
cryptographic keys) made it unthinkable to share this.

My method of coming up with these patches was: Pipe a metadump of my
reference image through "strings -n 10" and scroll until something
recognizable catches my eye. This did not take too long, usually. Find
the origin of the found leak and squash it (using "XFS File System
Structure" from the wiki). Repeat until there is nothing recognizable
left. Said image is a 1.1 TB volume created in early 2012 and used
daily ever since on our development server, containing about 12
million inodes (mostly hundreds of checkouts of our main Mercurial
repo with about 15000 files in it).

I have not submitted a patch before, and I don't think I will be
particularly pushy with this one. It exists mostly to inform you of my
findings. I have not dealt at all with a v3 filesystem. TBH, I don't
even know what this is and how to create one. Looking at the metadump
code as it exists now, it would likely have been much safer to copy
just the required contents as opposed to copying everything and then
trying to find every nook and cranny where unwanted stuff could seep
through.

Stefan Ring (1):
  xfs_metadump: Zap more stale data

 db/metadump.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 5 deletions(-)

-- 
2.14.4
