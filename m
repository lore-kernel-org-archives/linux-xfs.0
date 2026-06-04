Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6807B2253A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553373; cv=none; b=AgfHAS5M2fnW2hoLnYfYpBMp2aH/3FF5WBfDdPYATQYQDitSI35MpJc1Xj++YiTJesbWxRVm3nCxTu3ZEUdXI7uHN+pLLUASorOxRZJ2gGBZOJLUSSNlrslUoFyK6V9NDrtau8r5GJQIVRsA50j/HGRyaO/qaeJb9r2MltT7Sjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553373; c=relaxed/simple;
	bh=J9Bg10p36oDeIOyPp7HbZzt6YLZBa7iZogu+Vc+Br9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYbei060epxsgYPVkxY9U4eyZsypKnEfDSDhFB11TfzHMd178LtjoOsr8FNRO+o2bUH0UCUekDwJtEt+IHLksFRlLE2oSJt1Erg2HlKGu+p8hG2HYK9fqHjz1wVh9OZnhkY0P5k296UUMLDPLcII6zvb/vEFs56tEokgncBr/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iy8kxYXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iy8kxYXn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3ABB91F00893;
	Thu,  4 Jun 2026 06:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553372;
	bh=plowv2wmbRqdVv+ilTO+0aSc06q9O+EAy4bcGDZRvqY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Iy8kxYXnDUADD7UoSDSsxKP4SfP0stooS0xVg6jM0dQk4qOaTn5CGPpB0Ju8dwIjv
	 yo2HzlJYoiihX+N+BB0GOIjInGwoXtaAo8iGH5PGqXDM0VhHTHqMIVQUOWrDunlREP
	 kFZng1i3hxx5OOggGSzdMmYwP4FZ2BfjrYnt9k05W9F95MDwW3xcGSuGeSrlUfQKBJ
	 ed5y4kACGZVgD/A8qdf+5wFZTFIbnY/VmZoSOxwwpcVkxnZASSPtpXGPFlg7HsyVhc
	 piySi61GDwCAU+x/8zyfFlCgRGYzndesti4VMnnKG8ajX+lrn0ZoSfOBpPhjCym0la
	 /lW7TVWvMUqTQ==
Date: Wed, 03 Jun 2026 23:09:31 -0700
Subject: [PATCH 20/21] xfs_scrub: bitmap iteration functions must retur
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303476.2608728.8389975048890577690.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

bitmap_iterate doesn't generate its own errors, so don't invert the sign
of the errors returned from retry_deferred_inode_range.  This keeps them
all positive, which is something that Codex is good at noticing and I'm
not. :P

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 5a30504f0c60e1 ("xfs_scrub: defer phase5 file scans if dirloop fails")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 52bbbca4b9f06a..329d208d882ef1 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -527,7 +527,7 @@ retry_deferred_inodes(
 		ncs->new_deferred = NULL;
 		ncs->fixed_something = false;
 
-		error = -bitmap_iterate(ncs->cur_deferred,
+		error = bitmap_iterate(ncs->cur_deferred,
 				retry_deferred_inode_range, ncs);
 		if (error)
 			return error;
@@ -546,7 +546,7 @@ retry_deferred_inodes(
 	ncs->new_deferred = NULL;
 	ncs->last_call = true;
 
-	error = -bitmap_iterate(ncs->cur_deferred,
+	error = bitmap_iterate(ncs->cur_deferred,
 			retry_deferred_inode_range, ncs);
 	if (error)
 		return error;

