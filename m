Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C97EF;
	Mon,  1 Jan 2024 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQeOuqKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F81DC433C7;
	Mon,  1 Jan 2024 00:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070304;
	bh=J+wDQk9S7dRGqux9z0+Vowaz4LghVZfn/8EvSMEiWNM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IQeOuqKL1xHSQlE+SFgQxYKLkc0+BNfyXXY90oOM3GBrUZb/PJJ76Z0JBBz8ksid/
	 9XWPkiP31QpbCKEx9Y6/SxymMGvS8BIuSvZkqpETVV6dcAtKJ0hENlUHJ2HnUdoB5N
	 6+3psddtgtI7ScM6zNjIIsi4V6RnHrn7Wle58sR73LYhmCXcTLdwUoNkC7oVIAuph2
	 Isq16ZP8mK1U6MHsLwxT5yVWSW298EdKXI2IhgcAhm9qQd4OEoJTssN7owxqxBRnX8
	 mAqfnCjtkJQe31PGv1hwAi8c2FlE6Slc3fiQGEspo7uMUQa0JL0s4lwLIX71jssCak
	 H+rE2VFubt7Zw==
Date: Sun, 31 Dec 2023 16:51:43 +9900
Subject: [PATCH 07/11] xfs/856: add metadir upgrade to test matrix
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405029942.1826032.15570536793461753536.stgit@frogsfrogsfrogs>
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

Add metadata directory trees to the features that this test will try to
upgrade.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1856 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/1856 b/tests/xfs/1856
index 84e72d7c81..93bdbaa531 100755
--- a/tests/xfs/1856
+++ b/tests/xfs/1856
@@ -173,12 +173,14 @@ if rt_configured; then
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	check_repair_upgrade metadir && FEATURES+=("metadir")
 else
 	check_repair_upgrade finobt && FEATURES+=("finobt")
 	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
 	check_repair_upgrade reflink && FEATURES+=("reflink")
 	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
 	check_repair_upgrade bigtime && FEATURES+=("bigtime")
+	check_repair_upgrade metadir && FEATURES+=("metadir")
 fi
 
 test "${#FEATURES[@]}" -eq 0 && \

