Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D11C0DE7;
	Mon,  1 Apr 2024 16:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990160; cv=none; b=HrigC471V7R3zKj8IpAIWGfXdBspLkgVBXtjdf0VyOCJROFhm7yd411EX02dreS5D1pL32EPYAhG5S/yNj5OoaWyjkdZ/LUYFXycvynLe/5CWOZ1pvzkXe+CzhvHRY6kph9oxVidNB072VIpGC6y3MBzgm7jApN3MmScoyF2YRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990160; c=relaxed/simple;
	bh=idlhxL3YJdkllj+fy4JcdQgpylzSgEU9bIeOJ9u+x2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdt5JV6PgOPN+RF2L1QyrAZa1f0fw3Cb3T3xGFGbw1/ytgaRhNUMR2E9QhXjDo8YO/igxfWA3QhdTJ0G3I+sr1DGNpI3BsmF/ihZAoTx64m0gIboYUTH0/oKFpgaUS4EqQNkNKLtO5iNULPVhwAGfCpJgdungvhADxFRvOkWh74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxaLzSuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxaLzSuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C26C433C7;
	Mon,  1 Apr 2024 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990159;
	bh=idlhxL3YJdkllj+fy4JcdQgpylzSgEU9bIeOJ9u+x2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxaLzSuFPlDCyAUslTcuB0VVxyLBzx7wt5Hh3lvCFSpcGPfQUoefbdYviiKlIYdJX
	 JhyOaNFUKERKt7OYFBXAwwWdVQG/v5i8M763ViI0f8SLSUxbo4tlTMt6LnYc7VbDXe
	 pehU+1oamTS6yKsJ6MNgac/wnZHgWPnL0NBhahGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 264/396] xfs: remove unused fields from struct xbtree_ifakeroot
Date: Mon,  1 Apr 2024 17:45:13 +0200
Message-ID: <20240401152555.776803665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 4c8ecd1cfdd01fb727121035014d9f654a30bdf2 upstream.

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_staging.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */


