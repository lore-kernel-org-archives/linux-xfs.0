Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4C0378D9A;
	Tue, 15 Sep 2026 05:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450736; cv=none; b=maoQN4FScJNAc6dk12hEgMsumqPCGX+VlnI+7PTKdnTW/wzLVsqCyrZKiXhriWuJk0O3D7tIQl17/iDl3CncALUsHTJkXbEanI7UL2mUAcd9Oq/caMFEPc97MUHqrjHPmWjLdHpHIR8O6duv8dZSZ5YG+zaEJOicHF2Sxu07Zv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450736; c=relaxed/simple;
	bh=UMX48jKeATHWb1u1LEBxkTGJG2JDWhdLtkFmMyv39Ak=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DT2LxQPfTtr5sdxxR7MyTtnVTXihHuL1BE+Rrgkw2769XUVNkI14llmeyp22vrlZc4x8mQZU4SxUgsNiWdNKZkwo3agLe6vB/J5qzmwuJSbkH+SMSAyN8+FgSZSkrezrw0Yk7WkZWXUN9U67TZxAN92mrYi4Ii5PHs/KuaqFuoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flC+7ne9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flC+7ne9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 250341F000FF;
	Tue, 15 Sep 2026 05:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450735;
	bh=CspbFF1XQ9bvtKFBfcjgZTzM1ZHIjrn72X6FdPRtjvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=flC+7ne9iukR2BMDW4nJR4EFjXUJSV4qjc5DNgRHaZfti7+FdWtdaml2oUEOOa2aP
	 6nFXx4bX+JpG9V1XpPqegtYJnJEzfG2bdIZLnIXEv97mkWUn4AWnf824hVrILyPcqp
	 gZrxXiWgq6DHWUTy66n7bYlBklBRd2cVl6E7BnnqxXUo5bAtnEQrBdoYPir6rd+OQm
	 kTsR7/hTMrHXk3Xx7CZs5C/D0Pk7faRlTXN+BSD9GqM9+CxyLc7DNS25yEhN++6ujI
	 OeRkD0bn8bJ8f5HW1k+n8zzAZzFrFFeYRQ8UoGXn5n2DLypd/LdAZp0RGz1rGc9IeC
	 HRtvsbiJGzGTg==
Date: Mon, 14 Sep 2026 22:38:54 -0700
Subject: [PATCH 09/11] xfs: drop dquot flush lock when we can't find a buffer
 to flush
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048690.3061055.7567460343709434849.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xfs_qm_flush_one fails to drop the dquot flush lock
if it can't grab the buffer associated with the dquot.  Since there's no
buffer, nobody else is going to drop the dqflock, so we need to do it
ourselves.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_qm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 99a82107b8e6f2..54d00d543b513a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1432,16 +1432,22 @@ xfs_qm_flush_one(
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error)
-		goto out_unlock;
+		goto out_dqflock;
 	if (!bp) {
 		error = -EFSCORRUPTED;
-		goto out_unlock;
+		goto out_dqflock;
 	}
 
 	error = xfs_qm_dqflush(dqp, bp);
 	if (!error)
 		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
+	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqrele(dqp);
+	return error;
+
+out_dqflock:
+	xfs_dqfunlock(dqp);
 out_unlock:
 	mutex_unlock(&dqp->q_qlock);
 	xfs_qm_dqrele(dqp);

