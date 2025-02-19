Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE78146B8;
	Wed, 19 Feb 2025 00:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926533; cv=none; b=oOptAd1Y4mk5MxGPCn4xrGhX7MxOacOOHJcWz04wwdfqqkwgYEWndC7Hl/reKGZIo7+Uet6n6/RYrRg5G7+PvuYds+oWhNLKJg4YdVx4Ojk8BQhsSPcALtIFlIfVeWAXr6L0z2+b14ipdHQnWp7f1Pl2+3yfPI5MizIJGemSSjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926533; c=relaxed/simple;
	bh=IifR8vjFBLOTcIWgGqWJQLnSreQDquGjh+9n+9XMPuQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0VwFnuQV0eDV1DROl1LuYkMOC7tL5tjbRbtI4VI5PQ7CL5n2qyHGNsI5q9PwnLUVMCyS0yMbpnL2FRpdDSDH6N7tDhFqZ1rXhL8R7nfvKLqkzRTuDps9+n0OmzPUaoMHeXX8o9w8gWuOnAw7Vi+0kYYDr6gH0XdZ1u2w7AjBIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m97RZ45y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m97RZ45y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B236BC4CEE2;
	Wed, 19 Feb 2025 00:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926532;
	bh=IifR8vjFBLOTcIWgGqWJQLnSreQDquGjh+9n+9XMPuQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m97RZ45yD0hdQzUwEuJqvfu+zPfkhMzxeuVfH5sA8G4pN6j/B1HpXSFrZIW0qUsT9
	 ELnqPalER0TxhLT1BJr8gmZrTK7HLPbV7Pu7S0VISvLLmzuPkQA/KyicpqxIZcfqMU
	 7dhEKsIhc538BAqkVCsCDbIohgEdTXrKoWYP6J7rTmFUIpMP8o5q5bwHIYDg3XW8EM
	 8LuZSU+RIFIZc1UoDtrAC2TT4I3UpIO0iEWqUV42awpe2exsoHXFSfLbr9VBAz9mB4
	 3XMCj8QOnegGqYiRNNyDfT6mzhpI07+MgzF2oxeKAFTsz+BsSVAk5KM2FWR6W86qFW
	 nOQ6IX+URQckg==
Date: Tue, 18 Feb 2025 16:55:32 -0800
Subject: [PATCH 08/12] xfs/163: bigger fs for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588208.4078751.16040969808269964576.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adjust filesystem size up so we can pass this test even with metadir
and rtgroups enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/163 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/163 b/tests/xfs/163
index 75c3113dc2fd03..015a82cdffaa68 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -42,7 +42,7 @@ echo "Format and mount"
 
 # agcount = 1 is forbidden on purpose, and need to ensure shrinking to
 # 2 AGs isn't feasible yet. So agcount = 3 is the minimum number now.
-_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
+_scratch_mkfs -dsize="$((900 * 1024 * 1024))" -dagcount=3 2>&1 | \
 	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 t_dblocks=$dblocks

