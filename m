Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78E515C0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230731; cv=none; b=uDuZDlGC0Of0uVRVTyAZjVdwaB4g++dd96kKqmPiHYo5shtLmAVjlwQQqjaR67wvDJqTCExOyqDiNjuc2+HKhoZwp3bL5hQbP+PYR5llIEbPpT2v5zYQaERchLBM3/lzH1/VkJQu9ihydSxWp5/cyowhnbE5zNuhgJe7xXHaXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230731; c=relaxed/simple;
	bh=E2M/rcfP+/CqbTM5dIpAJqqzqRSbxEZmfykRsm8jC2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMqBnusU1NwAhNYbqD1XHdvFqtidl0pY7uvnsqP21SLxLPwxGfRQZ1M6UzVSTihz8Qnwn7FFxDJs93cRLNWSOZ9SkElXj154oDcxhtZqGCJhtBe8O0dNzeDVLTZgVL17LVVoGy2J+BvLzuojBIuyWyRIeZGvs4vOt10lvdbdunE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mS4Q/QQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mS4Q/QQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94E4C113CC;
	Tue, 16 Apr 2024 01:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230731;
	bh=E2M/rcfP+/CqbTM5dIpAJqqzqRSbxEZmfykRsm8jC2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mS4Q/QQrFwgOS19fp/9s6EBgeztUAzwYTbh/M0Abgu9qTaTyg5lQIjCuAOi4Z7yAd
	 3aR7pR1vw/TF//OBpPSgYl81qZmv4RUtQJtudx57/ws9GlLqaw2DFj7ayKp0nQ1AFY
	 3Y7RTPuRSOOXu0kPNKDn6wC/LnG4lFtUQk0Igd3MnRq8slet+Seoy/3bsRoD4DiQME
	 brF7FeZu5V2iY2k/FG6XRmmpbDRr6IAZqIc3REDJ46HIekrAVdLAUq9Iu0ao/zaHew
	 aMxJR1h5u3PSyd+ced4GJzjhE+6pngJf3ItDwa1sc/SufZs4zxvrARSUZ82EwDDbgp
	 lL3qt83jhlr2Q==
Date: Mon, 15 Apr 2024 18:25:31 -0700
Subject: [PATCH 12/14] xfs: refactor name/length checks in xfs_attri_validate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027265.251201.6119205796906521889.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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
index 59723e5f483e2..c8f92166b9ad6 100644
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
 

