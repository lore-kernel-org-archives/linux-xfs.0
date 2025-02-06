Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADF2417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882888; cv=none; b=IDpTYnCmiGlqriqHQoiwPvDpl0jJcHivLf9AVOW6ayK1d2Pu8v3PODAahjWyTBSieOHhMbEWJqaCnQKVMhS9sLB8FoMwhhASMjxAUtPZjdu6QcgUqwyQwGbH/+5IddB/y5QIhni9CnAzhmY3IRHrF+COptJ+kMhfEfIoj9Dl6s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882888; c=relaxed/simple;
	bh=NblbH9LpjGVa+//DviO7apKqVlJXTv4KgAOmQhSycHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXSMVN1HUhxKVOwh9wmubmD9LqDvcmD4LMLGZop2DRGfUy/1RNUp2hEzcP2M7M1Hzx0z4EfDWk1SxIhLp5lHcd18y1OV//x+iKkiv6gwo+Px0P/N0swWedWUDhO/S3fM6tH16nXv0Nk0OGxKYwHzkYLFWyNbdrLT3/Xtrdxvwys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssTRAqc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssTRAqc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150D3C4CEDD;
	Thu,  6 Feb 2025 23:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882888;
	bh=NblbH9LpjGVa+//DviO7apKqVlJXTv4KgAOmQhSycHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ssTRAqc5SwiXViWbCW9DYE0U6KKOmHV2yx/lWZCCfOXAMf8fYTtPsN0cdW2rFNxeq
	 GlDtKyQJ2AUCVcYji6uwflQsY/lRPs0sEd2P5gzodLd41x1jS2QLUwor6/1yyqG/8b
	 Hp8wnv+ydhySmwCE2+IrPn05edWF82HLB0ngSVJYGA3ovZW8h0vqlVPsW6fR0WOxWS
	 rWj+NeY694ypHKS6wgFbbNGnWAo4KRlvkvm4tkNlfGc/uTJKVVbevx+vWHDVqOnuFn
	 z008XSHFsBldaeNOdGyDEw51NloJIhiVx3+xKGA79DQLEDhmuKdfHMfZeXoj5qCqZ9
	 fplHVaqPgfJIw==
Date: Thu, 06 Feb 2025 15:01:27 -0800
Subject: [PATCH 18/22] xfs_repair: allow realtime files to have the reflink
 flag set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089207.2741962.17336773299406608051.stgit@frogsfrogsfrogs>
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

Now that we allow reflink on the realtime volume, allow that combination
of inode flags if the feature's enabled.  Note that we now allow inodes
to have rtinherit even if there's no realtime volume, since the kernel
has never restricted that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f49c735d34356b..5a1c8e8cb3ec11 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -3356,7 +3356,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_REFLINK) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have a reflinked realtime inode %" PRIu64 "\n"),
@@ -3388,7 +3389,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		}
 
 		if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-		    (flags & (XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT))) {
+		    !xfs_has_rtreflink(mp) &&
+		    (flags & XFS_DIFLAG_REALTIME)) {
 			if (!uncertain) {
 				do_warn(
 	_("Cannot have CoW extent size hint on a realtime inode %" PRIu64 "\n"),

