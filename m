Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F923D7CE
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199480; cv=none; b=UmQTlyymSelqN8qzlI/2ZQZe1sgc3st1d5bOVsgeQPEo8+P2D6zkiKkXY4WYCevLdlRYK5XQI0iJB/zDpPkT1xDbshtjv2z7Ta0/QyMYI7ex2flan8pkI79Sl2pc7+qbnC4uoZ7N5iSeulE8BV9yPD1RuUVFJd9BtD5r9y0JskE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199480; c=relaxed/simple;
	bh=uBirIRot+/NaRCqiRYN6NWzflBszvfjBOoyol/kBPIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idoXDtfvjCICIwQU9SKMBK6PD2zMW1az5QagLUr6myTQ9DvLiSAfSlOBT+Wf29kkmzkeICNDwT52A4+Qh2vLKj2dYnVT9TmRXrqy8nEym9DjUUr72LmNizN6Ood2UlDUdmTCri29BcwKAPZy/+8s1CTGLBUNZ1QM5vcYI0OU0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFUOQKGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFUOQKGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94350C116D0;
	Sat, 20 Dec 2025 02:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199480;
	bh=uBirIRot+/NaRCqiRYN6NWzflBszvfjBOoyol/kBPIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFUOQKGFE4WN/8hJJlQMPLlB6VJTXpehBy9juz+FArb5vmZ4URhQg8rV/YGF6gMok
	 IaYKmnB0B/ODurX6lSilb0Emk8KndbbFVfneLdqF+M4LMNs+S+l9cbHUwtfJG1yNkB
	 v0dpZpYk3Weun7TwfwzaaCvt0WXoZWarqcKf6f8UmPOI8y/mTfSBKUs5VafnMpGLE3
	 rMqx7ZP0bZeI219lauI8TUKMHOBxrvigMLL8YH+b13shyx0nLLmG+x72yHmPdzmwiR
	 TvW8/NKwk2H9bws8kbleNnXaE/2v7olvNH6nHJAag2ipmi3XGq9/eU7rl5V9kDqEal
	 UwcKpFkv3DCbg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 2/6] mkfs: remove unnecessary return value affectation
Date: Sat, 20 Dec 2025 11:53:22 +0900
Message-ID: <20251220025326.209196-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251220025326.209196-1-dlemoal@kernel.org>
References: <20251220025326.209196-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function report_zones() in mkfs/xfs_mkfs.c is a void function. So
there is no need to set the variable ret to -EIO before returning if
fstat() fails.

Fixes: 2e5a737a61d3 ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 mkfs/xfs_mkfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bc6a28b63c24..550fc011b614 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2589,10 +2589,8 @@ report_zones(
 		exit(1);
 	}
 
-	if (fstat(fd, &st) < 0) {
-		ret = -EIO;
+	if (fstat(fd, &st) < 0)
 		goto out_close;
-	}
 	if (!S_ISBLK(st.st_mode))
 		goto out_close;
 
-- 
2.52.0

