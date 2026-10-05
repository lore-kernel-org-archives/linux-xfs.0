Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EF31ED93;
	Mon,  5 Oct 2026 05:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179782; cv=none; b=RnIIo5Z2G2m9TKstcGEpuNzgvJR3pw034QQCL07UQPfNZq1Jor9brAH/Hp9oyL1ExLYrw9BrHfQ0+JVgNK4sTyE3dr/dN024LPdvh4b8ir4oJT7Mat1ze9YDq7RuPU5Ay62357WduKJorOh7e81ZbBgT8m6lmz+c6QOln7ehHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179782; c=relaxed/simple;
	bh=W3DYBCMzSpQ7uz13x7DqtWd3vsfCsun/jBglzbnXmGQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeRJ2Yp5e4FMgTaL48cRtBaQLPeQcd0wdWt6eCrVWLqcLSoi8nGJ61LwBm3FgfJWoN3qew+AZ4cMM+5bptPFjZmpU1lzJpfDVVqNS22SsPTmNcfBSdJrDxfnNe3YFWzgeFrN0Go4bchZ5q/a0ClvS08t08/W04/daH7jGvWlQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAkIC0CP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAkIC0CP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 82C481F000FF;
	Mon,  5 Oct 2026 05:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179780;
	bh=12Hh+roD3fvyUmntvVqoEilkwdNoBVz5wScPxtaeizc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WAkIC0CPA/G3Gf7L76rai6vjZC2zoaZFGCVhsgDecggYAX943+GtQheFHDlKj+3pM
	 O4TpYokLwgzE0JEwezc8CKQyYwD1j/VKYeB5rOqF0COUMAW2HUUv9Ydp1eZhrWv1AE
	 QrY2YEvsuc3aMTS6Su7oUqULqCjobg409Cz2AVOUA0hFXKfHKZxgzZ7C7WT155pqtx
	 6jtjEZqU+e8GT64qscxXOIIVWzbNljYGHM1zBp+71JC8A8VXC5ZMespuuR/ooKOVpc
	 dp/MDqj3qm3ZdLLsC5nQFcFk0mvd7wHwnPKjGEVNDWniA0s4RtJTMf97AnW/1HgCKO
	 xfK+CJRMuh5kg==
Date: Sun, 04 Oct 2026 22:56:20 -0700
Subject: [PATCH 04/12] xfs: don't pass iget failures up when marking ondisk
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965094.614350.8297165772601670682.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes a couple of problems with this callsite -- an ENOMEM
return is completely ignored and a subsequent run through the loop body
obliterates the return value completely.  Also, an error value
indicating that the list is corrupt can get passed up (thus terminating
the repair) even though we can handle corrupt lists.  Fix the callsite
not to have these problems.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2b0cd7d1ad0389..497701cf96940e 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1348,8 +1348,12 @@ xrep_iunlink_mark_ondisk_rec(
 		 */
 		error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino),
 				&ip);
-		if (error)
+		if (error == -ENOMEM)
+			return error;
+		if (error) {
+			error = 0;
 			continue;
+		}
 
 		trace_xrep_iunlink_reload_ondisk(ip);
 

