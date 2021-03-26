Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5F0C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0981619F2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCZCsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhCZCsn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDEBC61A36;
        Fri, 26 Mar 2021 02:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616726923;
        bh=1MlbojNCqloqRJ65ZT5cDjxlOpuGTQimYjmNakPFE7Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YfSwXVtKeXJrTeNwSCiJ8/AaABQUgW7ay46iA7FWEKyPazUApnr5pAQ4X77Zd1s7D
         gdBAtzpKo7w5QZ3wKfnkLQMfO5H3Qqn+bxODFtYwpXVBMfvQ9zGpdYlxBkXXw4rwHK
         ng8G3VfTTadLtiZfZjQ1cmEKnxM5w7coQLyeIwG9H/DkeEUH/XMFUzsf/V9ivaxwTW
         BEAAeHk2S2N2fsZK9hjeS8C5qdtQf7GF8jQeIkWHNHvySykvXljONZVGt6LrOGb948
         dsXYhA4marFHCKCiTAO/0/HGFKVwQ7HZRkdAwU7luMePJC78L+HjnsMFNiSE9cp7Ef
         SFKUDk9RYLhwA==
Subject: [PATCH 2/2] design: document changes for the bigtime feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 25 Mar 2021 19:48:42 -0700
Message-ID: <161672692218.721010.7004865825251110891.stgit@magnolia>
In-Reply-To: <161672690975.721010.3851165011742824524.stgit@magnolia>
References: <161672690975.721010.3851165011742824524.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Document the changes to the ondisk format when we enable the bigtime
feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    6 ++
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 ++++
 .../internal_inodes.asciidoc                       |    5 ++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    4 +
 .../XFS_Filesystem_Structure/timestamps.asciidoc   |   65 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 6 files changed, 96 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/timestamps.asciidoc


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 2e78f56..2eaab02 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -443,6 +443,12 @@ See the chapter on xref:Sparse_Inodes[Sparse Inodes] for more information.
 Metadata UUID.  The UUID stamped into each metadata block must match the value
 in +sb_meta_uuid+.  This enables the administrator to change +sb_uuid+ at will
 without having to rewrite the entire filesystem.
+
+| +XFS_SB_FEAT_INCOMPAT_BIGTIME+ |
+Large timestamps.  Inode timestamps and quota expiration timers are extended to
+support times through the year 2486.  See the section on
+xref:Timestamps[timestamps] for more information.
+
 |=====
 
 *sb_features_log_incompat*::
diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index 29ffbb5..de73b51 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -184,4 +184,18 @@
 			</simplelist>
 		</revdescription>
 	</revision>
+	<revision>
+		<revnumber>3.1415926</revnumber>
+		<date>October 2020</date>
+		<author>
+			<firstname>Darrick</firstname>
+			<surname>Wong</surname>
+			<email>djwong@kernel.org</email>
+		</author>
+		<revdescription>
+			<simplelist>
+				<member>Document the bigtime and inobtcount features.</member>
+			</simplelist>
+		</revdescription>
+	</revision>
 </revhistory>
diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
index 45eeb8b..84e4cb9 100644
--- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
+++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
@@ -128,6 +128,11 @@ limit will turn into a hard limit after the elapsed time exceeds ID zero's
 +d_itimer+ value. When d_icount goes back below +d_ino_softlimit+, +d_itimer+
 is reset back to zero.
 
+If the +XFS_SB_FEAT_INCOMPAT_BIGTIME+ feature is enabled, the 32 bits used by
+the timestamp field are interpreted as the upper 32 bits of an 34-bit unsigned
+seconds counter.  See the section about xref:Quota_Timers[quota expiration
+timers] for more details.
+
 *d_btimer*::
 Specifies the time when the ID's +d_bcount+ exceeded +d_blk_softlimit+. The soft
 limit will turn into a hard limit after the elapsed time exceeds ID zero's
diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 02d44ac..1922954 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -200,6 +200,10 @@ struct xfs_timestamp {
 };
 ----
 
