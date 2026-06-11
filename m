Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0A02D5940
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186723; cv=none; b=sZEVtQcCD9rwZRZTmWAM+hfbSWC7tcHrwZi3cV+koJCKGIG06IxHZC3IbX/imZO4AjcgYUaFCkjVEX7qfRxwreClxJl9Ro/jJLkMENoQKoFaZLO+mNFbk7OO0DLFAjwKwe7OXsPeMXb6j0+ZW2OY8TaghtjrJfP5PgdjlafqcUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186723; c=relaxed/simple;
	bh=gN1kCwQMiM/Fx4303SH4WllKVY/awjIY2H4arq7GI3Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnSdicD6jVx84TssnqBjejJvivkXKJ3Iuu+6AJ43elZGJRm7nvYLQ71LRoBNUA7tH+TTc7mTnA1NFQbxd0l9xT1//md0Bwjy1fKM4vYWIY45tYZXK4979ZaNWT5bifTJxl2sgBhTAYeeF5TBXjae9Lqu/UWmRBgyvRaNaIVOV1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sbk8m0+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sbk8m0+/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 383691F00893;
	Thu, 11 Jun 2026 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186722;
	bh=3cg9D+kAIUhs9NqsBys606EVr+P/OeHOmaJ+flR9lP8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Sbk8m0+/10escJEsKpGFQ6BRcrQMwszYRsMoYASuEQk0VyBChxhs9FlCz26UZHiji
	 iuZ0cGoFoCDwhaKzG1CmivIhZ6gADA+5y/6djHit1YbIqWJXZIhBb/CsVUZoCXMECA
	 5jPP1SgvEjxUyEpchxnSMHF3EfWadB/mnk7yZZvMvcZHC8uitz3jdQXc+j5u7s7opL
	 zYn1mWyXclL8nvU63Sh3TBeB8GSaFVgPasMKnSVftp4aPmlZy2hjN0BSznK6a3+KdO
	 mgNOHHNdIO4U2YB8eori4kaV7P/4mFNX8GMPoQDxXCCf8HOmxxM1qSaD+1Ec6rqYXO
	 O26WMshM4jAbg==
Date: Thu, 11 Jun 2026 07:05:21 -0700
Subject: [PATCH 2/6] xfs_healer: don't allow aliasing of mon_fd in
 setup_monitor
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178118661279.728615.16193461564655914882.stgit@frogsfrogsfrogs>
In-Reply-To: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

As the comment says, mon_fp consumes ownership of mon_fd.  Therefore, we
should set mon_fd to -1 so that we can't use it further on.  Codex
complains about this logic bomb.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: b9b03770197d19 ("xfs_healer: create daemon to listen for health events")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 4ea8d86ac9114a..ec402a78d5d2bf 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -442,6 +442,7 @@ setup_monitor(
 		perror(ctx->mntpoint);
 		goto out_mon_fd;
 	}
+	mon_fd = -1;
 
 	/* Increase the buffer size so that we can reduce kernel calls */
 	ctx->mon_buf = malloc(BUF_SIZE);

