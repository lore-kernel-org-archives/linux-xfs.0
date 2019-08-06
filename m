Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33264 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732142AbfHFJEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 05:04:33 -0400
Date: Tue, 6 Aug 2019 10:03:23 +0100
From: Sheriff Esseson <sheriffesseson@gmail.com>
Subject: [PATCH] Documentation: fs: Convert xfs-delayed-logging-design.txt to
 ReSt
Message-ID: <20190806090323.GA16095@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: skhan@linuxfoundation.org
Cc: linux-kernel-mentees@lists.linuxfoundation.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "supporter:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

Convert xfs-delayed-logging-design.txt to ReST and fix broken references.
The enumerations at "Lifecycle Changes" breaks because of lines begining with
"<", treat as diagrams.

Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>
---
 Documentation/filesystems/index.rst           |  1 +
 ...ign.txt => xfs-delayed-logging-design.rst} | 69 +++++++++++--------
 MAINTAINERS                                   |  2 +-
 3 files changed, 44 insertions(+), 28 deletions(-)
 rename Documentation/filesystems/{xfs-delayed-logging-design.txt => xfs-delayed-logging-design.rst} (96%)

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 2de2fe2ab078..0b94ff710b67 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -32,3 +32,4 @@ filesystem implementations.
 
    journalling
    fscrypt
+   xfs-delayed-logging-design
diff --git a/Documentation/filesystems/xfs-delayed-logging-design.txt b/Documentation/filesystems/xfs-delayed-logging-design.rst
similarity index 96%
rename from Documentation/filesystems/xfs-delayed-logging-design.txt
rename to Documentation/filesystems/xfs-delayed-logging-design.rst
index 9a6dd289b17b..a85ca00d4221 100644
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
@@ -27,14 +30,18 @@ written to disk after change D, we would see in the log the following series
 of transactions, their contents and the log sequence number (LSN) of the
 transaction:
 
+        ============           =========        ==============
 	Transaction		Contents	LSN
+        ============           =========        ==============
 	   A			   A		   X
 	   B			  A+B		  X+n
 	   C			 A+B+C		 X+n+m
 	   D			A+B+C+D		X+n+m+o
 	    <object written to disk>
-	   E			   E		   Y (> X+n+m+o)
+        ------------------------------------------------------
+	   E			   E		Y (> X+n+m+o)
 	   F			  E+F		  Y+p
+        ============           =========        ==============
 
 In other words, each time an object is relogged, the new transaction contains
 the aggregation of all the previous changes currently held only in the log.
@@ -85,7 +92,7 @@ IO permanently. Hence the XFS journalling subsystem can be considered to be IO
 bound.
 
 Delayed Logging: Concepts
--------------------------
+=========================
 
 The key thing to note about the asynchronous logging combined with the
 relogging technique XFS uses is that we can be relogging changed objects
@@ -154,9 +161,10 @@ The fundamental requirements for delayed logging in XFS are simple:
 	6. No performance regressions for synchronous transaction workloads.
 
 Delayed Logging: Design
------------------------
+=======================
 
 Storing Changes
+---------------
 
 The problem with accumulating changes at a logical level (i.e. just using the
 existing log item dirty region tracking) is that when it comes to writing the
@@ -194,30 +202,30 @@ asynchronous transactions to the log. The differences between the existing
 formatting method and the delayed logging formatting can be seen in the
 diagram below.
 
-Current format log vector:
+Current format log vector::
 
-Object    +---------------------------------------------+
-Vector 1      +----+
-Vector 2                    +----+
-Vector 3                                   +----------+
+        Object    +---------------------------------------------+
+        Vector 1      +----+
+        Vector 2                    +----+
+        Vector 3                                   +----------+
 
-After formatting:
+After formatting::
 
-Log Buffer    +-V1-+-V2-+----V3----+
+        Log Buffer    +-V1-+-V2-+----V3----+
 
-Delayed logging vector:
+Delayed logging vector::
 
-Object    +---------------------------------------------+
-Vector 1      +----+
-Vector 2                    +----+
-Vector 3                                   +----------+
+        Object    +---------------------------------------------+
+        Vector 1      +----+
+        Vector 2                    +----+
+        Vector 3                                   +----------+
 
-After formatting:
+After formatting::
 
-Memory Buffer +-V1-+-V2-+----V3----+
-Vector 1      +----+
-Vector 2           +----+
-Vector 3                +----------+
+        Memory Buffer +-V1-+-V2-+----V3----+
+        Vector 1      +----+
+        Vector 2           +----+
+        Vector 3                +----------+
 
 The memory buffer and associated vector need to be passed as a single object,
 but still need to be associated with the parent object so if the object is
