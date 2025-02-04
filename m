Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D41509BD;
	Tue,  4 Feb 2025 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695223; cv=none; b=H47vbd8YxNGPxnBd7lHUdUFCj2Z2mBkRq8wVzT+//LAyYUS2kewVNqGWDN+0VL0z5De+RYjfn/K6fcEavZL3noLIPZ3AtY2y9GQwxinsicQshdfW5TpUAUpcbSQAzBhymZnL4Wz+eXlMxC110CTHIdicibaGnJQlAKwLoiAIlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695223; c=relaxed/simple;
	bh=LHb/TuVy3D+/FibKVZy9IjJ6zLxeLpmti7E3Rsil9UI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBsrEV2ItvpP2B+gwNNyGhH18vAmif7OuFQouLbmMnwn1YAVVURDAepAvCG6ri0Vk3ZbFDBTDFQNpZTjL7Kl/POtRwld3zfSc0nKPPAm0cwP5uURdN4pY/ZEdKNPL0Xp65/Eiti/4KyNn6RH9Ny09oy6DnMQCAzNnF22w/ssBa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5wLJjKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5wLJjKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF312C4CEDF;
	Tue,  4 Feb 2025 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695223;
	bh=LHb/TuVy3D+/FibKVZy9IjJ6zLxeLpmti7E3Rsil9UI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R5wLJjKgNIEoVOWHbfVcImz7DStGyrr4kkbdIIlxQolhdDRRoGxd2h1km9OXOVGqo
	 3P4+9eXzZgeCct3qvW26UCFZC2snpQlFtayO7XwVxfAJYFeK8slggda3Xs8vBr10o2
	 uJpLMeoPT8My2QBPOh0l2bTmLP4DWuDPIFvzvSeMIcu8+jtMcAvQpOeyahA6iZxDpF
	 lC33dkNcMWre/LXA5eoENozNL6qlFH4PSzUwWE92q0L2+Ltbv4axt2v0a7CqVfXIe6
	 3MY/8roc8WD46lcPyiU4+ezOso+dHNl3BpeaHwaNjEXUrZBjk9OHCWts9520nmCc0F
	 O8pYIEPVs4QGA==
Date: Tue, 04 Feb 2025 10:53:42 -0800
Subject: [PATCH 10/10] xfs: lock dquot buffer before detaching dquot from
 b_li_list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org
Message-ID: <173869499505.410229.5000932484028162941.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit 111d36d6278756128b7d7fab787fdcbf8221cd98 upstream

We have to lock the buffer before we can delete the dquot log item from
the buffer's log item list.

Cc: <stable@vger.kernel.org> # v6.13-rc3
Fixes: acc8f8628c3737 ("xfs: attach dquot buffer to dquot log item buffer")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/xfs_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index d64d454cbe8bca..0d73b59f1c9e57 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -87,8 +87,9 @@ xfs_dquot_detach_buf(
 	}
 	spin_unlock(&qlip->qli_lock);
 	if (bp) {
+		xfs_buf_lock(bp);
 		list_del_init(&qlip->qli_item.li_bio_list);
-		xfs_buf_rele(bp);
+		xfs_buf_relse(bp);
 	}
 }
 

