Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F80E1F91DB;
	Thu, 16 Jan 2025 23:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070662; cv=none; b=DtN3Wm9mA13+P9rDpnYybZa0acwWqYTt1kkDfgrRxXOes1e/8ZCG4YxIkGPADc4OIEs7BRUzBwuNo8bUo14k1+nf5G9chrSa5ot8Qsxo6hxpEA44pNFPIRKcCsZdIsKZ8NBnJZpIdpKajWM1aTpljZ94HQysuA3ujwHzK3g+wfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070662; c=relaxed/simple;
	bh=y2ABjItUbd32HXtlfAm1Ea3pYTAv4cHjPK7axHPk1jU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JiTqn7Yk4o7h/8wouyEi3hgEZmpPOu51xe8T2p252hKt7zUThr+3L4pwl0wDeBFSS/xkOb5JbvDqHYS9xhadUGOS1arZn+871WvYY2k106pH8Ot9jvdEfdmNB+OrFBjqQnn43uBS2sa9sWLnc+aLkchnOOpgNunK4UygtvQKjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhVJ6raV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhVJ6raV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A0DC4CED6;
	Thu, 16 Jan 2025 23:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070661;
	bh=y2ABjItUbd32HXtlfAm1Ea3pYTAv4cHjPK7axHPk1jU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MhVJ6raVIXW/D70fXORx/hO9w43cPDaCGj7tG3ZItOA1JiWXFcbBZCKyRBUcsuP65
	 x3WJtdoa1tTX1pEkLgtIo100uBhKZYaCSNb2pGoesKSopJEq6q3GOKU/q+qy31J7DT
	 7CE864WX7KU8KXzStQIsqF+gAQiaVexrcv+wMAr2bxUIMsN0ZeIedFKAvZzlkbGnFL
	 f3Cze19Ga2891JFqhkJF5rdzO0ty5Bj9JUfaNVLcF08y+de2FUh00TJzTg5X5PJnD1
	 32G7fkhKTs4NwewhjMXnTIEqXVWhAqr9ZLl9GlUbiqbnS0SU/4Vx4PyQoYPiyJgxfr
	 D6A7f2agd0VUQ==
Date: Thu, 16 Jan 2025 15:37:41 -0800
Subject: [PATCH 10/14] xfs/449: update test to know about xfs_db -R
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976216.1928798.18232305078880656112.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
References: <173706976044.1928798.958381010294853384.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The realtime groups feature added a -R flag to xfs_db so that users can
pass in the realtime device.  Since we've now modified the
_scratch_xfs_db to use this facility, we can update the test to do exact
comparisons of the xfs_db info command against the mkfs output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/449 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 3d528e03a483fb..a739df50e319c5 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -30,7 +30,11 @@ echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
 # xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
 # mkfs does, so make a quick substitution
-diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+if $XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+	diff -u $tmp.mkfs $tmp.dbinfo
+else
+	diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+fi
 
 _scratch_mount
 

