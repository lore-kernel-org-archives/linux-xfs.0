Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241D5286289
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739938131; cv=none; b=lPDUqNA/rmyiQWBL7YiGblS2WbyVoHK873x0aSHCX7YZmPOqrMNr3WhlsVhqhYFcKzKeSSljK8h5juxh0GFJIHc+sDleprmXrtpq4g5jJLrPXjsucLQVLVIc8a34PaoxXH9B4Ih66MRBwCyZbz9RVt8TzbQUk9ZpOsR2rVrX8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739938131; c=relaxed/simple;
	bh=GHjRotfsGseaOEoa/T5CsZo38sSYm2aOLHoM679ZRLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fr5omIEDkrN24Lw3tYmzl2oRx4gnF96PBoUF1+IJl99i4LvE+2OiGlppXr4VAmDRiNMS7q5JlUUHi7HrdGL4rs0W+o3Ob3553r024zrmpxOG1FNRXgbrmmDnqP02f9C9cSHOYivovH5f9fANzK81E1f6/83dEFFGH6BZdAzeGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjtEsOKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjtEsOKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93235C4CED1;
	Wed, 19 Feb 2025 04:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739938130;
	bh=GHjRotfsGseaOEoa/T5CsZo38sSYm2aOLHoM679ZRLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PjtEsOKepA/26eUa16h03dOv6Gjpw6AWmRs9GwCdJTwZaUdE+OmJbPhMSr0ud5T6L
	 6mt7eVPsDp0oorbrgGoC6jT2XsU9ClRW7YpzWfISf9y9a3iWAHwWC8KKHcL+I5ao+V
	 Jtz7ME+ugnLBfR5PH2iHPy0hlGWv/vvwUSHl1FqjoDb1mqCbvb64GsftGKslaJTrTB
	 0SlDN9plRX8dUzdizVEdAZGANcQTtlj4iekHeI9tsdP10zoWgQ08h4qstBDX6/3Kui
	 k81Uk0jDRwGSqdLJdviMYwRWs0eVLymnrJ/yMhqUKtpV5BDkYsWtJF85ldxZiAPQ7Y
	 8U9LtjAgkTxFA==
Date: Tue, 18 Feb 2025 20:08:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH 2/2] xfs_db: obfuscate rt superblock label when metadumping
Message-ID: <20250219040849.GM21808@frogsfrogsfrogs>
References: <20250219040813.GL21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219040813.GL21808@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Metadump can obfuscate the filesystem label on all the superblocks on
the data device, so it must perform the same transformation on the
realtime device superblock to avoid leaking information and so that the
mdrestored filesystem is consistent.

Found by running xfs/503 with realtime turned on and a patch to set
labels on common/populated filesystem images.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 6bc20c5edbab51 ("xfs_db: metadump realtime devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/metadump.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/db/metadump.c b/db/metadump.c
index 4f4b4f8a39a551..4d090942bf29cd 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3073,6 +3073,17 @@ copy_rtsb(void)
 		print_warning("cannot read realtime superblock");
 		return !metadump.stop_on_read_error;
 	}
+
+	/* Replace any filesystem label with "L's" */
+	if (metadump.obfuscate) {
+		struct xfs_rtsb	*rtsb = iocur_top->data;
+
+		memset(rtsb->rsb_fname, 'L',
+		       min(strlen((char *)rtsb->rsb_fname),
+				sizeof(rtsb->rsb_fname)));
+		iocur_top->need_crc = 1;
+	}
+
 	error = write_buf(iocur_top);
 	pop_cur();
 
