Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B9BECAAD3
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Sep 2022 09:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIQJQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Sep 2022 05:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIQJQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Sep 2022 05:16:14 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887782F01D
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 02:16:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MV4vY0YMFz14QMM;
        Sat, 17 Sep 2022 17:12:09 +0800 (CST)
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 17:16:10 +0800
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml500016.china.huawei.com (7.185.36.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 17:16:10 +0800
Message-ID: <d63e28c3-b265-07f0-3483-ca93a47322d9@huawei.com>
Date:   Sat, 17 Sep 2022 17:16:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
To:     <cem@kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        <linux-xfs@vger.kernel.org>
From:   zhanchengbin <zhanchengbin1@huawei.com>
Subject: [PATCH v2] xfsdump: Judge the return value of malloc function
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml500017.china.huawei.com (7.185.36.243) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add judgment on the return value of malloc function.

Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
---
  common/inventory.c    |  4 ++++
  inventory/inv_stobj.c |  4 ++++
  invutil/invidx.c      | 24 ++++++++++++++++++++++++
  invutil/invutil.c     | 12 ++++++++++++
  4 files changed, 44 insertions(+)

diff --git a/common/inventory.c b/common/inventory.c
index 6ffe9fe..0de7f6f 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -364,6 +364,10 @@ inv_stream_open(

  	/* XXX yukk... make the token descriptors not pointers */
  	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t));
+	if (stok == NULL) {
+		fprintf(stderr, "%s: internal memory error: stok\n", g_programName);
+		exit(1);
+	}

  	stok->md_sesstok = tok;
  	stok->md_lastmfile = 0;
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index e2e8767..5a6786a 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -1015,6 +1015,10 @@ stobj_unpack_sessinfo(
  	assert (bufp);

  	tmpbuf = (char *)malloc(bufsz);
+	if (tmpbuf == NULL) {
+		fprintf(stderr, "internal memory error: tmpbuf\n");
+		exit(1);
+	}

  	/* first make sure that the magic cookie at the beginning is right.
  	   this isn't null-terminated */
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5874e8d..5e4c79c 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -363,15 +363,27 @@ read_stobj_info(int fd, int idx, invt_seshdr_t 
**out_hdr,

      lseek(fd, STOBJ_OFFSET(idx, 0), SEEK_SET);
      hdr = malloc(sizeof(*hdr));
+    if (hdr == NULL) {
+        fprintf(stderr, "%s: internal memory error: hdr\n", g_programName);
+        exit(1);
+    }
      read_n_bytes(fd, (char *)hdr, sizeof(*hdr), "stobj file");

      lseek(fd, hdr->sh_sess_off, SEEK_SET);
      ses = malloc(sizeof(*ses));
+    if (ses == NULL) {
+        fprintf(stderr, "%s: internal memory error: ses\n", g_programName);
+        exit(1);
+    }
      read_n_bytes(fd, (char *)ses, sizeof(*ses), "stobj file");

      if(ses->s_cur_nstreams > 0) {
  	lseek(fd, hdr->sh_streams_off, SEEK_SET);
  	strms = malloc(sizeof(*strms) * ses->s_cur_nstreams);
+	if (strms == NULL) {
+	    fprintf(stderr, "%s: internal memory error: strms\n", g_programName);
+    	    exit(1);
+	}
  	read_n_bytes(fd, (char *)strms, sizeof(*strms) * ses->s_cur_nstreams, 
"stobj file");

  	nmfiles = 0;
@@ -381,6 +393,10 @@ read_stobj_info(int fd, int idx, invt_seshdr_t 
**out_hdr,

  	if(nmfiles > 0) {
  	    mfiles = malloc(sizeof(*mfiles) * nmfiles);
+	    if (mfiles == NULL) {
+		fprintf(stderr, "%s: internal memory error: mfiles\n", g_programName);
+	        exit(1);
+            }
  	    read_n_bytes(fd, (char *)mfiles, sizeof(*mfiles) * nmfiles, 
"stobj file");
  	}
  	else {
@@ -552,6 +568,10 @@ insert_stobj_into_stobjfile(int invidx_fileidx, 
char *filename, int fd,

      /* for seshdr: malloc buffer, copy new entry into buffer, read 
file entries into buffer, write the lot out */
      buf = malloc(((sescnt.ic_curnum - pos) + 1) * sizeof(invt_seshdr_t));
+    if (buf == NULL) {
+	fprintf(stderr, "%s: internal memory error: buf\n", g_programName);
+	exit(1);
+    }
      memmove(buf, hdr, sizeof(invt_seshdr_t));
      lseek(fd, STOBJ_OFFSET(pos, 0), SEEK_SET);
      read_n_bytes(fd, buf + sizeof(invt_seshdr_t), (sescnt.ic_curnum - 
pos) * sizeof(invt_seshdr_t), "stobj file");
@@ -561,6 +581,10 @@ insert_stobj_into_stobjfile(int invidx_fileidx, 
char *filename, int fd,

      /* for session: malloc buffer, copy new entry into buffer, read 
file entries into buffer, write the lot out */
      buf = malloc(((sescnt.ic_curnum - pos) + 1) * sizeof(invt_session_t));
+    if (buf == NULL) {
+	fprintf(stderr, "%s: internal memory error: buf\n", g_programName);
+	exit(1);
+    }
      memmove(buf, ses, sizeof(invt_session_t));
      lseek(fd, STOBJ_OFFSET(sescnt.ic_maxnum, pos), SEEK_SET);
      read_n_bytes(fd, buf + sizeof(invt_session_t), (sescnt.ic_curnum - 
pos) * sizeof(invt_session_t), "stobj file");
diff --git a/invutil/invutil.c b/invutil/invutil.c
index 0d27a0b..304edc0 100644
--- a/invutil/invutil.c
+++ b/invutil/invutil.c
@@ -409,6 +409,10 @@ GetNameOfStobj (char *inv_path, char *filename)

      str = basename(filename);
      name = (char *) malloc(strlen(inv_path) + 1  + strlen(str) + 1);
+    if (name == NULL) {
+	fprintf(stderr, "%s: internal memory error: name\n", g_programName);
+	exit(1);
+    }
      strcpy(name, inv_path);
      strcat(name, "/");
      strcat(name, str);
@@ -425,6 +429,10 @@ GetNameOfInvIndex (char *inv_path, uuid_t uuid)
      uuid_unparse(uuid, str);
      name = (char *) malloc(strlen(inv_path) + 1  + strlen(str)
  			     + strlen(INV_INVINDEX_PREFIX) + 1);
+    if (name == NULL) {
+	fprintf(stderr, "%s: internal memory error: name\n", g_programName);
+	exit(1);
+    }
      strcpy(name, inv_path);
      strcat(name, "/");
      strcat(name, str);
@@ -440,6 +448,10 @@ GetFstabFullPath(char *inv_path)

      fstabname = (char *) malloc(strlen(inv_path) + 1 /* one for the "/" */
  				   + strlen("fstab") + 1);
+    if (fstabname == NULL) {
+	fprintf(stderr, "%s: internal memory error: fstabname\n", g_programName);
+	exit(1);
+    }
      strcpy(fstabname, inv_path);
      strcat(fstabname, "/");
      strcat(fstabname, "fstab");
-- 
2.33.0


