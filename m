Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2D370AF5
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328018; cv=none; b=k4OLEHrIRDJ5ULj93XW7e8eCyOe77rs/wnV42SpCgHivnasZe10eITHX+y3XWOJxLy7W9ZoLGteZ0OYz0cnPd9wFVKjXuIc7AfqoJI5A5hCyxEGXECmFLGEKXqSs8c7K6T95c2fj0JkX3UdYBq9QRQ7/Z1899IY4/o9iDDozExI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328018; c=relaxed/simple;
	bh=IPY7kGGvZZbFXRToFQqHRtroVuP9+g8M9jW6VlJvDz4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n02W+hJzISKDxXE3+igylsf3bo9hWJ/GZ7ZB75ZyzxSy2lwSC6MuI4Ph7ZJZwZnogl3gUC0k484QWK/u8QJUG0RS2PwBej7emOrEMQAI12SXnWjKvUIVJWnR/zv230w7GxxXELdu06+gC2Vde7oV45Efsy+M7jE+bpFvhOANgt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mk6pJ/tV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mk6pJ/tV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4390B1F000E9;
	Wed,  2 Sep 2026 05:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328017;
	bh=6bJwvJclF8vgMfPrpIWh8AgnwCSXZZfMMaN8ufkod+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Mk6pJ/tVgE4EQy2r9ZYFTKcdY/6hErVWMNJ4yyyIbKOwel+kLDkpYviqRv4hy5VK4
	 GdjMn/FiQyzjI2uo7/X953ZBep1aw1pFxNZLphE47O881576uBInmpfUXN86nZj3Ya
	 xIXdbCKXaCtWu+ZgCjRx8Nr9NH6ExcsAv8tshPTZ1Phxv+PvwgfhwOZw24hDKzDA4o
	 dXNZWsKpRQxO33bZVaKpaHa0CSMpdwYYTfebjqA8Qi+HnyUBUx7rw6k4MfDIESA1qD
	 JzpxTTfRf9MGi+8xSurloDti1MzlC6u/eOOQDBifiryUCy4YP2z+ctmQMx9UTmRPjq
	 9gtPDgMpw/r1w==
Date: Tue, 01 Sep 2026 22:46:56 -0700
Subject: [PATCH 2/8] xfs: move healthmon event merge tracepoint
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178832750309.3507776.2729420337141667342.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
References: <178832750217.3507776.15975397025387963886.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the tracepoint into the predicate function so that the list
conversion in the next patch is easier.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_healthmon.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index a4efc084a8fc0b..2f7853b9277aca 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -192,7 +192,7 @@ xfs_healthmon_merge_events(
 
 	case XFS_HEALTHMON_LOST:
 		existing->lostcount += new->lostcount;
-		return true;
+		goto out_true;
 
 	case XFS_HEALTHMON_SICK:
 	case XFS_HEALTHMON_CORRUPT:
@@ -200,19 +200,19 @@ xfs_healthmon_merge_events(
 		switch (existing->domain) {
 		case XFS_HEALTHMON_FS:
 			existing->fsmask |= new->fsmask;
-			return true;
+			goto out_true;
 		case XFS_HEALTHMON_AG:
 		case XFS_HEALTHMON_RTGROUP:
 			if (existing->group == new->group){
 				existing->grpmask |= new->grpmask;
-				return true;
+				goto out_true;
 			}
 			return false;
 		case XFS_HEALTHMON_INODE:
 			if (existing->ino == new->ino &&
 			    existing->gen == new->gen) {
 				existing->imask |= new->imask;
-				return true;
+				goto out_true;
 			}
 			return false;
 		default:
@@ -224,18 +224,18 @@ xfs_healthmon_merge_events(
 	case XFS_HEALTHMON_SHUTDOWN:
 		/* yes, we can race to shutdown */
 		existing->flags |= new->flags;
-		return true;
+		goto out_true;
 
 	case XFS_HEALTHMON_MEDIA_ERROR:
 		/* physically adjacent errors can merge */
 		if (existing->daddr + existing->bbcount == new->daddr) {
 			existing->bbcount += new->bbcount;
-			return true;
+			goto out_true;
 		}
 		if (new->daddr + new->bbcount == existing->daddr) {
 			existing->daddr = new->daddr;
 			existing->bbcount += new->bbcount;
-			return true;
+			goto out_true;
 		}
 		return false;
 
@@ -250,18 +250,22 @@ xfs_healthmon_merge_events(
 
 		if (existing->fpos + existing->flen == new->fpos) {
 			existing->flen += new->flen;
-			return true;
+			goto out_true;
 		}
 
 		if (new->fpos + new->flen == existing->fpos) {
 			existing->fpos = new->fpos;
 			existing->flen += new->flen;
-			return true;
+			goto out_true;
 		}
 		return false;
 	}
 
 	return false;
+
+out_true:
+	trace_xfs_healthmon_merge(hm, existing);
+	return true;
 }
 
 /* Insert an event onto the start of the queue. */
@@ -325,7 +329,6 @@ xfs_healthmon_clear_lost_prev(
 	struct xfs_healthmon_event	*event = NULL;
 
 	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
-		trace_xfs_healthmon_merge(hm, hm->last_event);
 		wake_up(&hm->wait);
 		goto cleared;
 	}
@@ -373,7 +376,6 @@ xfs_healthmon_push(
 
 	/* Try to merge with the newest event */
 	if (xfs_healthmon_merge_events(hm->last_event, template)) {
-		trace_xfs_healthmon_merge(hm, hm->last_event);
 		wake_up(&hm->wait);
 		goto out_unlock;
 	}

