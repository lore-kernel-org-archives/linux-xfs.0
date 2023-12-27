Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF644A04
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSqMqbv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E090DC433C7;
	Mon,  1 Jan 2024 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071258;
	bh=iLQXLdzrd5w0gnFbKh6DylXPSFmDyHopPpYWz8QlBZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aSqMqbv5XqS+8/t7a9Vf5LIEhzRUTk+D1ry/3J80xbZiDoIHY6efOrasZOkyZQiUA
	 +dx91lGpMSxrLu+054+qJZhduMVCJEQj26vQWo/uPkg8bxSKOGYXWpWPd6BlG+sxZe
	 fqM88zv6FcrigUfYrCDzYdccDpymREC66gUK3Q8/g6vsV4XPHXGmBJHA13ZJkbMQWh
	 wBOntxdxwfWyAULfQ2sXljozIYaN33cAhVz5ffGKdtQNB+2/wsgoSLyzjuDXoRv80f
	 sTCAYKzG6g89OnU5kVOE8Zgi3uRfs8CUGmx6syzH5bCV+iFK8QV/d8DT4NvabPH4J6
	 mYRq8kNQqlrIw==
Date: Sun, 31 Dec 2023 17:07:38 +9900
Subject: [PATCH 1/1] design: document new name-value logged attribute variants
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036215.1829412.10624772030547951296.stgit@frogsfrogsfrogs>
In-Reply-To: <170405036203.1829412.14716609287158101338.stgit@frogsfrogsfrogs>
References: <170405036203.1829412.14716609287158101338.stgit@frogsfrogsfrogs>
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
 .../journaling_log.asciidoc                        |   60 ++++++++++++++++++--
 1 file changed, 54 insertions(+), 6 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
index daf9b225..c91fbb6a 100644
--- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
+++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
@@ -730,10 +730,21 @@ of file block mapping operation we want.
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
+| +XFS_ATTRI_OP_FLAGS_NVREMOVE+		| Remove the specific name and value
+from the attribute structure.  The name and value must already exist.
+| +XFS_ATTRI_OP_FLAGS_NVSET+		| Associate an attribute name with the
+given value.  The name and value must not exist in the attribute structure.
+A name associated with a different value will not be removed.
+| +XFS_ATTRI_OP_FLAGS_NVREPLACE+	| Remove a specific name and value from
+the attribute structure, then associate a specific name with a given value.
+The two names and values need not be the same.
 |=====
 
 The ``extended attribute update intent'' operation comes first; it tells the
@@ -747,11 +758,17 @@ through the complex update will be replayed fully during log recovery.
 struct xfs_attri_log_format {
      uint16_t                  alfi_type;
      uint16_t                  alfi_size;
-     uint32_t                  __pad;
+     uint32_t                  alfi_new_value_len;
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
@@ -764,6 +781,11 @@ order, not big-endian like the rest of XFS.
 *alfi_size*::
 Size of this log item.  Should be 1.
 
+*alfi_new_value_len*::
+For NVREPLACE, this is the length of the new xattr value, and +alfi_value_len+
+contains the length of the old xattr value.
+For all other opcodes, this field must be zero.
+
 *alfi_id*::
 A 64-bit number that binds the corresponding ATTRD log item to this ATTRI log
 item.
@@ -778,6 +800,13 @@ The operation being performed.  The lower byte must be one of the
 *alfi_name_len*::
 Length of the name of the extended attribute.  This must not be zero.
 The attribute name itself is captured in the next log item.
+This field is not defined for the NVREPLACE opcode.
+
+*alfi_old_name_len*::
+For NVREPLACE, this is the length of the old name.
+
+*alfi_new_name_len*::
+For NVREPLACE, this is the length of the new name.
 
 *alfi_value_len*::
 Length of the value of the extended attribute.  This must be zero for remove
@@ -789,6 +818,25 @@ name.
 Attribute namespace filter flags.  This must be one of +ATTR_ROOT+,
 +ATTR_SECURE+, or +ATTR_INCOMPLETE+.
 
+For a SET or REPLACE opcode, there should be two regions after the ATTRI intent
+item.  The first region contains the attribute name and the second contains the
+attribute value.
+
+For a REMOVE opcode, there should only be one region after the ATTRI intent
+item, and it will contain the attribute name.
+
+For an NVSET or NVREMOVE opcode, there should be one or two regions after the
+ATTRI intent item.  The first region contains the attribute name.  The second
+region, if present, contains the attribute value.
+
+For an NVREPLACE opcode, there should be between two and four regions after the
+ATTRI intent item.  The first region contains the attribute name to remove.
+The second region contains the attribute name to create.  If +alfi_value_len+
+is nonzero, the third region contains the attribute value to remove.  If
++alfi_new_value_len+ is nonzero, the next region seen contains the attribute
+value to create.  This could be the third region if there was no value to
+remove, or it could be the fourth region.
+
 [[ATTRD_Log_Item]]
 === Completion of Extended Attribute Updates
 

