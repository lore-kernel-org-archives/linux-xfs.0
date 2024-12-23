Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0571C3F3B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990453; cv=none; b=hpktmYa1nanHiI6+xswnmq7HbfGOcHz1Mp0n3nrFFmV7TsNzf8nTdNrHzPFeMHW/8fZ6KlypnQAVzkgK55OcW6fCn+2A8DOWHz3xaM6367sOI+2Fa/tyres+Q+uyhlvfZUgtjHNYAO2RBkf9ReJGdhFWi9gM3167SrCWLg5F9oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990453; c=relaxed/simple;
	bh=pXhYa2gE5pPlF/6ULKSW+UCWJjWyrGPD9Q/kjczkelQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=syRg4jSkl9TeDbUPKdlCwxyD+R+PEf8ufGwfMSqIeUEfWoDGXR7Ci3o/efS5EUSKgkgKBWIgygZ3dOa1cjDDwoBhUuU2lZwYbkdn7CjnstIuJnKYRm7OaXBtbTXTSk86Gj5sywS9WjWu1MQ/QilrdqxCxeuPdMU8e+w5qcmyJ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwamiJja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwamiJja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F19C4CED3;
	Mon, 23 Dec 2024 21:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990453;
	bh=pXhYa2gE5pPlF/6ULKSW+UCWJjWyrGPD9Q/kjczkelQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AwamiJja8GCqyo0OgKkqcVHhAZ+t53nBez34OWl6mlaZ5foeP2AI+K/lGHhTukocw
	 JL1k45EpQhQRSwXfGS87S4uKilLITyZcNzcvfMsM8LdsphbuCozLsT++c3YL9mL3fm
	 yYfmASg/mUewq32YEbHMQF/91SofQspPnyZJeolFm2fS1Nk7emUMpuWdYPFqu/olUl
	 gNjFkhP3mzz8XOcvkRWLntkbpTU4AiWwseRBk4ug1Sak/1UN7auTTFmttYl+vfKa23
	 aIlHkYYhwO9seQIKz2iqe8Q+49nr9D5+KS+nJPEITef4C7pEtF0zq6l5hIBr3NVFvU
	 aPwb/hevm/DaA==
Date: Mon, 23 Dec 2024 13:47:32 -0800
Subject: [PATCH 04/41] man2: document metadata directory flag in fsgeom ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941028.2294268.16295120792966671511.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Document the additions to the fsgeometry ioctl for metadata directory
trees.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index db7698fa922b87..c808ad5b8b9190 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -214,6 +214,9 @@ .SH FILESYSTEM FEATURE FLAGS
 .TP
 .B XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE
 Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_METADIR
+Filesystem contains a metadata directory tree.
 .RE
 .SH XFS METADATA HEALTH REPORTING
 .PP

