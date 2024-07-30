Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485D2905
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302331; cv=none; b=HNAzVyzVOUpIEWIlHoTaNOPNFo3gDrnVVrw7FUrHF6fT4ttwQbKrs3yc5802sjMucc6touwEOoRfIUt1RaS75c0E/MAFqV/NM1lP4WStu7A5Kid09zx1yZ14hfSlJzjnpcRVqLsGHUkjNCmU65/uYW8e4nBOB0I3pqr9cEPswHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302331; c=relaxed/simple;
	bh=xsXM0gOFimYj6+zqWWOgXD7qd2Ir7CLY7CCBQdD3cUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNrOFAB/SJI1sEHg3MG38t61D31X1rEGGy0vUBPvmi/AUWfmudS4aesz4vebece+fBcdoQz7ZM4crKVPCSzvr64aTif6x+p8l5l1tqsFQL5t4tEYrexSsX807EUCIO26GrVv5zuKWopzmMeHQyeuJATl/S4QbfMVgHFvMpkHlW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/sNnZ6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/sNnZ6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52452C32786;
	Tue, 30 Jul 2024 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302331;
	bh=xsXM0gOFimYj6+zqWWOgXD7qd2Ir7CLY7CCBQdD3cUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d/sNnZ6o1HMn6+LlrqOj6GDdEiSHbMy8K+X3GG0i0WTHR5IbHGCWy+aamXouaTyRA
	 kPF9N09vekMo8OELbRniYHeJwc0h9n8YgMl+8rXn5rwv+EZ38rl+vh3ObU4eswNn1z
	 fCQYub6RqvmfXIt4wVDzFOQZVvPDZJeWCl3V7dbXS7ytJAUiAZ1LAFfA3VsOkkunJJ
	 7H4fUnf+wzQ1+ywA7zfJbCF6WGWwXERRnd0uf69uByR5fjRqjmBnQvslz88E/w+2W2
	 0BPjRl9tj79ypZBprWoo7pmQr3LWkdnMlhgLLYbJ/xgOpMTzTQ2aGTGFItxgBg1M0M
	 FW3FlN5lIl6lQ==
Date: Mon, 29 Jul 2024 18:18:50 -0700
Subject: [PATCH 6/6] xfs_repair: check for unknown flags in attr entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850145.1350643.9201433814080449584.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
References: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
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

Explicitly check for unknown bits being set in the shortform and leaf
attr entries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/attr_repair.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index a756a40db..37b5852b8 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -291,6 +291,13 @@ process_shortform_attr(
 			}
 		}
 
+		if (currententry->flags & ~XFS_ATTR_ONDISK_MASK) {
+			do_warn(
+	_("unknown flags 0x%x in shortform attribute %d in inode %" PRIu64 "\n"),
+				currententry->flags, i, ino);
+			junkit = 1;
+		}
+
 		if (!libxfs_attr_check_namespace(currententry->flags)) {
 			do_warn(
 	_("multiple namespaces for shortform attribute %d in inode %" PRIu64 "\n"),
@@ -648,6 +655,14 @@ process_leaf_attr_block(
 			break;
 		}
 
+		if (entry->flags & ~XFS_ATTR_ONDISK_MASK) {
+			do_warn(
+	_("unknown flags 0x%x in attribute entry #%d in attr block %u, inode %" PRIu64 "\n"),
+				entry->flags, i, da_bno, ino);
+			clearit = 1;
+			break;
+		}
+
 		if (!libxfs_attr_check_namespace(entry->flags)) {
 			do_warn(
 	_("multiple namespaces for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),

