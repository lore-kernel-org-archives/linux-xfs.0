Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB3D78F26;
	Tue, 21 Jul 2026 03:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604384; cv=none; b=uGkn1+7111t42isbuv08Bh6oeWnVSQR6IL082x9STYKHZfQC/8tb9opxniaTstMIaB2NmrTKxrrpzMUvWrZMueyTotxj3cD8rxxCbC81ItK2oxhMgAcEGDLAbtULBtHsws6zfBPAyMWGcL8nDYhMDwhWLOj/YeWLjZ2KQVTamBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604384; c=relaxed/simple;
	bh=GsvXTTRVikVTHJdceg0/gdZ+dS22qkpLXwGSXebYmEE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbUekhpbLJqONVYH6NMRi13WpyIlIji526M12yJfk4tVeuTm1Zpy3fktAgdvHl2jI3ACowMefkYUCSIH7wUCNs7DtyXsZht7yI8gCl52rxAU1hXMojCBNWVy+IkUL6Lqdn/6Ps7+GcDA9XCfFJiRUqXnW5P/BpzijDUytWuOTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbMy9L+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbMy9L+l"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EA7311F000E9;
	Tue, 21 Jul 2026 03:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604383;
	bh=eyh/jjWjzRB3SSvJmm7f73C8iwm6qN2MCmJcudIUtag=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CbMy9L+l3lHhKXlgD9HQ3sleU4lVFkP5Opizmi05LGurZLOHo/oogPu7GLEouKe/U
	 5k7G6nzqYAo4Ho+jdOW4+N1gsLKeZ3ThK99z2Jbm411AIZyGTqlLwPbqovFx22pkTM
	 bgnk+zTJUoDZTX2scHSMXxU6qS2cDV+FPcNYGYThYbkQoLagJhHF1UD1CbPIzR3Wl7
	 pt+lG1gac4hVEUujbfnMZYFmTRTjNMrU3ydtbsHl8IL97JlqdvBzLhDdCkvWITghBx
	 o/mIvum1YAPDaFt22rf+kHoFZajWpSp3iSudoX21FI6xNyGEoMQWaVOSTMqMJOWKel
	 IyVHGoJTr5z0g==
Date: Mon, 20 Jul 2026 20:26:22 -0700
Subject: [PATCH 6/9] xfs: check xfarray iteration errors when committing
 unlinked inode lists
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178460419616.830862.9734210711949892226.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we neglect to check for xfarray_iter itself returning
errors when writing a new AGI.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7f19554843038d..8514d2d7e3cea3 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1675,6 +1675,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Fix all the back links */
 	idx = XFARRAY_CURSOR_INIT;
@@ -1683,6 +1685,8 @@ xrep_iunlink_commit(
 		if (error)
 			return error;
 	}
+	if (error < 0)
+		return error;
 
 	/* Copy the staged iunlink buckets to the new AGI. */
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {

