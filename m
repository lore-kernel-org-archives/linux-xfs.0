Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE022417D6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370102; cv=none; b=N2dbZbLq4/fAULSIikuQe8pwRuawVQ4W555ClF80aWCtPSAteUwMmttewDmcl6D/0HP7iIrLWoLZ7hQ6k+GPhBwyeUDb8SM99MgOJay6blHiC1EPXv1X40bqJMADLY0AvehXihm1EQitSLQ5/BA1asmLZcir44h71nqPpYqTGmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370102; c=relaxed/simple;
	bh=i5jII2evY/N2c+mweMjFj9HfmBtgp+BKC8PIQxTepoY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FaznNaeTyS053sSSlItKW53g/m1CQ9sD3F9Wb/WgP6koYXgc376UCuNqqFSqtlaZw67WfmPZhizclrp2z+tQtpVEx/erpLSxiK09Px1k0X6apX6nXLjBp5viCqeKORMZpZK33tJc12qXfnKb0NUJ6haFvCNSnGNvoYhVDbVYdLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ROhRVr4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ROhRVr4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D36C4CED1;
	Fri,  7 Mar 2025 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741370102;
	bh=i5jII2evY/N2c+mweMjFj9HfmBtgp+BKC8PIQxTepoY=;
	h=Date:From:To:Cc:Subject:From;
	b=ROhRVr4R9+DdkDaZgN972PNSBMrlBnjKYxuNqUxDa+BeWHxzBw2W8OQCeCfIFROjt
	 BEbcKbt1Vrrlkd55x7zDmvGwMMTYJXcYhYK6d1GnkNGjL7wn1RJCX6vXqqQpiiUmWz
	 rh8AAepqxtHz535QByY+1lcmiR7zKu5XLoliwcz0bAR8XzrDtUYcf4S4bzwtlhqpPz
	 yyDBH6q102cqCkNfGNwipt6g2AUDwv6LdvwzqOBoI+oQdFd8WUK7N9xy4Eyvnhy5Kh
	 DMGVCJ9PoLbzZxJ2Q1NrkgH6PF8txBh0d3pF5Ygkz1zzHipNUaNQNvXJkULdylXMF2
	 JfNYEt4198aMw==
Date: Fri, 7 Mar 2025 09:55:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs_{admin,repair},man5: tell the user to mount with nouuid
 for snapshots
Message-ID: <20250307175501.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Augment the messaging in xfs_admin and xfs_repair to advise the user to
replay a dirty log on a snapshotted filesystem by mounting with nouuid
if the origin filesystem is still mounted.  A user accidentally zapped
the log when trying to mount a backup snapshot because the instructions
we gave them weren't sufficient.

Reported-by: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/sb.c         |    9 +++++----
 man/man5/xfs.5  |    5 +++++
 repair/phase2.c |    9 +++++----
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index aa8fce6712e571..52ac48d45d5ae6 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -266,10 +266,11 @@ sb_logcheck(void)
 		dbprintf(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
 "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
-"re-running %s.  If you are unable to mount the filesystem, then use\n"
-"the xfs_repair -L option to destroy the log and attempt a repair.\n"
-"Note that destroying the log may cause corruption -- please attempt a mount\n"
-"of the filesystem before doing this.\n"), progname);
+"re-running %s.  If the filesystem is a snapshot of a mounted filesystem,\n"
+"you may need to give mount the nouuid option.  If you are unable to mount\n"
+"the filesystem, then use the xfs_repair -L option to destroy the log and\n"
+"attempt a repair.  Note that destroying the log may cause corruption --\n"
+"please attempt a mount of the filesystem before doing this.\n"), progname);
 		return 0;
 	}
 	/* Log is clean */
diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 0c1edc53e227ce..f9c046d4721a14 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -91,6 +91,11 @@ .SH DESCRIPTION
 and
 .BR xfsrestore (8)
 are recommended for making copies of XFS filesystems.
+To mount a snapshot of an already-mounted filesystem, you may need to supply
+the
+.B nouuid
+option to
+.BR mount " (8)."
 .SH OPERATIONS
 Some functionality specific to the XFS filesystem is accessible to
 applications through the
diff --git a/repair/phase2.c b/repair/phase2.c
index 29a406f69ca3a1..9a9733749266e5 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -72,10 +72,11 @@ zero_log(
 				do_warn(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
 "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
-"re-running xfs_repair.  If you are unable to mount the filesystem, then use\n"
-"the -L option to destroy the log and attempt a repair.\n"
-"Note that destroying the log may cause corruption -- please attempt a mount\n"
-"of the filesystem before doing this.\n"));
+"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
+"filesystem, you may need to give mount the nouuid option.If you are unable\n"
+"to mount the filesystem, then use the -L option to destroy the log and\n"
+"attempt a repair.  Note that destroying the log may cause corruption --\n"
+"please attempt a mount of the filesystem before doing this.\n"));
 				exit(2);
 			}
 		}
