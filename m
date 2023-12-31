Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53066C2DA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Llkq5SAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2C0C433C8;
	Sun, 31 Dec 2023 23:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066955;
	bh=CSpnDdq1Sro1k6zWb+KoPUoc82+O09337mvgxXNlD8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Llkq5SAoV311Ozr38hpHvY6dXCTY/rnPVSPHkuhdmvi65qwt/CkpQhHghScmkaQOw
	 YP6P0JeTq8dKlWPLECz3oZgyRmUJmvxVlECyY+PbPFaH3NFATlPtWw/8jWU/UI15rN
	 +npbuAM56JcEZ79Sl/t6aFNjtIopEkY5RBMNmw4RQzP+IZuO3H16PCG4QJbevqmpjG
	 4wLcCKdxnnKbaIWvqFC0yU0Rw2Sz+UifujjkiJERasq2qDWWogwcwYByNRzQVlUofo
	 +GKqEImbgKjFNg+Ac0JcmhMiNRBxkybW/r0rLvzfwppfUqyBW8cdg8UVG6PmrqLWpu
	 Xa+wIkJANaO7w==
Date: Sun, 31 Dec 2023 15:55:54 -0800
Subject: [PATCH 32/52] xfs_db: listify the definition of dbm_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012593.1811243.12218139848186985131.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert this enum definition to a list so that code adding elements to
the enum do not have to reflow the whole thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 20de9c74d4a..0c29c38eee0 100644
--- a/db/check.c
+++ b/db/check.c
@@ -26,14 +26,36 @@ typedef enum {
 } qtype_t;
 
 typedef enum {
-	DBM_UNKNOWN,	DBM_AGF,	DBM_AGFL,	DBM_AGI,
-	DBM_ATTR,	DBM_BTBMAPA,	DBM_BTBMAPD,	DBM_BTBNO,
-	DBM_BTCNT,	DBM_BTINO,	DBM_DATA,	DBM_DIR,
-	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
-	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
-	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,	DBM_BTFINO,	DBM_BTRMAP,	DBM_BTREFC,
-	DBM_RLDATA,	DBM_COWDATA,
+	DBM_UNKNOWN,
+	DBM_AGF,
+	DBM_AGFL,
+	DBM_AGI,
+	DBM_ATTR,
+	DBM_BTBMAPA,
+	DBM_BTBMAPD,
+	DBM_BTBNO,
+	DBM_BTCNT,
+	DBM_BTINO,
+	DBM_DATA,
+	DBM_DIR,
+	DBM_FREE1,
+	DBM_FREE2,
+	DBM_FREELIST,
+	DBM_INODE,
+	DBM_LOG,
+	DBM_MISSING,
+	DBM_QUOTA,
+	DBM_RTBITMAP,
+	DBM_RTDATA,
+	DBM_RTFREE,
+	DBM_RTSUM,
+	DBM_SB,
+	DBM_SYMLINK,
+	DBM_BTFINO,
+	DBM_BTRMAP,
+	DBM_BTREFC,
+	DBM_RLDATA,
+	DBM_COWDATA,
 	DBM_NDBM
 } dbm_t;
 

