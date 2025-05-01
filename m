Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD01210185
	for <linux-xfs@vger.kernel.org>; Thu,  1 May 2025 08:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746087381; cv=none; b=Ri6D1kHkqXUH0uCDnWDdZqrk7uid8oZP1a628Nr0ASqDlOGw91YQjd5D32l2JZFsatyOl+iNMig7c1/N1ZllIzprdvXt6RwHyd99/6yq6D1k5W7PpI3Nf33wDPQpnAY1Cxdm96fQcBHGN3oZTUcgTJUK61vpFV4jOgTLxa+SEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746087381; c=relaxed/simple;
	bh=9zjZeFU4Cy4d9+mKCrbB+7luaz0dmKDDERyUnp2ZZWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgoze9KS6OjIjdQ3WgMLNxpW8ZAW1yLvcS+d/QRycq9Jrltyobq1Fjk4J6uSk8SAKRhKi0OARCFQf3fUapyAsYiwarO9Csvd0d0qsqJ0Udi8coJRTOB7nHuKDbJ2N85qsGNn5E8xyj6VMRMSQvSt2labMFywjoTMSBF6/iY9iDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j++PH42D; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j++PH42D"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5f4d28d9fd8so932413a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 01 May 2025 01:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746087377; x=1746692177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rB4wbft2bqo44HSiPyP/q9tqOViLrMJbRO1B3RlLf8A=;
        b=j++PH42DK+46JC/iU6ah9DGoIYNBVJKJP9Ak/52z91Pzx5pEvFj7SgL6BIL/DgXoh2
         wwIDho+6QfdEUoxwjLfwZRxIArp69IYIZ0vueDjsAjkUhaA/YpG49RgwJPiCGGMKqxCS
         AZ0lOtSLjElGGZxtRZkjO57O+TJtk+rlvQeA6BECUW7tQvD3GUtan+PSJsmIPFFYxDWV
         Y9gkAU3iZ9ncCPlIyaf6jJwoLwjqJErFI4CyaPlczftDZQZEJ2ieXvTmfpmsH7V1PKaN
         J9ovgSyOT+q7qpmKJQXecV3nJVK4sBmSCE/YHfpFGVpPaIgVp+NfV2H8D4h2SNkAn+8Z
         Qo7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746087377; x=1746692177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rB4wbft2bqo44HSiPyP/q9tqOViLrMJbRO1B3RlLf8A=;
        b=iAgAdpLhBxDTpzwR/QuB9wy+Y0uSxchFawhK+0GNOXBzP6Al+BD3P/T7uEm33dvKE3
         df0roYlIUXgB6RQRHN97x3KXN8Y2HFP75zQKXRJG0NoVZ/bV7GkCt2A/QRDa1CJJLLDq
         K3wdE6ksl0QcW6mRyy+nJZfBXjywdnMuwCuQjNRRhbYtoEm2qVQ6A5NXAyk97/YML9pa
         ga7OI+p25O2TA6Iu1WYidp4YW7fEn3lWTWw9FRhXSSIQWnVEtW2f61DdbJjnZUzXXh+5
         9OaHIgfhKfM0ZwyRCkiu2nRkNYKQojcW2o0FDpkXqArgsOaYz22k/xIwzkXrnnJVZ9G4
         3B1A==
X-Gm-Message-State: AOJu0YzYlM7rpzkRMKXkBfU573IuSuoDhlELCNvJHvBLsJy5nskm5kC8
	WidoqZbexkuA3t0FAhhu7oXhEsGxWc6dBU4XocCU+dsSpa2HvUi6eIgB0A==
X-Gm-Gg: ASbGnctPskM0Z7OWxJcrMbyWtOM2FgihVloNtUCR/uitIP5hD3zYYJrhilC/79oRd5K
	IDjClj4Ms8ZydzF4DNLGkWnoaX3XOosGC91BPyV6hWMOsY/StKjEc33Rqc1d9nPxv9FMDukbfC4
	WA9vIACcheAdbzupS+e2SfdiQoG32kYqXLa0zeHErXdR8TYwRs+XhYkTnlzMwi9pMhYmIs/9/cC
	2NLrAw2PNvfORXIxIyXL9J5C9S/WjJw4xD3mJ/ZxMur/tIl8y9kJEwdePdi5h/LzwKH6x+aVX0i
	Ti3v+/j8glWArk72ylpX
