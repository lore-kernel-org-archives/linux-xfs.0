Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF62F6FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883017; cv=none; b=i7q1qlBFrrGe1c6leX/VORU8HNmfW23qGYCO7Zv8UzWt7USQUK83jyCzajrKH5NHeUpE8BAIBfS8FCpq6pOAZohgoSl+C4H3LG906ns6SbCoiTy3fwpkySGBKz3Op1akLlKJ77gItZH46LkOfTrBu7j72vfefegi5aMqe0PdM/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883017; c=relaxed/simple;
	bh=PU0pNOeEBHrPzaVNhRjJT9EaRMrH0udakCTn87x942I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=olh1DWVA0F3u86vcalIuFDtX5a6QKR5VCRg4iuvy8xExDLMrWLOkTCOHH+38wZsoPzR84ycsEKx5SfUHwAm5P3rX2ksO6cvwq5ZvU0gC5wCMRRYsbqFWvOlaxg+TaAi6ks9DKzwBNGIhCj3S31KT5h20oJBvcpSxlddZSjmZ4AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcHOxICl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcHOxICl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571BCC116B1;
	Tue,  2 Jul 2024 01:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883017;
	bh=PU0pNOeEBHrPzaVNhRjJT9EaRMrH0udakCTn87x942I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dcHOxIClgei0ZUb/sS7y7WDkf8n9IvlQ0txvx9U6a7ewhlejeqHEE6M/lUvcL8/SZ
	 M09BJQ1WfClLwCJpJACsbOEDyW/IsB9lgws/BTz0UfXfJj/2ThuqWjMQfMn7/N0egw
	 HU7a6VOPCrAAVuFti6tJgh9Ac3bsvGXyQfCMYRMGoGbb2rrlRBbHESDwVYta4bQS48
	 weYgReYyXO95fkKxuRMo7piFNTAl4Kx2s0rDKnAzOeR4D6s4GmBdX0OVGsA775c5El
	 PKTkc8CWeScSWwy/s6ILc1wN8+S0n0GLK40XQjUjo3jQgE5CQUUZrfnAdJwM28igrT
	 wNkalkfuZfldQ==
Date: Mon, 01 Jul 2024 18:16:56 -0700
Subject: [PATCH 24/24] mkfs: enable formatting with parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121434.2009260.2474734396646436248.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Enable parent pointer support in mkfs via the '-n parent' parameter.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move the no-V4 filesystem check to join the rest]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/lts_4.19.conf |    3 +++
 mkfs/lts_5.10.conf |    3 +++
 mkfs/lts_5.15.conf |    3 +++
 mkfs/lts_5.4.conf  |    3 +++
 mkfs/lts_6.1.conf  |    3 +++
 mkfs/lts_6.6.conf  |    3 +++
 mkfs/xfs_mkfs.c    |   45 ++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 60 insertions(+), 3 deletions(-)


diff --git a/mkfs/lts_4.19.conf b/mkfs/lts_4.19.conf
index 92e8eba6ba8f..9fa1f9378f32 100644
--- a/mkfs/lts_4.19.conf
+++ b/mkfs/lts_4.19.conf
@@ -13,3 +13,6 @@ rmapbt=0
 sparse=1
 nrext64=0
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/lts_5.10.conf b/mkfs/lts_5.10.conf
index 34e7662cd671..d64bcdf8c46b 100644
--- a/mkfs/lts_5.10.conf
+++ b/mkfs/lts_5.10.conf
@@ -13,3 +13,6 @@ rmapbt=0
 sparse=1
 nrext64=0
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/lts_5.15.conf b/mkfs/lts_5.15.conf
index a36a5c2b7850..775fd9ab91b8 100644
--- a/mkfs/lts_5.15.conf
+++ b/mkfs/lts_5.15.conf
@@ -13,3 +13,6 @@ rmapbt=0
 sparse=1
 nrext64=0
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/lts_5.4.conf b/mkfs/lts_5.4.conf
index 4204d5b8f235..6f43a6c6d469 100644
--- a/mkfs/lts_5.4.conf
+++ b/mkfs/lts_5.4.conf
@@ -13,3 +13,6 @@ rmapbt=0
 sparse=1
 nrext64=0
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/lts_6.1.conf b/mkfs/lts_6.1.conf
index 9a90def8f489..a78a4f9e35dc 100644
--- a/mkfs/lts_6.1.conf
+++ b/mkfs/lts_6.1.conf
@@ -13,3 +13,6 @@ rmapbt=0
 sparse=1
 nrext64=0
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
index 3f7fb651937d..91a25bd8121f 100644
--- a/mkfs/lts_6.6.conf
+++ b/mkfs/lts_6.6.conf
@@ -13,3 +13,6 @@ rmapbt=1
 sparse=1
 nrext64=1
 exchange=0
+
+[naming]
+parent=0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 991ecbdd03ff..394a35771246 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -114,6 +114,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_PARENT,
 	N_MAX_OPTS,
 };
 
@@ -656,6 +657,7 @@ static struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_PARENT] = "parent",
 		[N_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -679,6 +681,14 @@ static struct opt_params nopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = N_PARENT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+
+
 	},
 };
 
@@ -1040,7 +1050,7 @@ usage( void )
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1,\n\
 			    concurrency=num]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1878,6 +1888,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &nopts, N_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2385,6 +2398,14 @@ _("exchange-range not supported without CRC support\n"));
 			usage();
 		}
 		cli->sb_feat.exchrange = false;
+
+		if (cli->sb_feat.parent_pointers &&
+		    cli_opt_set(&nopts, N_PARENT)) {
+			fprintf(stderr,
+_("parent pointers not supported without CRC support\n"));
+			usage();
+		}
+		cli->sb_feat.parent_pointers = false;
 	}
 
 	if (!cli->sb_feat.finobt) {
@@ -2419,6 +2440,17 @@ _("cowextsize not supported without reflink support\n"));
 		usage();
 	}
 
+	/*
+	 * Turn on exchange-range if parent pointers are enabled and the caller
+	 * did not provide an explicit exchange-range parameter so that users
+	 * can take advantage of online repair.  It's not required for correct
+	 * operation, but it costs us nothing to enable it.
+	 */
+	if (cli->sb_feat.parent_pointers && !cli->sb_feat.exchrange &&
+	    !cli_opt_set(&iopts, I_EXCHANGE)) {
+		cli->sb_feat.exchrange = true;
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
@@ -3458,8 +3490,6 @@ sb_set_features(
 		sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
 	if (fp->projid32bit)
 		sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	if (fp->parent_pointers)
-		sbp->sb_features2 |= XFS_SB_VERSION2_PARENTBIT;
 	if (fp->crcs_enabled)
 		sbp->sb_features2 |= XFS_SB_VERSION2_CRCBIT;
 	if (fp->attr_version == 2)
@@ -3520,6 +3550,15 @@ sb_set_features(
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
 	if (fp->exchrange)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_EXCHRANGE;
+	if (fp->parent_pointers) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+		/*
+		 * Set ATTRBIT even if mkfs doesn't write out a single parent
+		 * pointer so that the kernel doesn't have to do that for us
+		 * with a synchronous write to the primary super at runtime.
+		 */
+		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
+	}
 }
 
 /*

