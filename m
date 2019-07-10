Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46924 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfGJVuA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 17:50:00 -0400
Subject: Re: [PATCH] Fix the inconsistency between the code and the manual
 page of mkfs.xfs.
From: Eric Sandeen <sandeen@sandeen.net>
References: <1560421580-22920-1-git-send-email-Alvin@linux.alibaba.com>
 <aa442f3b-e0ee-ea55-efcd-9aa3a499fdec@sandeen.net>
Message-ID: <821e1d22-06ef-9ec9-f1ff-155792f8beb9@sandeen.net>
Date: Wed, 10 Jul 2019 16:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <aa442f3b-e0ee-ea55-efcd-9aa3a499fdec@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alvin@linux.alibaba.com, linux-xfs@vger.kernel.org, sandeen@redhat.com
Cc: caspar@linux.alibaba.com

To save time, I'll merge this with my edits if you agree:



mkfs.xfs.8: Fix an inconsistency between the code and the man page.

From: Alvin Zheng <Alvin@linux.alibaba.com>

The man page currently states that block and sector size units cannot
be used for other option values unless they are explicitly specified,
when in fact the default sizes will be used in that case.

Change the man page to clarify this.

Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>
[sandeen: sector/block values do not need to be specified first]
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 78b15015..9d762a43 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -115,9 +115,9 @@ When specifying parameters in units of sectors or filesystem blocks, the
 .B \-s
 option or the
 .B \-b
-option first needs to be added to the command line.
-Failure to specify the size of the units will result in illegal value errors
-when parameters are quantified in those units.
+option may be used to specify the size of the sector or block.
+If the size of the block or sector is not specified, the default sizes
+(block: 4KiB, sector: 512B) will be used.
 .PP
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
@@ -136,10 +136,6 @@ The filesystem block size is specified with a
 in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
 .IP
-To specify any options on the command line in units of filesystem blocks, this
-option must be specified first so that the filesystem block size is
-applied consistently to all options.
-.IP
 Although
 .B mkfs.xfs
 will accept any of these values and create a valid filesystem,
@@ -901,10 +897,6 @@ is 512 bytes. The minimum value for sector size is
 .I sector_size
 must be a power of 2 size and cannot be made larger than the
 filesystem block size.
-.IP
-To specify any options on the command line in units of sectors, this
-option must be specified first so that the sector size is
-applied consistently to all options.
 .RE
 .TP
 .BI \-L " label"
