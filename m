Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E434A1E908E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971228; cv=none; b=m4a+dqj0VfKi14fD/crNRNp2SrOYejmiAQ1C3xbESZKulvDOXwzI56Hi/CQ2lo2ZEjtxb4NArs2ixrQfKblE6MDbuoPzUNXiCelm59Y2+gRUzBNIq9yLhz9VG2yHL8xHDVnd/brpBqwK+GFUUELOhTIGoQ2im00K37lpFXLUZwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971228; c=relaxed/simple;
	bh=Dh4iXcgtG/qrc/VWDfyTd+YM+uKzGBaVs9a0zvvqgr0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJTL4haD2aWTIU7bPsAKnFgAgbiOJK95ufBtyLMD57GApALtyYVh5PcWrg5Vg2D/0ysKUCwU0yDokIxjWUW5lX1Rd7trxIgQ9eM2Mx6COjFQRqOqrV/3SRYQTloGzM/Sj3WIbCReL47qcYGyMuvAkEuqBprn+/Ujt/0AveVu8K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qj1h5KS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qj1h5KS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E253C4CED0;
	Mon, 18 Nov 2024 23:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971227;
	bh=Dh4iXcgtG/qrc/VWDfyTd+YM+uKzGBaVs9a0zvvqgr0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qj1h5KS90HuvyCbEgKq5mxo1a/3zyhhEepTCmdGTrhzwwqoxLyrxetoAG4wH+oSea
	 0jsyvkamPCYcOK2YWCqfosdFa1eChTSCk1v+m2s/JdM63asogaCF7gKJf1bfsaIqt/
	 Xfz4beW9SUiQCdha20RVMrsBsBZX7QcGJI0vznG5taCHzugIDKnLiQjdje0Fx/A5Lt
	 c7myLhV1fAziIkhVw4Tr7+ZEPWmWvYTIo7lB9TE/5DxSG6YV+XTucB/AYbAmkdOhnj
	 azDT6J+1dPQkEsXDYnkA/4SB30UYohuSEprm46PCBuT0il5cHqlGjSzdkUW9CF0/1j
	 9VWcNJV+aMFtA==
Date: Mon, 18 Nov 2024 15:07:07 -0800
Subject: [PATCH 10/10] xfs: fix error bailout in xfs_rtginode_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: dan.carpenter@linaro.org, linux-xfs@vger.kernel.org
Message-ID: <173197084583.911325.13436063890373729938.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

smatch reported that we screwed up the error cleanup in this function.
Fix it.

Fixes: ae897e0bed0f54 ("xfs: support creating per-RTG files in growfs")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index e74bb059f24fa1..4f3bfc884aff29 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -496,7 +496,7 @@ xfs_rtginode_create(
 
 	error = xfs_metadir_create(&upd, S_IFREG);
 	if (error)
-		return error;
+		goto out_cancel;
 
 	xfs_rtginode_lockdep_setup(upd.ip, rtg_rgno(rtg), type);
 

