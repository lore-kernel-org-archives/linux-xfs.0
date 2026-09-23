Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1568415F0B;
	Wed, 23 Sep 2026 06:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143409; cv=none; b=qgQ2nNWcJF+6UlvvJQiBvNqPBdHTOu/BwxUiO7Vap/MTxyMBZxN4zE/OukgXjRmapInNjix5o0UWkNxe1XwTGcM9jQhZDCbWIlhc7X0n/ZAN67GwJkaYg8rzPPw4ZANLKvfh94WT32KjbFX5B0QCoBRTdfl0ETVnlhElQwRbOqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143409; c=relaxed/simple;
	bh=PFUI2/StswXXOUg5WGtdwKnHOjvZ+Z+I+f0iHxb0K+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrxP26kWI47AxSJRnrvxp7h7cUMNxMFfsIj36K0eZbf89gafZtjdJowHhrxhNZQ+gXxYbCZyhLRpelGrynNIXNEArFsqtgl11E4FUd5dNNZ0H9GcIDM3F5b1CdeXrmidkScYMos6pbofxqOlifTmSdxoZ+kKNxrDX/IdH+luOA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Owtu/7pj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Owtu/7pj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 67F4F1F000FF;
	Wed, 23 Sep 2026 06:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143401;
	bh=HdkKv1xmkuZ2txwjljtRuCnPCYu1YBqL6+uTE7YOmfY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Owtu/7pjDOrHliTRLbwtbGjf5JICuOVeHOFpimH2CoGXerDc3pRtYu9QFsnlFR9aM
	 oy9UNmbKg2Y+tYHS1+Q2+iB90lghLy8Ormn8tbOagjQroNAXx2Ntm/eUrNyA2bj/Gn
	 1RHWmLL7dvt4MkVAXJMNl4An4FiQ4f1wITR3GG/fNp2Uc+abfk06L0IZfvn6Hj/Tq2
	 x2Uulki9dG5mElOgleLK/15+9VgHSZAuasTKiu1DWLT7KTTXKm37iWRVbCrWOC0HPa
	 upvmdVHo30+uzjRSazvTO2mhX8V8nXTvZrf/BYT1Q7GMLMKBVM3FvvwS90VCe/Audu
	 fVUca7l6Bw/qw==
Date: Tue, 22 Sep 2026 23:03:20 -0700
Subject: [PATCH 10/12] xfs: fix unnecessary dapos truncation in xchk_dir_walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159756.1875436.1369162178937848347.stgit@frogsfrogsfrogs>
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

LOLLM points out that the all the implementations of xchk_dirent_fn can
handle a signed @dapos parameter, so the truncation here breaks the
information captured in scrub tracepoints if the directory is very
large.  I don't think it ever made sense to do the truncation for the
VFS readdir code for programs that can handle 64-bit offsets, but commit
15440319767942 has been around for 17 years without complaints so I'll
leave that alone.

Stumbled-over: 15440319767942 ("[XFS] truncate readdir offsets to signed 32 bit values")
Cc: <stable@vger.kernel.org> # v6.4
Fixes: 4c233b5c4f29df ("xfs: streamline the directory iteration code for scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index d68bf20b4a148d..970d43030704e1 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -238,7 +238,7 @@ xchk_dir_walk_leaf(
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 
-		dapos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		dapos = xfs_dir2_byte_to_dataptr(curoff);
 		ino = be64_to_cpu(dep->inumber);
 		name.name = dep->name;
 		name.len = dep->namelen;

