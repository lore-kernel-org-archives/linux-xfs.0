Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3030F253F29
	for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745675764; cv=none; b=Jqeh/fFkdNqcMFmJcI3Nzf9cmunI7AxZZfYAC/PpyU8IUhuG3Vc5CfM+MG2KRumtFMdsEzY9pjHWZ/0J0zFKH2HbKuysxEgnIUieAwkdNMzusNSvKkQO5NnPYfUN3Z9P1QwQrDvjXj1i7zseTjSH6QT4LjE4OF2luhiD60vU0TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745675764; c=relaxed/simple;
	bh=aL6OfA9JF3LqrSh/kPnDieqA/ju9ejEoSsNpojv8o3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3zzwWdQHrS/fA003GFBAnnpt46qIGyMEXSokMJNUC2bmAzhbYkiBRDA+cYw51BgUT3SMwnDgursNSwiDRooFA1ibMVPRCsbzL1VCJigh8Ou5c6CTdDQzbH4Iob8owb5SblutMZZCbIXdqePxteG+PZN6Q4notiqcp3SJclOV8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLw35vAs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLw35vAs"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so514476766b.1
        for <linux-xfs@vger.kernel.org>; Sat, 26 Apr 2025 06:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745675760; x=1746280560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tyLELFkVvBdIFSmRiZwXyt9e4CX9nhPfsRS/CsJrSM=;
        b=VLw35vAsRfb/YaMDsz2rphqTFh7if2GPT2tkXYGyAwlTxmW/oZkv4eOs6SP4N1IMV6
         F5kUgDzT0OJMt+cbhK7rkspVpFvFOLraQGhGC/3Wyja3WyxwzkV3Shmpj36RFJm2SeI8
         QD08b/J/ujIAop9E+lJezp31gasQDWFzKia8cw3RkUSgtMkaTzEYONUmuXJD98ljedAA
         BYyQfD+Stx35Mczz9yZDsGBE3X1IidHsorG+nWSOxLMMgoMsTCphi3fdEw3XoKNjvzOG
         xwvnEEHg3aeJ4t3VTrR8EyNmgqmX1C/QWe1lgsO9epeIVmvpDWDjbEUSz1ZqgP2jvQfL
         iUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745675760; x=1746280560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2tyLELFkVvBdIFSmRiZwXyt9e4CX9nhPfsRS/CsJrSM=;
        b=RTlAwu8kZehClWx2wLf/6+A2ZUjjv6XVpiWHCQEwSoHb7icgLPycXq8B0EI9jBLuHe
         aoDN52CJhpTh9hi7EPsTxNQ0JV9vwE1E2rszMxubyoXL7R9cfL8KIr6xhccJYD8x6Bc5
         VnGlhsI7Dlz8ggyfhiaPyVFOINTiFD7cKUBmTWAvtA0OlEwW4hELayYmqWCEUC6eSWZO
         mDXMxG7FHLcVECiOXRyPo4eXCWk3GdmSezRLU4u/DH1/7RddtA1eZRfV8zJs598vpa1I
         uo2nxNPGCeaTXChLe2+bigqwq3MN5qlRwsz1xH16i5hnJVfP7kuUzK4A5Vf9CYT/wP+o
         CCrg==
X-Gm-Message-State: AOJu0YyrqoU9TsoN+fkvhoeZBpoRl/dNd5E90HV41SkS/FyQJ0raxe2a
	R188WZV3h0tUAga4k/kyqcIYjDCDoNokxc/SOl7tRBxCeqyDQp+mCVX+Yw==
X-Gm-Gg: ASbGncs7bqflHFQME6GGwM50X8TjlNHhVCRsUZUswaZaC4FJ9Xe5FwkAqKr5tsSj61c
	g2S/RpXifmQqkkCjUrj7YScSqBhwXUQTc9PmU5DN1U9LurxR7Yt8FPEbhM8yGnyxntX5qJl1viJ
	0z+2fvi/DVLqul3zpGHm2MTywrMC8+mwfCl4MSwhF+oEnksOQPyhflp7iR4sAYj2tszt4he9gZE
	up5Nnh+2KQeXw/JP6ELJcibuOSXkKYvqxxRGXv/lOz4mfZKYaytzymotuvU27tHf43a9d0V7Ukr
	skVnLoZeViTd/SdW4rSNUA==
X-Google-Smtp-Source: AGHT+IE9if6JufOKsI9M62khYjaYxdA0V9VszDWCKbICSmxTJjXT4v5oepFPpbFtc9+qWjkIjb80Dw==
X-Received: by 2002:a17:907:3ea2:b0:ac1:dfab:d38e with SMTP id a640c23a62f3a-ace848fb811mr253424566b.15.1745675760081;
        Sat, 26 Apr 2025 06:56:00 -0700 (PDT)
