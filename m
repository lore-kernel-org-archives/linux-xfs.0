Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C71BC147;
	Sat, 24 Feb 2024 01:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737381; cv=none; b=F6kqG2XM+wDneoYMxZSa5+7ZXZzHyZ9gW4tpCXj0OzDYgUek6YGb8ZRo+qXzEW5zo4DBJnVVoVeo8oQ6q+wBjoxCkM/xgLVeGNMH63r7DVLGEQazBx3ke0GEiKMwXkaLzNAbDWupchFrBfTCDbC+Erfec1fEsd9BuiNVJEmm+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737381; c=relaxed/simple;
	bh=t+A4fuSyZmpKgcoiyVGvJurKhFdfR6NSDpq/Eq4fqh8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsZkhfyZDPojUFRDjoLWKReRdRlJcLDdTZiSvhHtmVVQWSmpJU1/b38FPJXX3ixGAjD26ACh6qPNFduRXPfksP3C0EbZWdDS/c7uUyJLQbRg+wghxC6++6JLbH0z+rVZmmRGWB8Zo1VgBP0nsNlBiS3KDvnx/fMHFKBLRCQjvf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoRxnbZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoRxnbZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E225C43399;
	Sat, 24 Feb 2024 01:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737381;
	bh=t+A4fuSyZmpKgcoiyVGvJurKhFdfR6NSDpq/Eq4fqh8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EoRxnbZKmfu1bsYK1Q5UbSC01cBn6XZ1TgE1TnePN5bIcvfPiYfIhyUVnrrduUrPf
	 oK58BvBt+rBr/d2Gob1cyRBJI8gwvlC/zI6Id1SHgT/ttTOL8dqlUlWyNe6yQbB7kW
	 LC0mZxAO4aPVMsCnHpszl4Zq7VULCA5+bbn+jCQJmeQRJgWasv3OnDUIrnw5Q2iI/o
	 LU3KHY+SaISVU8oMKAY0qmgPwceQ1+9mTko/dqFh1y87x0vdJAwscNSEtaX7SFHy87
	 cdpyVPfNgsGm3xnuvC8CXEm82fdUnqaLaEsmtpizBJiHH4yBnBrwZxfcdBnj640UsT
	 kcAKk1V3LRaBw==
Date: Fri, 23 Feb 2024 17:16:20 -0800
Subject: [PATCH 10/10] thread_with_stdio: suppress hung task warning
From: "Darrick J. Wong" <djwong@kernel.org>
To: akpm@linux-foundation.org, daniel@gluo.nz, kent.overstreet@linux.dev,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <170873669050.1861398.1460620236602264758.stgit@frogsfrogsfrogs>
In-Reply-To: <170873668859.1861398.2367011381778949840.stgit@frogsfrogsfrogs>
References: <170873668859.1861398.2367011381778949840.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Kent Overstreet <kent.overstreet@linux.dev>

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 lib/thread_with_file.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/lib/thread_with_file.c b/lib/thread_with_file.c
index f4946a437332a..b09dc60ba6280 100644
--- a/lib/thread_with_file.c
+++ b/lib/thread_with_file.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/poll.h>
+#include <linux/sched/sysctl.h>
 #include <linux/thread_with_file.h>
 
 /* stdio_redirect */
@@ -46,7 +47,15 @@ int stdio_redirect_read(struct stdio_redirect *stdio, char *ubuf, size_t len)
 {
 	struct stdio_buf *buf = &stdio->input;
 
-	wait_event(buf->wait, stdio_redirect_has_input(stdio));
+	/*
+	 * we're waiting on user input (or for the file descriptor to be
+	 * closed), don't want a hung task warning:
+	 */
+	do {
+		wait_event_timeout(buf->wait, stdio_redirect_has_input(stdio),
+				   sysctl_hung_task_timeout_secs * HZ / 2);
+	} while (!stdio_redirect_has_input(stdio));
+
 	if (stdio->done)
 		return -1;
 
@@ -67,7 +76,11 @@ int stdio_redirect_readline(struct stdio_redirect *stdio, char *ubuf, size_t len
 	size_t copied = 0;
 	ssize_t ret = 0;
 again:
-	wait_event(buf->wait, stdio_redirect_has_input(stdio));
+	do {
+		wait_event_timeout(buf->wait, stdio_redirect_has_input(stdio),
+				   sysctl_hung_task_timeout_secs * HZ / 2);
+	} while (!stdio_redirect_has_input(stdio));
+
 	if (stdio->done) {
 		ret = -1;
 		goto out;

