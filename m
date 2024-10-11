Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677D6AA7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609438; cv=none; b=poUiJ7HRXdkC3cBNCsSD5qF/sWWpRZ4cZIQ9IEQa/z7J27uKyoGcFqMwFuyUDE/hrc2hxs+1/X59kxuw6OJN9eEMj+1SK2GlK7BMMA1RgSQPLwJx1AOmOCdQjElgiNcvaUk5DwGGl0iM045E+p3XpZWe4BESaPX98rrOrG4i8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609438; c=relaxed/simple;
	bh=M6z1+gMdka3mogh9M3IyU4XA5KY/MG9JPNZD9SWa3Io=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BF1HyuUo4bnTrQNmdpsTAUuIZPSHVrxOFzmPNe5uj1v8ZY/VFCIOsKXTYnPjKXPXgdjL62vUk0FbjrLJ1WfhCj2eTOnsdOKiqGCwMFilU8w0nIWRCVU0NJ0i/QoebIdz3YYkkst20BMA+yF49zGco5X9+5cGSUdAgtduUjdDqtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoOjfx7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoOjfx7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A43C4CEC6;
	Fri, 11 Oct 2024 01:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609438;
	bh=M6z1+gMdka3mogh9M3IyU4XA5KY/MG9JPNZD9SWa3Io=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IoOjfx7l/350d4i7V1qL1p0xEcE13BSKEU+S63J2FD0luuhOhIXJQu6CjaCdXpTiq
	 vh9PcFnPifoaBWCf15wFA/pcRduceaJP/AXh4SlyT+zBZzK77Y4hUrYnWdKfrZ3KQ+
	 JWUiPjwSMguplnyvJblBoI6MFHz6JIaiVhapJHY0QsERkMD0hc2S9taq6d6m0zjZYE
	 owVjONPtoYU7fekydgiFRtGpq1r3fNtBgE63YWtwRdHV1NiMZ8aAkOouG+h7QBmVNO
	 ms69j6252gEijdrTlMWGvrsgUGIc49ZRUf/NSrbXZr9F/rFywkYtkYdchxgmKL5vhQ
	 j4fh1k6bKonkQ==
Date: Thu, 10 Oct 2024 18:17:17 -0700
Subject: [PATCH 12/38] xfs_spaceman: report health of metadir inodes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654161.4183231.6724128746227913319.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the filesystem has a metadata directory tree, we should include those
inodes in the health report.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 spaceman/health.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/spaceman/health.c b/spaceman/health.c
index d88a7f6c6e53f2..c4d570363fbbf1 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -324,6 +324,8 @@ report_bulkstat_health(
 
 	if (agno != NULLAGNUMBER)
 		xfrog_bulkstat_set_ag(breq, agno);
+	if (file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	do {
 		error = -xfrog_bulkstat(&file->xfd, breq);

