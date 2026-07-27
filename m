Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587F3233723;
	Mon, 27 Jul 2026 05:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129952; cv=none; b=NfuY4DuWsNCFGO39itykPHjGJjErP35w6mgefMUcvLZRIKXfYaHepdDl8idA/UCTg3mirQUFFDB8yuAey8d2Fpe6kMQoNUO26srYxtuDjwaIgcJl+vsqyK6JcNYS9CBf7jsWE6SlYSpw1B8OV8vlr88fCXcJ0kI/VJxsP6muyvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129952; c=relaxed/simple;
	bh=zJP02KU+8yXmhWCs+lkj5O65KxUucut/ENBVPA8kLGs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejisxDoQzMkmdyjtJzP5zEOsWgfai8mdcsp9+UOKowXy1wGymkv0S39IhnzRixRU8AmjlIoFdeGoLbYPHb+LflGMqHfLaRGw4A8dWnjEmzF1az46n6Xz8lDDpRTwiW1MyBy2cUlIfESbTMLO8FhPH4e/lFdZf8M0pT9rvPUkK78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yk3QGSdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yk3QGSdY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 313641F000E9;
	Mon, 27 Jul 2026 05:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129951;
	bh=xhbZkpcI9Y8tPJaBGPfad4SMI/GkiHBPLryXbkBjIxI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Yk3QGSdY2wFaKzlKygaP48dlvugTioU4hdYp1DVmier89wL8h8oSSkA2zSeAarwMX
	 99wQfEMzAH63a5/NAu/AGEjL8lWa29cylzWbXUHc5WvkXQQi0KKIm+JSen6Wf87LWO
	 ScalEPLz8UaTOwiaLww0DneEI0NH3NJTuvhM+r4Dm3JpyJ4eNwQTAzrjE+2yjWMwcD
	 BT+KwsHBgKilFBqaIXm/PQz7Ymk+D+mJDWzObIFX5p2E3vR9qcXCkz8Gln1KseATI9
	 A2lgB/EISx5SHJMK/6tEA8yN3zUp5j7CHtxJwHv+w8oKvDyLceNdbKpCBYKW8fo0ZD
	 AIJ616LKUJq4A==
Date: Sun, 26 Jul 2026 22:25:50 -0700
Subject: [PATCH 06/10] xfs: check xfarray iteration errors when committing
 unlinked inode lists
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389723.1495075.5558406938676258391.stgit@frogsfrogsfrogs>
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

LOLLM noticed that we neglect to check for xfarray_iter itself returning
errors when writing a new AGI.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

