Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211103D47A9
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553156; cv=none; b=flkWc9oqT5QZ+U+hly4ZOszdhCsJjuqJ/o3MTBVmI+QpKoq6BdLwJVg785ABXVqIoGP3HBptALjR1z4q/E0UGi0cmqTF9csqSWuVpGzXib/iPCwh2H7WXbWdtLUM1Tf8Y8iHzjmd0oatABjbW/CSegR19+ABRwDZxCfi+XsrJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553156; c=relaxed/simple;
	bh=S4rRClfC3rdtK8namS5eduqfSLgcVGjCLcwcTliID7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+FPXUajKjt3IQH511vR6jjcbtv/n8uQfRkgiMZWAZzYI9JQwfeK4wRI4AqLDNrZOq+Rx3nHHWp6vMjfS97J/D98NkVsddkxN/KEP8YFjuqwJiDfZpGdS3sI9kStaw5HzKnnMj3Mn0igcvIbAI+suOwsfZvO6JakpZc1zJPnKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+sYoKeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+sYoKeW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A57891F00893;
	Thu,  4 Jun 2026 06:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553154;
	bh=RcaimwUT92k51/A9Ac2CnNvAGbM0KmpJBfAqiLAboSU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=M+sYoKeW3DmGg8S7aPAycqsJrVxKPmtq3QrKJ/vTU9bVLpL7x9JnQHLdsZbY8EJsu
	 BnoRrhOiL7mUaflCPYsLjSxvAfD7zDr7fPWGIQP9HajV+UQxUWxjSOKM+FdpTZE+S5
	 yDGij+nxhRoRqkji/tYF7pbrkxSb681z8QAVNQYszsRlUNgugiXlsshqA77xEOzvr+
	 89n75lC66itk8TD0lfsPAsY4MzwNTAZbkAANImDokMPUFlBLySoQUyta1a81kluKSJ
	 T1EdTbnT2BiKLiXi0hTakVLmKbWypApITzAL/uamwHUfR/ztB9o+yU8DkRVk22BL/y
	 HtxjH5LULg6bQ==
Date: Wed, 03 Jun 2026 23:05:54 -0700
Subject: [PATCH 06/21] xfs_scrub: fix integer overflows
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303219.2608728.7060540682362288655.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

agblocks is a 32-bit variable, which means that on a filesystem with a
large AG block count (e.g. 2^31 blocks on a 1k fsblock fs) the
multiplication with 95 could cause an integer overflow.  Let's just do
64-bit arithmetic here.  Codex found this.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 34bed605490f93 ("xfs_scrub: tune fstrim minlen parameter based on free space histograms")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 0967832da890e3..5bfe0ffb4868a2 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -149,7 +149,7 @@ fstrim_compute_minlen(
 	 * We can't calculate or query that value directly, so we guesstimate
 	 * that it's 95% of the AG size.
 	 */
-	ag_max_usable = ctx->mnt.fsgeom.agblocks * 95 / 100;
+	ag_max_usable = (uint64_t)ctx->mnt.fsgeom.agblocks * 95 / 100;
 
 	if (debug > 1) {
 		struct histogram_strings hstr = {

