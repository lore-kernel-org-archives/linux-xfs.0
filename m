Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE9C3921D8;
	Wed, 23 Sep 2026 06:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143371; cv=none; b=hO2djcabnUjenuA9fpE1RaokHW9Kh78niHp2g9tZI/5x8/ZAenC7nDCCGvL/Gg5s0XoZ7ko//drp3sR3ggD2+OFufgTMX3Ho0MVZ8rutck6c1B5TZkzEgfcQAvVnp6/qDc+fKmf9Z6PLdvD8GqwpppPiJOa98TopCnFS8QvndTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143371; c=relaxed/simple;
	bh=yu8Wv6tm6bF1SadrpmHDG0c81GGgyz0NhzO+brlsOCE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=An1wu4rXPfXX7kB5lx7w6Wkv2VQteCLjCFPIE0DVkyLiWDMNZFZIt9bk+DjQAu4o7qdcM48RFPhBeMbJrhpT2lF0aLeVu5kNaskesKcs24f0fh05biBgJk/WNJVvLCE8Qe2Eima/VC3TZgZW/kxWfyqUsvN7mfUOZQeF5CPcV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AI99I+Qu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AI99I+Qu"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 224361F000FF;
	Wed, 23 Sep 2026 06:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143370;
	bh=IaO7iYmsGBJvTGdu/UfYEk0saZyqapFjYn5ga70BfvU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=AI99I+QuVmvtyEc23AbfAK2iwrONwuuGUK3x/w1fSwkXfG05rYivQ3Iejtai0zFRa
	 6YLT9hs1GYLZuY8pHhPnnJTfEiYdwV9ny9uvIXnAnlXotuiK8L29rwJOFCn4yn5Ri2
	 izEc+6y2t/PTQLh5NqXIC+nlAw8+6MTNuAa10aGjRaQT4RHpkTjYAKAkc6P6hDE136
	 nI4fUZZdRO9gSuc/H3HAa8jw8pWO6zAuT1mOUz6BJVbhEV1Q2IkVg0H3Qwn5wgkwTq
	 oMOSG5IOTku/xDw7ZWZ21h+HG5qdxK6DpkUkMHWI6+Z0gH+cw2EzpARbh91S9peaXU
	 Lyx3z2kBT8GSA==
Date: Tue, 22 Sep 2026 23:02:49 -0700
Subject: [PATCH 08/12] xfs: actually report corrupt xattrs as XFAIL during
 cross-referencing
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159713.1875436.4353102591557994166.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Some LLM reports that xchk_dir_parent_pointer really ought to report
xattr corruption errors as XFAIL (cross-referencing failed) when a
directory scrub tries to find the parent pointer for a dirent name.
Let's do that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 61b3f0df5c2358 ("xfs: check dirents have parent pointers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 19d974c7e2b7a9..4ab7e646924828 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -155,6 +155,8 @@ xchk_dir_parent_pointer(
 			&sd->pptr_args);
 	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+	else
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error);
 
 	return 0;
 }

