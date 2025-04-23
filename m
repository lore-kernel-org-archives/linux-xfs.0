Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAD62820C6
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 08:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396602; cv=none; b=j7t9OPDieB6mrd9FMJPcMrSFZgH6hVHDccab1FANbe7XbNkS88/zF9DvHmssheomkAcLWqwYbtJ2vEQXNlvI14ZyLRZwaNf8GDTpXDtRJYyMnY2esNfVoj/n6XoPaQPmcC2kg0WDbzZmyHuThKoUnJ35AUyljCov3R4q/XruWaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396602; c=relaxed/simple;
	bh=5TnAcBZ/1cHytLYi/tXT+YYG2LOXllz1o8KLTYRlkpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8jRLvwJDIsTuMeVWMrAHe6CamXmhW9hHMN+Eioo+NyrUqeZ2Woz/Uo9jdVWFtLsmzu9Z/ENUw6Dfv/2Fxp+EHVBdrzqM1v4eDJ5V8wUqXL2bvCPAIs4Gr8AR+DsfqOh1QV8emmgftypkJrWeuoce3J7Kqux63h+4aNTkvxPihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nZAaC2al; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nZAaC2al"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c266c1389so4510207f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745396599; x=1746001399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwoWsl8AaD6SF3PMNXab4qrxJoLjeIsq6VvtfN+z2+Q=;
        b=nZAaC2alhwag7ZM5BntM9dqSPzKuX2xkh0WNc0RtJBdIGV4XXWHvfrXsJJpj9IjZyg
         zI/F+6qjMyN8leKu8EdwACfJY5W4fWyWZqngSnVrGdpbUNmsmjjmBMQmykfnuk7XGfTS
         Ak9Yy+zTf0lfSsIj+zkXUkLhWWdvZZBPXvUG+Dncg9WZx+BQPMcu1E5CjACaCtXVe98t
         ++QSh2X/xP2KFhN2U7HaA+nRM23BLZDkmyOh4kmHDneiMvMgqFtslN0ngu1Nlj95TsXW
         3+0EQrVJ8+1gsZNs5m8KfpCkJtHB0p/pJeyEujlMWSeahWyekGFYWV2C4jDVx3GG8yzs
         77tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745396599; x=1746001399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwoWsl8AaD6SF3PMNXab4qrxJoLjeIsq6VvtfN+z2+Q=;
        b=Wo9TUb+2jU1LD37ZQ1rF+NyFlmPVC2Xmnueuj0vvgUJeF8in8/uyE4ZAxXqoa9mmnp
         nkunoXfWFf68kPoBSLO/5HpubaF56Sk6S7V1oQ2nrO9EJ5FJxuzu430J7/iPur5/Kaq1
         m1wPiwp/XaEEGrdmrevRgCijxUUyK3EkI1DDydWcJYrvNlyv6zEBPMtRRT0i+CbUSnXQ
         TqHS0kUo4FB3hshKDX1lSgUMePChuD+Vk62XBxnYnWLCI/SuIljhvCSyJM22FMt6ItPA
         TOkqsGJ0+ky5Tk3Ayucb6hrJERKnzhGoUOWRKVEKHxPxKxeGFvnfBFhcrG+Ju2sIxRfC
         vxVg==
X-Gm-Message-State: AOJu0YxLPAzm3mLjliOP8A9vfh0CNc4WloA0mcgZcLs4YdusCZ3nAW7F
	8NXxXo/gT8TpEz+0PGwBwYO36q5u8w70XYq3ebEVW6OI9CEdvEung7TYfQ==
X-Gm-Gg: ASbGncuGUmH9C1UzUBQTgpsivm2keWRGGVkhGYVMCjnmhmJBHXoG4kQdMlW8DQbhgi5
	KT+4FnfKXyouhlOLtuPrQhQm9aGNXLHVV+HH8eWMA9c8VUFBbBzXlzLRG8DLXGKebIaZyX5gAKc
	SrWPhReEAs7zUsnoGNJ8P/8/qx4LsSDfc08Cv6KlbQykMcUY1evHvhoVOrwxs21iCmPYrkVssmB
	r0rYC1KrnWZL1VFDPVAGe0a6OzP5SR08FjCwrcGBywGmvHFpgHsEPx2qSrkoPMUO9A35w6WuBkA
	mvTUeAoZCviZ6eMAtpFU
X-Google-Smtp-Source: AGHT+IFz1w0neQOH/G+R2BKC4IpaZEdjp+E6q302iA7Ov0284ZIUcstp1GO7FuYUXQFFU/jQdEjdVg==
X-Received: by 2002:a05:6000:2408:b0:39a:ca0b:e7c7 with SMTP id ffacd0b85a97d-39efbacdea0mr14354147f8f.36.1745396597643;
        Wed, 23 Apr 2025 01:23:17 -0700 (PDT)
Received: from localhost.localdomain ([78.208.91.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c37sm18345313f8f.98.2025.04.23.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 01:23:17 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org
Subject: [PATCH v4 2/4] mkfs: add -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 10:22:44 +0200
Message-ID: <20250423082246.572483-3-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423082246.572483-1-luca.dimaio1@gmail.com>
References: <20250423082246.572483-1-luca.dimaio1@gmail.com>
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
 mkfs/xfs_mkfs.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f5556fc..06d1c12 100644
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

@@ -5110,7 +5112,7 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));

-	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
 					long_options, &option_index)) != EOF) {
 		switch (c) {
 		case 0:
@@ -5136,6 +5138,11 @@ main(
 				illegal(optarg, "L");
 			cfg.label = optarg;
 			break;
+		case 'P':
+			if (strlen(optarg) > sizeof(sbp->sb_fname))
+				illegal(optarg, "P");
+			cli.directory = optarg;
+			break;
 		case 'N':
 			dry_run = 1;
 			break;
@@ -5334,9 +5341,18 @@ main(
 		initialise_ag_freespace(mp, agno, worst_freelist);

 	/*
-	 * Allocate the root inode and anything else in the proto file.
+	 * Allocate the root inode and anything else in the proto file or source
+	 * directory.
+	 * Both functions will allocate the root inode, so we use them mutually.
 	 */
-	parse_proto(mp, &cli.fsx, &protostring, cli.proto_slashes_are_spaces);
+	if (cli.protofile && cli.directory) {
+		fprintf(stderr, "%s: error: specifying both -P and -p is not supported.\n", progname);
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
