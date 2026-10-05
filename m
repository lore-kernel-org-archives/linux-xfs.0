Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F90231839;
	Mon,  5 Oct 2026 05:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179828; cv=none; b=H/Q2MgwNVSyljVJOIVEI0imsnArLXA9o7Wl5WOwBj7o36MrWTYJwCjAn8e0vLRpofcpKlqr+aeal+KHCLsUCvuHUA26w/ohNNGoTtKVDzLZby0hePfMwIMAOuteC8lL3Qs9PIpPKA+NtS2GuHJvGMXqRa4MEFJRZalWZM9+GPQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179828; c=relaxed/simple;
	bh=0OrLoXk/s8nslcXtB+kR389pZBLKTkkMMiGnBWBTi0M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iv6k1hFfu6qAfAjbjtG330DfKjLwff+mS4orPzAHGCyDYQv6lCqFJcNokmXaPBp7u5ICRfGLo8JcLWmyRnBWVgATE2nImVXTvCHhZZnYPYagCbEDV2he8z1ec69N6IqcXE7E7/FJMal5KE2Onfr/dChHR4V9vxYToan6XgnnZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgYWYjob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgYWYjob"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5CA0C1F000FF;
	Mon,  5 Oct 2026 05:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179827;
	bh=xvvnPL/AQ2yLXkb2uDyszJn5dvikVKw4y5Io2DmX770=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XgYWYjob8/RMQfDZP7Etf4bJiBjIPGQyr8mNW7sP4uUQQeo8UM/uQJfvM4W4YetEk
	 QjbtsvXai/KwnI3ZODjWuxxR6d1Iw2EyFnP4lqfi9exozzWs3fxtUuyaYbiq4dAGwN
	 nQc1NhWcHiiaAe3N5YcV5yp+dB2oISR5EXYC3Eveuanx68ZplmyVbdI0D//FiDbKq0
	 qtUzgE4kpf5dnoPUjEr1/mtyYgtYKDTqP6PdB+6QG3O9IrSHc9+UobTtVsJywplDsY
	 XjcVdoy1lxNXBngdbX2ff2LlE71+g8eLMkNg+hS6rZVNgtivdO1zNPcscxJEHIhKmR
	 LXCmq38kq10gA==
Date: Sun, 04 Oct 2026 22:57:07 -0700
Subject: [PATCH 07/12] xfs: don't try to scrub self-referential dirent in
 metapath checker
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965159.614350.4466564726537723655.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that the _ilock_both helper will loop forever trying to
double-lock the same inode if mpath->dp == sc->ip.  Callers are not
supposed to call us with parent == child because that makes no sense.
Trigger an assertion, mark the scan incomplete, and return IO error
so that this fails noisily.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: b3c03efa5972f0 ("xfs: check metadata directory file path connectivity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/metapath.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index e0ee7d9b903ff0..4cc0d37b529f97 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -319,6 +319,13 @@ xchk_metapath(
 		return 0;
 	}
 
+	/* Callers should not set the parent to the child. */
+	if (mpath->dp == sc->ip) {
+		ASSERT(mpath->dp != sc->ip);
+		xchk_set_incomplete(sc);
+		return -EIO;
+	}
+
 	xchk_trans_alloc_empty(sc);
 
 	error = xchk_metapath_ilock_both(mpath);

