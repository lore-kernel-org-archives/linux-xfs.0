Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898B71D540
	for <linux-xfs@vger.kernel.org>; Mon,  5 Aug 2024 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722883583; cv=none; b=PK3zEzFbnMUlBprAArEPMqp2y/lxSLXjoL5ErlZnEPTa3jv8KpwedeW4Zmh9TIl1PWthClx7Sm8XAJ7MXvzQaZ7+d4KpgcIYMwPu63kNlv/hXLX6JBmpfe6CDgJ8HiMhAv5rrfILGx9hfHgNJREGJ/7b/wzxImoRdsF7WK+gCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722883583; c=relaxed/simple;
	bh=R5tyqaN6s9+8d0KCToAZkpTnXBrBnad6Oa+65Qr3ekU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZtftcuU1G3h7ar0eZGNfMwH1pcno6PTlvykH7FnKWZIDenps8NFh/4SaaxL2Yu03+cPdPw7B3gyO7gpcIhPKaQpXdRKf7hi7OrSzIsDrYDAQP+MbfO16Up9STXMM/Svgstli3mqM8nS2Asl0mOojgrFo7qQ7ugSDqwTNy5e1lc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjBtlkum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjBtlkum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFEAC32782;
	Mon,  5 Aug 2024 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722883583;
	bh=R5tyqaN6s9+8d0KCToAZkpTnXBrBnad6Oa+65Qr3ekU=;
	h=Date:From:To:Cc:Subject:From;
	b=gjBtlkum0sI+acrF7f00m3Qz35TF3XKjgPwG2EKdGEbempIfdW7e0okJThFgyQwDQ
	 M5b4uw2wTkTrAOlx3ira6NW7CvoovayqM2tE1PFNJmRvhbwlNkpGoUyYdIyg/FKKU2
	 b3gvKIgqYzKvqdMKip+Ikk6F4SqrKfZMHfmrTCVYbHV7sktI2ZgWIov9isDaX5JrOe
	 DQQ0mF3WeH+l+aBo19vMaJMTakpdabtNTzV0MJwTq1i7fV7xHlHKmXcE64sfVPG5Vz
	 gtrzXO6zFdQnE2zWGcOPbEniSgK9c5LjV5S53iXScljO64qQfPYgdNgou9HJ8FXTi1
	 vwZJDK1kIAK4A==
Date: Mon, 5 Aug 2024 11:46:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: revert AIL TASK_KILLABLE threshold
Message-ID: <20240805184622.GB623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In commit ce46e893b6762, we changed the behavior of the AIL thread to
set its own task state to KILLABLE whenever the timeout value is
nonzero.  Unfortunately, this missed the fact that xfsaild_push will
return 50ms (aka a longish sleep) when we reach the push target or the
AIL becomes empty, so xfsaild goes to sleep for a long period of time in
uninterruptible D state.

This results in artificially high load averages because KILLABLE
processes are UNINTERRUPTIBLE, which contributes to load average even
though the AIL is asleep waiting for someone to interrupt it.  It's not
blocked on IOs or anything, but people scrap ps for processes that look
like they're stuck in D state, so restore the previous threshold.

Fixes: ce46e893b6762 ("xfs: AIL doesn't need manual pushing")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_ail.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0fafcc9f3dbe..8ede9d099d1f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -644,7 +644,12 @@ xfsaild(
 	set_freezable();
 
 	while (1) {
-		if (tout)
+		/*
+		 * Long waits of 50ms or more occur when we've run out of items
+		 * to push, so we only want uninterruptible state if we're
+		 * actually blocked on something.
+		 */
+		if (tout && tout <= 20)
 			set_current_state(TASK_KILLABLE|TASK_FREEZABLE);
 		else
 			set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
