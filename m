Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D103EDAA3;
	Fri, 26 Jun 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474371; cv=none; b=VQ6L4xOdEGMfpnNwDpf2IzVcMVDLCYzKguA2SLwVBg19/P0PuXTVVVQ6ZC+D9QFcHenaoaAzFTxMlhrHYZrYAKlCKEo2zxiiifQWzptT0gPuT14Tz2k6KF3IQarpELC0IokBymaXJjs3bOL65ghEKqTOoo7idjxM94TsrQeUiFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474371; c=relaxed/simple;
	bh=NLsTun4jQtB8hqjauD84nAnbnWKR9gCEFN9rBk7gnIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUyZEnvpNMJXghnQB1sE8LsxdhM444zlCnTGup4KowpIYnwfGELyq0T8bKE9dvfVTz1SQ9pmhC+laEKO65xWVfZKq6yJy67XX1JwaOElJgkPRk1dEbtx0CS1oRO6bEOlk76vO640gnUkKkPorBYlmcd2aNSATpxlM60YfriZvEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3/t6SCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3/t6SCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A541F000E9;
	Fri, 26 Jun 2026 11:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474370;
	bh=skAIGMQH1C+3KIf+uXAEx3r/aiUtIYALOVftkX5/uQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3/t6SCYp9VHB+fBjSei/ft/pRuLBN22KRUJgHLczJXSVU/dCrkbe6aBgyG/9yZBX
	 lxVXWWG4Vo28IRlemXwsBWSF6fXnWsTIsjwYvkNVh93ed8Xc9hHNWlxBF271Ng1mH/
	 qeNy1dx2ejrM3+CpwbfEMYuvjI8Sq6d1YcL4zrmJIYdZon+J2RuXsY+0IqWkOA+8Fj
	 8NvjJrQuV7olNppJekovOuojnLgibdC1bbBg3q+u9OQCP5BO/ZwsQrHID3+hMnXbTt
	 /boZNVa0mhQiH/JUx7Ugr8+h7ZWs29Tnoxt948JGl/v1QsWk1zAnOA59ZGnqS1Ds7y
	 D22z+p+FQRIPQ==
From: cem@kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: jack@suze.cz,
	djwong@kernel.org,
	hch@lst.de,
	serge@hallyn.com,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [RFC PATCH 2/4] quota: Don't issue audit messages on quota enforcing
Date: Fri, 26 Jun 2026 13:45:21 +0200
Message-ID: <20260626114533.102138-3-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626114533.102138-1-cem@kernel.org>
References: <20260626114533.102138-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Calling capable() to determine if we can bypass quota enforcement or not
can trigger spurious audit messages. We don't really require it here so
just use the capable_noaudit() version.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/quota/dquot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 64cf42721496..1122a29215f7 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1308,7 +1308,7 @@ static int ignore_hardlimit(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
 
-	return capable(CAP_SYS_RESOURCE) &&
+	return capable_noaudit(CAP_SYS_RESOURCE) &&
 	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
 		!(info->dqi_flags & DQF_ROOT_SQUASH));
 }
-- 
2.54.0

