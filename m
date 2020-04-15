Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B5EC2BB55
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 14:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0C6208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586961257;
	bh=uXg2CbdYoVc2/yvEd4tpZ+hPjUaqKNfqwpxEWsr8Q7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uUuQlxIcTFDf1/Do+sgzIwbdnQRBD4tpN/YCy/gGCw/fCEQ0HMVFRWDfb3fCUJkbn
	 nKf195WwyhdIZX04xGb/aDQ2fjc4Td4JIphJ+Z7MlKNX2/RfrhrCrj8qb6iqMfNc7f
	 KJA165U3KmdbpPngz72xiU0zmbheEWRSuIUcbcmE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394120AbgDOOdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 10:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394096AbgDOOdI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 10:33:08 -0400
Received: from mail.kernel.org (ip5f5ad4d8.dynamic.kabel-deutschland.de [95.90.212.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB586221F7;
        Wed, 15 Apr 2020 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586961172;
        bh=uXg2CbdYoVc2/yvEd4tpZ+hPjUaqKNfqwpxEWsr8Q7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6X+Gop7NHKdwmw6Ik5pODRXAfpIjbbSMY/HQBNJJZqVf7d1i0x1pyv38XDwAheuO
         TgNOGiWodXbXKCJDrC7Ox/juoKQRKCKwgPxGCsHyutpYNR22AGgolRkQELv8o8t0Xf
         Us9ci4Hh5A0zIwjLSbkh7V6gdbwlGTW7KJhd0tuU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jOj5u-006kQK-8C; Wed, 15 Apr 2020 16:32:50 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 33/34] docs: filesystems: convert xfs-delayed-logging-design.txt to ReST
Date:   Wed, 15 Apr 2020 16:32:46 +0200
Message-Id: <b491ec35c2119568edb77d3d2ba0c8d344b9f66e.1586960617.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <cover.1586960617.git.mchehab+huawei@kernel.org>
References: <cover.1586960617.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

- Add a SPDX header;
- Adjust document and section titles;
- Some whitespace fixes and new line breaks;
- Mark literal blocks as such;
- Add it to filesystems/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/filesystems/index.rst           |  1 +
 ...ign.txt => xfs-delayed-logging-design.rst} | 65 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 40 insertions(+), 28 deletions(-)
 rename Documentation/filesystems/{xfs-delayed-logging-design.txt => xfs-delayed-logging-design.rst} (97%)

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 687fe64d8b5c..70c0e0b29e74 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -121,4 +121,5 @@ Documentation for filesystem implementations.
    udf
    virtiofs
    vfat
+   xfs-delayed-logging-design
    zonefs
diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.rst
similarity index 97%
rename from Documentation/filesystems/xfs-delayed-logging-design.txt
rename to Documentation/filesystems/xfs-delayed-logging-design.rst
index 9a6dd289b17b..464405d2801e 100644
--- a/Documentation/filesystems/xfs-delayed-logging-design.txt
+++ b/Documentation/filesystems/xfs-delayed-logging-design.rst
@@ -1,8 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================
 XFS Delayed Logging Design
---------------------------
+==========================
 
 Introduction to Re-logging in XFS
----------------------------------
+=================================
 
 XFS logging is a combination of logical and physical logging. Some objects,
 such as inodes and dquots, are logged in logical format where the details
@@ -25,7 +28,7 @@ changes in the new transaction that is written to the log.
 That is, if we have a sequence of changes A through to F, and the object was
 written to disk after change D, we would see in the log the following series
 of transactions, their contents and the log sequence number (LSN) of the
-transaction:
+transaction::
 
 	Transaction		Contents	LSN
 	   A			   A		   X
@@ -85,7 +88,7 @@ IO permanently. Hence the XFS journalling subsystem can be considered to be IO
 bound.
 
 Delayed Logging: Concepts
--------------------------
+=========================
 
 The key thing to note about the asynchronous logging combined with the
 relogging technique XFS uses is that we can be relogging changed objects
@@ -154,9 +157,10 @@ The fundamental requirements for delayed logging in XFS are simple:
 	6. No performance regressions for synchronous transaction workloads.
 
 Delayed Logging: Design
------------------------
+=======================
 
 Storing Changes
+---------------
 
 The problem with accumulating changes at a logical level (i.e. just using the
 existing log item dirty region tracking) is that when it comes to writing the
@@ -194,30 +198,30 @@ asynchronous transactions to the log. The differences between the existing
 formatting method and the delayed logging formatting can be seen in the
 diagram below.
 
-Current format log vector:
+Current format log vector::
 
-Object    +---------------------------------------------+
-Vector 1      +----+
-Vector 2                    +----+
-Vector 3                                   +----------+
+    Object    +---------------------------------------------+
+    Vector 1      +----+
+    Vector 2                    +----+
+    Vector 3                                   +----------+
 
-After formatting:
+After formatting::
 
-Log Buffer    +-V1-+-V2-+----V3----+
+    Log Buffer    +-V1-+-V2-+----V3----+
 
-Delayed logging vector:
+Delayed logging vector::
 
