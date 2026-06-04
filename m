Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9364B3D6CAA
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553140; cv=none; b=CF8uiLJlXnpSkx6NgQlAGGucV7KKRFh8yJZboLirETLbiK5e5dX5uEZtMBj8gXcHyV2yVCitZkr+PIME8AH3xxoMNhLdUGT4t9l7xFfVKXUPGznpmftZzmI7JVRcbfN+1lEr609NGzskpRcHQDTlgwXc18aBBZPZLFhvkP2Tkxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553140; c=relaxed/simple;
	bh=BD5Fc2EqJtKrnj8py2/4f+cz+ZFsVwYz4AxBk73Gkio=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b6hE2BZK9rLgFDlpbkdy8GMs5hvbQPa9db2AYEgO9DBONLhmnSXgPawA8paWIloOTn9XbcuBR7v0pjv3Tw57Q5mA6R6v0Y/7msX0e/L8HztbbB+z9Ibnj2XEXngFFkp52iS26+Qvt58VYgzv0h1MrCdBgsiQ68y7yK0m1keW3yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiPiNCjh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiPiNCjh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 286EC1F00893;
	Thu,  4 Jun 2026 06:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553139;
	bh=TsbVwWj8sz9AzexX5D6PqfFotDph/cu6fEjsKYBxDL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LiPiNCjhY65avcTKe9b6u5+gIRKtLj3pHJGVNabFo/T4Uy2wb16FjPTY510hWsBWF
	 cyHR1u/R+EwuXR5RkXpFQLalNvpDdK7Gm89H2p7dqMd4YElgrRazrCZ7OG+1c93oKH
	 CG3XITdS40l4nk2xLcHPgLxE8m+6miSPYSlEIaqsUfBm0pdBvfOz4gs6YivrX3hmgS
	 WzbMRop6GP50jb+lub9fMlE76HALcHmea5V/pBNYbON7ymIlYQR6H5/HvSoABlU3Rt
	 4ff1ZfGqeTRkqELUaWIJnMYDYwoACjslv2/1xXXLIe7om94a22YzDw4g9+wX93LWVU
	 xfZKbzReaiQeQ==
Date: Wed, 03 Jun 2026 23:05:38 -0700
Subject: [PATCH 05/21] xfs_scrub: fix uninitialized variable
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303201.2608728.9617306419340909584.stgit@frogsfrogsfrogs>
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

If the action list is empty, we'll return random stack garbage because
we never set ret.  Found by Codex.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: a18f915ce76bc8 ("xfs_scrub: use repair_item to direct repair activities")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index b2c4232fe8cea1..c3a8b3179600a6 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -719,7 +719,7 @@ action_list_process(
 {
 	struct action_item		*aitem;
 	struct action_item		*n;
-	int				ret;
+	int				ret = 0;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
 		if (scrub_excessive_errors(ctx))

