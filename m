Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E97B42AF86;
	Fri,  9 Oct 2026 06:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526538; cv=none; b=LOMVIr6ehuUs8A6g4TQEfUrEOwrLRVDX4lG6X3ECz84xA3+lpvOVm4NqfM8G/HY00hojZND+y24Vui2p7lEMZVo7uEeULQJ/Au8WBvrcwVcNAJoI8bqp7qy7KI4u4Qb2q7vZJurnvcJshm8+ZnM8Nf1mdCetrNWJgrul8JGEMqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526538; c=relaxed/simple;
	bh=sHujBVnl8LruPkMduLImqHfZXqz+ciTJpYwMZFBrnLo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrfnYIg43GTWhGC7JzCuo4Cs5NdxGDTiwETJ1PW6AuwASbbMYcARYQQ1MdGSb4W8TbTWCcrLDJtNkMqrNXuGlUNypdLyrDIdK2dYwar1L4E3Nof85ogsLninBU5R1i066R+J5CCrBxxYBJ+o5rnlJ7V3uwkTkdp1BtsXfpGfcOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4VOIIlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4VOIIlw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B0871F000FF;
	Fri,  9 Oct 2026 06:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526537;
	bh=XzALPZZFNI+jW+uLfo8a5c/+ldvofRhwFnAFkbeL8As=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=B4VOIIlwjA6fZi0T30fpxwW0mTXY8UMqYEcOQ3EbrXQhP4wWdTRAz+4QSLxfT+GTV
	 A2e0FlSZ+ennHoZdRWDQVWYliN3G63vcAencdAgnYY6dtfoPkpUCA7Fpcd3pjzJoqh
	 3G9dkiZNZOA9CgRm71SBmFzESgcam3qzegfVov7NXhw/bBEJMS2tFjr5eSWUOZB1Rw
	 +rlxDnqRmTyQ/+v5NKa/oW0avaghMMXvRk7sMe7pGvDFtgk+RWc2yj84uv8VvktQlV
	 3vsX+XGchr4qKbhQpufvCV8MkJSeneXHuxEoaMDAbJiCCrIeAUpWOGPsxZN5RvAaLu
	 Z+TQf+u44LTMQ==
Date: Thu, 08 Oct 2026 23:15:36 -0700
Subject: [PATCH 03/13] xfs: abort directory tree repair whenever dl->aborted
 is set
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614685.3163896.1260817276380598497.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that if the live update hooks for the directory tree
repair code ever fail, they'll set dl->aborted, but then the main repair
code path won't check it to exit early.  This can cause incorrect
repairs, so let's check for hook errors and abort the repair.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree_repair.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 717ebbe4f91916..1de4d9f1b61657 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -575,6 +575,8 @@ xrep_dirtree_delete_path(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 
@@ -720,6 +722,11 @@ xrep_dirtree_adopt(
 		error = -ESTALE;
 		goto out_trans;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans;
+	}
 	error = xrep_dirtree_create_adoption_path(dl);
 	mutex_unlock(&dl->lock);
 	if (error)
@@ -780,6 +787,8 @@ xrep_dirtree_move_to_orphanage(
 
 	if (!error && dl->stale)
 		error = -ESTALE;
+	if (!error && dl->aborted)
+		error = -EIO;
 	return error;
 }
 