-Object    +---------------------------------------------+
-Vector 1      +----+
-Vector 2                    +----+
-Vector 3                                   +----------+
+    Object    +---------------------------------------------+
+    Vector 1      +----+
+    Vector 2                    +----+
+    Vector 3                                   +----------+
 
-After formatting:
+After formatting::
 
-Memory Buffer +-V1-+-V2-+----V3----+
-Vector 1      +----+
-Vector 2           +----+
-Vector 3                +----------+
+    Memory Buffer +-V1-+-V2-+----V3----+
+    Vector 1      +----+
+    Vector 2           +----+
+    Vector 3                +----------+
 
 The memory buffer and associated vector need to be passed as a single object,
 but still need to be associated with the parent object so if the object is
@@ -242,6 +246,7 @@ relogged in memory.
 
 
 Tracking Changes
+----------------
 
 Now that we can record transactional changes in memory in a form that allows
 them to be used without limitations, we need to be able to track and accumulate
@@ -278,6 +283,7 @@ done for convenience/sanity of the developers.
 
 
 Delayed Logging: Checkpoints
+----------------------------
 
 When we have a log synchronisation event, commonly known as a "log force",
 all the items in the CIL must be written into the log via the log buffers.
@@ -341,7 +347,7 @@ Hence log vectors need to be able to be chained together to allow them to be
 detached from the log items. That is, when the CIL is flushed the memory
 buffer and log vector attached to each log item needs to be attached to the
 checkpoint context so that the log item can be released. In diagrammatic form,
-the CIL would look like this before the flush:
+the CIL would look like this before the flush::
 
 	CIL Head
 	   |
@@ -362,7 +368,7 @@ the CIL would look like this before the flush:
 					-> vector array
 
 And after the flush the CIL head is empty, and the checkpoint context log
-vector list would look like:
+vector list would look like::
 
 	Checkpoint Context
 	   |
@@ -411,6 +417,7 @@ compare" situation that can be done after a working and reviewed implementation
 is in the dev tree....
 
 Delayed Logging: Checkpoint Sequencing
+--------------------------------------
 
 One of the key aspects of the XFS transaction subsystem is that it tags
 committed transactions with the log sequence number of the transaction commit.
@@ -474,6 +481,7 @@ force the log at the LSN of that transaction) and so the higher level code
 behaves the same regardless of whether delayed logging is being used or not.
 
 Delayed Logging: Checkpoint Log Space Accounting
+------------------------------------------------
 
 The big issue for a checkpoint transaction is the log space reservation for the
 transaction. We don't know how big a checkpoint transaction is going to be
@@ -491,7 +499,7 @@ the size of the transaction and the number of regions being logged (the number
 of log vectors in the transaction).
 
 An example of the differences would be logging directory changes versus logging
-inode changes. If you modify lots of inode cores (e.g. chmod -R g+w *), then
+inode changes. If you modify lots of inode cores (e.g. ``chmod -R g+w *``), then
 there are lots of transactions that only contain an inode core and an inode log
 format structure. That is, two vectors totaling roughly 150 bytes. If we modify
 10,000 inodes, we have about 1.5MB of metadata to write in 20,000 vectors. Each
@@ -565,6 +573,7 @@ which is once every 30s.
 
 
 Delayed Logging: Log Item Pinning
+---------------------------------
 
 Currently log items are pinned during transaction commit while the items are
 still locked. This happens just after the items are formatted, though it could
@@ -605,6 +614,7 @@ object, we have a race with CIL being flushed between the check and the pin
 lock to guarantee that we pin the items correctly.
 
 Delayed Logging: Concurrent Scalability
+---------------------------------------
 
 A fundamental requirement for the CIL is that accesses through transaction
 commits must scale to many concurrent commits. The current transaction commit
@@ -683,8 +693,9 @@ woken by the wrong event.
 
 
 Lifecycle Changes
+-----------------
 
-The existing log item life cycle is as follows:
+The existing log item life cycle is as follows::
 
 	1. Transaction allocate
 	2. Transaction reserve
@@ -729,7 +740,7 @@ at the same time. If the log item is in the AIL or between steps 6 and 7
 and steps 1-6 are re-entered, then the item is relogged. Only when steps 8-9
 are entered and completed is the object considered clean.
 
-With delayed logging, there are new steps inserted into the life cycle:
+With delayed logging, there are new steps inserted into the life cycle::
 
 	1. Transaction allocate
 	2. Transaction reserve
diff --git a/MAINTAINERS b/MAINTAINERS
index 2ac15ec9ebf8..c52991586853 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18551,7 +18551,7 @@ W:	http://xfs.org/
 T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 F:	Documentation/ABI/testing/sysfs-fs-xfs
 F:	Documentation/admin-guide/xfs.rst
-F:	Documentation/filesystems/xfs-delayed-logging-design.txt
+F:	Documentation/filesystems/xfs-delayed-logging-design.rst
 F:	Documentation/filesystems/xfs-self-describing-metadata.txt
 F:	fs/xfs/
 F:	include/uapi/linux/dqblk_xfs.h
-- 
2.25.2

