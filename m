Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A8146A8F
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 22:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417475; cv=none; b=Y81catHrpKgWW8wfkvbUYq69frL9VDnEriCYAm0BPjLHAEqjaoiFMUk0EEJQztnYD0kKrTXn8/lFIKRKM9tbFAHQCfz8jVKCSVawyOPfwBkKouQcSf1l0JZ2pxd6Qt+T1IbjaLrTM1qPiwZMbtVieR27ZgTnmfQuZwo3MFhlA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417475; c=relaxed/simple;
	bh=lYtWMaq8MeT4Plcl3z82CRHtstBc+4HX5DOJpqZ532U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WD+fd/b/xpL0a+gtfsiz0nH5ZULvd2cEiDmqTFOxvtVvfWJXyHUWIeO0odaN3Ah6gHdxkmfrQbdlKZ6+oeqtBXcG7tvwxzugoomjDvq+twAlGzpCDDvV36C8+zHgic5Sjv7//Ks/O+7YQa91JgHAE+T31n0fMSUQmvSzsQUVF8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=cVJKCCli; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="cVJKCCli"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=q8ZdsYRkYSEO/cKJD+rLAOMYbeEZfdRXx9Ry5wsZ3tM=; b=cVJKCClidSDuxSVF6LfM6aHjzN
	GxNvj04Fgr4kI11i0F0ORyySZJzXaTCL5oVs5wKtWrjt/ovi2EH0psW/gkhUhQcCrvQSAj9gZgnzA
	+8cX23xRzx77l6YIfZscAz1Q57Ez11KKud3ElfvVRty+veaelCeEqhXLtWNFCdWIhzNVTcl6pOnd4
	yRw1o6iZE8Zs6irQylJdrYy70uIxm4+GNSoA7MimwTR02NfU5/gH0JIU899TJuQZwGrWpim/UJLHA
	GrEoxqE+cutQ+jmJlkPRLvIHNKgltmDCFiEc+HMbfKNGWYSJupNyXoM+xwV6FdRxnPgBKozpHUzSG
	L4cLLtKg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1s9ual-00ECyh-3u; Wed, 22 May 2024 22:37:51 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2] xfs_io: make MADV_SOFT_OFFLINE conditional
Date: Thu, 23 May 2024 00:37:48 +0200
Message-ID: <20240522223748.9986-1-bage@debian.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

mips64el does not have the symbol MADV_SOFT_OFFLINE, so wrap it in an
ifdef.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 io/madvise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io/madvise.c b/io/madvise.c
index ede23395..644c85e0 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -40,7 +40,9 @@ madvise_help(void)
 " -H -- enable transparent hugepages (MADV_HUGEPAGE)\n"
 " -m -- mark the range mergeable (MADV_MERGEABLE)\n"
 " -M -- mark the range unmergeable (MADV_UNMERGEABLE)\n"
+#ifdef MADV_SOFT_OFFLINE
 " -o -- mark the range offline (MADV_SOFT_OFFLINE)\n"
+#endif
 " -p -- punch a hole in the file (MADV_REMOVE)\n"
 " -P -- poison the page cache (MADV_HWPOISON)\n"
 #ifdef MADV_POPULATE_READ
@@ -101,9 +103,11 @@ madvise_f(
 		case 'M':	/* disable merging */
 			advise = MADV_UNMERGEABLE;
 			break;
+#ifdef MADV_SOFT_OFFLINE
 		case 'o':	/* offline */
 			advise = MADV_SOFT_OFFLINE;
 			break;
+#endif
 		case 'p':	/* punch hole */
 			advise = MADV_REMOVE;
 			break;
-- 
2.45.0

