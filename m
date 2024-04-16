Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1CB539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231404; cv=none; b=ORsBcZE45hGQZ1i6iHXFf1M/bQpnIDoQPbJQvFJZwQdViFrjnQKIQaRcSO0v24AOWjrY/ylLA2+nyMhlHuLraxRIpPzDR6DI6yeTAMSnUN/0GWny/W93M9+yuO8ttBMLvQV3hKVouqbfcs9sFxfShqc9lbbTzvhEWEbw6V2yoFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231404; c=relaxed/simple;
	bh=D44BGYNjjDDc0fWg5nVBELt1yLVtNJgu9ghly+lbR4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k81i1EOFELFxiO+ZaElLWieq+qp4Gwy9wvX3rnaM47wMlxg0GHQ+X0UYJ38U9nHYgsRHRVWtMqjzpBHsJdtNFHnfPM6Y0hO0FVrlE/+eCEq4OofdWjEuidIE3OwK8SoCdjHOR0OGJ5wKViEASRwK1nmKBpD6W6etpRTpa8sk614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pDuaqfry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDuaqfry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1277AC113CC;
	Tue, 16 Apr 2024 01:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231404;
	bh=D44BGYNjjDDc0fWg5nVBELt1yLVtNJgu9ghly+lbR4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pDuaqfrynEPuMAqC9YcRWP6vdhNyuBM+nicrlpJMS35tzB/S72cExJ4Z2SdroMPlt
	 DV045dHQO7gc4nYS0QfhDeA1lgv7VoTI/oygu3tl39pc1V0A51VXZo6RrLFvU4xfnt
	 xxIOaE9HrkjCoNUnyOwuSrQgO08jVgsBX5wYoW/RomIciyDbBPS3HppIWjAsaIXXYA
	 2bTG7LsSjLrYgcTKareIpYh+Nste/TIo0WnVQlvzsP//U0tTcxkxB5VdEruVAurWTO
	 WDJImtC7FRxDUdgeTMIDT4kwkLL7l9NigNpQwx8aMm8kb5rJGhNF/+CNsVGRvjG0+3
	 xipRIo4b/8QAg==
Date: Mon, 15 Apr 2024 18:36:43 -0700
Subject: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling xfs_attr_set
 on pptrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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

Adapt the xfs_attr_set function so that repair code can use it to fix
broken parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c98145596f029..b18f6c258a174 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1027,14 +1027,21 @@ xfs_attr_set(
 	case -EEXIST:
 		if (op == XFS_ATTRUPDATE_REMOVE) {
 			/* if no value, we are performing a remove operation */
-			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
+			if (args->attr_filter & XFS_ATTR_PARENT)
+				xfs_attr_defer_parent(args,
+						XFS_ATTR_DEFER_REMOVE);
+			else
+				xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
 			break;
 		}
 
 		/* Pure create fails if the attr already exists */
 		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
+		if (args->attr_filter & XFS_ATTR_PARENT)
+			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_REPLACE);
+		else
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1044,7 +1051,10 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
+		if (args->attr_filter & XFS_ATTR_PARENT)
+			xfs_attr_defer_parent(args, XFS_ATTR_DEFER_SET);
+		else
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
 		break;
 	default:
 		goto out_trans_cancel;

