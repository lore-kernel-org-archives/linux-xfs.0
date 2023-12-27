Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1336ABF;
	Mon,  1 Jan 2024 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="splVlQne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E718C433C7;
	Mon,  1 Jan 2024 00:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069771;
	bh=cigiQpYKPEGIkOtVAYOeeC4ImoLJyqLbkzqyETM2ry0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=splVlQneaeiTbFfdubhX3UC8qBNjk2Ag5w7B0nOcU/dfrf37AFSglxuqSiZqTsXOb
	 a2RUk/R6drg5wCvqjByllQsMID1SxMaChMcBKAkUZeouU/5wLuAlTonhZLrvHVvo+c
	 mWySJjHBJ9ckj3vB3hdv0f2fJ0gwCbBHw0tZSO2z/IMIzWhhYctdlXSX6Cy1L3EW4g
	 0CyWRaJqljCwVdfOVJS16dNKCJL8/4a55xM4yeDetnbxXw8xn4Q21MtyCiCph06byF
	 3GieEcAdAPGAVckOiLBk0yvzgSQoycOJB+l80jfEXMcTzu6zjd4v5wLY/sWG6+QOI/
	 7jqBt3kBchEmQ==
Date: Sun, 31 Dec 2023 16:42:50 +9900
Subject: [PATCH 1/3] fuzzy: mask off a few more inode fields from the fuzz
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405025614.1821776.11739533344730730248.stgit@frogsfrogsfrogs>
In-Reply-To: <170405025600.1821776.14517378233107318876.stgit@frogsfrogsfrogs>
References: <170405025600.1821776.14517378233107318876.stgit@frogsfrogsfrogs>
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

XFS doesn't do any validation for filestreams, so don't waste time
fuzzing that.  Exclude the bigtime flag, since we already have inode
timestamps on the no-fuzz list.  Exclude the warning counters, since
they're defunct now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index f5d45cb28f..35cf581cd3 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -120,7 +120,11 @@ __filter_unvalidated_xfs_db_fields() {
 	    -e '/^entries.*secure/d' \
 	    -e '/^a.sfattr.list.*value/d' \
 	    -e '/^a.sfattr.list.*root/d' \
-	    -e '/^a.sfattr.list.*secure/d'
+	    -e '/^a.sfattr.list.*secure/d' \
+	    -e '/^core.filestream/d' \
+	    -e '/^v3.bigtime/d' \
+	    -e '/\.rtbwarns/d' \
+	    -e '/\.[ib]warns/d'
 }
 
 # Filter the xfs_db print command's field debug information

