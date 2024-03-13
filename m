Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFFAAD56
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294877; cv=none; b=XxdssN3lpW5w21KhoTEK18AHA/HfpKQ/nOlkD7EjU9am/D97OjaZEGyCB9zN9TJQkagMwShds/cdm+k2wmtgu0rYV3tW3lGIM9r8JmnxoHADfNUcsqUfYVujC5DX0Xd7sZTkg36pUslOBKTEoSw2CXy6X4e7XMiq7kFYe/uOAW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294877; c=relaxed/simple;
	bh=+UMA8x/iZC0pbcoGnfWXvkNcT9u9zBzU9cTImSZKgiE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3puE5S5aGmsXoOfp4z1yVkENOAwSyDO+BItphd89H+Dr2JwqmKK3nG4RQ28DfiyxZRP6qvEziAXD/XfvwveBxSU/MQwwc+ym2GmQ3ECTnRCPIC74GD6QOE/mG2w3bXH/N3W6xFUx0kqjPXi4jjE/6/Hcb6ZiiWLas/UfPPXt34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QaagVS6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QaagVS6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA43C433F1;
	Wed, 13 Mar 2024 01:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294876;
	bh=+UMA8x/iZC0pbcoGnfWXvkNcT9u9zBzU9cTImSZKgiE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QaagVS6gZN1oVFJz/fCE8DrcBVxCID1n5ANHEy4Us1kfnJ7PBYw8sh1nvGKgO3apI
	 NPV4HFEwZs276d/VVlWLi0D09qrJrr6Dd+wSxfdDQmuFIIWTd7deuR9FF+5GCLssFp
	 cFxhBYJ5/w4NpqllTuY2azlj12WoNH9dk4nZzSz6MOJ8MjB0WZJLtojE1EbWMnrTEy
	 XOOPUb0SK1hHeqIfveHNsH3oXbdhuqKGdpikra/w64eess0thcI9mtW4rkizeFZ18b
	 j7a5ZfrktEBUS0MDbYODdpiCHHYTJZaMIAcOm9etyeu5BnBfLKNziMFd/i1R/pyQL+
	 EDyiCtRGWsdaw==
Date: Tue, 12 Mar 2024 18:54:36 -0700
Subject: [PATCH 06/67] xfs: hoist ->create_intent boilerplate to its callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431280.2061787.12889835241946985948.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: f3fd7f6fce1cc9b8eb59705b27f823330207b7c9

Hoist the dirty flag setting code out of each ->create_intent
implementation up to the callsite to reduce boilerplate further.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 6a9ce92419c0..1be9554e1b86 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -235,6 +235,8 @@ xfs_defer_create_intent(
 	if (IS_ERR(lip))
 		return PTR_ERR(lip);
 
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
 	dfp->dfp_intent = lip;
 	return 1;
 }

