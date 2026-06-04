Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90A1A23B1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553124; cv=none; b=TF3y6zujFI5Gaw8+k/WiAeVSeqY+I6AUrQRP8bZK7rw5GLcUC2uLrjPLawJHqzcfwGleRjYZamFoVpTl7vKwMiqqcSJ7MBGvcShQZ2LTtqdM3lUbyUVndQxIzWSyl7QvWvC1zbOb4eVlJ9pjsEp2tlmgrHZ2D+cNGxKcHVFEsAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553124; c=relaxed/simple;
	bh=nxSC8jjpQSVOP6WEsvSR4QwxPGqSYF0j5ChWvtS19gg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4BMKPyTlhz0PyjmJyTAGi8NAoJlsmKRbeQEsf3paUaB4RvRcokY8r4jsfjSRzb7DJbm/fTr6F9oH0QYsx0dGvhzKvK/N471feCY46zi6loXLTela+HbNY60rWJy1vZq9AnBhPueo2SBpxv5brzGJ0/C64NlJXPKl0oMxv0Uf3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOoeLxEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOoeLxEC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F8771F00893;
	Thu,  4 Jun 2026 06:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553123;
	bh=lwJ2fOorcNpeald2+oG7XTiDKXkVR1gTnty4Ak2cR0g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bOoeLxECH71LQzWmpaSFCxZJS0LecMMrAcqZoiK4tGU9ebgYCrie7x0ROT8MG20iA
	 69noYbR+ng36+525vHcpP9Ags+3nixT2FGr2eHuTJhl8VriSUqJM+/aY8cmvZlHDBS
	 NmnebOPBhaJbOeOfHgtFNQVVA1Shq/YrKIHWAoxiwem1oLUhEwlRhBH4X7Syx76V4f
	 IfPq1FT4Z9IU58jS65qbVD1189bf26xxRtZhjDFilUEgb38fbBs9D/hngDb5Q6Htov
	 22awXKoJfJ0iJ/ZzmzfT+g3PufvNBfQjU9QJP9tlmeuoKHgpKGPfCaJLZvUyxAhU10
	 cX1oJxvGmMbug==
Date: Wed, 03 Jun 2026 23:05:23 -0700
Subject: [PATCH 04/21] xfs_scrub_fail: send content headers for xfs_scrub_all
 failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303183.2608728.11213800137735900500.stgit@frogsfrogsfrogs>
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

Codex noted that fail_mail() doesn't include the same content headers
that fail_mail_mntpoint() does.  As a result, utf8 encoded content for
xfs_scrub_all failures might not be interpreted correctly by mailers,
whereas they will for xfs_scrub@ failures.  Fix this by emitting C-T-E
and C-T headers so that mailers will see this as 8-bit encoded utf8.

One could argue that the choice of utf8 is actually system-dependent and
ought to added by the MTA, etc. but I suspect that 99.9% of Linux
systems out there are using utf8 and not some other legacy encoding.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: e040916f649f71 ("xfs_scrub_all: failure reporting for the xfs_scrub_all job")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_fail.in |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index 089b438f03c018..7893e208027483 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -47,6 +47,8 @@ fail_mail() {
 To: ${recipient}
 From: <${service}@${hostname}>
 Subject: ${service} failure
+Content-Transfer-Encoding: 8bit
+Content-Type: text/plain; charset=UTF-8
 
 So sorry, the automatic ${service} on ${hostname} failed.
 

