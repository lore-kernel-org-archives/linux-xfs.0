Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0F281364
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424960; cv=none; b=ZDWHAjxaMq8OmSJgYpn+dzYTed8Jj91QfEblhoXe6FG8aXB8EE3irXv1//aqUBVX7YpAsgZa5FdCc3PlTri07WCrkYrMLGd3FbbSwMp9q/TqdkMkiwUmXmzTL4P3Uk/4bglBvAipO9kUtS2YwTzoCmBaKoKRLAHO/jJqOBgci6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424960; c=relaxed/simple;
	bh=OYdZMV6f3nl8Js8MpPkeXI0/JrM+/1CoPYzr8a+ZLAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEc8fSsWaDQ/uqBvlFwoOCOz41BHWkAmqN3gTS4fYwcGMZw0QLPgaJjzz3LDA0C5jFeqxj4y1wQDqfVqhO+96jw+xHvsSzRuWisMd7HEc0U5vlbke/vCRtDz35Q5gv/QJPpnL4kAVl8V7pOvZpZliA/amo1UoUQlM3flgN+Ee38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KxuCq95b; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KxuCq95b"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so18694f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 09:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424957; x=1746029757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOoCr97R8MEsFFT1SJdLg/w0ZQD5joIIYt5Dg666rw4=;
        b=KxuCq95bYUqLiZB1Lub0qM48s9SKEw1mEE1SBAqRPGpIa1f1osoEQrhqg3TAWkr3GN
         0FefsIKx0apkvCt2Cu4wQQclA/+SiDuX1J2sm0npVJ/fmU3NMel55VhtWUuNm4WI7FoQ
         0Cg92XOjxb6L8VUeLoPVo+mY3UoRFUEbsJEUDF5cUr98WVPkHvPm7Zkk2Ibz090BRCUs
         qiNX3U1Zqw/Tcc0X/EXE5XPd6fAOopOqNFPAh9NnYaYgRmWhMdyaWpvzUFtyphQKj2Jl
         qtJs4SoAEMSyVChCaWjd4hOM2O5lBhOFlTdFQBx38F+/JpZ5tbUVCc51yeKdBHI+RHqx
         0DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424957; x=1746029757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOoCr97R8MEsFFT1SJdLg/w0ZQD5joIIYt5Dg666rw4=;
        b=GDR+t9eOURfRndqFYSeeCw0oGq7/RLT1yqTu8LGZdMYp2vdfV8JGnpr7dC516Aks2x
         okg8PJROElVNEWxn4luwZGGfim+Qq4zXR5janZQ/O2vHhkKDvtX3vyDJ7He9iNZZsn1M
         ULdVI35t6W40Kyzwgm/kiZz50xR6YcDR//gPPYhDVHUvkYzg7I+uriqV4/ecMSZ7hwyG
         AFjnNorlyWjWZ4NFP6jKVSPE1O+bGcfAh57Pesy+aIM1E3kmmkLzbd3EsAdg4JLQQ7DH
         uNKSe2DjIeYNCsU8wAftmkyspHCbAuuRsMZvnOKDxd03nApA+SKvdG/adzAmxB2qqwM4
         o7tA==
X-Gm-Message-State: AOJu0YzQcrCaKuIMt/VWIivsENUsVWKlC26vm5u284fSNjMz26hnxfz1
	OEqzt35ic51oLwuly/4x1rOBf3xC/2JK8O52d8zkEq+3hki9n9RQhPcv7g==
X-Gm-Gg: ASbGncuvEZhT1rUqAWeljH3Co8LsU/o3FzAA+CWc7LE+dYugYrPV/VDAg1zhvinwfVt
	jAaRTAPJKsnFBKsxEFLMLY+gNBGFAvANfqZnKKQsOmW7swmoIq7qlyv6IrlHVrJbBHvMQJCnI8+
	Xvx4iBzzwmNRXjJ4wY7S1dbxaKWh4Mrl1wO1WcOlZ04XCqJh+/TkhOfQQWPEfaQo7w97k4HVren
	07k0lbJwv5qfn05rEgel98HSCGoSrPplHnjrmZrZNgIVsmXup6PGRNabgyytE/JuuwLnAQyDCAC
	ojTVw8oPGs72DhYqLsGh
X-Google-Smtp-Source: AGHT+IF0BlXqHJHtykvBtZMkOO4X7GiEGSYw5gZhqDyd2NmQkEx2j+5xtaM8MlYePxkJsJ2jMnmvtg==
X-Received: by 2002:a5d:6488:0:b0:391:3207:2e6f with SMTP id ffacd0b85a97d-39efbace3e3mr13749708f8f.42.1745424956906;
        Wed, 23 Apr 2025 09:15:56 -0700 (PDT)
Received: from localhost.localdomain ([78.209.93.220])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa421c79sm19083567f8f.1.2025.04.23.09.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 09:15:56 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v6 3/4] mkfs: add -P flag to populate a filesystem from a directory
Date: Wed, 23 Apr 2025 18:03:18 +0200
Message-ID: <20250423160319.810025-4-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423160319.810025-1-luca.dimaio1@gmail.com>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
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
index 3f4455d..57dbeba 100644
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
@@ -5254,7 +5257,7 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));

-	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
 					long_options, &option_index)) != EOF) {
 		switch (c) {
 		case 0:
@@ -5280,6 +5283,9 @@ main(
 				illegal(optarg, "L");
 			cfg.label = optarg;
 			break;
+		case 'P':
+			cli.directory = optarg;
+			break;
 		case 'N':
 			dry_run = 1;
 			break;
@@ -5478,9 +5484,20 @@ main(
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
