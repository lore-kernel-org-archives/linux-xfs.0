Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81C738E113;
	Wed,  2 Sep 2026 05:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328143; cv=none; b=i41ntpKRvGFVnkvqyrtNqwu9ai3+ufjSkC/Ty+aO6YKq7BIWKRynwTjPPHSfOYO2TgcmDlAC5emVlOkCVU6EJs2jB04Er7z3Wl5+jpkY3AMIwA6pnMdr7RgDqpuEDNMI1sb1CuuBhZp3yxAvUvtS86YnzHVj4MLnwvj4QyYJYZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328143; c=relaxed/simple;
	bh=jvUKhtCvsYDriTu7mNOtfaZnRp6v7GSv4RjPWcWOmrs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FwBeel8MOshbOQuH6eJxCvkS0l8P4PJ2KiIq31MDjrqas5JheBOcUVjhc768gXptZmH66hLJ4BgQJc9Vh3s9sldZBMgyHJbhf0hOb6nUs6tk+3XX5wjHHvYEq+wRU8Sxo+fxe2V2IWh1Wb3BLOzRw3qpIArMFw83GmGLl9DZBe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxobDlh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxobDlh+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 839A51F000E9;
	Wed,  2 Sep 2026 05:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328141;
	bh=vSqmG9ngYgBXDJKcKmrtC59tGe6Xz+/WeNRGE/kYCQo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=JxobDlh+jydaAwbEHN6fcFYZMBnaYlmNUoqlWAdloa1gPnG7VS3sKrWceU5Eh1PKO
	 xnJuMsDSEpvXy0muNxveLF6DYnT3mPwqY8XS5V1kJQqL/pigpSK6WQnVVkqvcacRZh
	 ollec56V5u32OTf+4jtXWiV5gRNF+jyHPrsIROiMwGbF8A3zYpIo7LlI2JbuJJZPdi
	 PaX8hzuMgOulTvjUci/K9kBZYzmB0fxNlb8WCTPx5ClVPA4KqZWiw27LNH+v1vhQcx
	 JjrB4UupZaMj4cKfFX4WitWESWcWGHhuIfFKkwg97P7E1DOM2u8Aw+0HvVjV/rd0ie
	 1TnBq9fagGRpA==
Date: Tue, 01 Sep 2026 22:49:01 -0700
Subject: [PATCH 2/5] xfs: truncate quota file correctly when repairing quota
 file
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832750752.3508131.12269209789139517612.stgit@frogsfrogsfrogs>
In-Reply-To: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_quota_data_fork screws up the unit handling when
it computes the offset at which to start truncating the quota file.
max_dquid_off is the file block offset containing the highest possible
dquot, and xfs_bunmapi_range takes the starting file block offset.
Therefore, it makes no sense to multiply max_dquid_off by the blocksize;
all we need to do is start truncating at the next block.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota_repair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 487bd4f68ebb2a..ca3ac6728339d1 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -455,8 +455,7 @@ xrep_quota_data_fork(
 
 	if (truncate) {
 		/* Erase everything after the block containing the max dquot */
-		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
-				max_dqid_off * sc->mp->m_sb.sb_blocksize,
+		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0, max_dqid_off + 1,
 				XFS_MAX_FILEOFF);
 		if (error)
 			goto out;