+If the +XFS_SB_FEAT_INCOMPAT_BIGTIME+ feature is enabled, the 64 bits used by
+the timestamp field are interpreted as a flat 64-bit nanosecond counter.
+See the section about xref:Inode_Timestamps[inode timestamps] for more details.
+
 *di_mtime*::
 Specifies the last time the file was modified.
 
diff --git a/design/XFS_Filesystem_Structure/timestamps.asciidoc b/design/XFS_Filesystem_Structure/timestamps.asciidoc
new file mode 100644
index 0000000..08baa1e
--- /dev/null
+++ b/design/XFS_Filesystem_Structure/timestamps.asciidoc
@@ -0,0 +1,65 @@
+[[Timestamps]]
+= Timestamps
+
+XFS needs to be able to persist the concept of a point in time.  This chapter
+discusses how timestamps are represented on disk.
+
+[[Inode_Timestamps]]
+== Inode Timestamps
+
+The filesystem preserves up to four different timestamps for each file stored
+in the filesystem.  These quantities are: the time when the file was created
+(+di_crtime+), the last time the file metadata were changed (+di_ctime+), the
+last time the file contents were changed (+di_mtime+), and the last time the
+file contents were accessed (+di_atime+).  The filesystem epoch is aligned with
+the Unix epoch, which is to say that a value of all zeroes represents 00:00:00
+UTC on January 1st, 1970.
+
+Prior to the introduction of the bigtime feature, inode timestamps were
+laid out as as segmented counter of seconds and nanoseconds:
+
+[source, c]
+----
+struct xfs_legacy_timestamp {
+     __int32_t                 t_sec;
+     __int32_t                 t_nsec;
+};
+----
+
+The smallest date this format can represent is 20:45:52 UTC on December 31st,
+1901, and the largest date supported is 03:14:07 UTC on January 19, 2038.
+
+With the introduction of the bigtime feature, the format is changed to
+interpret the timestamp as a 64-bit count of nanoseconds since the smallest
+date supported by the old encoding.  This means that the smallest date
+supported is still 20:45:52 UTC on December 31st, 1901; but now the largest
+date supported is 20:20:24 UTC on July 2nd, 2486.
+
+[[Quota_Timers]]
+== Quota Grace Period Expiration Timers
+
+XFS' quota control allows administrators to set a soft limit on each type of
+resource that a regular user can consume: inodes, blocks, and realtime blocks.
+The administrator can establish a grace period after which the soft limit
+becomes a hard limit for the user.  Therefore, XFS needs to be able to store
+the exact time when a grace period expires.
+
+Prior to the introduction of the bigtime feature, quota grace period
+expirations were unsigned 32-bit seconds counters, with the magic value zero
+meaning that the soft limit has not been exceeded.  Therefore, the smallest
+expiration date that can be expressed is 00:00:01 UTC on January 1st, 1970; and
+the largest is 06:28:15 on February 7th, 2106.
+
+With the introduction of the bigtime feature, the ondisk field now encodes the
+upper 32 bits of an unsigned 34-bit seconds counter.  Zero is still a magic
+value that means the soft limit has not been exceeded.  The smallest quota
+expiration date is now 00:00:04 UTC on January 1st, 1970; and the largest is
+20:20:24 UTC on July 2nd, 2486.  The format can encode slightly larger
+expiration dates, but it was decided to end support for both timers at exactly
+the same point.
+
+The default grace periods are stored in the timer fields of the quota record
+for id zero.  Since this quantity is an interval, these fields are always
+interpreted as an unsigned 32 bit quantity.  Therefore, the longest possible
+grace period is approximately 136 years, 29 weeks, 3 days, 6 hours, 28 minutes
+and 15 seconds.
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 5c1642c..a95a580 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -72,6 +72,8 @@ include::btrees.asciidoc[]
 
 include::dabtrees.asciidoc[]
 
+include::timestamps.asciidoc[]
+
 include::allocation_groups.asciidoc[]
 
 include::rmapbt.asciidoc[]