Received: from localhost.localdomain ([37.161.219.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7a41sm298700866b.55.2025.04.26.06.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 06:55:59 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v7 2/2] mkfs: modify -p flag to populate a filesystem from a directory
Date: Sat, 26 Apr 2025 15:55:35 +0200
Message-ID: <20250426135535.1904972-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

right now the `-p` flag only supports a file input.
this patch will add support to input a directory.
on directory input, the populate functionality to copy files into
the root filesystem.

add `noatime` flag to popts, that will let the user choose if copy the
atime timestamps from source directory.

add documentation for new functionalities in man pages.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 41 +++++++++++++++++++++++++++++------------
 mkfs/xfs_mkfs.c        | 19 +++++++++++++++++--
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88e..f06a3c9c 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -28,7 +28,7 @@ mkfs.xfs \- construct an XFS filesystem
 .I naming_options
 ] [
 .B \-p
-.I protofile_options
+.I prototype_options
 ] [
 .B \-q
 ] [
@@ -977,30 +977,39 @@ option set.
 .PP
 .PD 0
 .TP
-.BI \-p " protofile_options"
+.BI \-p " prototype_options"
 .TP
 .BI "Section Name: " [proto]
 .PD
-These options specify the protofile parameters for populating the filesystem.
+These options specify the prototype parameters for populating the filesystem.
 The valid
-.I protofile_options
+.I prototype_options
 are:
 .RS 1.2i
 .TP
-.BI [file=] protofile
+.BI [file=]
 The
 .B file=
 prefix is not required for this CLI argument for legacy reasons.
 If specified as a config file directive, the prefix is required.
-
+.TP
+.BI [file=] directory
 If the optional
 .PD
-.I protofile
-argument is given,
+.I prototype
+argument is given, and it's a directory,
 .B mkfs.xfs
-uses
-.I protofile
-as a prototype file and takes its directions from that file.
+will populate the root file system with the contents of the given directory.
+Content, timestamps, attributes and extended attributes are preserved
+for all file types.
+.TP
+.BI [file=] protofile
+If the optional
+.PD
+.I prototype
+argument is given, and it's a file,
+.B mkfs.xfs
+uses it as a prototype file and takes its directions from that file.
 The blocks and inodes specifiers in the
 .I protofile
 are provided for backwards compatibility, but are otherwise unused.
@@ -1136,8 +1145,16 @@ always terminated with the dollar (
 .B $
 ) token.
 .TP
+.BI noatime= value
+If set to 1, when we're populating the root filesystem from a directory (
+.B file=directory
+option)
+access times are NOT preserved and are set to the current time instead.
+Set to 0 to preserve access times from source files.
+By default, this is set to 1.
+.TP
 .BI slashes_are_spaces= value
-If set to 1, slashes ("/") in the first token of each line of the protofile
+If set to 1, slashes ("/") in the first token of each line of the prototype file
 are converted to spaces.
 This enables the creation of a filesystem containing filenames with spaces.
 By default, this is set to 0.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3f4455d4..1715e3fb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -121,6 +121,7 @@ enum {

 enum {
 	P_FILE = 0,
+	P_NOATIME,
 	P_SLASHES,
 	P_MAX_OPTS,
 };
@@ -709,6 +710,7 @@ static struct opt_params popts = {
 	.ini_section = "proto",
 	.subopts = {
 		[P_FILE] = "file",
+		[P_NOATIME] = "noatime",
 		[P_SLASHES] = "slashes_are_spaces",
 		[P_MAX_OPTS] = NULL,
 	},
@@ -717,6 +719,12 @@ static struct opt_params popts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = P_NOATIME,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 		{ .index = P_SLASHES,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .minval = 0,
@@ -1022,7 +1030,6 @@ struct cli_params {

 	char	*cfgfile;
 	char	*protofile;
-
 	enum fsprop_autofsck autofsck;

 	/* parameters that depend on sector/block size being validated. */
@@ -1045,6 +1052,7 @@ struct cli_params {
 	int	lsunit;
 	int	is_supported;
 	int	proto_slashes_are_spaces;
+	int	proto_noatime;
 	int	data_concurrency;
 	int	log_concurrency;
 	int	rtvol_concurrency;
@@ -1170,6 +1178,7 @@ usage( void )
 /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
+/* populate from directory */	[-p dirname]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
 			    concurrency=num]\n\
@@ -2067,6 +2076,9 @@ proto_opts_parser(
 	case P_SLASHES:
 		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
 		break;
+	case P_NOATIME:
+		cli->proto_noatime = getnum(value, opts, subopt);
+		break;
 	case P_FILE:
 		fallthrough;
 	default:
@@ -5181,6 +5193,7 @@ main(
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
 		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
 		.autofsck = FSPROP_AUTOFSCK_UNSET,
+		.proto_noatime = 1,
 	};
 	struct mkfs_params	cfg = {};

@@ -5480,7 +5493,9 @@ main(
 	/*
 	 * Allocate the root inode and anything else in the proto file.
 	 */
-	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
+	parse_proto(mp, &cli.fsx, &protostring,
+			cli.proto_slashes_are_spaces,
+			cli.proto_noatime);

 	/*
 	 * Protect ourselves against possible stupidity
--
2.49.0
