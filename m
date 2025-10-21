Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B36B23E347;
	Tue, 21 Oct 2025 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072125; cv=none; b=hdssDDphTqpCgIsb3QEjglrB3EVqgHpVvx+WO29SViOvPsBL8sBxUpw1mfzdBqXle3SqS5LwbLDNnJJxXV8VrWyLpi7jpHotgaWu4JY4nO+RMTpjjTmoM29jxcH49y0SJf7sVTchHV7bk+PE3gpgNk2+4HNHeJF3yLRdIxkb4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072125; c=relaxed/simple;
	bh=nDC1+gtCqmSWtBN3f/RSEOqjnLYJhdkDoHCujVQn6tM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tU+CDV6khjgBZ5bnzKzeE/vjIUXIu9/ULkDu2Xf+gLhZFC6wugqN/iToz5ZIc6Y3+PnhoAYo41JbfCcukTsA3Ic2EEvIK5VTKM8F5icx86dGgUgSFl1R0nHB+O0FMrrj3RdcXFCSsyz5SgMYCDZZQJzZCsUNGfqUcuuwHnXobsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0Kl0hKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0Kl0hKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB085C4CEF1;
	Tue, 21 Oct 2025 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761072125;
	bh=nDC1+gtCqmSWtBN3f/RSEOqjnLYJhdkDoHCujVQn6tM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s0Kl0hKRlkNmBeRE3EKVbbBxo47IC9rnfDLofjNpXx8dmLrtMTX9rIKqm7uJ9JxOt
	 AtnSeA93Ru6wheOHtKLO24QGVuyZUK2QgB2230ZvAGUvV91rXOnActQnR+gdq0E8zW
	 vRoeT3m9uRig8F7w9/7jSoDG0ypdq0l3n/yAHNXZX2WxjlsJnND0K17coKXujPxybf
	 /MBHjlXCf7NhxuEj+qsvYL4fP1Py2wREFbdRlJIqK1SN0iEDmlvuqG6K0Eb+mhazqF
	 7MJZ9+dJlNA0bVFuP40L+mYNlKxtHKatf80Nuz8R1JeU3ckfebmLzp5S6zLfxNU+FQ
	 Q5FT/SZrLk6Mw==
Date: Tue, 21 Oct 2025 11:42:04 -0700
Subject: [PATCH 11/11] fsx: don't print messages when atomic writes are
 explicitly disabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <176107188870.4163693.967026967128229321.stgit@frogsfrogsfrogs>
In-Reply-To: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The user knows they disabled atomic writes, no need to clutter up the
output with a message that also causes golden output failures if they
start fstests with FSX_AVOID='-a'.

Cc: <fstests@vger.kernel.org> # v2025.10.20
Fixes: e2bc78e9d340a6 ("ltp/fsx.c: Add atomic writes support to fsx")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsx.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 0a035b37b6bd7e..626976dd4f9f27 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -3164,7 +3164,6 @@ main(int argc, char **argv)
 				 longopts, NULL)) != EOF)
 		switch (ch) {
 		case 'a':
-			prt("main(): Atomic writes disabled\n");
 			do_atomic_writes = 0;
 			break;
 		case 'b':

