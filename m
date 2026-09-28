Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEBD38F624;
	Mon, 28 Sep 2026 06:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576245; cv=none; b=fzRxi62Gjpkce2w/70v2m8HIFZ/9FQw509OslL9qKEQBqHDwJHeCWGu0QkWnk4bhDkKV9XAKdEdrzwQJ/CtFyU/gATEMMRPA9wIRjyCPN9G2OC+CYVd1b+d2uSnznqWS57KOXUvWfLwIQVDn1cjJb5EZrNghOYVpY+6XCZGVNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576245; c=relaxed/simple;
	bh=W9YVJ94J0CKVLTLTqyD54EgDG/faVmrFQsOvqXeGsUU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Na652vq5r/P0He9av+ewVsHS1TrwNuQA5DUuxfClQhSow+TPzLCOUOFIVDZhFpMWpHYMop1P5zKdMvKexdLcxYch2Yjj4m0zS1wThwGeh3yTnSjglTiRn7Lxo4Lm6Xthyu/lqxWvm4qAy8VlRvLOX2IclDO/f9bX4dn8oEzgB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+uxjJwo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+uxjJwo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 771031F000FF;
	Mon, 28 Sep 2026 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576243;
	bh=eTLgj3UIr3aLXfP81BZoCWFkRCetcyJnxz41OfFzAh4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S+uxjJwobvDY90W+yFgJgbl2ofF35ftqWK6v9Lgx1I3HEAoo9nBrcxKQJd6Su8yrG
	 J4NZlOFzZ1m30flWOmVvRor1418H7B8zO3HdC6uIRKJym+APVB9z/Hz504l4p8FSKr
	 lThKdUj5QwrNergFYyjBbfzwOJ3WoBF90ottkixt2lWYq0rrLdPAD/eLPTOn26VAtJ
	 wVK0nsyYGvfKbzwIJrgOPz9FLnmjIZ7zYM9ozJvPMhSBCrtXHM93QeXsOMVkNMp21b
	 w+tZyn1DjouJFeFIdJulZ4iBcB8uoSzTH3AbxG8/+0Wpb1Lb+zQgHKD6j1GIW0qD91
	 OkrNqyhm4vn+A==
Date: Sun, 27 Sep 2026 23:17:23 -0700
Subject: [PATCH 06/12] xfs: don't repair fs summary counters with garbage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612724.479634.10486546764392701308.stgit@frogsfrogsfrogs>
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

LOLLM noticed that if we scan the filesystem and come up with totally
garbage numbers for the summary counters, we don't actually mark the
scan incomplete.  Because we don't do this, repair can install the
garbage values into the filesystem, making things worse.  Don't do that.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index cd96393a9e6fcf..b3fb1b4227659d 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -368,8 +368,10 @@ xchk_fscount_aggregate_agcounts(
 	/* Bail out if the values we compute are totally nonsense. */
 	if (fsc->icount < fsc->icount_min || fsc->icount > fsc->icount_max ||
 	    fsc->fdblocks > mp->m_sb.sb_dblocks ||
-	    fsc->ifree > fsc->icount_max)
+	    fsc->ifree > fsc->icount_max) {
+		xchk_set_incomplete(sc);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If ifree > icount then we probably had some perturbation in the

