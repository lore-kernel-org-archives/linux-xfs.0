Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31351A0BE2
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 09:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725356315; cv=none; b=JF361n7JFDyv0Os52UxM2PH/x6ALl2W3gNhqeSFTryWPtUyCLHJZh5xos3dwx6425UMrlwKJ2lrXcXqveJqKWzVAxl6Mjskr3kSv+vVScxerhy0fmZwA7rULXRGT18JDK6+qfxwWWp0nqDB2zxcmpqT6tyUsxnL7+OpSXSYHS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725356315; c=relaxed/simple;
	bh=U9oNB1J485bQRrphjJ5NcoJNS9nfwv05CbOzocJ/w4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WoPcLd0jgQ0LVlS/a4ofYUgNnF+y4B7o+rypGLJLAg8DStxv6hFJwd47cQoqaLJJjMUHZzCJYx7mRtLQLu9G0Br1elZvKt+WaQcHtyE97llMIWodV8pVW8tYzRLprrwpYJsuyXUzB7irLthM+apBoVXA2djzaYDlT9euwRRUxNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OSswN8wq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OSswN8wq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725356311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kA1TF/z9ppLW/8RERtlqFaSLmVCLCh4e3gE/iOhBohI=;
	b=OSswN8wqnQbRQCoMCsbEZqMVSJ59EqMNclceNZKMPJzhTAqkHr1H0+3LYX/7ySjp55mPAA
	mpLOEr3zAXN6o5T5VTssjbVnWvaqeO55W2s9uNl7n6RFkQsWWAzQurAJknVLtUUWNDWodF
	XDiIucu6v+sOsbAslL+eHXZg2dennd0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-beHwnuMpNU6SQfwM8DCz3A-1; Tue, 03 Sep 2024 05:38:30 -0400
X-MC-Unique: beHwnuMpNU6SQfwM8DCz3A-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2f403c3ffecso49739261fa.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Sep 2024 02:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725356309; x=1725961109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kA1TF/z9ppLW/8RERtlqFaSLmVCLCh4e3gE/iOhBohI=;
        b=vtsIv5ZTb/s0IdlwwVGvPK1e7eT1nvoryUvrVQBE9uUNKd8feSdBejwgwCNDLUDkdI
         1Rf4RcigfngqsugtXVOCRAzY6sfN0x156KL/pg9OLTR7+laKE0/Uyh+B5HKr3kSE85P3
         pKNXhLMgw1mTu1ui6UizOIqFjkNSBgCMsDElb3/NN7DzAfuXa2dy6B1TyaKD7DSqQy3R
         Vzlmz2ASbAhhtNJ8whMoISVen0SdrfFaSxjsG2PBkwJHIXCG6dGuloX9mqo3EHBC0LDb
         3uRVcyByYetD4k3zgYXAFEP+cEIgqlBaN4M6Xqga+bxxMPFIf0vaZytHLc38GSLTuubI
         Gtzg==
X-Gm-Message-State: AOJu0YzYGMcWTKE4+xg7UpEAb46GBXEILUunLwgv+Tv9HQMbYGEPpsNJ
	R9CD27MWVstVOtWeIOnchQ5wLhtwXmtlcC2LM0BCqR5/iaiLyqFI6gyeDeSE+6bBYWiXUKVEU76
	94N+CtwiYoApPNq4ad/yC6U8L/UGOjB+PH1SuJ4+bG1ODBfcaoxnUq/l357qsam20lIet7QLew2
	22Y/0pINYixVt3bY9vjxfff5WNc4xEVT2hQq5bmxke
X-Received: by 2002:a2e:a54b:0:b0:2ef:2b06:b686 with SMTP id 38308e7fff4ca-2f6103a565bmr132355371fa.17.1725356308559;
        Tue, 03 Sep 2024 02:38:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuq+k4ndhL2foBcBUllNgEMI6llEiZfeZmJKm7KpV50jG8frdGdqOnL61Rr2JtgGsn7i3ICA==
X-Received: by 2002:a2e:a54b:0:b0:2ef:2b06:b686 with SMTP id 38308e7fff4ca-2f6103a565bmr132354871fa.17.1725356307377;
        Tue, 03 Sep 2024 02:38:27 -0700 (PDT)
Received: from thinky.redhat.com (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c226c7c055sm6269388a12.47.2024.09.03.02.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 02:38:27 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH] xfs_io: add fiemap -s flag to print number of extents
Date: Tue,  3 Sep 2024 11:37:30 +0200
Message-ID: <20240903093729.1282981-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.44.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FS_IOC_FIEMAP has an option to return total number of extents
without copying each one of them. This could be pretty handy for
checking if large file is heavily fragmented. The same can be done
with calling FS_IOC_FIEMAP and counting lines with wc but
FS_IOC_FIEMAP is limited to ~76mil extents (FIEMAP_MAX_EXTENTS). The
other option is FS_IOC_FSGETXATTR which is much faster than
iterating through all extents, but it doesn't include holes.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 io/fiemap.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/io/fiemap.c b/io/fiemap.c
index b41f71bfd027..d4e55a82f6db 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -42,6 +42,13 @@ fiemap_help(void)
 "\n"));
 }
 
+static void
+print_total(
+	   struct fiemap	*fiemap)
+{
+	printf("Extents total: %d\n", fiemap->fm_mapped_extents);
+}
+
 static void
 print_hole(
 	   int		foff_w,
@@ -223,9 +230,11 @@ fiemap_f(
 	int		done = 0;
 	int		lflag = 0;
 	int		vflag = 0;
+	int		sflag = 0;
 	int		fiemap_flags = FIEMAP_FLAG_SYNC;
 	int		c;
 	int		i;
+	int		ext_arr_size = 0;
 	int		map_size;
 	int		ret;
 	int		cur_extent = 0;
@@ -242,7 +251,7 @@ fiemap_f(
 
 	init_cvtnum(&fsblocksize, &fssectsize);
 
-	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
+	while ((c = getopt(argc, argv, "aln:sv")) != EOF) {
 		switch (c) {
 		case 'a':
 			fiemap_flags |= FIEMAP_FLAG_XATTR;
@@ -253,6 +262,9 @@ fiemap_f(
 		case 'n':
 			max_extents = atoi(optarg);
 			break;
+		case 's':
+			sflag++;
+			break;
 		case 'v':
 			vflag++;
 			break;
@@ -285,8 +297,9 @@ fiemap_f(
 		range_end = start_offset + length;
 	}
 
-	map_size = sizeof(struct fiemap) +
-		(EXTENT_BATCH * sizeof(struct fiemap_extent));
+	if (!sflag)
+		ext_arr_size = (EXTENT_BATCH * sizeof(struct fiemap_extent));
+	map_size = sizeof(struct fiemap) + ext_arr_size;
 	fiemap = malloc(map_size);
 	if (!fiemap) {
 		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
@@ -302,7 +315,8 @@ fiemap_f(
 		fiemap->fm_flags = fiemap_flags;
 		fiemap->fm_start = last_logical;
 		fiemap->fm_length = range_end - last_logical;
-		fiemap->fm_extent_count = EXTENT_BATCH;
+		if (!sflag)
+			fiemap->fm_extent_count = EXTENT_BATCH;
 
 		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
 		if (ret < 0) {
@@ -313,6 +327,11 @@ fiemap_f(
 			return 0;
 		}
 
+		if (sflag) {
+			print_total(fiemap);
+			goto out;
+		}
+
 		/* No more extents to map, exit */
 		if (!fiemap->fm_mapped_extents)
 			break;
-- 
2.44.1

