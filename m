Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C32305693;
	Wed,  2 Sep 2026 05:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327769; cv=none; b=dMs7yCE+qsCPXHzn7/qzVpf/caBi6v6P7/sVDTVR2WdpMa0AkgpZtbKmzVu2e4Nf0XmTb21Czsh2Xilnc3vmV3VOI4HA8+UHu0J6b6ZI93vvM0PapANWSMFPCxXB8Oj4n3+L7822YL+sV+FAJePtrgltPo/QUhPV6I9ELtXMsiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327769; c=relaxed/simple;
	bh=Mf5SR6UBvqeE1g7nm3z7CdCVXSK9Aq+dr3EgtWdnj8s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TMZQTNM2RyyTHAGY16eh4S4+AO9Z9F7TzRBJwIMOdldRc6EJY4fiavTdG2GgFRi68A8RF//qUQjHOgy84/PlarKbGBTI5HK2hmM2SWDWm0AQbgMtBG6swAOGTVY3HubDJHHmXvzPAwe9kn2I6FDtj4goQOCKBgLVKnUEGlSlyr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRfUkaaT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRfUkaaT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ADF0A1F000E9;
	Wed,  2 Sep 2026 05:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327767;
	bh=mQOKEn4at3Fszvmjg3XM42GVpHYzqbPeDF/YKv6zGe4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BRfUkaaTImgSjRuSHmZ1bX+bCddh5+2kRvHYsuNgC/82B8BfAi2t/Mm9F6rY0Qt8L
	 wlBzPtsgrMEu1SMeHkwQbgzWC2XWDQgk7W3CLv2202btWYyA1tbdzanHB/hdR5AzQn
	 GsFJJoLlnclCNHG8DKMBsWNRqEw1QirzBYWnIrFnf22/uR6AmVKfPh5rMxZNyg1l3F
	 Tok9X8Uv3jUvRVDrS98+ZVmmM8uXCGjc95tKegk75CZzUQTI0S5fVAoS0T2ltZ2jAo
	 AQ8+VGA5jbSGsBG+SSQLVjSFY/49J6HuAjpRuc/NhGOiWiLgQSEBOG6cmlNk109nmc
	 MrzA0JUfU9ysQ==
Date: Tue, 01 Sep 2026 22:42:47 -0700
Subject: [PATCH 4/6] xfs: don't leak dqacct if rhashtable insertion fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749094.3506928.325770266119312865.stgit@frogsfrogsfrogs>
In-Reply-To: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
References: <178832748977.3506928.16933046913052359243.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that xqcheck_mod_live_ino_dqtrx doesn't free the newly
allocated dqa object if rhashtable insertion fails.  Fix this leak.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 200491875ce144 ("xfs: track quota updates during live quotacheck")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c199d128538e55..c32030a0544065 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -263,8 +263,10 @@ xqcheck_mod_live_ino_dqtrx(
 		dqa->tx_id = p->tx_id;
 		error = rhashtable_insert_fast(&xqc->shadow_dquot_acct,
 				&dqa->hash, xqcheck_dqacct_hash_params);
-		if (error)
+		if (error) {
+			kfree(dqa);
 			goto out_abort;
+		}
 	}
 
 	/* Find the shadow dqtrx (or an empty slot) here. */

