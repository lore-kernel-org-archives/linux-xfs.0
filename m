Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520B31F9BC;
	Mon, 27 Jul 2026 05:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129999; cv=none; b=cZfioteWMG1KpP9XgZ9+5SBW95Vh9MAL2zItbGzfMgpKxiTIMCoEkUQzIx5ZNB2fG4f6pPSD/0G4F9WMtUKiL4V/MLEuq/F4iVWv7pbuDvYTYqHwG8Ra59zrDQ6EkiTBpVYjTfphJT+VXdSzpFLpHUy+ZuX+kuK14bShcCDCo9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129999; c=relaxed/simple;
	bh=28hQ+3G6pN5d3YqM1LOIDd3LSlMbjSNYMgdSgFDRk2w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjaQ5Nen2RVPoqSxA5YNk516Bs22AE/3zq0h3X4o4CNrUlqh606ZYI4VgThydS/MLHde66S7zkpvu51HoT9/iDUFdDEMOTvBUsekyxf14YMluXPcCsXK8dSlntFy9+mVuiuFbyTu3FwIb2BTqpG+jJwBn2oMLe3R3cTR1zHsxLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vhz4jkJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vhz4jkJg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B7F5B1F000E9;
	Mon, 27 Jul 2026 05:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129997;
	bh=6CIE/JQXHBwhHneaS6Y7f+WYXIw2Iin8Rd/W4+mF4kY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Vhz4jkJgCrOn1EUx0c+Epno7O1WxlvFPzBjWrByoxeEpYc4lY8jwSGCZnZ2Iod9gs
	 Pzas4k2irhnqQyEENqYbkSqFHg+13kPv5TIK68rMirRWiaw1CFPi/UkVcgOg1f3w0X
	 ld29WFl8uWVKqCggNcxPwTPqvHPVFNZw4GkvR7tHD8Tn3sTogvRNMEUEOleW74+H7R
	 jRT5xDPRIi7FM+xxU4+Ep5n3p0j3K775ABvmKsD66R2tyIv3zb8G3ML9PIVFybSLH8
	 f+aXSlI0nqs2ym67Cq3ENcwL9GO5FfKZaiJUkoy1jM66VeEE5iz5qeokewlDu20Zmm
	 dj5rqGzPEx1gw==
Date: Sun, 26 Jul 2026 22:26:37 -0700
Subject: [PATCH 09/10] xfs: set the prev pointer when reinserting an inode on
 the unlinked list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389787.1495075.6471218385775739202.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we find a rogue free inode and decide to reinsert it into the
unlinked list, we need to set the prev pointer to NULLAGINO so that the
incore list gets updated.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 65b9a8befce99b..4f1f235349c5a3 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1504,6 +1504,10 @@ xrep_iunlink_add_to_bucket(
 	if (error)
 		return error;
 
+	error = xrep_iunlink_store_prev(ragi, agino, NULLAGINO);
+	if (error)
+		return error;
+
 	/* Remember the head inode's previous pointer. */
 	if (current_head != NULLAGINO) {
 		error = xrep_iunlink_store_prev(ragi, current_head, agino);

