Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5021DD0D4
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 19:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424047; cv=none; b=Sj9ZsIGDKK9gUEW7vVap/H3WP3/pxWHCdBsU0iJQrd9uPYQFaGi5H5uTS4gvMxfLP49PbPqX07W7gOnQjFYke9Ry14f2rajp+eILZm7TB5NK568bOraqMJ0iIrg7+hsjz91c9BSyRw2Y6+2eTszUqwszKXJDMGzWRJ3l0tWbyMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424047; c=relaxed/simple;
	bh=jDZL9JBQze7jATv6nLZrrpFqNHkW55VduwVDMIICaKE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmXq7jnyfGFDxhTyDGWoyHq/a9re2zTrTsjZ8XSnTk0RiHE5riYDGzk/YkMbsuaqewz1FoVnGRDcx95PIMxstiGDyWQvp53UcOk566hw2aBSp2lU/I9s2+kELbHPt19UdAAN6H9yDsc3Its63ns1ZFqDYCRhO0GjmDI3TJ7u80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHkkinzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHkkinzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C078C4CED6;
	Mon, 24 Feb 2025 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740424047;
	bh=jDZL9JBQze7jATv6nLZrrpFqNHkW55VduwVDMIICaKE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gHkkinzTKSO/7MvmzC/AkL7Q44U2A8D+MCV4FJdMvH8NGyANSYr8twBE7n4oTNZkJ
	 3bw8TkCPblMp3ST8WfYQtTk7I3HelkoTPObJFI+PzsnMuzYluHD42LZ5yoP5SI7cFU
	 F3R6510YpwNNP+X8KQENlGqasIHfX+8BGO94hR8IgWVc+vjyqXzt6n4N7pdhqtzQcz
	 0y1WNmTuTp716t4lYj5SgRnAzBBGFDssSFAhmih9ulXwbdQOjsl6HeIukTd4YtaTY6
	 j9Dn4wZzUSMHFLsINsCxx92T8KC/La8XX7DMbt3EENNw6F0dcnR3WLLFzjldgR9/e3
	 52CPdVzo+yY4A==
Date: Mon, 24 Feb 2025 11:07:26 -0800
Subject: [PATCH 1/3] xfs_scrub: fix buffer overflow in string_escape
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174042401290.1205942.5986684789242095979.stgit@frogsfrogsfrogs>
In-Reply-To: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Need to allocate one more byte for the null terminator, just in case the
/entire/ input string consists of non-printable bytes e.g. emoji.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 396cd0223598bb ("xfs_scrub: warn about suspicious characters in directory/xattr names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 scrub/common.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/scrub/common.c b/scrub/common.c
index 6eb3c026dc5ac9..2b2d4a67bc47a2 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -320,7 +320,11 @@ string_escape(
 	char			*q;
 	int			x;
 
-	str = malloc(strlen(in) * 4);
+	/*
+	 * Each non-printing byte renders as a four-byte escape sequence, so
+	 * allocate 4x the input length, plus a byte for the null terminator.
+	 */
+	str = malloc(strlen(in) * 4 + 1);
 	if (!str)
 		return NULL;
 	for (p = in, q = str; *p != '\0'; p++) {

