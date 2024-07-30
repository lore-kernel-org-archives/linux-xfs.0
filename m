Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556EFD26D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300905; cv=none; b=o7H5cknowQ26Y8Kj+II2N2SENeJp/02u4obniSozMl+aHR1ZxW9n0u82H97u3O/GUo0w+a+L+K2QE1aJwnq8mm2+tQBqWe8C6lgDPJG4LraC4pyB5C7Pj0M5jPl5ID90j3PpU0Pijgko7PeLp9yCtFWSHst7dgQQ3kKP56aMh1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300905; c=relaxed/simple;
	bh=yynjWoQsjJVNqBigusQ8Wh5fVJ03wjYArxfI1d0A7j8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LeY3Pixd1UCp60+UF1IB8YIpsDExu4SNQs9MtlH8+8dGg77SzN6a4Se/zCBvApl/tWYOofiatDYpXiquXUlJa797k79VzbIAI1mJPs6MFyXZIcAgdO7sBK7iVpdrqQHbqbxlvmb8RqkPQoB73Xoq5qeLuP9/LDyCdVA45JbDRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbS8auM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbS8auM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AC9C32786;
	Tue, 30 Jul 2024 00:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300905;
	bh=yynjWoQsjJVNqBigusQ8Wh5fVJ03wjYArxfI1d0A7j8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZbS8auM4FEs5aGsvHP90kZgvC44w/3Fg/1rW0UmUEGv/Oa+dAMHkAex+UaluZXUWa
	 gFbGEA4x/vxhY6jr8AYTQ+SVzLRnzCAI/wQlIVooAkFpbPd/yshPz+yFh7p60ujmkf
	 RFxLS/U2RjxnFuJFRptE6VIfhbDiBfK5VTCr3SqBM6EVZMonYojRoJc3Mn5O/Ey0CH
	 zg5R8H4tlMbLhjrXuw2yJBeYZUkHfRoB8HFWau236A9qFJT47ylj5o4si2UCj6P7tL
	 Mou0NFRNTwEDwrYJ68l2QLan1aUFBVCJ+yZ5rUpeY/9NmvWz/CquQXil8lb5Vzryie
	 ZZxMdAjjOM04g==
Date: Mon, 29 Jul 2024 17:55:04 -0700
Subject: [PATCH 05/12] xfs_db: advertise exchange-range in the version command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229844469.1344699.9725818747080538227.stgit@frogsfrogsfrogs>
In-Reply-To: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
References: <172229844398.1344699.10032784599013622964.stgit@frogsfrogsfrogs>
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

Amend the version command to advertise exchange-range support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index b48767f47..c39011634 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -706,6 +706,8 @@ version_string(
 		strcat(s, ",NEEDSREPAIR");
 	if (xfs_has_large_extent_counts(mp))
 		strcat(s, ",NREXT64");
+	if (xfs_has_exchange_range(mp))
+		strcat(s, ",EXCHANGE");
 	return s;
 }
 