@@ -242,6 +250,7 @@ relogged in memory.
 
 
 Tracking Changes
+----------------
 
 Now that we can record transactional changes in memory in a form that allows
 them to be used without limitations, we need to be able to track and accumulate
@@ -278,6 +287,7 @@ done for convenience/sanity of the developers.
 
 
 Delayed Logging: Checkpoints
+============================
 
 When we have a log synchronisation event, commonly known as a "log force",
 all the items in the CIL must be written into the log via the log buffers.
@@ -341,7 +351,7 @@ Hence log vectors need to be able to be chained together to allow them to be
 detached from the log items. That is, when the CIL is flushed the memory
 buffer and log vector attached to each log item needs to be attached to the
 checkpoint context so that the log item can be released. In diagrammatic form,
-the CIL would look like this before the flush:
+the CIL would look like this before the flush::
 
 	CIL Head
 	   |
@@ -362,7 +372,7 @@ the CIL would look like this before the flush:
 					-> vector array
 
 And after the flush the CIL head is empty, and the checkpoint context log
-vector list would look like:
+vector list would look like::
 
 	Checkpoint Context
 	   |
@@ -411,6 +421,7 @@ compare" situation that can be done after a working and reviewed implementation
 is in the dev tree....
 
 Delayed Logging: Checkpoint Sequencing
+======================================
 
 One of the key aspects of the XFS transaction subsystem is that it tags
 committed transactions with the log sequence number of the transaction commit.
@@ -474,6 +485,7 @@ force the log at the LSN of that transaction) and so the higher level code
 behaves the same regardless of whether delayed logging is being used or not.
 
 Delayed Logging: Checkpoint Log Space Accounting
+================================================
 
 The big issue for a checkpoint transaction is the log space reservation for the
 transaction. We don't know how big a checkpoint transaction is going to be
@@ -491,7 +503,7 @@ the size of the transaction and the number of regions being logged (the number
 of log vectors in the transaction).
 
 An example of the differences would be logging directory changes versus logging
-inode changes. If you modify lots of inode cores (e.g. chmod -R g+w *), then
+inode changes. If you modify lots of inode cores e.g. ``$ chmod -R g+w *``, then
 there are lots of transactions that only contain an inode core and an inode log
 format structure. That is, two vectors totaling roughly 150 bytes. If we modify
 10,000 inodes, we have about 1.5MB of metadata to write in 20,000 vectors. Each
@@ -565,6 +577,7 @@ which is once every 30s.
 
 
 Delayed Logging: Log Item Pinning
+=================================
 
 Currently log items are pinned during transaction commit while the items are
 still locked. This happens just after the items are formatted, though it could
@@ -605,6 +618,7 @@ object, we have a race with CIL being flushed between the check and the pin
 lock to guarantee that we pin the items correctly.
 
 Delayed Logging: Concurrent Scalability
+=======================================
 
 A fundamental requirement for the CIL is that accesses through transaction
 commits must scale to many concurrent commits. The current transaction commit
@@ -683,8 +697,9 @@ woken by the wrong event.
 
 
 Lifecycle Changes
+=================
 
-The existing log item life cycle is as follows:
+The existing log item life cycle is as follows::
 
 	1. Transaction allocate
 	2. Transaction reserve
@@ -729,7 +744,7 @@ at the same time. If the log item is in the AIL or between steps 6 and 7
 and steps 1-6 are re-entered, then the item is relogged. Only when steps 8-9
 are entered and completed is the object considered clean.
 
-With delayed logging, there are new steps inserted into the life cycle:
+With delayed logging, there are new steps inserted into the life cycle::
 
 	1. Transaction allocate
 	2. Transaction reserve
diff --git a/MAINTAINERS b/MAINTAINERS
index 6c49b48cfd69..acbce11c3d49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17664,7 +17664,7 @@ T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 S:	Supported
 F:	Documentation/admin-guide/xfs.rst
 F:	Documentation/ABI/testing/sysfs-fs-xfs
-F:	Documentation/filesystems/xfs-delayed-logging-design.txt
+F:	Documentation/filesystems/xfs-delayed-logging-design.rst
 F:	Documentation/filesystems/xfs-self-describing-metadata.txt
 F:	fs/xfs/
 F:	include/uapi/linux/dqblk_xfs.h
-- 
2.17.1
