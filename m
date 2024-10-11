Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA25101E6;
	Fri, 11 Oct 2024 01:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611000; cv=none; b=IWwwEsbJzeyr21tBjuec7zP8zJo/dK/C5HjZ2evCHOtB4aita7cSLRhMh8LVfdsV7y2MNjXw3CzPKkaOROpDsZzLSF3hjluJIh96JruGM1Ut9pRdfp2Vyh+5O8plPvpn9yuIFgz6KeNpWNN52tpDhvTbDUaxpwRZXAwhq4nWCrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611000; c=relaxed/simple;
	bh=IBphJlXMo8kIFmosi7P1qUTbVnOjzbhZ879WsQ/vNYc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nPQClMI1VvN8lwzW3NSOz5838Zg3GE+ApUz36DQLuyY+RtCsLMonjwGFad1QhEe089JJuG17fyCZHnh6CM6K7IKbtCCsPomc+VOAWW0vnCcUH1B2QA5MkoAuITu79hWx7F2vCovVVwRGZu5LzN5PclkL6YUEXCepHPjxWXQK1iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p583lQRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p583lQRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B64C4CEC6;
	Fri, 11 Oct 2024 01:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611000;
	bh=IBphJlXMo8kIFmosi7P1qUTbVnOjzbhZ879WsQ/vNYc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p583lQRurmjNbxk63wzuHjbs2JBNZ0ECQgaziBmz/KP+0nQyPp7/77yx0/WMHKLLI
	 EI6d++/h8I9I99/qRvz16y0JazHcW1/3j5f+Es7gBrBhOVp3gClyaz0NLApLXWz6PB
	 VFkLiQXk8MpsQP7MC8y2u1ZiZhJqV+TfM5Yrmycmy6FiNDF1QK+BiOBBo0pWM5Iv0M
	 CkCsRGTxUvUphJNKB8RW8igwOyOQMJOst//7PPSiyP1frsnBcbvjqozNVTAoMmbo4v
	 cDQjW/4ANfp+BMSr6KUBnWiG6VQk8Jr81ZvKaUlHTP3o8lBpbW68+k/xAyY+B5BYlS
	 bpJRc4o5BiefQ==
Date: Thu, 10 Oct 2024 18:43:19 -0700
Subject: [PATCH 09/16] common: pass the realtime device to xfs_db when
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658658.4188964.5581122925265318002.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

Teach xfstests to pass the realtime device to xfs_db when it supports
that option.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/xfs b/common/xfs
index 39cb04ff2cddcd..ffa5f3fa6d0d7b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -303,6 +303,10 @@ _scratch_xfs_db_options()
 	SCRATCH_OPTIONS=""
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' && \
+			SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 

