Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD11388
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710395; cv=none; b=OE4ooq7HOxow4qhudieztuehKKiseOBJJ/CqSRI0y8Aj1LSC3S71lCQmLarnHe3IFqVg7TiJWBRnFHQBGmfijTgfQk1IW0mn26+4jVUb1cLm+W01x8Bfvz0V8zxMD2s0In+xy9Bp7aXA+4nn8IyFkkN2Tj5CEwC7k4kBCWZ0grI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710395; c=relaxed/simple;
	bh=+V9eI/rr6IRnitiAUmopbXyefcqGiQw9qhvaBYJ3mB8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCtuvnq2POMTULkFFYZ5Wrmm7qlGZop/7r3nly3J3lUKWvsv3vqxSU1v6q4AK33AaoSPMy9hiAZjBawDTvBGm+Nqub+aJBooDfaDRgbNPKyLOBc+ccjRGGEuQOxm4biHFS6eCLUdbJDUrnMijuwsUJY+rQjieDHgAeHmxsKNUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imui3hRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imui3hRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3ADC433C7;
	Wed, 10 Apr 2024 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710395;
	bh=+V9eI/rr6IRnitiAUmopbXyefcqGiQw9qhvaBYJ3mB8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=imui3hRBaVa0yxJSBRZ4IqXD6W2OwpLFMyvYp/BuhJboBBvuvS5btqfzQM3z7UNI/
	 duabIgrF0yfMycsJHFeoTe/OvPulcQz8VaW+SP7uVVszA9V2X3aL18l1SERy3fYwTl
	 S/6JT+1IGcxxOK5R9ia3QiWbbh/tEJgpOaaoTcAsOsF5/ErLQ0QYYjbWVdYm4omx+h
	 MkUMDUiLAUxQM+CNgw3PA1CyY5FQ+obAKEvlfCVaajGJJPK3AWjXcMX2mqJh6UISzJ
	 R2bzrwH9y82YzyIJfeKqiBnNHzXg7UCJMjjPPHi4tG8qgK/zKj8uYDG1Bz4o+wjBAL
	 jQ/8xLuOud5bA==
Date: Tue, 09 Apr 2024 17:53:15 -0700
Subject: [PATCH 11/12] xfs: refactor name/length checks in xfs_attri_validate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270969031.3631545.9868795270237115582.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_attr_item.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 59723e5f483e2..5ad14be760adc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -486,23 +486,26 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
-	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
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
 

