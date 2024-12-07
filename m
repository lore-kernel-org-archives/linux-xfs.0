Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C8633DF
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530477; cv=none; b=E+rMgrhfY+S+L7E3WyP5L0CW/RtqGhL8DAVY+Vin+iKQAHp4pro0dNg4ZH0n9xDaMmd8CSH8beO8qp1cH+t9mT15BtaeSJl8A72fD3Cufmi1Wy4dudNFfOeDRdxqcMWp9B6XOk3QCjginucTCGQUInUTWWPLldv5DJGfJ3XWaN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530477; c=relaxed/simple;
	bh=zT+E6OCWeudgHt9lgvzfPosuSo3tm0/fKcUBY+KgI3Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KRyPKkZha/YS09iOyf1FcMYOCMpfcEok666Dmixsh529HnqSz6Tvn2PkK7YLYrZVv6DqkCheZl4RDK3ms0/0G9VQYEGF1HZF3JB/xoyr1QBIsytifpxWh17FBmJuHgmgEsyehTsS3DP2j2p3D2pSbkh6KNs0R1bmVtMrUeo6CTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAPthBCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAPthBCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF759C4CED1;
	Sat,  7 Dec 2024 00:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530477;
	bh=zT+E6OCWeudgHt9lgvzfPosuSo3tm0/fKcUBY+KgI3Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dAPthBCxS9KhOxMkE67HZwh/YbIzvmHUlOmE4NrtTMKH1Iv8JnRET/pubQYI3jyFH
	 s9DKJLJZsCBWr9Ntb5hpbskndQZ1hV0iGrYfNYdgPwFCyLhG0yW+hweG3IeFgXOWg/
	 y5J/cHWExo1kSO0zCwUT65erxoA2YoNfFqvPgcdbmIt+YM3bJ4QmQ9wNrhYhnIGswa
	 vXMC26gl7lDHHu5YwAw504ymStGI4WdNXWfoXQS0sdGFGi7Z6k9Kd5C/t+0equm6iM
	 BCLP4KMgGgw/D5Iqt0GJkSfPrLqO4ZX9A/GjqjQFEsv98MPDpRXIFb6g1/Z+AMxwNg
	 8q2mY+N6CyF+A==
Date: Fri, 06 Dec 2024 16:14:36 -0800
Subject: [PATCH 37/50] xfs_io: support scrubbing rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752510.126362.13394045053539281164.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support scrubbing all rtgroup metadata with a scrubv call.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/scrub.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    3 ++-
 2 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/io/scrub.c b/io/scrub.c
index 45229a8ae81099..99c24d9550243c 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -165,6 +165,32 @@ parse_metapath(
 	return true;
 }
 
+static bool
+parse_rtgroup(
+	int		argc,
+	char		**argv,
+	int		optind,
+	__u32		*rgno)
+{
+	char		*p;
+	unsigned long	control;
+
+	if (optind != argc - 1) {
+		fprintf(stderr, _("Must specify one rtgroup number.\n"));
+		return false;
+	}
+
+	control = strtoul(argv[optind], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad rtgroup number '%s'.\n"),
+				argv[optind]);
+		return false;
+	}
+
+	*rgno = control;
+	return true;
+}
+
 static int
 parse_args(
 	int				argc,
@@ -230,6 +256,12 @@ parse_args(
 			return command_usage(cmdinfo);
 		}
 		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (!parse_rtgroup(argc, argv, optind, &meta->sm_agno)) {
+			exitcode = 1;
+			return command_usage(cmdinfo);
+		}
+		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
@@ -539,6 +571,8 @@ scrubv_f(
 		group = XFROG_SCRUB_GROUP_ISCAN;
 	else if (!strcmp(argv[optind], "summary"))
 		group = XFROG_SCRUB_GROUP_SUMMARY;
+	else if (!strcmp(argv[optind], "rtgroup"))
+		group = XFROG_SCRUB_GROUP_RTGROUP;
 	else {
 		printf(_("Unknown group '%s'.\n"), argv[optind]);
 		exitcode = 1;
@@ -576,6 +610,12 @@ scrubv_f(
 			return command_usage(&scrubv_cmd);
 		}
 		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (!parse_rtgroup(argc, argv, optind, &scrubv.head.svh_agno)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
 	default:
 		ASSERT(0);
 		break;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c73fee7c2780c6..6775b0a273e5aa 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1425,11 +1425,12 @@ .SH FILESYSTEM COMMANDS
 .RE
 .PD
 .TP
-.BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " | " metapath " ]"
+.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
 parameter specifies which type of metadata to scrub.
 For AG metadata, one AG number must be specified.
+For realtime group metadata, one rtgroup number must be specified.
 For file metadata, the scrub is applied to the open file unless the
 inode number and generation number are specified.
 For metapath, the name of a file or a raw number must be specified.

