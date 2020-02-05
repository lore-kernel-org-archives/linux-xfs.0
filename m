Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11512C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1BDA2082E
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 22:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bZDFkHnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBEWsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 17:48:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727307AbgBEWsZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 17:48:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iiv+hFypyOtyHQ75Ev+LMGFV0c8VrCNpawf4WxNY7Yw=;
        b=bZDFkHnPoNfdnnViBzQXSaYjM+yvc+oL61ITmmGLnpqkDPb+AgBSZzu4H2BGcSdHkll6tV
        7C6GKjQuRMFeB34ebuZhKFjSo1AdG2HaxM2xsXL3O9Nqc97RWTIxu5TYQvVZYPC/RmJqQr
        /0Gi8wLnAODDAyw/wRsqtsfnEnaP53o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-Arg-gos3NIq1Mp_hcL-EvA-1; Wed, 05 Feb 2020 17:48:22 -0500
X-MC-Unique: Arg-gos3NIq1Mp_hcL-EvA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65D911081FA2;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 49B7284DB8;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: by segfault.boston.devel.redhat.com (Postfix, from userid 3734)
        id 4B4A3208CD11; Wed,  5 Feb 2020 17:48:20 -0500 (EST)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 2/3] t_mmap_collision: fix hard-coded page size
Date:   Wed,  5 Feb 2020 17:48:17 -0500
Message-Id: <20200205224818.18707-3-jmoyer@redhat.com>
In-Reply-To: <20200205224818.18707-1-jmoyer@redhat.com>
References: <20200205224818.18707-1-jmoyer@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix the test to run on non-4k page size systems.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 src/t_mmap_collision.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/src/t_mmap_collision.c b/src/t_mmap_collision.c
index d547bc05..c872f4e2 100644
--- a/src/t_mmap_collision.c
+++ b/src/t_mmap_collision.c
@@ -25,13 +25,12 @@
 #include <sys/types.h>
 #include <unistd.h>
=20
-#define PAGE(a) ((a)*0x1000)
-#define FILE_SIZE PAGE(4)
-
 void *dax_data;
 int nodax_fd;
 int dax_fd;
 bool done;
+static int pagesize;
+static int file_size;
=20
 #define err_exit(op)                                                    =
      \
 {                                                                       =
      \
@@ -49,18 +48,18 @@ void punch_hole_fn(void *ptr)
 		read =3D 0;
=20
 		do {
-			rc =3D pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+			rc =3D pread(nodax_fd, dax_data + read, file_size - read,
 					read);
 			if (rc > 0)
 				read +=3D rc;
 		} while (rc > 0);
=20
-		if (read !=3D FILE_SIZE || rc !=3D 0)
+		if (read !=3D file_size || rc !=3D 0)
 			err_exit("pread");
=20
 		rc =3D fallocate(dax_fd,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				0, FILE_SIZE);
+				0, file_size);
 		if (rc < 0)
 			err_exit("fallocate");
=20
@@ -81,18 +80,18 @@ void zero_range_fn(void *ptr)
 		read =3D 0;
=20
 		do {
-			rc =3D pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+			rc =3D pread(nodax_fd, dax_data + read, file_size - read,
 					read);
 			if (rc > 0)
 				read +=3D rc;
 		} while (rc > 0);
=20
-		if (read !=3D FILE_SIZE || rc !=3D 0)
+		if (read !=3D file_size || rc !=3D 0)
 			err_exit("pread");
=20
 		rc =3D fallocate(dax_fd,
 				FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
-				0, FILE_SIZE);
+				0, file_size);
 		if (rc < 0)
 			err_exit("fallocate");
=20
@@ -113,11 +112,11 @@ void truncate_down_fn(void *ptr)
=20
 		if (ftruncate(dax_fd, 0) < 0)
 			err_exit("ftruncate");
-		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+		if (fallocate(dax_fd, 0, 0, file_size) < 0)
 			err_exit("fallocate");
=20
 		do {
-			rc =3D pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+			rc =3D pread(nodax_fd, dax_data + read, file_size - read,
 					read);
 			if (rc > 0)
 				read +=3D rc;
@@ -142,15 +141,15 @@ void collapse_range_fn(void *ptr)
 	while (!done) {
 		read =3D 0;
=20
-		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+		if (fallocate(dax_fd, 0, 0, file_size) < 0)
 			err_exit("fallocate 1");
-		if (fallocate(dax_fd, FALLOC_FL_COLLAPSE_RANGE, 0, PAGE(1)) < 0)
+		if (fallocate(dax_fd, FALLOC_FL_COLLAPSE_RANGE, 0, pagesize) < 0)
 			err_exit("fallocate 2");
-		if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+		if (fallocate(dax_fd, 0, 0, file_size) < 0)
 			err_exit("fallocate 3");
=20
 		do {
-			rc =3D pread(nodax_fd, dax_data + read, FILE_SIZE - read,
+			rc =3D pread(nodax_fd, dax_data + read, file_size - read,
 					read);
 			if (rc > 0)
 				read +=3D rc;
@@ -192,6 +191,9 @@ int main(int argc, char *argv[])
 		exit(0);
 	}
=20
+	pagesize =3D getpagesize();
+	file_size =3D 4 * pagesize;
+
 	dax_fd =3D open(argv[1], O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
 	if (dax_fd < 0)
 		err_exit("dax_fd open");
@@ -202,15 +204,15 @@ int main(int argc, char *argv[])
=20
 	if (ftruncate(dax_fd, 0) < 0)
 		err_exit("dax_fd ftruncate");
-	if (fallocate(dax_fd, 0, 0, FILE_SIZE) < 0)
+	if (fallocate(dax_fd, 0, 0, file_size) < 0)
 		err_exit("dax_fd fallocate");
=20
 	if (ftruncate(nodax_fd, 0) < 0)
 		err_exit("nodax_fd ftruncate");
-	if (fallocate(nodax_fd, 0, 0, FILE_SIZE) < 0)
+	if (fallocate(nodax_fd, 0, 0, file_size) < 0)
 		err_exit("nodax_fd fallocate");
=20
-	dax_data =3D mmap(NULL, FILE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED,
+	dax_data =3D mmap(NULL, file_size, PROT_READ|PROT_WRITE, MAP_SHARED,
 			dax_fd, 0);
 	if (dax_data =3D=3D MAP_FAILED)
 		err_exit("mmap");
@@ -220,7 +222,7 @@ int main(int argc, char *argv[])
 	run_test(&truncate_down_fn);
 	run_test(&collapse_range_fn);
=20
-	if (munmap(dax_data, FILE_SIZE) !=3D 0)
+	if (munmap(dax_data, file_size) !=3D 0)
 		err_exit("munmap");
=20
 	err =3D close(dax_fd);
--=20
2.19.1

