Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F35B188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992454; cv=none; b=UAb6OPanI3tsg0PG6QyH4wuF2fUCcEJhyRDaQ/NRtcd/dQ+EVdBnN+t8yEkkSibrSoUp/muY2nmWESV5im+GimNQqPRVpzXOD4RlMykBvq8o+Qk7+1YfZQaJ9tB9LKQdBMMIf8mQqDnsKovANpOY8Ir4eZcUvI8Emb7t8HGz8Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992454; c=relaxed/simple;
	bh=c2uJ1Gmt/AozRenllNmzFt/OH3vyEc/td+CaOLZqGdQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9X/HOnttbmLGHUYiRN3nyM50WRX23wtajBBOwvKHf5ayo6vaqIioSbmfs1oQ1RlHRh3/rJreXZHH+Ft9g/4vDCwsZ1cNTTV93IEkmcygw0OuxETvZFaSbCX48ojtA2yK9SVUPfsI5qy1r9EBfRcNZwjiUzouW7uaucB9PjZ8yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UcprkfDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UcprkfDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA67C4CED3;
	Mon, 23 Dec 2024 22:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992454;
	bh=c2uJ1Gmt/AozRenllNmzFt/OH3vyEc/td+CaOLZqGdQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UcprkfDUTpeFdbh5lMy+z9czMq34V3piN7CvpySujPtV9Fz1Nrzc4lGy34KJiCkAF
	 cTcBVlM/1ZlUIG0Xdch5dtmS0NtKmppkUd/UW0zXzlOEu7fAzQCoODpKpnxSQCg6HC
	 r1UTSjKK6pWzSMzR3bQRBl8ir+5ftWqVNJVS3QUMUI8j5Vnc/ezc1MAVSYlfKI1i4O
	 9PJsd78HU5fFXPq0OdqmfDoPTD4YMZWA2devOkqyDrzaV+XbF0keUVnDGBzFwv0YGD
	 /J4MsHvbfJdMhU8z4l6Q/DGBT9XP9aVp9ekY6Eiv4N/n/TqV3StG6xQJIqT5tAnRzl
	 LmqykJQUXX/cA==
Date: Mon, 23 Dec 2024 14:20:53 -0800
Subject: [PATCH 35/51] xfs_io: support scrubbing rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944339.2297565.9149694495176919267.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

