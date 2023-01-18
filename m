Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0214DC00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjARA7B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjARA6j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:58:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42D139BAF
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E713B8164A
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074FFC433EF;
        Wed, 18 Jan 2023 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002721;
        bh=MWxFknRPbmg+boAqguwpg591rn/kJtZmvZ/TuFobdL0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=I4n6xOo8BY7NrVZo8slBzRF8SUecNq66YM+XsvELOsnxuS8IqNsUAKYL37wb9AzSl
         t+qHSwcvPaS9dNVPH6yGtdvabOMu57H1GW8F/2CpkBW+QHR7kjJnixlVaUXBdncAjo
         4OCcNiPgHNSKAwyzSxXpUYktaP+n8MtpGfUlgddEvaIk2+BUPtQ+vQuMaoxnkunLP5
         ISfnNGQOfsuLayYkm7Fr+2Xuwgoq3ONO1lsSiQou8F5MTaS3DtL+zd4ti2D5ktSf7l
         pQcic5i9QwQVDhQRsNnpTC2tnqhs8NPxTRl/+lrurYrNuE1vx250CkogFCxRZYxB0H
         TVJoFAcBF6D5A==
Date:   Tue, 17 Jan 2023 16:45:20 -0800
Subject: [PATCH 3/3] design: document extended attribute log item changes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        allison.henderson@oracle.com
Message-ID: <167400163318.1925795.14365139273911946287.stgit@magnolia>
In-Reply-To: <167400163279.1925795.1487663139527842585.stgit@magnolia>
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Describe the changes to the ondisk log format that are required to
support atomic updates to extended attributes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |   14 ++-
 .../journaling_log.asciidoc                        |  109 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 3 files changed, 122 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index c64b4fad..c0ba16a8 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -461,9 +461,17 @@ space mappings allowed in data and extended attribute file forks.
 |=====
 
 *sb_features_log_incompat*::
-Read-write incompatible feature flags for the log.  The kernel cannot read or
-write this FS log if it doesn't understand the flag.  Currently, no flags are
-defined.
+Read-write incompatible feature flags for the log.  The kernel cannot recover
+the FS log if it doesn't understand the flag.
+
+.Extended Version 5 Superblock Log incompatibility flags
+[options="header"]
+|=====
+| Flag					| Description
+| +XFS_SB_FEAT_INCOMPAT_LOG_XATTRS+	|
+Extended attribute updates have been committed to the ondisk log.
+
+|=====
 
 *sb_crc*::
 Superblock checksum.
diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index ddcb87f4..f36dd352 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -215,6 +215,8 @@ magic number to distinguish themselves.  Buffer data items only appear after
 | +XFS_LI_CUD+			| 0x1243        | xref:CUD_Log_Item[Reference Count Update Done]
 | +XFS_LI_BUI+			| 0x1244        | xref:BUI_Log_Item[File Block Mapping Update Intent]
 | +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
+| +XFS_LI_ATTRI+		| 0x1246        | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
+| +XFS_LI_ATTRD+		| 0x1247        | xref:ATTRD_Log_Item[Extended Attribute Update Done]
 |=====
 
 Note that all log items (except for transaction headers) MUST start with
@@ -712,6 +714,113 @@ Size of this log item.  Should be 1.
 *bud_bui_id*::
 A 64-bit number that binds the corresponding BUI log item to this BUD log item.
 
