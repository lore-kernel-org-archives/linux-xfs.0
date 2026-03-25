Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B90C3E3170
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456369; cv=none; b=gqoh4fKA4qGlwqL2iEaZs5boUbOMYBhw6NXuUxUv0TfiX+lsFo3Gx/w0B2ONfaBe1GgIBRB2ORTAuA8/ntB2GNMxzDm4YR6pKOiSILF2LbBRE+A34aCbFCNA3GfzQcgDA2UGmURvvv486Xe0DmNXE85cItNwh3rzyMBIUtR1g50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456369; c=relaxed/simple;
	bh=b2ef4lzMhJ91QbzNjAWWtIwyhoxHgEUDVkHxnWyN0mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C33Qbzykd7Uah4csmIGJi/8Tf3d0dnIcfJTSIIqsQdop+hiRKFhXr7f/92DE5DBW7ljjLo7zjfPTCqZf6cKlYkK63SCRb4D+L61Lq/gi8nUj+jEFRIuzCNUmknyekN1I3IUxKTgzc2WPwEpaa4/PhP5KOY01m3HkQQfDaHkiKGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ov6yp77v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ov6yp77v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F546C4CEF7;
	Wed, 25 Mar 2026 16:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774456369;
	bh=b2ef4lzMhJ91QbzNjAWWtIwyhoxHgEUDVkHxnWyN0mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ov6yp77v2lMsOTPaFh71x7D9UUc1WY92E6rZmAEnuGLznx7bfoRM+LeQUgZm2tbSy
	 CBgQ3XEPvqMcENjnCFbQt99i5hVvKvjv7U+JgeSTxIhnXVFrErBydtiBPYUDxOcMot
	 7Y3FuPqpLTtKMkCPmn37uPpj5McbJVhoqsX9O5uPq1U/TYRwzdgIpZmBneKZ0sXL54
	 4MBfmkyxFBcJDSeL/BTqnuiiyUHl5uwtTBVgUz+CSdNHRMzqNqQtsPuvlTN8adtkAn
	 64wsh6LKh2/QstDwPy5Yq7rGuP8sylDyj1npfz1ryAJm1E/X3WV6YvB0aaW49dLfNc
	 O+c2zVLNCzUyg==
Date: Wed, 25 Mar 2026 09:32:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 01/40] libxfs: fix XFS_STATS_DEC
Message-ID: <20260325163248.GX6223@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120757.2266274.10399851330751546106.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177429120757.2266274.10399851330751546106.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

This macro only takes two arguments in the kernel, so fix the definition
here too.  All existing callsites #if 0 it into oblivion which is why
we've never noticed, but an upcoming patch in the libxfs sync will not
be so lucky.

Cc: <linux-xfs@vger.kernel.org> # v4.9.0
Fixes: ece930fa14a343 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v1.1: add rvb tag
---
 libxfs/libxfs_priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5474865a673e9a..f72f07fabdf21e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -183,7 +183,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_ILOCK_SHARED		0
 #define XFS_IOLOCK_EXCL			0
 #define XFS_STATS_INC(mp, count)	do { (mp) = (mp); } while (0)
-#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
+#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
 #define XFS_STATS_ADD(mp, count, x)	do { (mp) = (mp); } while (0)
 #define XFS_TEST_ERROR(a,b)		(false)
 
