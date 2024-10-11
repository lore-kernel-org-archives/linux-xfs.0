Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83A9D268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610343; cv=none; b=iwMlo+OxYCN48rgapiSedMo4t52Emmnm+gkcH0iEbX/LQnsG9p89AmNfCqECeAxkOEZV6iFtP2PpiWubsFnYHIUxB46OtNvMoUsgGAoTqFeVV8GAOTfipLDisa2AEpAT3TwVBfnwBxCeX2QFCpzpHS8XIpGhaxI+As4MIRoo18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610343; c=relaxed/simple;
	bh=FDl7YyHOsEqO0WhNMJ3P1eOQfWIZdgV7mndAPb9Bqzk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSm2YwAKtOnqRrY2XnrnZFVgRj9wseoiVVUMdcAo8J0E+J19U9124Pw4sLz+hSOgX77+XAbWLCIWxnovNsW09sbkHrA6q24A0n7k1ffJWUE4CMRJuy7NyxpfmLuBMKNxVNRGZsgjywpxoWEfui8bICRN99LVzLbKUS1zBKol2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyg7evNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyg7evNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DA5C4CEC5;
	Fri, 11 Oct 2024 01:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610343;
	bh=FDl7YyHOsEqO0WhNMJ3P1eOQfWIZdgV7mndAPb9Bqzk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gyg7evNNpy3/f5T/MX1UaUt8aRWkx8rto7DbuWovym8RrQZOhlfobwPkZaZ15RFPt
	 Cp8rv9wESwPxpq2nbqKQNoboIdaNsqJjn8NsvQHwsMvy/91Tg5UoVQ1zgBIYn9P9sR
	 tyJuNIf3w3S3a09+QARgW9t3ExfR/Va5B3wjO7Lg3MWVJSkWaSBKyzouURrGkyqmLv
	 yGKMJzQST5PpYS4i1VzTEU1XrH1i61lYxaJj4YNM+vWJ+V8XAlu9aKfX3Gn8wEaNMU
	 Ngy69sLsYJqQ5qpEeOc1AjaNx7Uzc/b0hDudZWZqqOctLqWk2P7R5R3fJh3vr4jspo
	 R3jKCMEiLDN4g==
Date: Thu, 10 Oct 2024 18:32:22 -0700
Subject: [PATCH 30/43] xfs_io: support scrubbing rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655825.4184637.1351882688946104157.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

Support scrubbing all rtgroup metadata with a scrubv call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