+[[ATTRI_Log_Item]]
+=== Extended Attribute Update Intent
+
+The next two operation types work together to handle atomic extended attribute
+updates.
+
+The lower byte of the +alfi_op_flags+ field is a type code indicating what sort
+of file block mapping operation we want.
+
+.Extended attribute update log intent types
+[options="header"]
+|=====
+| Value				| Description
+| +XFS_ATTRI_OP_FLAGS_SET+	| Set a key/value pair.
+| +XFS_ATTRI_OP_FLAGS_REMOVE+	| Remove a key/value pair.
+| +XFS_ATTRI_OP_FLAGS_REPLACE+	| Replace one key/value pair with another.
+|=====
+
+The ``extended attribute update intent'' operation comes first; it tells the
+log that XFS wants to update one of a file's extended attributes.  This record
+is crucial for correct log recovery because it enables us to spread a complex
+metadata update across multiple transactions while ensuring that a crash midway
+through the complex update will be replayed fully during log recovery.
+
+[source, c]
+----
+struct xfs_attri_log_format {
+     uint16_t                  alfi_type;
+     uint16_t                  alfi_size;
+     uint32_t                  __pad;
+     uint64_t                  alfi_id;
+     uint64_t                  alfi_ino;
+     uint32_t                  alfi_op_flags;
+     uint32_t                  alfi_name_len;
+     uint32_t                  alfi_value_len;
+     uint32_t                  alfi_attr_filter;
+};
+----
+
+*alfi_type*::
+The signature of an ATTRI operation, 0x1246.  This value is in host-endian
+order, not big-endian like the rest of XFS.
+
+*alfi_size*::
+Size of this log item.  Should be 1.
+
+*alfi_id*::
+A 64-bit number that binds the corresponding ATTRD log item to this ATTRI log
+item.
+
+*alfi_ino*::
+Inode number of the file being updated.
+
+*alfi_op_flags*::
+The operation being performed.  The lower byte must be one of the
++XFS_ATTRI_OP_FLAGS_*+ flags defined above.  The upper bytes must be zero.
+
+*alfi_name_len*::
+Length of the name of the extended attribute.  This must not be zero.
+The attribute name itself is captured in the next log item.
+
+*alfi_value_len*::
+Length of the value of the extended attribute.  This must be zero for remove
+operations, and nonzero for set and replace operations.  The attribute value
+itself is captured in the log item immediately after the item containing the
+name.
+
+*alfi_attr_filter*::
+Attribute namespace filter flags.  This must be one of +ATTR_ROOT+,
++ATTR_SECURE+, or +ATTR_INCOMPLETE+.
+
+[[ATTRD_Log_Item]]
+=== Completion of Extended Attribute Updates
+
+The ``extended attribute update done'' operation complements the ``extended
+attribute update intent'' operation.  This second operation indicates that the
+update actually happened, so that log recovery needn't replay the update.  The
+ATTRD and the actual updates are typically found in a new transaction following
+the transaction in which the ATTRI was logged.
+
+[source, c]
+----
+struct xfs_attrd_log_format {
+      __uint16_t               alfd_type;
+      __uint16_t               alfd_size;
+      __uint32_t               __pad;
+      __uint64_t               alfd_alf_id;
+};
+----
+
+*alfd_type*::
+The signature of an ATTRD operation, 0x1247.  This value is in host-endian
+order, not big-endian like the rest of XFS.
+
+*alfd_size*::
+Size of this log item.  Should be 1.
+
+*alfd_bui_id*::
+A 64-bit number that binds the corresponding ATTRI log item to this ATTRD log
+item.
+
+=== Extended Attribute Name and Value
+
+These regions contain the name and value components of the extended attribute
+being updated, as needed.  There are no magic numbers; each region contains the
+data and nothing else.
+
 [[Inode_Log_Item]]
 === Inode Updates
 
diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
index 9be26f82..a343271a 100644
--- a/design/XFS_Filesystem_Structure/magic.asciidoc
+++ b/design/XFS_Filesystem_Structure/magic.asciidoc
@@ -71,6 +71,8 @@ are not aligned to blocks.
 | +XFS_LI_CUD+			| 0x1243        |       | xref:CUD_Log_Item[Reference Count Update Done]
 | +XFS_LI_BUI+			| 0x1244        |       | xref:BUI_Log_Item[File Block Mapping Update Intent]
 | +XFS_LI_BUD+			| 0x1245        |       | xref:BUD_Log_Item[File Block Mapping Update Done]
+| +XFS_LI_ATTRI+		| 0x1246        |       | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
+| +XFS_LI_ATTRD+		| 0x1247        |       | xref:ATTRD_Log_Item[Extended Attribute Update Done]
 |=====
 
 = Theoretical Limits

