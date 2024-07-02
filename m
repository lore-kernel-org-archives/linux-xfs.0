Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF59B9449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883095; cv=none; b=T/lTpt19WZvPDawAzG7jKDxtouUXU9yzBK0JcIxzeu18U80LiOxCL95Dzzy8B5FNZjl9dWORDHlI/DdqNB++AODLsdKqetlycJWnYnipc4hBnTFxqPLXjqOx1jl6/22sX2DdWgX2rpl9IYyi/qt1whnWvuQdmoE0sFIOEUsaivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883095; c=relaxed/simple;
	bh=K59YIOkGywNUw3KSqnhG75Iref+m01Q98q76CNm2HrI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aqq9SaCA1ErLgF9v/Lv2uuGmLvLXKe0jNeSA1fkTqL3ZoIupbreqndoJJ/Y1QR5PAqexYZbhKYU72RXVEtA+2wlrw5O3Na/eKkHOIX9htzqeStYj679ghVI5BZDyOk7ekgVjv4nWd6f5VARdPCGVNX8TGc+VJEOlkYnUdwm112Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUR+mwtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUR+mwtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC4BC116B1;
	Tue,  2 Jul 2024 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883095;
	bh=K59YIOkGywNUw3KSqnhG75Iref+m01Q98q76CNm2HrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GUR+mwtkT91MTQWZMjT2s/mUrzCno2UbOZSMULkkCDbOuPO2gXSsCcYsJgiKRyADr
	 GzvzG8X/AaCpdYKLQFzAltS3O4FJjk/eea+43a+OjLiN/8pXhSMJmzxd+uysJI3pzM
	 pV1dy92zNCt/aVHiYX9pmsJAdxdOFcRva71OPkOyCbAGUjVhO3tMVejHexVKKTDWl8
	 8gSZkQJ2E7EbOJ//kXl9tStwn6doX+z223D9GjKzEQokXsA5kPlprFOfXye4r7SHU7
	 Br+tkjMvEDHLsx52zD2mxML3o6ZyBBYPH/HbEfz6aYBOwIX6sExpYslQHLo2ZxgPe4
	 UbdkXtCUO/pVg==
Date: Mon, 01 Jul 2024 18:18:15 -0700
Subject: [PATCH 03/12] xfs_repair: junk parent pointer attributes when
 filesystem doesn't support them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122212.2010218.8882336678990830158.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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

Drop a parent pointer xattr if the filesystem doesn't support parent
pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/attr_repair.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 2e97fd9775ba..50159b9a5338 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -327,6 +327,13 @@ process_shortform_attr(
 					NULL, currententry->namelen,
 					currententry->valuelen);
 
+		if ((currententry->flags & XFS_ATTR_PARENT) &&
+		    !xfs_has_parent(mp)) {
+			do_warn(
+ _("parent pointer found on filesystem that doesn't support parent pointers\n"));
+			junkit |= 1;
+		}
+
 		remainingspace = remainingspace -
 					xfs_attr_sf_entsize(currententry);
 
@@ -527,6 +534,15 @@ process_leaf_attr_local(
 			return -1;
 		}
 	}
+
+	if ((entry->flags & XFS_ATTR_PARENT) && !xfs_has_parent(mp)) {
+		do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " on filesystem that doesn't support parent pointers\n"),
+				i, da_bno, ino);
+		return -1;
+	}
+
 	return xfs_attr_leaf_entsize_local(local->namelen,
 						be16_to_cpu(local->valuelen));
 }
@@ -562,6 +578,20 @@ process_leaf_attr_remote(
 		return -1;
 	}
 
+	if (entry->flags & XFS_ATTR_PARENT) {
+		if (!xfs_has_parent(mp))
+			do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " on filesystem that doesn't support parent pointers\n"),
+					i, da_bno, ino);
+		else
+			do_warn(
+ _("parent pointer found in attribute entry %d in attr block %u, inode %"
+   PRIu64 " with bogus remote value\n"),
+					i, da_bno, ino);
+		return -1;
+	}
+
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(

