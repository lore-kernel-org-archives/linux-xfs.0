Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258A4A02;
	Mon,  1 Jan 2024 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8PMkr0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7C8C433C8;
	Mon,  1 Jan 2024 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070570;
	bh=tRMTNM3QfGoz/9U8zJNO0HR24KKcjGIKNThQT91LvIY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M8PMkr0hplGzRAzPbQRkHc0qGpCgBhOfYTTCFhKVinrWzOtixiZc6wbkncqix9Ykb
	 TsczOmyFV1fSt3Tb845M6uyPN3o5a3UzvI3Ot4sFysCsRz+1h8WrmOI6UMiXlxz1Fv
	 kH9hn1Sgy5GZSRhZQi6szgukV/8zihjauEAv5bGC+5AiJsRORwDMq75/CnfcpFuKoe
	 OEGcOh3QOO4vzvq6MMJte9viy0VQ6cx6CbQT2z1XKo/23m0LH1htSsM0XCbe+hVNBg
	 Feqz20CvgsTgTl3LkcGyZvnu6wCIrmjQnBo7KGyP4B4fLmN32InGNRLMVmMAZSg2n5
	 p0+90l2mial+g==
Date: Sun, 31 Dec 2023 16:56:09 +9900
Subject: [PATCH 13/17] xfs/122: update for rtbitmap headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030508.1826350.16701115460263023294.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 21b139d838..8bb79ba959 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -119,6 +119,7 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32

