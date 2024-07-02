Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8529449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882595; cv=none; b=MleqHbCBBtRjgArLcLq7mnscUBHvCDUIOMX+9NfUavTixTl3bl2SNzc/Uf1axRUh7IYmcZUlEmdtNlwG75gNg4TYK07nicbwYyiE7r5ZGrzC3yjJ4b7qFQERrMYXftAmBvdscWT8GbrDUuXJHxErSC3KWo0n7sXH5tbqsnz9GX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882595; c=relaxed/simple;
	bh=W+ILKeEbpkw5u2f1YFFmq70zutsauHOuMTKgsehggu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZImEJ0QjyP+hOzEdTNV2jrZ6Bapt6Hvq0ov8Gb8I+MAzJBs6hFQ8VOc2igQaBhxnI21LhD/RaTlkSaGJpQ9COsrF21LIX9Sx+KbqJnU8vO8AcW5iVpRcDMJrfs7obQ8lzmGG8JFmGZKB32LpQMl39cDMEMhkI1oWM4aAaweDaCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5sOkeED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5sOkeED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0187BC116B1;
	Tue,  2 Jul 2024 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882595;
	bh=W+ILKeEbpkw5u2f1YFFmq70zutsauHOuMTKgsehggu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M5sOkeEDbu5KDOIA9MSh3j7GUfUvVwgbthLMglqvsSpDNMYPNdDLc0t93LlRSkJeA
	 5Zyq1bBioUsuCTVB7qZe2bGVY23wAyeyITdEhcaxwOIJJH4G/0Vdptk6guY6Dg3/mE
	 vw0CTDQxnwK//nLIoJjTFwlns592i2DpXKx/kiUtgqsRI364/jjHoNdaW+ECOO9MtJ
	 5/+tWcieFc7+qsrN5jRQMTHksM0PDKeMyLYEleBU2EmbPF75qV6ZOE+KwhwyBab/dU
	 gb5yI+B969ZxyYXEp44CYiglB/KtwmrCKYINzFdAjtBdGM6LvzTHCgnMBXRx8lfTM2
	 NkTN53J+o4+Xg==
Date: Mon, 01 Jul 2024 18:09:54 -0700
Subject: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
In-Reply-To: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
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

Now that we're finished building online fsck, enable the periodic
background scrub service by default.  This involves the postinst script
starting the resource management slice and the timer.

No other sub-services need to be enabled or unmasked explicitly.  They
also shouldn't be started or restarted because that might interrupt
background operation unnecessarily.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index 69a79fc67405..c3fbcd26232e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -114,7 +114,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol

