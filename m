Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54951F1502;
	Thu, 16 Jan 2025 23:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070301; cv=none; b=IHzY8MMze1/vfhI1JEsv+C7lweMPk6oYCm6+NYDS3Cbxyx0+ZV+MYnymN9pgj2UH5rLIa1712bcmJsS7qcaMcitvMcGyOJzc/yVsWbg2HCoCa+pICvmkEqmuWaC9p67tc27PKW7f3xNeI7klh+UjNz/c3O3Q+Ijw4IvVnP76P90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070301; c=relaxed/simple;
	bh=1b3WRsNnivAxyi55OjZu3eEOrtb0Id4ruAwv8YsLp24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEO97EorrxNskD/fTlHT/RQ0zv/8XqS8qlOS3RBV3rtPRRgsKJcSmXpJR6OoBcRexJVPz90OO3lyfxSd0vEmv9LeT2qUWVXG1M4FabsPAuheuTw5d1LkHEWaAG3VyqPvs68UTNB82C75EH1UiR3US6VADjMj48OpPUS3B20nHOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKZpWbzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKZpWbzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BBCC4CED6;
	Thu, 16 Jan 2025 23:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070301;
	bh=1b3WRsNnivAxyi55OjZu3eEOrtb0Id4ruAwv8YsLp24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mKZpWbzHpLEp9xeJWW1jsH4lib5BmrkzBCUXDsYrp8JeZd3NEwmBg4TlmG5a7V7kb
	 8lgpLunatj7vl57MvdBCY1tydPQx2+SfmmAQGei5Fxky6QzMfU4sU0razKMfJViCkz
	 JyDTdP//1jHt4zSNdWNEnSrGa4/5bBkqlbazAGeItg5Vq56H3dY/XdEUmj/KJEU1tm
	 Itu/PM5PzLBdN4+HWd6i8G9hhGdDA/chr0z62KmW8sOC1/ZhnA1ccypFsIsGN7j0xq
	 DgknJX3A7YgvBKsbC+sd3JSOfsrtyBVmOQ7U1cfZK1v8oaHvSPj22rMcUMO+hTPhi0
	 RC/uDyHTOdmCQ==
Date: Thu, 16 Jan 2025 15:31:41 -0800
Subject: [PATCH 2/3] logwrites: use BLKZEROOUT if it's available
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974764.1928123.15642624942297043790.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974730.1928123.3781657849818195379.stgit@frogsfrogsfrogs>
References: <173706974730.1928123.3781657849818195379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the BLKZEROOUT ioctl instead of writing zeroed buffers if the kernel
supports it.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 src/log-writes/log-writes.c |   10 ++++++++++
 src/log-writes/log-writes.h |    1 +
 2 files changed, 11 insertions(+)


diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index aa53473974d9e8..8f94ae5629e085 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -42,6 +42,7 @@ static int discard_range(struct log *log, u64 start, u64 len)
 
 static int zero_range(struct log *log, u64 start, u64 len)
 {
+	u64 range[2] = { start, len };
 	u64 bufsize = len;
 	ssize_t ret;
 	char *buf = NULL;
@@ -54,6 +55,15 @@ static int zero_range(struct log *log, u64 start, u64 len)
 		return 0;
 	}
 
+	if (!(log->flags & LOG_ZEROOUT_NOT_SUPP)) {
+		if (ioctl(log->replayfd, BLKZEROOUT, &range) < 0) {
+			if (log_writes_verbose)
+				printf(
+ "replay device doesn't support zeroout, switching to writing zeros\n");
+			log->flags |= LOG_ZEROOUT_NOT_SUPP;
+		}
+	}
+
 	while (!buf) {
 		buf = malloc(bufsize);
 		if (!buf)
diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
index b9f571ac3b2384..f659931634e64a 100644
--- a/src/log-writes/log-writes.h
+++ b/src/log-writes/log-writes.h
@@ -63,6 +63,7 @@ struct log_write_entry {
 
 #define LOG_IGNORE_DISCARD (1 << 0)
 #define LOG_DISCARD_NOT_SUPP (1 << 1)
+#define LOG_ZEROOUT_NOT_SUPP (1 << 2)
 
 struct log {
 	int logfd;

