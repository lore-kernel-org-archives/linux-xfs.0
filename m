Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A703D1AB5;
	Thu, 13 Aug 2026 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598698; cv=none; b=iG8e2GEI6fz3mSUnARTmfxDdHg0SLxSEFJO2mnjnSkDLt2LYepaTwxxEWs+SDYZPTNucQ0z764oK5hu370V60LpIVqkBbNydbMok+v8WfikBc8QvoiP1qjib4GTTsyurFdKnB51cJs+zyGILSS8O05lpC780nBVcCwFHtAcupl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598698; c=relaxed/simple;
	bh=Mf5SR6UBvqeE1g7nm3z7CdCVXSK9Aq+dr3EgtWdnj8s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c5HjEzsy9baPsUto7Ai2b6Io71B/8mlY5weBcAkTjf2Qw1YHdm374V6BBxkoYZadnJO1kUhCBiOr5ssTF3+bO53oiL+qc7aLO6rvKQ63Y9Drv7t7HVNF4Pvys3ZbY5UaVjViVonwKtCUPOB0+Et+Q+RBNnDr8w0ah3nv3im1Cg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdLUH2EN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdLUH2EN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 72DF91F000E9;
	Thu, 13 Aug 2026 05:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598694;
	bh=mQOKEn4at3Fszvmjg3XM42GVpHYzqbPeDF/YKv6zGe4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jdLUH2EN/+QxNc9iHqyNLuJlowrjWQHZxmMQmq0MD6KW3gYQxNzQyk5yMUxqgyvz0
	 FzwesblBvg9MMuJMK6OazV8MjWHFGUxpkNaDqwnVg0XFkDChqwIoLhq+V1W0POBj4G
	 et9lVUfJhsDqlNS/pv6JYjUqhcLs+GbrXnudS/miNMDXY3FKDHWM5JHG95jqNJmcqF
	 a2VudU3S2cdI6wvfTRkYegdg2kKHLMDCjEJJOPvDPCwd8/mhV8E2KjYOPz29tC9Mor
	 ddty1Ciywui2izvtTJvlxK+jcZ9Z4GBIHHJ2Zvk4bhdNK3GdY+ZrDJHAKC4fT0YH6R
	 +n59d9HrMN+7Q==
Date: Wed, 12 Aug 2026 22:24:54 -0700
Subject: [PATCH 4/6] xfs: don't leak dqacct if rhashtable insertion fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861549.833642.4329592684062612986.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
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

