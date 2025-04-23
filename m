Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2866B1DE4E3
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 10:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745405172; cv=none; b=aq+fEVB6gbaDrKbVIOlnN1ZDrTS/R7E4ugR8UquTBtZPn5hOhvptVa7EvHBjlq8yDbo9Lyddktuq3XXn4AHy+jIhqXsKQY7yM4ZHGNQeSv70CAlUzAQaruqvhnb0Af8ciwxXdQVl0GdrBG1nhez0rtXgUE+Bgk51k6PaBKuCII8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745405172; c=relaxed/simple;
	bh=+3y+FtKuIQaS3wR1iBRWUF2BhTkve5KKmi4i25oD2Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYEQ2mV/0iZeS8KWCZ7KjfZCLOZP4iJw+N9rr9RnHblRXGYm4VHKyOiEEmeup6cScd1Lw/HvBxi+q+anO1ZUKvQ9SQVv9+cxHppub3QduYt2XT6hH3meJHPzS1AtBpMKdB+0gSPg/DOQHeXv0UwDs5mOavyc4qlIF9tbkk7w+5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvJ8L1nd; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvJ8L1nd"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c1ef4ae3aso531684f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 03:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745405169; x=1746009969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKst7Heg9EdzIbPTVrfqd+xG1cX9Xp5t7nuujE+LLG8=;
        b=AvJ8L1ndx3ThCKtZbmdZ+HhpMUUk5q0JPG+rPK/z8flDW+NMnI619Czz6NSBmGZlUI
         hGgx3c6O7cOqUe/vvFKNht1lDrvgrT9V9Gpe1x2l1tQwuowH5JWqPZVhi9dEKfCPD75p
         bIaK8dknD5tP0GXZ+uNrz/GscAPfImNl0+Seq9f1ID8cyFzMCqCJrFukpgAysTzfc4ov
         BKfFWVBTvTA9Pr5aQ4rkelFvjLn3QMZfOy3sAhe2o7tmtt1k277uKIl9vWxYFmr4seAE
         9vtclvV9KbY3hWLuFQnRrgpSDirJ4ojJ8Bp1qvQKmgO0A+BcJZwtlkThB8BevsXqI8xo
         1d6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745405169; x=1746009969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKst7Heg9EdzIbPTVrfqd+xG1cX9Xp5t7nuujE+LLG8=;
        b=MPo5M3ubQyb/48zb6jBFmHvvec9q3UwGRpZ6qD6bd1msNNyUGf5HH29tSHVdxSTARP
         NlRFEmB0i4u8HnfnzVDITeLVrgdUY2jqgt3EQcx0MS3sRKnk8+SfmXqu8sH4w+DCbGH5
         zHb8I96iGV+A82A29DWz0zNOa+nDjiGSVxo+ocuyTT7vrOWHwJoS/7pUC06Ih90ToNWU
         V6ENG8z3wRGk5vVSvKqt8MCxjpdqLJt57Lp/IkdjPxxFomOCDYosDptYcT2xOG++bxng
         ChiPGVOqN2fL72s7Ax9l2jhQurhHmf0mrIy3Q7H7jOZPmDohEt6/OvgubEGp5xIy7jH5
         t37Q==
X-Gm-Message-State: AOJu0Yx0B5GWETShAYCfGNfJRoLIVZ9WtsKR1lf6FMoMnCCbpGDGoH2X
	QVq+/XECMzkgRsfGMcSNOPIQrTKyGgUFWtk548C9YnF3Pr+ay3m1XKUYvQ==
X-Gm-Gg: ASbGncvmKo9xLwiMvDxXTrE1vR5XYWu94FU9LVvyOv6xnRJ4sQFtZJxzdHXstOVcAB7
	RXd2Kr3XOWHLw1Bwhyy438Z1CD5lW+uvI8D3i2Xp30LRwn/R2RsZSygbKB0rFYilfBL7GV/uR4f
	YV6UzULDFv9jsbU1ACpwt5DDJpDiBmJkCNnGg1tXDhhH9745IX5SXdtAUccsUMu4NjEVeCfMqS/
	M120nkJIVvPUwzL+Os6iQEKtSkLkwsZZartoTlWvbr7hWtFCYuY9ElPFsrLNF5y4o7cPxOiB2A/
	ZLk+RNqOIBq5kKFlgQM=
X-Google-Smtp-Source: AGHT+IFPsEzX4C6d2e4UaOGDTXhVrNtMLYKFXUWhvModUZS2CfaSVysBKG9fzxVyjpXFzWiRXugLww==
X-Received: by 2002:a05:6000:4022:b0:39c:12ce:1112 with SMTP id ffacd0b85a97d-3a067285ac7mr2109962f8f.21.1745405169267;
        Wed, 23 Apr 2025 03:46:09 -0700 (PDT)
Received: from localhost.localdomain ([78.209.88.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43ca78sm18214925f8f.47.2025.04.23.03.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:46:08 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v5 3/4] mkfs: add -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 12:45:34 +0200
Message-ID: <20250423104535.628057-4-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423104535.628057-1-luca.dimaio1@gmail.com>
References: <20250423104535.628057-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a `-P` flag to populate a newly created filesystem from a directory.
This flag will be mutually exclusive with the `-p` prototype flag.

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/xfs_mkfs.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f5556fc..44a8d73 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -14,6 +14,7 @@
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
 #include "proto.h"
+#include "populate.h"
 #include <ini.h>

 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
@@ -1022,6 +1023,7 @@ struct cli_params {

 	char	*cfgfile;
 	char	*protofile;
+	char	*directory;

 	enum fsprop_autofsck autofsck;

@@ -1170,6 +1172,7 @@ usage( void )
 /* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
+/* populate */		[-P directory]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
 			    concurrency=num]\n\
@@ -5110,7 +5113,7 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));

-	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
 					long_options, &option_index)) != EOF) {
 		switch (c) {
 		case 0:
@@ -5136,6 +5139,9 @@ main(
 				illegal(optarg, "L");
 			cfg.label = optarg;
 			break;
+		case 'P':
+			cli.directory = optarg;
+			break;
 		case 'N':
 			dry_run = 1;
 			break;
@@ -5334,9 +5340,20 @@ main(
 		initialise_ag_freespace(mp, agno, worst_freelist);

 	/*
-	 * Allocate the root inode and anything else in the proto file.
+	 * Allocate the root inode and anything else in the proto file or source
+	 * directory.
+	 * Both functions will allocate the root inode, so we use them mutually.
 	 */
-	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
+	if (cli.protofile && cli.directory) {
+		fprintf(stderr,
+			_("%s: error: specifying both -P and -p is not supported\n"),
+			progname);
+		exit(1);
+	}
+	if (!cli.directory)
+		parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
+	else
+		populate_from_dir(mp, NULL, &cli.fsx, cli.directory);

 	/*
 	 * Protect ourselves against possible stupidity
--
2.49.0
