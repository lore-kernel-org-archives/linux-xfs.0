Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085FB1547FE;
	Thu, 16 Jan 2025 23:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070005; cv=none; b=szCryJ2hIAhySDFCqdz5hufYuKr41vn66aOG2ZszDqd4I5aujfljY8TN1Leh4j4Og6Go8SXP8kK9j2I9sz0KG6Vi4fDE4VQ9CzS2VXhpKiXpI3FOUkr/G6H98zMULzxWmSSDtWvvnuZhV8oIdAwAYAY7v+8G8yW9aqCJ3QNI5J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070005; c=relaxed/simple;
	bh=dm3+4pF3hh29oXOtz5V2tVKTeh6e8UX6hmXyRyzSKzY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1ICqKDaFPp7cuoEOyP9FHutLQTNYgYw/4SxHVERRpsym3RemEt5+rSubL4HYd6ozhGpdLDMMWvlV3chet5DJBOS9D3AFlC8xvb7go7tLhyV96UCauKjnin80Ipql2PYIsucf2wGZtyMfGdVS2Gp6nxd6Hz7POIxOvyMPClWB9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pAZTH4Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAZTH4Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1860C4CEDD;
	Thu, 16 Jan 2025 23:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070004;
	bh=dm3+4pF3hh29oXOtz5V2tVKTeh6e8UX6hmXyRyzSKzY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pAZTH4UeNzIrQ2rsFefBL07b6l7CWkEc9EJv0NvPXEbIu0EEzFSNFuk8z/8Q6TBPh
	 zYilv+WkOdqhSnBpDFsaNIjXjSny5jnGYkr6wwNzP80CCy0A3khM+O+yHuaMVt6Fng
	 W0b98ceMsbIZd1BDOiz26cnSaRX1g7Vs8lQfhdhZiCnouZTfR9BenuZ+c22ZvVnVON
	 2zp+zTQCs6tzC2gWaxmEdC8+b7svWhi16BWHCaoo8cybRzIeafOd1opuM2pWT9GBoG
	 hjOuLLbXREcRx+LpmXQHqHg7HDuzZaRjZKICCxhPTKCHA881jRjPlVyEgpueypPIru
	 P6BcCHWDSMneg==
Date: Thu, 16 Jan 2025 15:26:44 -0800
Subject: [PATCH 06/23] fuzzy: do not set _FSSTRESS_PID when exercising fsx
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974167.1927324.3074850676975765263.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we're not running fsstress as the scrub exerciser, don't set
_FSSTRESS_PID because the _kill_fsstress call in the cleanup function
will think that it has to wait for a nonexistant fsstress process.
This fixes the problem of xfs/565 runtime increasing from 30s to 800s
because it tries to kill a nonexistent "565.fsstress" process and then
waits for the fsx loop control process, which hasn't been sent any
signals.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/fuzzy |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 534e91dedbbb43..0a2d91542b561e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -1392,7 +1392,11 @@ _scratch_xfs_stress_scrub() {
 
 	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" \
 			"$remount_period" "$stress_tgt" &
-	_FSSTRESS_PID=$!
+	# The loop is a background process, so _FSSTRESS_PID is set in that
+	# child.  Unfortunately, this process doesn't know about it.  Therefore
+	# we need to set _FSSTRESS_PID ourselves so that cleanup tries to kill
+	# fsstress.
+	test "${exerciser}" = "fsstress" && _FSSTRESS_PID=$!
 
 	if [ -n "$freeze" ]; then
 		__stress_scrub_freeze_loop "$end" "$runningfile" &

