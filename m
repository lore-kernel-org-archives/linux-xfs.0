Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF9365A1D;
	Mon, 28 Sep 2026 06:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576229; cv=none; b=qGdANNgJ3sX136+ayS7bEbcYyzf4+AFCUJAPFk1LAcjmx2g4EYriQ7EbOUWBowBOGunIUIBHcABsSKPnI1wamH5AiF9dQMJRaQqf7f99e5/T/b41Hk+e8fgF7cM/L+AMpLLTd5rHX66rVxyCv1wRFVyttC+CVg0XhLHr3VM/XrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576229; c=relaxed/simple;
	bh=xC0pd8w4/eLtOxgpb7Xtv5XnlSSkPJDamGkcBMPgLbs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Op5yw2C/jrpOjvFyInWHqbRSaOHam5My8m5JfnVgNzUECVg1UtcJgYnsljm3zJW/d0aayY3+pJvP6GlzwCnfclq6x5O5T3XesAKP/WqvOGGhcsMBQ2YN1tfFRx9dzP7P6Ij7sAkqamQ1+p790fBu5nWzzuWc0cYLPVhHdO2NShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUlDlk+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUlDlk+A"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCBDD1F000FF;
	Mon, 28 Sep 2026 06:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576227;
	bh=cB4zF/tVbThVzBBsaPs6yZ8IEsWpDXAFQdVcXDgqcHE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZUlDlk+AFmbe4dRPFB55ldAgwQ4tqLSwW3olxrbSXLal/b6wQHG7FwbC9pumS8j81
	 nfObhZmg2/LW5nw9fJLbYr8xg1CVhKoBl4PCzGH+hPNabuz9CTXXhm7oavMqCG2B9x
	 idxha3iltWsIoCPhtSMiv+R+0XYoJqcGkDnKuzMrpqtBhxN17W1s360TDYAmLKpTVo
	 J7q/qzw4PnxlhGee7jvNLTnyFHJTHTxILwsMYuO21qF7VhTqg9xaOqLZjJH7JrV17D
	 DdalOElHzSiNCTuiXnHOibdSI9LeB7maJ0gLfdDOq8D6kzYcessFE/OdL+wGvq7O1q
	 6ybJDSW0j9z+g==
Date: Sun, 27 Sep 2026 23:17:07 -0700
Subject: [PATCH 05/12] xfs: fix revalidation of xchk_dquot_iter cached
 mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612703.479634.7305483806642816212.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the purpose of xchk_dquot_iter_revalidate_bmap is to
revalidate the quota file mapping after we've (presumably) done
something to the quota file contents.  However, the "yes this is valid"
code isn't quite strong enough -- the mapping must cover at least the
block at fileoff, not just end after fileoff.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dqiterate.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 079dc4e691a01a..76393c888484ff 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -58,6 +58,7 @@ xchk_dquot_iter_revalidate_bmap(
 	 * no need to reread the bmbt.
 	 */
 	if (cursor->bmap.br_startoff != NULLFILEOFF &&
+	    cursor->bmap.br_startoff <= fileoff &&
 	    cursor->if_seq == ifp->if_seq &&
 	    cursor->bmap.br_startoff + cursor->bmap.br_blockcount > fileoff)
 		return 0;

