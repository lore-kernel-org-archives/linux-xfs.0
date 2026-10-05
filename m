Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3530EF91;
	Mon,  5 Oct 2026 05:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179750; cv=none; b=oRUHd1aWmmPWGNO3TLqmGYFzJrPM4u1BLG6uCXb3ILHxKLHbVjJxYOjaHoZbGVv9AAFIGJApbzFN7VGKwpIBxHaUV4xUJJYjIew/xIdZwO2EwYZy4hkknxgyzUqzsunkMqe4acFHvwGgZew4lieY8RDDrUAzVl+DiHVWNBkTytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179750; c=relaxed/simple;
	bh=I3QMhEBcJJDuclwgCSTqv164CU6U/SABcQji2hE5nNU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5yOfGAeuc4D5VOTgbE8BhBOiB6iZcuBMvUU4htnTds2+QI9/B7zksh4m1cJyVJn59KAkHRhH8ffadC0VtBQN8gkuuJH52Ns1M1GvDDp9ZWHPSetmBuoNhHMm3jsluQE3KfmwC7hP9TIMRCkXsIuYSFOjhZMXD+QY3GMrP3y0qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhvpLci1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhvpLci1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39ECC1F00893;
	Mon,  5 Oct 2026 05:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179749;
	bh=75uG3+W2fjxPWpdayjiPTzjb1AuV+4mqyYXhJ0SvyGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=fhvpLci16r7n1VwcHJFqi7PtWZBdcn+v/GyACP2B2FjT/e8E/S/kR0ySoVkjaeE2O
	 DRkCtQSgrBIH77ZNiA42K/eKkxof2e13iQj/AAigWitrp+ylwqdbI6e0Ab8rSPY5KC
	 A1GQNEhBvXKjO/BkIi4Xyee5kbpoeYt4PXg2tffntJUfseJm/nbIfBL2Vc8QWfIMWe
	 xW8Y6Zu3ZFu0B87ndvf+UF2uVlZcxFkn3BBb5AUZ7yk+SZcp8w3WgtYcLqw87F9qnk
	 8mZHq0AuFv7NtXsnGiPf6yYbAPjCdQaCsks8t/56fIOOGw0gYINfERyH/8S/q3QyP9
	 nyNmWOrMPAkqg==
Date: Sun, 04 Oct 2026 22:55:48 -0700
Subject: [PATCH 02/12] xfs: zero out di_metatype when removing the metadir
 file iflag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965051.614350.759924722702194200.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM pointed out that we should zero di_metatype (fka di_onlink) when
we're clearing the METADIR inode flag because the file is no longer a
metadata file.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 7297fd0bebbd70 ("xfs: enforce metadata inode flag")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index b047abd28bd341..5ecccc75af2500 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -579,8 +579,10 @@ xrep_dinode_flags(
 
 		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
 				flags2);
-		if (fa)
+		if (fa) {
 			flags2 &= ~XFS_DIFLAG2_METADATA;
+			dip->di_metatype = cpu_to_be16(XFS_METAFILE_UNKNOWN);
+		}
 	}
 
 	dip->di_flags = cpu_to_be16(flags);

