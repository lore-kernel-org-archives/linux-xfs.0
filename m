Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752751AbdHXUJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 16:09:33 -0400
Subject: [PATCH 7/6] xfs_bmap: fix -n documentation in manpage
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5fb3c541-ceaf-409c-3536-96bf8805076c@sandeen.net>
Date: Thu, 24 Aug 2017 15:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

xfs_bmap's manpage mis-describes the behavior from the
-n option.  xfs_io's fiemap command references the xfs_bmap
manpage, and has the same problem:

-n does not change the query batch size, it limits the number
of extents displayed.

This has been true for 15+ years, so change the documentation
to match reality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index 098cfae..c725519 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -77,12 +77,11 @@ option is used.
 .BI \-n " num_extents"
 If this option is given,
 .B xfs_bmap
-obtains the extent list of the file in groups of
+will display at most
 .I num_extents
 extents. In the absence of
 .BR \-n ", " xfs_bmap
-queries the system for the number of extents in the file and uses that
-value to compute the group size.
+will display all extents in the file.
 .TP
 .B \-p
 If this option is used,

