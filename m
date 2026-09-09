Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ADD25C6EE;
	Wed,  9 Sep 2026 06:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933954; cv=none; b=Bt9CXVnVGU9W0ahJzRJUBuj/9IjAHKUt3LyJRsLP3X7BGfMMtYO6O4lEyWVNqK5bMwiRv8FeTMDeJbUkuOQiK68aD33XFGI1ZzTreKSpQUawZ3AYsYua0tdAsysmSFprgD06ce8+cgXU6DcUj2LQ72p0/jxfIuLOZ0LuiNQNQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933954; c=relaxed/simple;
	bh=t9QmQVupWe7Q2CKtOyO2a3NUgDr8RNizsvPPuFomu60=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fmPM5LcnCeA/B4wT2kvstjrmOw19nI2Vv1tR68viw0y4ZiUx+ZdGeMh4ODK534L31hp1KvJZMNhxbsfOGa4axTZVKfSwd3XOMS/DJsiUVrCrrIaXrJ9VnqNe+5efueDgupL2Mb2yY+js1gWY5Sm+AHpb4FtEy3izuUVUHESp8hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cePzWyyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cePzWyyY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 490BF1F00A3A;
	Wed,  9 Sep 2026 06:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933953;
	bh=rtyudFbjvNS9UGYtwfZYKu8fO1gAcL6ecHMoXLm9+Lk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=cePzWyyYsZ2zcZWbEIvGY31JDy3ZxWMKpCY7Qnsa3/CHkoC9j2/FGahXzf/IWHzQv
	 tS9KXyxRn1ZcpB6fUy95Bkb2bBY1s+ncNzsxzq1hzwUkR9xH4Ecq6cY9CyTQTtbT1u
	 /3iBzHdbvNfDW93ElZHPP2EENVGDgsokmoZ5OUtYpvLG7cPauAWkbSnt5G88nZzGig
	 ZNtwM1j2DQ2zdXRkXEZIyL1ASJPOwpv5Za0Sn/25mbiw3ElYc9KjV8kzNQVN1khso9
	 hYfQYDMyd/PBNK9jeyqeV19TTUcR01Sa5VKxoC3v7iSyunZOE64RPXmP5BfwfQI8cQ
	 jrNrjedtUq0KA==
Date: Tue, 08 Sep 2026 23:05:52 -0700
Subject: [PATCH 6/7] xfs: reset parent pointer args before each dir tree
 unlink repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936749.4057962.1251607208695971705.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xfs_parent_removename only partially initializes the
passed-in parent pointer arguments object.  In the directory tree repair
code, we could decide to remove multiple links to a file, so we don't
want state from one call to bleed into the next one.  Zero the whole
thing explicitly.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 8acd55b8c7696d..1d1eafcf6eb598 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -479,6 +479,7 @@ xrep_dirtree_unlink(
 	}
 
 	if (xfs_has_parent(sc->mp)) {
+		memset(&dl->ppargs, 0, sizeof(dl->ppargs));
 		error = xfs_parent_removename(sc->tp, &dl->ppargs, dp,
 				&dl->xname, sc->ip);
 		if (error)

