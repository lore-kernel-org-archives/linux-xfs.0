Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C68C2417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882857; cv=none; b=VOnNRPY1/Wc28M5oYq7T/2oXOnwCeyS1zSamCxo1sSTicallPjM5JR7Rj4zIlozF4qcsREHtEtiUkvEL/0wRyn5YR9taRTXSPrC0aqdgd2S1b/63n87YwBvd3iUP+aOuCY1V/322W3P1D1+c5VyGg3tvRMZeC01bG9/s5WjykQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882857; c=relaxed/simple;
	bh=ABDVfO+uZuwJgXV5FdxvC4uUVIdZqYDj7a0VOjPekHM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PI4Fv7cfPj8wzG19WEetPI5ae1AMVfDJvMyiKKLWD3xylq8uU6xgAcK2TAvFwLVd12HqpLm0tFI+9F6JfW1UHsicq6R9Jvpa5kIYUYSfTSd5+gkX4pO5IH5NihYu3+FCObpIuCk8ViXW6COaz6NhydQWi6MTwvvVo6QxfSItCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgS23lCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgS23lCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF140C4CEDD;
	Thu,  6 Feb 2025 23:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882856;
	bh=ABDVfO+uZuwJgXV5FdxvC4uUVIdZqYDj7a0VOjPekHM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lgS23lCKbBsXTz/+73VajVry5WDkEaTVE4zGLMfUUFKYntnN93TfsBchWN5m6xp5p
	 Our53tzVwdxE0fzYTp17eHH30YDYb3eJmqEAdXkmN4gtHJShSi+hwEJtqzllNBaH9F
	 LzpAnAG+6BV2FHhTWa/QKZFnYBBMqVyqyYckeUwdp2nQtOog/kMmkrb9OlFQjFLn0g
	 6IjWtdzeqwkmQtW6l/Hmeysy5F9bnD7oVT/lU1OPEsH/1p7sCe1uX1SI31lNdy5XZc
	 uAgF8ga0kOlqTYFzgGslxhAVXruxcBkOJiHjmdxgTmhjCQyJ5Hdt02H6x8Lx3ixXCm
	 ONjfji3C2YvaA==
Date: Thu, 06 Feb 2025 15:00:56 -0800
Subject: [PATCH 16/22] xfs_repair: reject unwritten shared extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089177.2741962.5838383202072252893.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We don't allow sharing of unwritten extents, which means that repair
should reject an unwritten extent if someone else has already claimed
the space.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 3260df94511ed2..f49c735d34356b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -311,7 +311,8 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 			break;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
+			if (xfs_has_rtreflink(mp) &&
+			    irec->br_state == XFS_EXT_NORM)
 				break;
 			set_rtbmap(ext, XR_E_MULT);
 			break;
@@ -387,8 +388,14 @@ _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt
 			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
-			if (xfs_has_rtreflink(mp))
-				break;
+			if (xfs_has_rtreflink(mp)) {
+				if (irec->br_state == XFS_EXT_NORM)
+					break;
+				do_warn(
+_("data fork in rt inode %" PRIu64 " claims shared unwritten rt extent %" PRIu64 "\n"),
+					ino, b);
+				return 1;
+			}
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -472,6 +479,18 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	return bad;
 }
 
+static inline bool
+is_reflink_type(
+	struct xfs_mount	*mp,
+	int			type)
+{
+	if (type == XR_INO_DATA && xfs_has_reflink(mp))
+		return true;
+	if (type == XR_INO_RTDATA && xfs_has_rtreflink(mp))
+		return true;
+	return false;
+}
+
 /*
  * return 1 if inode should be cleared, 0 otherwise
  * if check_dups should be set to 1, that implies that
@@ -717,9 +736,14 @@ _("%s fork in inode %" PRIu64 " claims metadata block %" PRIu64 "\n"),
 
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				if (type == XR_INO_DATA &&
-				    xfs_has_reflink(mp))
-					break;
+				if (is_reflink_type(mp, type)) {
+					if (irec.br_state == XFS_EXT_NORM)
+						break;
+					do_warn(
+_("%s fork in %s inode %" PRIu64 " claims shared unwritten block %" PRIu64 "\n"),
+						forkname, ftype, ino, b);
+					goto done;
+				}
 				do_warn(
 _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
 					forkname, ftype, ino, b);

