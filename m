Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8315F305E1F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291842; cv=none; b=BKJYXqW0tqL52vx9tnMRNXjUjUEBX+JscslA2/TFj+rOKul8x4MxHmCNrHRjcM0CGMzOgYrbm55TZZUIXMPnTq48Z0KXvnut0ofLJxDj6fBRr+GTeCnlfUyZwbYUpFlh0pVUMIIqriFzAQ9Dc8Wi2qJbF0RgMPy4EAIH4m22hho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291842; c=relaxed/simple;
	bh=fDWuJ93+zfmNGO7umEHtDSQfBNFARQZHU6QcPQ0q8OY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLCK9sCxncyQtZBMVfvTFySxuwkk/+1rntiP1L8ER5ZMl3PhYC9G+MlaUEO4mDoHb9PQ5R3ph9dOzAAZzSAiJfuVrUgnCQF2KyRb3SG7S3kpLC9Z9E8PkipMQS51e1WJZtoQdnqapeEcxWNZREs7k5o3DeRcuk1pp95Q/Sucpf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMvO2c/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMvO2c/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFF7C2BC87;
	Mon, 23 Mar 2026 18:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291842;
	bh=fDWuJ93+zfmNGO7umEHtDSQfBNFARQZHU6QcPQ0q8OY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JMvO2c/0iga8Ja/ZqHbqkfd+WSgzl3BGcK0HL582LWfH07CTRe6tkSzSeplmAthYX
	 Wi8LhuGM+r5UWqNi/FXs9sJOfzcMGeCsSmQ783yPi6K9lqTgSZuy1c7a4y27/zkbga
	 aGDr1qhA8AOkrafo4AQURqddPhU9GAuJ4Rml1YdB3Nna2fZcl1WndvrU33RCIhbEdF
	 6yrgWwrXZUljbgZ4rfwQClRqH+qK2arIM/0iO1cyvWlyrX/EeQRlLnZUKkfHryRH30
	 a2DgqZcGK4NhKXSCOaetnXCm4OILn7YQePUWoyxIyM0hCjptzsywoIEe+ZoDPvSequ
	 TXqEn7XEeR5dQ==
Date: Mon, 23 Mar 2026 11:50:41 -0700
Subject: [PATCH 36/40] xfs: Add a comment in xfs_log_sb()
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, nirjhar.roy.lists@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429121402.2266274.12310258685440208789.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Source kernel commit: ac1d977096a17d56c55bd7f90be48e81ac4cec3f

Add a comment explaining why the sb_frextents are updated outside the
if (xfs_has_lazycount(mp) check even though it is a lazycounter.
RT groups are supported only in v5 filesystems which always have
lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
check is redundant.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b29077dcd0aed7..7a1d85b86e59ea 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1345,6 +1345,9 @@ xfs_log_sb(
 	 * feature was introduced.  This counter can go negative due to the way
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
+	 *
+	 * RT groups are only supported on v5 file systems, which always
+	 * have lazy SB counters.
 	 */
 	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =

