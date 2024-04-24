Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948A013340B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928324; cv=none; b=L2yUP1CRvH95XBLpsxKXT2B6+31iL8ohDU+n8te1LyfU51vHwtwP3ySVBjDdWSPA2JhQPr77VhtD+9xL3BdK0eVLGYSmHagmZdQT/vAJqfC3HcOkesOQCyZ9gRmVxn8YiZbkPRMimog95Dm5s24ZdMYPgYmzHXZdmpKZaMvnn4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928324; c=relaxed/simple;
	bh=oU1mg7wgAGqRTRADN9170IDfgIv7yYRwqtLOvaGm3sY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyrqYFHRXTGxkyRr2r11m8FGfucNWacrrjc4Cz3gA7a3cYuj1mHRfakJTnbAgalmJ0fnWJ2gSIYvMBuxBGSCEbPge7m+cvrezJxCT2FjgCgsrs72geRrSJ7ddclcDCX6JDbfrULRUBmCnSp5SoSMVxdnLl9Abjf/J2WqtQ/4b+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrfyz9/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrfyz9/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C0AC2BD10;
	Wed, 24 Apr 2024 03:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928324;
	bh=oU1mg7wgAGqRTRADN9170IDfgIv7yYRwqtLOvaGm3sY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rrfyz9/TEBsbexdWwtQM9x9idibVMZapG74me+YC/zGjhok84cVkqR1dSNlM1/aqR
	 BC7V9fICF5BkEyyLRZDYoBR5S/36yBJ629kSYIWnQGwZXoli4Y2JGeetqL/U2updNY
	 O0HqT113WdYt0SpajhR8SBcRKqsPL9mRidXHyTSxYbgaOvQI697+JB7Mn0Rrh0vPEe
	 2JonijvIpyyn1YpI9CkFRE/uX0DkhJF7WPCsWaeyq2xCF/yMaxIziaEulZhaLBpprn
	 BnNoDXKVemFPRPG5gwO3R0glqJGGJU5lSp5n/JL4Ra/i855x0zb0AFoTTL2ewOhuqR
	 0x7c4xjE8kPyA==
Date: Tue, 23 Apr 2024 20:12:03 -0700
Subject: [PATCH 12/14] xfs: refactor name/length checks in xfs_attri_validate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782775.1904599.5336276739826774234.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

Move the name and length checks into the attr op switch statement so
that we can perform more specific checks of the value length.  Over the
next few patches we're going to add new attr op flags with different
validation requirements.

While we're at it, remove the incorrect comment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 59723e5f483e..c8f92166b9ad 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -466,6 +466,12 @@ xfs_attri_item_match(
 	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
 }
 
+static inline bool
+xfs_attri_validate_namelen(unsigned int namelen)
+{
+	return namelen > 0 && namelen <= XATTR_NAME_MAX;
+}
+
 /* Is this recovered ATTRI format ok? */
 static inline bool
 xfs_attri_validate(
@@ -486,23 +492,24 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
-	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
 		break;
 	default:
 		return false;
 	}
 
-	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
-		return false;
-
-	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_name_len == 0))
-		return false;
-
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 

