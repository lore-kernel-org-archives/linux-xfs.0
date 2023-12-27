Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4672BBA32;
	Mon,  1 Jan 2024 00:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6soGt6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C39C433C8;
	Mon,  1 Jan 2024 00:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070006;
	bh=RrhqPbTimsUcSTsu21yzl32Eh29JC9NHW05Pw44yDyg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s6soGt6W5ZDQxN0cvWm6eAqyzvKm98kuEIbogWS9Wtd4ekIKO2gFPVjV6eXqeL2wc
	 TAhaEFSY6zYOeQa8stFLT94CWDWiwTPBCC42DztoTm29E4fe1No1X/mFQylc4QPM3w
	 vU/WaEDBz9u5dgN8BmYYTXKo3amN+ZtJzOmSyPvrAoj1t4oK4UoJ68jaxkOZ9aAD0G
	 5+AulkcDj81dnDC374U9QSk79FQVSsVgLtFuS5IjUUJn18yTLstB8zldfjxRAjroen
	 duBhwVt9H+ZthLdv9c2GpzYfjQ30FV6XnD9ul74PjeGsJlaC2iGuKO7hKwXhGst6zE
	 krLVPLXr+8SVA==
Date: Sun, 31 Dec 2023 16:46:46 +9900
Subject: [PATCH 02/11] xfs/206: filter out the parent= status from mkfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028454.1824869.85735145276487131.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
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

Filter out the parent pointer bits from the mkfs output so that we don't
cause a regression in this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/206 b/tests/xfs/206
index cb346b6dc9..f7f12ff1f9 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -64,7 +64,8 @@ mkfs_filter()
 	    -e "s/\(sunit=\)\([0-9]* blks,\)/\10 blks,/" \
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
-	    -e "/^Default configuration/d"
+	    -e "/^Default configuration/d" \
+	    -e 's/, parent=[01]//'
 }
 
 # mkfs slightly smaller than that, small log for speed.

