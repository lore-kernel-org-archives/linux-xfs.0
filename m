Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ADB13CFA3
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 19:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723058065; cv=none; b=Rh7QKd12UJD1gLOAP2nfKSHq4EiLoFnVP4G2eOW6nnps1FeEP/vXd7QC3E+zuXg5n1WF8JBviivxF6aI0y2NrtuRUmVBoSAQ03FRiHilLSwRwcrd+nwWviCAM9r00YHPiiooBH5/IFCOKG4+42qhhWrwsRhKp5yG/0AUwVtRPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723058065; c=relaxed/simple;
	bh=QPw9IRCI95tfLgM0IyAnsp+Ioqzye0YX8YqK3eG+D4o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kf2PbYvHsltK4WPRfRTEaBu10+52l5kDkoz2wlzeuQOfg4/W9ZGcVJTqJQNIVN3adwffSdWG4zwklsf+aGoFywakW1g3FOLZQsanyXQ14qVCkLw84Ew7FSBpAjRZtBohCQWIextOUfMDlKUcrd44ucL0wvRigYaKFeRwbTEU+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlydN1CY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlydN1CY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888BDC32781;
	Wed,  7 Aug 2024 19:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723058065;
	bh=QPw9IRCI95tfLgM0IyAnsp+Ioqzye0YX8YqK3eG+D4o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PlydN1CYyQG8KMsCjMHp+AvtVum+ri/ovKBb4mkxR0zIAiN6721Em7jvGj2J2a4K3
	 Lqu3zQ05mx9xUxf0M+HFlhFzzftiDhvbLWPvdJuxDkvuoNcfzcKYh8v2kCuN2jAhqY
	 PjjFkQb7lKg6fEBZIxk+NrY0eAsmaBVeoSaC5sqLcSyiNHYxjnZSEN7rK9lm/rLChK
	 h7L/BVyP9uPpcODsATEVzzI5vMKGkItRpYmec2/TQaXi0OHbmAii0JV2adqS7svnpE
	 xTXS25LB+ojMLVjonXGrNAxCW/kmW/SShDWJJCVZvEvKUAYMx9xTi7JtuXWVCPmwMe
	 wAOXRoH860S1g==
Date: Wed, 07 Aug 2024 12:14:25 -0700
Subject: [PATCH 2/5] design: document new name-value logged attribute variants
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172305794118.969463.1580394382652832046.stgit@frogsfrogsfrogs>
In-Reply-To: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
References: <172305794084.969463.781862996787293755.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In preparation for parent pointers, we added a few new opcodes for
logged extended attribute updates.  Document them now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../journaling_log.asciidoc                        |   54 ++++++++++++++++++--
 1 file changed, 48 insertions(+), 6 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index 9d9fa836..6b9d65c3 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -730,10 +730,18 @@ of file block mapping operation we want.
 .Extended attribute update log intent types
 [options="header"]
 |=====
-| Value				| Description
-| +XFS_ATTRI_OP_FLAGS_SET+	| Set a key/value pair.
-| +XFS_ATTRI_OP_FLAGS_REMOVE+	| Remove a key/value pair.
-| +XFS_ATTRI_OP_FLAGS_REPLACE+	| Replace one key/value pair with another.
+| Value					| Description
+| +XFS_ATTRI_OP_FLAGS_SET+		| Associate an attribute name with the
+given value, creating an entry for the name if necessary.
+| +XFS_ATTRI_OP_FLAGS_REMOVE+		| Remove an attribute name and any
+value associated with it.
+| +XFS_ATTRI_OP_FLAGS_REPLACE+		| Remove any value associated with an
+attribute name, then associate the name with the given value.
+| +XFS_ATTRI_OP_FLAGS_PPTR_SET+		| Add a parent pointer associating a directory entry name with a file handle to the parent directory.  The (name, handle) tuple must not exist in the attribute structure.
+| +XFS_ATTRI_OP_FLAGS_PPTR_REMOVE+	| Remove a parent pointer from the attribute structure.  The (name, handle) tuple must already exist.
+| +XFS_ATTRI_OP_FLAGS_PPTR_REPLACE+	| Remove a specific (name, handle) tuple from
+the attribute structure, then add a new (name, handle) tuple to the attribute structure.
+The two names and handles need not be the same.
 |=====
 
 The ``extended attribute update intent'' operation comes first; it tells the
@@ -747,11 +755,17 @@ through the complex update will be replayed fully during log recovery.
 struct xfs_attri_log_format {
      uint16_t                  alfi_type;
      uint16_t                  alfi_size;
-     uint32_t                  __pad;
+     uint32_t                  alfi_igen;
      uint64_t                  alfi_id;
      uint64_t                  alfi_ino;
      uint32_t                  alfi_op_flags;
-     uint32_t                  alfi_name_len;
+     union {
+          uint32_t             alfi_name_len;
+          struct {
+              uint16_t         alfi_old_name_len;
+              uint16_t         alfi_new_name_len;
+          };
+     };
      uint32_t                  alfi_value_len;
      uint32_t                  alfi_attr_filter;
 };
@@ -764,6 +778,9 @@ order, not big-endian like the rest of XFS.
 *alfi_size*::
 Size of this log item.  Should be 1.
 
+*alfi_igen*::
+Generation number of the file being updated.
+
 *alfi_id*::
 A 64-bit number that binds the corresponding ATTRD log item to this ATTRI log
 item.
@@ -778,6 +795,13 @@ The operation being performed.  The lower byte must be one of the
 *alfi_name_len*::
 Length of the name of the extended attribute.  This must not be zero.
 The attribute name itself is captured in the next log item.
+This field is not defined for the PPTR_REPLACE opcode.
+
+*alfi_old_name_len*::
+For PPTR_REPLACE, this is the length of the old name.
+
+*alfi_new_name_len*::
+For PPTR_REPLACE, this is the length of the new name.
 
 *alfi_value_len*::
 Length of the value of the extended attribute.  This must be zero for remove
@@ -789,6 +813,24 @@ name.
 Attribute namespace filter flags.  This must be one of +ATTR_ROOT+,
 +ATTR_SECURE+, or +ATTR_INCOMPLETE+.
 
+For a SET or REPLACE opcode, there should be two regions after the ATTRI intent
+item.  The first region contains the attribute name and the second contains the
+attribute value.
+
+For a REMOVE opcode, there should only be one region after the ATTRI intent
+item, and it will contain the attribute name.
+
+For an PPTR_SET or PPTR_REMOVE opcode, there should be two regions after the
+ATTRI intent item.  The first region contains the dirent name as the attribute
+name.  The second region contains a file handle to the parent directory as the
+attribute value.
+
+For an PPTR_REPLACE opcode, there should be between four regions after the
+ATTRI intent item.  The first region contains the dirent name to remove.
+The second region contains the dirent name to create.  The third region
+contains the parent directory file handle to remove.  The fourth region
+contains the parent directory file handle to add.
+
 [[ATTRD_Log_Item]]
 === Completion of Extended Attribute Updates
 

