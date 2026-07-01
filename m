Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EEF391E5C
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 05:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884999; cv=none; b=Gs+GCuauv9zuHO9YaKAwaDFAyboiWmG+8QfxdoQTdqlXrVeTaSzR4WLu7v/SN9107heE2mycWfcL9nUWv4XTgiA6Jv38r4FwPY3oieedKH1j486BJmdAvkqC32onvxLPzO5pr19OTk20sWL0eDFJWglpqnPNA9e1U3xe43bVWZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884999; c=relaxed/simple;
	bh=HW+L43hQ2t6m8hIzpRNca40zrNWahQ7hHNqnNexs7Rw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DnvgnDomRYCycsM2CklXqlfOhXXXqkE1zXgzV9OuZ5AIIMzIdj8BMehj6rmtMLbuSuukZEtFtCEr5ObW3Yzt7OaBYv8RO4NV0/2CS34Aw8oe69wgqHERWO2w9yRqb+0K3Cn6yg3B9Vo3PnS21OO8nM6TOEQTbYWQeJ9OLuCEO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JM8f62Tf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JM8f62Tf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 485941F00A3A;
	Wed,  1 Jul 2026 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782884998;
	bh=84Oq16wBAx9PmqzPYedC8Y5/apiMkvYQeOuqJUIrHgA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JM8f62Tf9ahuUowooEjIKbV3Tn3EOtdmRswSJgj5EtKnhX8ULHINDTnCzuKGkpyF/
	 5TeV9uCY8w+ecKTJKqqRcwsrhHxYLflmoTNlmQikpkhC8QWk20kxvrwEtBRzFRnoVK
	 VFFuK6YypqKvZVrOlKvUP6PwKDoqCLZhg3nwDFTb4HSK1pbQxRZT7oxBknrKiWHpfz
	 6o3mLg/dvbcu9NK6R5Ov60Q8hWbwM0oLTm9W1MTp2mpSZRBiB1egA5i3SrdHv9OjMm
	 b027TwX4C10rWAxLRsj+T2sUB8E1iD0DaD6nh0Vzt+6uC0nTjNb5nDyuCYAICooPq5
	 nEBxRy0Pu4v4A==
Date: Tue, 30 Jun 2026 22:49:57 -0700
Subject: [PATCH 2/3] mkfs: fix hardlink detection in directory import code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178288493220.702844.3296067461182118456.stgit@frogsfrogsfrogs>
In-Reply-To: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
References: <178288493170.702844.13763176151607587444.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's a serious problem in the hardlink detection code in the new mkfs
protofile functionality that copies a directory tree into the new
filesystem.  It's been long established that hardlinks can only be
detected by comparing st_ino *and* st_dev, but the new code doesn't do
that.  Fix the detector.

Cc: <linux-xfs@vger.kernel.org> # v6.17.0
Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index e435f2e6d42b4a..dd47e41d833e5a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1314,6 +1314,7 @@ writetimestamps(
 }
 
 struct hardlink {
+	dev_t		src_dev;
 	ino_t		src_ino;
 	xfs_ino_t	dst_ino;
 };
@@ -1368,7 +1369,8 @@ get_hardlink_dst_inode(
 	size_t			i = 0;
 
 	for (; i < hardlink_tracker.count; i++, h++) {
-		if (h->src_ino == filestat->st_ino)
+		if (h->src_dev == filestat->st_dev &&
+		    h->src_ino == filestat->st_ino)
 			return h->dst_ino;
 	}
 	return 0;
@@ -1406,6 +1408,7 @@ track_hardlink_inode(
 	}
 
 	h = &hardlink_tracker.entries[hardlink_tracker.count];
+	h->src_dev = filestat->st_dev;
 	h->src_ino = filestat->st_ino;
 	h->dst_ino = dst_ino;
 	hardlink_tracker.count++;

