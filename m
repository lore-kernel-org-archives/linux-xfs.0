Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401A437C903;
	Wed,  9 Sep 2026 06:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933939; cv=none; b=M2tayncgC32Qr9g2Y/9nA7qJsWdxrPn1snjX/kGWGKhqewvojdFxGFF6PyFXx1YT97XTg8mqY02ocYQH3uOIaGchpq/LPbiz4LJrbcJuWvrZHQiS69goFmLnaelq5nZME0MQ+CpjuGWi6iezL6XOxV0StvMS9jSIitKWfIsVpKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933939; c=relaxed/simple;
	bh=gEBBeVXBFskDUv04NOfHXH0PkuMbx1vWPsEEIEbqlLg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k4Z1HSGPYrDbOAjuXatKMgJvZMX9je11uB9UqJvVrUOu79pNmD9yKEDrpo/V7+Kdq5RH0kASnHQFm7wiGjgaeedjA+V+2NaEioXrsZu2si9mHBfxxsHAx6k3glibOrBrxulRZNP/NTy1NJuQwyK/52oCbIo7tqWbLiVKm/RbI4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6h1t29+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6h1t29+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD1B31F00A3A;
	Wed,  9 Sep 2026 06:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933937;
	bh=EkW4Smvfodx25QG8TRp/T8o9nefiCqUGmbhCtRmSPq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=H6h1t29+15eYreHNRloMIiwY55UN5ge/7yqE1sgu3r9LmKFKGIfwNWIbcoOKV3PFk
	 BqbQKkk4QgNV5Iu+XGsl66XrexNHjYOl3CmRj5kSB/nm3FKo0Inysi/c8+usBWuqKH
	 OMNTv2L9NuybtCuGQDaPrYct2e+emWOWNDaE1kWHTQSxkLENjyqFDxDJButjBC8OW5
	 r/nZ1EXdX+l4p3wvUf4hifQNVYt6KxKlm/a6DkN/dmrW+/DFgsESyDCajxpHPixcUt
	 6uHB9rrKrd7v+O0spFSjGUEZ1R8K7xqCySWoawevzj4znc3jtDLPYxh8ALihOa6fQY
	 co2SdB3lOTe8w==
Date: Tue, 08 Sep 2026 23:05:37 -0700
Subject: [PATCH 5/7] xfs: fix replaying dirent removals into the temporary
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936728.4057962.9945119784451295166.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xrep_dir_replay_removename is the function that replays a directory
entry removal from sc->ip into the temporary directory so that when we
swap the contents of sc->tempip and sc->ip, the directory is correct.
LOLLM noticed that we were passing the wrong inode pointer into
xrep_dir_init_args.  It doesn't make sense to set rd->args.dp to
rd->args.dp so let's fix this.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 0a3d02d8f04153..82ec5cfad63c59 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -727,7 +727,7 @@ xrep_dir_replay_removename(
 	const struct xfs_name	*name,
 	xfs_extlen_t		total)
 {
-	struct xfs_inode	*dp = rd->args.dp;
+	struct xfs_inode	*dp = rd->sc->tempip;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 

