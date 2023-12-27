Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD417ED;
	Mon,  1 Jan 2024 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAToLHxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E054AC433C7;
	Mon,  1 Jan 2024 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070272;
	bh=RADrQcVQ5hnq6i1FI1tSNwnR/V3ortWIapUM9cZ7++k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RAToLHxtBB3v27XX7MnO/vBoxunuMhyxW8U4qw6dgLUdqkLgKdCKAP66Y9XJ5Fyi5
	 inGpzBOFD7jSCYkII9SFVttPKLDY3XXbhVJdoe8//2yZVirpHZQN89gacD2WmEg1TR
	 c2vfq6Qu0L+FvJOvfnFGahUL6z2fQ+gWtCjh0fS99f/6cThfvtfI/ydReIle7yiMB9
	 d2teTSdQ0ZIJCEUr9HBP7J8GnTxUinAG9PGRqQe9I1bwhDs5smqbRRPU7A22CpbQnh
	 PrGLVDaV+RE/c7m/aHxp9MSoGyir8oxD+TyobADEYUGTmEnKpLtw2JQ0wwRoFNfsdv
	 T4hNXpZ+G97KA==
Date: Sun, 31 Dec 2023 16:51:12 +9900
Subject: [PATCH 05/11] xfs/206: update for metadata directory support
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029916.1826032.4300084170108329048.stgit@frogsfrogsfrogs>
In-Reply-To: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
References: <170405029843.1826032.12205800164831698648.stgit@frogsfrogsfrogs>
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

Filter 'metadir=' out of the golden output so that metadata directories
don't cause this test to regress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index f7f12ff1f9..9fd9400daf 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,7 +65,8 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/^Default configuration/d" \
-	    -e 's/, parent=[01]//'
+	    -e 's/, parent=[01]//' \
+	    -e '/metadir=.*/d'
 }
 
 # mkfs slightly smaller than that, small log for speed.