X-Google-Smtp-Source: AGHT+IFcYLfZNMbCZVn3TuXS1lfypiDz0LcnH7wp7FH4g0fvXTcqGwRRR10tXkciFremT7x2TSd9ug==
X-Received: by 2002:a05:6402:4301:b0:5f7:2af1:51d0 with SMTP id 4fb4d7f45d1cf-5f8af09a8c4mr4474934a12.26.1746087376863;
        Thu, 01 May 2025 01:16:16 -0700 (PDT)
Received: from localhost.localdomain ([78.210.34.211])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f92fc86545sm109708a12.10.2025.05.01.01.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 01:16:16 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v8 2/2] mkfs: modify -p flag to populate a filesystem from a directory
Date: Thu,  1 May 2025 10:15:52 +0200
Message-ID: <20250501081552.1328703-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
References: <20250501081552.1328703-1-luca.dimaio1@gmail.com>
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

add `atime` flag to popts, that will let the user choose if copy the
atime timestamps from source directory.

add documentation for new functionalities in man pages.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 man/man8/mkfs.xfs.8.in | 41 +++++++++++++++++++++++++++++------------
 mkfs/xfs_mkfs.c        | 23 +++++++++++++++++++----
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88e..bb38c148 100644
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
+Content, timestamps (atime, mtime), attributes and extended attributes are preserved
+for all file types.
+.TP
+.BI [file=] protofile
+If the optional
+.PD
+.I prototype
+argument is given, and points to a regular file,
+.B mkfs.xfs
+uses it as a prototype file and takes its directions from that file.
 The blocks and inodes specifiers in the
 .I protofile
 are provided for backwards compatibility, but are otherwise unused.
@@ -1136,8 +1145,16 @@ always terminated with the dollar (
 .B $
 ) token.
 .TP
+.BI atime= value
+If set to 1, when we're populating the root filesystem from a directory (
+.B file=directory
+option)
+access times are going to be preserved and are copied from the source files.
+Set to 0 to set access times to the current time instead.
+By default, this is set to 0.
+.TP
 .BI slashes_are_spaces= value
-If set to 1, slashes ("/") in the first token of each line of the protofile
+If set to 1, slashes ("/") in the first token of each line of the prototype file
 are converted to spaces.
 This enables the creation of a filesystem containing filenames with spaces.
 By default, this is set to 0.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3f4455d4..e4d82d48 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -121,6 +121,7 @@ enum {

 enum {
 	P_FILE = 0,
+	P_ATIME,
 	P_SLASHES,
 	P_MAX_OPTS,
 };
@@ -709,6 +710,7 @@ static struct opt_params popts = {
 	.ini_section = "proto",
 	.subopts = {
 		[P_FILE] = "file",
+		[P_ATIME] = "atime",
 		[P_SLASHES] = "slashes_are_spaces",
 		[P_MAX_OPTS] = NULL,
 	},
@@ -717,6 +719,12 @@ static struct opt_params popts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = P_ATIME,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 		{ .index = P_SLASHES,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .minval = 0,
@@ -1045,6 +1053,7 @@ struct cli_params {
 	int	lsunit;
 	int	is_supported;
 	int	proto_slashes_are_spaces;
+	int	proto_atime;
 	int	data_concurrency;
 	int	log_concurrency;
 	int	rtvol_concurrency;
@@ -1170,6 +1179,7 @@ usage( void )
 /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
+/* populate from directory */	[-p dirname,atime=0|1]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
 			    concurrency=num]\n\
@@ -2067,6 +2077,9 @@ proto_opts_parser(
 	case P_SLASHES:
 		cli->proto_slashes_are_spaces = getnum(value, opts, subopt);
 		break;
+	case P_ATIME:
+		cli->proto_atime = getnum(value, opts, subopt);
+		break;
 	case P_FILE:
 		fallthrough;
 	default:
@@ -5162,7 +5175,7 @@ main(
 	int			discard = 1;
 	int			force_overwrite = 0;
 	int			quiet = 0;
-	char			*protostring = NULL;
+	struct	xfs_proto_source	protosource;
 	int			worst_freelist = 0;

 	struct libxfs_init	xi = {
@@ -5311,8 +5324,6 @@ main(
 	 */
 	cfgfile_parse(&cli);

-	protostring = setup_proto(cli.protofile);
-
 	/*
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
@@ -5480,7 +5491,11 @@ main(
 	/*
 	 * Allocate the root inode and anything else in the proto file.
 	 */
-	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
+	protosource = setup_proto(cli.protofile);
+	parse_proto(mp, &cli.fsx,
+			&protosource,
+			cli.proto_slashes_are_spaces,
+			cli.proto_atime);

 	/*
 	 * Protect ourselves against possible stupidity
--
2.49.0
