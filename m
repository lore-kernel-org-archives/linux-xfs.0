Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20434 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753836AbdHXU4A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 16:56:00 -0400
Date: Thu, 24 Aug 2017 13:55:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_io: clarify the fsmap documentation
Message-ID: <20170824205555.GI4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Explicitly declare that the 'start' and 'end' arguments to fsmap require
one of -d, -l, or -r to select the data, log, or realtime device, and fix
misspelled command name while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/fsmap.c        |    2 ++
 man/man8/xfs_io.8 |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io/fsmap.c b/io/fsmap.c
index 9e70c7b..448fb53 100644
--- a/io/fsmap.c
+++ b/io/fsmap.c
@@ -48,6 +48,8 @@ fsmap_help(void)
 " -n -- query n extents at a time.\n"
 " -m -- output machine-readable format.\n"
 " -v -- Verbose information, show AG and offsets.  Show flags legend on 2nd -v\n"
+"\n"
+"The optional start and end arguments require one of -d, -l, or -r to be set.\n"
 "\n"));
 }
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c87db0b..0082ca9 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -323,6 +323,9 @@ and
 .I end
 arguments can be used to constrain the output to a particular range of
 disk blocks.
+If these two options are specified, exactly one of
+.BR "-d" ", " "-l" ", or " "-r"
+must also be set.
 .RE
 .RS 1.0i
 .PD 0
@@ -372,12 +375,12 @@ for other filesystem metadata.
 .TP
 .BI \-n " num_extents"
 If this option is given,
-.B xfs_fsmap
+.B fsmap
 obtains the extent list of the file in groups of
 .I num_extents
 extents.
 In the absence of
-.BR \-n ", " xfs_fsmap
+.BR "-n" ", " "fsmap"
 queries the system for extents in groups of 131,072 records.
 .TP
 .B \-v
