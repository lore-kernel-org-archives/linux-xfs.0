Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BF72F549F
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589711; cv=none; b=HjaFfz/L3BW1xDYqW6U0facljWIgAtVx8zMGyVZD8/aMR+CmMpV/xqRuAkZTCbnOsh7PJoaFlMDw8Lm+X5BPlOhIEJrCbsTv/fLXElKXA+t1wU5eqTgH4w0YGcFiRKao+iulCYznyTN/YlLbBHP7wYK/bXY6+LtAAASvmpB/oUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589711; c=relaxed/simple;
	bh=Tj5c+8tZNb1Ot41kz4U88mhOlZED7QMRvWuLerwe2xE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jvoy5kfdRRCOznCX35i83NmWdBYHX0K2fwgHA9FcVZDWKY7NhM+CpOuF53F1b5X3cEGTC71ueYt/Hxl65a8HmXR038S+K416Lf8Okj35hQYBwx8maxU+BZe2WMTK4heup5l9AudiUDbU9HurxIYaUNsrs87cHWYog/byzw3pQ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FSVlfX+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FSVlfX+k"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 40B3E1F000FF;
	Fri,  9 Oct 2026 23:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589710;
	bh=RJrPAKxPcQmZ7WTINyAb1enZvw8+EAehEj6QFaJB+44=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=FSVlfX+kRhFxAHvP3Iq8nBGdoHgMW86rdYwuFDeR92rogGovD8IKZMMphD9P1zEpt
	 jdzN/CXW0YR9QlKWz7/6ENQvCs53Zo8OHP8bjoWo37eEDLHXFNAexvDunlWQwNw27G
	 efeB42NNSAzC/UsUaMMUoLPwpjqkELbxUtOGJFNXJMyljZrPbBhDID9kS1x7Gdt9mN
	 p3yM9Zsrvfgpt7aUZF5CeBQ/h4XsFsH2O29tV5IIYR6Ml5qvSealY4c4bYhT0mumDd
	 bUJzPB39MLVesQMuGkrDmIQP43qiCpMYZZTOOsxb/OcLQgDTYNKS/tth68czgDD0ad
	 ogm2phJojDPyQ==
Date: Fri, 09 Oct 2026 16:48:29 -0700
Subject: [PATCH 11/26] xfs: fix exchange-range reflink flag clearing issue
 with INO1_WRITTEN
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, jiapenglin@tencent.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947567.3719791.4521272773575903605.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Lin Jiapeng <ljp1205831794@gmail.com>

Source kernel commit: a23eca88448e52eb1a81549862df7adce794fafb

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng (TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_exchmaps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 7d6f949aa1f3b3..21b64aa953a2f5 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -958,6 +958,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	/*
 	 * The INO1_WRITTEN optimization can skip exchanging hole and
 	 * unwritten mappings, which means we cannot guarantee that all

