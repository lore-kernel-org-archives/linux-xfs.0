Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA91F128823
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423376; cv=none; b=LlyvrJ/UKpMA05S2sSLmmH2Zik1xZt4NvB7klYt9PACdoQAlDH7huJ9HLr9kS+UDbaKFMVJFFkvEirEUpfaN7Sgz1RBvI+gVvpyKRDPQx9dJYdXOvmkjLYLb5tfu0bwKcMAkJzmUIiLNKnY6sb+TbPOeY/+jvphq9U9GAH/yxYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423376; c=relaxed/simple;
	bh=QTwu6rbirZl2RO7EH3iwjhlJMpbBn/qhLjV71cT6WkY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FKF+n3w+XZyfffuVrHz3edyc4nuIko3cXFGzpPFvK7H/PeabZE0uySZtYzDfsKIq9YVADzjXR0UsvNTox2MQOcgqikacvN8wZRbWmxgcfro9Zi71TB0YSpMU+bVRGz4tjSoKa7GDxW75xqX2CyjTPthVOWoIMaR6AhXNenWpo3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQANNGud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQANNGud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4118FC433C7;
	Tue, 26 Mar 2024 03:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423376;
	bh=QTwu6rbirZl2RO7EH3iwjhlJMpbBn/qhLjV71cT6WkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EQANNGudzcvIsqauLrHCeO6+4gSQER1sGVOqHBJTpg8c1Hc+8KiItdFMpROb50Gyj
	 y3X7478GKUAyd8yBpzZtNO7Pqkq+m/H41if2E6racSEcFXQ5POza26rQ7Tm6fvhwUP
	 gfRZiBC+gAm6p8q0lyz/y4D/8lhRqh+M7cVddFit23J2kCFGoFMXjgGjHluyFWZ3Q9
	 4QjHlFcFDEPUME1B5pKfrgbrlRPzhpJrjc8xAgpP7SOPr09ctTrN41XjQ6eLNdvMSL
	 qv/e1VqTB+byMqT6wz7E+6TrRIu4KSkDCCjWUz1w0KDFSPdtkMKFL5Jno0qBgOBa+8
	 jw0+LlaKYWqKQ==
Date: Mon, 25 Mar 2024 20:22:55 -0700
Subject: [PATCH 3/5] libxfs: remove the S_ISREG check from blkid_get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142128988.2214261.15871735846568125579.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
References: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The only caller already performs the exact same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    9 ---------
 1 file changed, 9 deletions(-)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 63f0b96a56d0..706eed022767 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -178,15 +178,6 @@ blkid_get_topology(
 {
 	blkid_topology tp;
 	blkid_probe pr;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)

