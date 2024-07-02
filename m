Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7144A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882642; cv=none; b=q9tHlcAUeWiTyqJR1JLBJ9m5yEBFmXn/NVPVNtQiFHi10zgn0AvK6dT8PU4p0ONoMn1YgkHglG7OKlOZ8gJgeLx9AUABF49zs7ERkSjztlifVF1cKUPftU/XOFoSVnNz+jnfSI0ZzbfSCBfm3KSmXRYe29rxqqy/4HRFJTO+Ngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882642; c=relaxed/simple;
	bh=ZijNAFIw9BfoqldwYmZYmLawlKhw+pUiiC27o8aDyRM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FT3zwmB9oCGjVyI6jYizA/d9anK2wA74AwG/NtEEQx6iskh77xg+BNVKOeaIC3j25Mon6Wt6s0UUeMbOX/945gcbbUtu0vMASfhKMRWK3GbMymnNTTiSlZ30NvQLANe6VqzkYlaJtG1ET/sBLLMIyOkMD1XmT6v/wIidU6X8EaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv0l1nT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv0l1nT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E606EC116B1;
	Tue,  2 Jul 2024 01:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882642;
	bh=ZijNAFIw9BfoqldwYmZYmLawlKhw+pUiiC27o8aDyRM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mv0l1nT7pSzXxBqzZtwtI8mCHVx73wcE1vv01zpjZjiRrNNjb8Yp+ia04QCJhPIJz
	 xZuUSQ70C0qgH5ZrsgXQAhpkB9GV6ZWpbENsYqKTx+d8ypm7OH7QTOcVz8ogtCzcxX
	 RumvKtLodfYrIqWmYQtiYPt8GQrk4DMg5NVLMxybAkLviPnZsPQfUXtXaIM90aE35b
	 rVzfygtNv/3K1XseatRAfLOGHdyJKkZIGEY2mfS7GWZiOZY4EeOIVgtBU3yaTUFWsn
	 OEzvD9MWnhA4Z70pFYymAHLq8EQZzA2ODSWlGfgSOOJ1sQ3pE3yjfq1p0Q+fb98Nrg
	 3KcPTQlBN0eCw==
Date: Mon, 01 Jul 2024 18:10:41 -0700
Subject: [PATCH 3/3] xfs_repair: check for unknown flags in attr entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120647.2009101.16639921173241660983.stgit@frogsfrogsfrogs>
In-Reply-To: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs>
References: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs>
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
---
 repair/attr_repair.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index a756a40db9b0..37b5852b885e 100644
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

