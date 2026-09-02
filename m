Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DC838C415;
	Wed,  2 Sep 2026 05:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327910; cv=none; b=CMQ8X8+M+D5lPOllgHDXI2ExgYMzcXvlo/tbGPFJx2zkGbRCOaS5P0gpL6bYNQ0aArhRPUAm7bzUCdRrCqYJPSTgWBVv1EmbfTr8QH4DHH/EFlIaJ0GbyBCSC1M5W4m+PQb3gJFapnsH/1ptCZ58qqi5NGykI18DHJrVUNFwV0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327910; c=relaxed/simple;
	bh=+Wk44bF/0iuvwn109DgMY9iJL9t2Wk1I37mTNLSDH44=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UoLL7RGAEFkoiNzLj0+UxpoI/usNIp/M1RLQuYa+F3vDepMVkaynL/c2KxVkOTPI+vWCZXhlcYx8zXW7lPVM06RRCdFQxnxI1BrZHtM14ulIna9GfkvzjJKx/GxoFYn5TLKqz0B9mEbC5gKic6jR6NtbNKC2zuAM5dK7SIkS8Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrmqK3tJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrmqK3tJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 667C81F000E9;
	Wed,  2 Sep 2026 05:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327908;
	bh=r88GzeaQGvnNHKTGKZHLfwMUBlmwJJxdbxMCxHXHxH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CrmqK3tJmMaUmjqlqHdMIfn8dH9ukyfhn43YkI8xCKiqIYfTYMtYKsFEu+hk8CsSF
	 AQCSNOzwFrQIA2yeh4ffNvXBkh039RYMOT0OFA4/O6NwqXyCrcFvp3yHxARFagywFi
	 BTTboG3V35LLjapvIRzsA8yM13qzXpvuf/kYb+iCffaGfhpcsydPL0Q0ZwIvYUUp29
	 Thd3W24ISXWlhAPmek8AMPH8YDEhMdeJtR7xAQ235NKRzE71QBVJyokFv4emakZWco
	 TKNAjA+omvCL9X843jWDmzHfQ4pg+PdrilSyC0gtrouWgYpR9/7LdzEcJJum8NGGGe
	 Jcnf3S6l2S1FQ==
Date: Tue, 01 Sep 2026 22:45:08 -0700
Subject: [PATCH 1/6] xfs: don't spin forever on zero-length dirents when
 salvaging them
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749856.3507493.9558405265791933554.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
References: <178832749800.3507493.12247008945704358106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 1c088cfba10ea9..0c1224d05d579a 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -484,18 +484,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 

