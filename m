Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BD6361DA7;
	Wed, 23 Sep 2026 06:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143423; cv=none; b=Q0ZN42/sA7DEtXfWcaAHVkF5DdtoaN4sxOnDb+DQ6O/nqqENPcQxEUEDm3zI3sNR4QPCqZAkas+ap/yuvWJaplbEPx541Q8bixG2lPNUeUjEZ8A8dhJjQJrGj9tRcTA1Ya4Lwx4R2ItlvbNZ5VsyKAEq+jYYYG/nq3fEaRokqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143423; c=relaxed/simple;
	bh=Beem9XbnbCtNmmph6kw/GOjuLc0Y0jHoQ6OmTBP+ZgQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Za29ftk+hIG/zX3QEemrUAbrauVNNq/peTzHtG/7mRJdQ4sIftL+cI3Xc+TV2MH8qux8H4yqcbPTdPBX1R9SppBWRNMICuN2Pe2iGJ/hMpNch24e7WlprBESCzYOXXU9GkjgNBUz6lpCsh9HCy/sYj+E4ZiAAJ7lD1MqYUwYoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zlo4jcEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zlo4jcEt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 107F11F0089A;
	Wed, 23 Sep 2026 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143417;
	bh=yzCEMFi8VfTHopUidWs1rcyrc44Ch1zUARO8qCIvkPY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Zlo4jcEtrHt8hsjci3VKxqPsHs4PMBXxu5duKChlsWOUWq4OHF3vNH9ONYkkNgtuW
	 ea/BKuJvVW9RhsuoWA1B9YVO2WOk3nwpE0f8Lm0b77FPP/24EiM07/uP70NjhDXqi+
	 har0FARy+XIky86ivqFriRFOjqUDbDW1UyIIzaIJfPqdVNtzY+RP5K82ei882c2EdJ
	 dsOswvVgTadUf4pAnnv1DdViJuDDk7k1n7yZoWsj95TQTkbCXRwLs2MhTKIFDjVcp1
	 2mQHSDexz4fMvBxLZUCkGUHwvCZL1ZMYoK67xAmkiShPbMhtKd11RLszCOdj3f20gt
	 +aIBud9WmD6uA==
Date: Tue, 22 Sep 2026 23:03:36 -0700
Subject: [PATCH 11/12] xfs: actually lock the metafile reservation when
 adjusting after repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159777.1875436.9839611902429627901.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM reported that xrep_reset_metafile_resv performs unlocked loads
and stores to the metadata file space reservation counters and thus can
race with other threads.  Fix this by taking the lock.

Cc: <hch@lst.de>
Cc: <stable@vger.kernel.org> # v6.15
Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/repair.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c2a437416227a8..956aa75218aa24 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1377,12 +1377,14 @@ xrep_reset_metafile_resv(
 {
 	struct xfs_mount	*mp = sc->mp;
 	int64_t			delta;
-	int			error;
+	int			error = 0;
+
+	mutex_lock(&mp->m_metafile_resv_lock);
 
 	delta = mp->m_metafile_resv_used + mp->m_metafile_resv_avail -
 		mp->m_metafile_resv_target;
 	if (delta == 0)
-		return 0;
+		goto out_resv_lock;
 
 	/*
 	 * Too many blocks have been reserved, transfer some from the incore
@@ -1398,7 +1400,7 @@ xrep_reset_metafile_resv(
 			mp->m_metafile_resv_avail -= give_back;
 		}
 
-		return 0;
+		goto out_resv_lock;
 	}
 
 	/*
@@ -1412,14 +1414,18 @@ xrep_reset_metafile_resv(
 		if (delta == 0) {
 			xfs_warn(sc->mp,
 "Insufficient free space to reset metabtree reservation after repair.");
-			return 0;
+			error = 0;
+			goto out_resv_lock;
 		}
 		error = xfs_dec_fdblocks(mp, delta, true);
 	}
 	if (error)
-		return error;
+		goto out_resv_lock;
 
 	xfs_mod_sb_delalloc(mp, delta);
 	mp->m_metafile_resv_avail += delta;
-	return 0;
+
+out_resv_lock:
+	mutex_unlock(&mp->m_metafile_resv_lock);
+	return error;
 }

