Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB122DC783
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933923; cv=none; b=fHCL7iRGqqrE5lQPuo36PzIDawHIq6VZDNSsaByQ9KmoxzFNbd4vDlkwX0Iflizu0zZi0tAmF14K9Qaqh7aoz8QUTMAmpra/4HDBs3TjkKLgp3rqxq9MFWMgsMnHrB0gVe3jJEbJOp61egIhSvrV1ShpLFEsCd8Cvu/Ej0rDG0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933923; c=relaxed/simple;
	bh=T0tzdtg45U9Y8BC9yI3flgfnuiZNGwMLQaaoWO/aiVs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8zNlcTRFCEwDQra6ju3GzOBIwN9KefqUIIWrqLBaJSngCMkH6PoAEUta8Anhax2g8simKvvaRVKCYEW89oiDYMbUrMJMa7xgdEzYurdwGsf2tlEBXvkJGxpsB5fIPSY2MQSdravYXTo2naSWxHH44isnN8MoALAm7Vv71sy86g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYzv8JdV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYzv8JdV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 087F31F00A3A;
	Wed,  9 Sep 2026 06:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933922;
	bh=REAEBkaYuMl1RX+3t+jW+K1jZCC7H7IaldzBI+vmetw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TYzv8JdVg3FWYDyuNkPH/G9PMWwyMo0iDqpRmoXR75lKNK9hdnbuafhTnVf9Il077
	 yuPeJJkpuEabIF5Y48s8FQHJcXr491Zr69mRH8P2m7l7EfMD0VuQ3bH0yRUPQm77yn
	 qoVPc/sp9w/L55SjlYk6m3yQApSLtX6r73ebUNfSp9qqBqy9Vp8Ez7C1Zd04og5Prc
	 H+AILmAcwhdIdsSLF4qT1iCXCGFV06NYyhDl7WJFfO0midWTLBkTjHgSAryHumU4ms
	 hCD5YPyRcYuZJvlH2hFKTjKYGjXmtIW6cb5cuCCFHdcg4PbdcT62i5any8W8lasT1+
	 VuNWgpl1HdRBQ==
Date: Tue, 08 Sep 2026 23:05:21 -0700
Subject: [PATCH 4/7] xfs: fix termination logic in xchk_bmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892936706.4057962.7423867565222582609.stgit@frogsfrogsfrogs>
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

xchk_should_terminate can turn its @error argument into -EINTR if the
user is sitting on ^C.  Unfortunately, this code here turns that into a
0 return, which isn't quite correct.  LOLLM complains about this, though
I think it's a very minor matter because the only way -EINTR happens is
if there's a fatal signal.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/bmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 3b0f1dbd9147ac..4f3c7f681bd921 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -1103,8 +1103,9 @@ xchk_bmap(
 	 * the rmap must match the combined mapping exactly.
 	 */
 	while (xchk_bmap_iext_iter(&info, &irec)) {
-		if (xchk_should_terminate(sc, &error) ||
-		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			return 0;
 
 		if (irec.br_startoff >= endoff) {

