Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6521B3925
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638865; cv=none; b=PYoOGOrriROTC00cqaPGXPgZyO5YSM3gbCT00w4flIZ3FXpd8dW5QKjHboUWkMK5ZWmCqAVcHAOHRf/0CG1OKxNkKaClrWXiG1oWeDlYWbTt20Qlj11HrPeSppfTLzR6YRuXkoKFGYryJLxhFyR+al9BKCw0sGEf/TFuQ9N8gtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638865; c=relaxed/simple;
	bh=Pe5ULLN6IkHPY1h3DoCQRhQPt9dSjPwlRettW7AJlhk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXZq3wewFlPnMq3gX1AOCXHjRR3MTRjTU27n0WAq0lfGOkN9w83171i8T3I0uy0UQhQQEI7t4hnpXb8YEbj9m03r10/ksC7rVqwopFsBdpYx4N2bxyw75QkUT/woe3WUpUwqFavCAAPcbtKdOk1/DIKRlDZIdRg0GrOq0NVxuDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruFthXbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruFthXbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429C4C4CEF1;
	Tue,  2 Dec 2025 01:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638865;
	bh=Pe5ULLN6IkHPY1h3DoCQRhQPt9dSjPwlRettW7AJlhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ruFthXbVLIXPMz6vAw0eJKH0MUJEqbvGFg4uK3uaC+sekCPQnZ2aVEhUt6SINx6qu
	 GFOK2cXniHwlmqAGB3IFtJ/4hloQjf2t0rTxLAWjQKJRI0cEmwlWMSqJUBW2/WHQGJ
	 4H0BOTd6ydCmzD/ROro/ojJW9hDWM9CnYCOBugrfT0GG8wXix5YzsBa2fZirbeoTN5
	 IDEPP+N07fgEUrHth2wgKDWCfH989phd+UvS7ctTyIdTmMGaUwijecQw8XuoAfze2w
	 7oRuHCAlo60fCfKs10UUv81fMI3QD2jG2ihstSdyVuTz9E0WCi0Kmx3tpJVL91KRGa
	 dywUQiu0lKUbA==
Date: Mon, 01 Dec 2025 17:27:44 -0800
Subject: [PATCH 2/3] xfs_db: document the rtsb command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176463876136.839737.6808868548984812536.stgit@frogsfrogsfrogs>
In-Reply-To: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
References: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the rtsb command, which positions the debugger at the
superblock for the realtime volume, if there is one.

Found by xfs/514.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_db.8 |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1e85aebbb5b27c..ba2a68211ef21f 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1310,6 +1310,10 @@ .SH COMMANDS
 
 .B rtconvert rsumlog 21 rsuminfo 809 rsumblock 10 rbmblock
 
+.TP
+.B rtsb
+Set current address to the superblock header at the start of the realtime
+volume.
 .TP
 .BI "sb [" agno ]
 Set current address to SB header in allocation group

