Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1829ECAAD8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Sep 2022 03:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiINDr0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Sep 2022 23:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiINDrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Sep 2022 23:47:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C33E6F252
        for <linux-xfs@vger.kernel.org>; Tue, 13 Sep 2022 20:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663127242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JfEyaIK5t5t2zBsurteXVraVZM5Dvm9NZ2TrwIG60I0=;
        b=NnmOwco9kw2CGsTo53zHUanYouuqavLiGMOn6fmeKfoObs2jZrqcbu9jf5FuDYjxVlsT7Q
        fEeGq4fZjxv3dl2/amd9CYTR91Mi+CrvOjEDyYVDn5h7CMGFoN5vPAEoRz/v+Vqr2sVt4z
        /6wijEiJ0kg+UniLX1k7ceNP6j9ebJw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-ovuRhZCkOkmoUsErajW_Vg-1; Tue, 13 Sep 2022 23:47:20 -0400
X-MC-Unique: ovuRhZCkOkmoUsErajW_Vg-1
Received: by mail-pg1-f200.google.com with SMTP id s68-20020a632c47000000b00434e0e75076so6679482pgs.7
        for <linux-xfs@vger.kernel.org>; Tue, 13 Sep 2022 20:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=JfEyaIK5t5t2zBsurteXVraVZM5Dvm9NZ2TrwIG60I0=;
        b=rm/2n0EXMsiA6NEIZhKTLHIFFqEpUmjID0OoZfd7Cee5MyAUBg4hHGQdrbgZlpyRNn
         QjN4vm0qnsdY7BxzACr04Rwr+9eKWWWznUYP4Sm66kibrnee6tvMMsy9IM//yl6tKx5r
         iHCYKxgJo3GwuapckA2ZgWyJg3Jh1bH2plQ+6yOy/pTvLLQ9zsQf4LtuOmsya3k7wEh7
         iOlzA7bb/2Kibg3yDtEDEoVM9Gdi5KwVQLINdS7uCnu8wyb+Hl0Yb1XZN0XaaJl9DfE6
         TEqmey0vf5XbBtNEe/CtkYlZ13fXCRGylY3bjwqgZK37HsBeC/amaQirKo+oUT/elBUj
         geKg==
X-Gm-Message-State: ACgBeo3RAW64LijkpPCZJjU7CIAcpUpqla/iOKLKmgkFhsQw8C5ToS5W
        YV/G7hHocH5XYQ4Ad46g1D5DNJbNGu8DdWcXsbe1oGfLbUtONuA9q5KluzcAZYiX6FVChpd5G6C
        GzF0SxlL7K7UiT1wtbxdejfkhSkSkPdHFQwVaDKodqWbqcDdvyHY6ruypR9vCq/+cuAvIwKiL
X-Received: by 2002:a05:6a00:234b:b0:545:fec9:abca with SMTP id j11-20020a056a00234b00b00545fec9abcamr6188149pfj.14.1663127238075;
        Tue, 13 Sep 2022 20:47:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR52dAllOChkt5xtuAoVitGUTXVYmlYpwMgHZR1Gl8pTb7BjzlThSAicmqDL8e2pC3ogKXasNw==
X-Received: by 2002:a05:6a00:234b:b0:545:fec9:abca with SMTP id j11-20020a056a00234b00b00545fec9abcamr6188127pfj.14.1663127237707;
        Tue, 13 Sep 2022 20:47:17 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a6ac800b001f8b3f7cc16sm7997932pjm.57.2022.09.13.20.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 20:47:16 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfsrestore: fix inventory unpacking
Date:   Wed, 14 Sep 2022 13:47:08 +1000
Message-Id: <20220914034708.1605288-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When xfsrestore reads the inventory from tape media it fails to convert
media file records from bigendin. If the xfsdump inventory is not
available xfsrestore will write this invalid record to the on-line
inventory.

[root@rhel8 xfsdump-dev]# xfsdump -I
file system 0:
        fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
        session 0:
                mount point:    rhel8:/boot
                device:         rhel8:/dev/sda1
                time:           Fri Sep  9 14:29:03 2022
                session label:  ""
                session id:     05f11cfe-2301-4000-89f2-2025091da413
                level:          0
                resumed:        NO
                subtree:        NO
                streams:        1
                stream 0:
                        pathname:       /dev/nst0
                        start:          ino 133 offset 0
                        end:            ino 1572997 offset 0
                        interrupted:    YES
                        media files:    1
                        media file 0:
                                mfile index:    33554432
                                mfile type:     data
                                mfile size:     211187836911616
                                mfile start:    ino 9583660007044415488 offset 0
                                mfile end:      ino 9583686395323482112 offset 0
                                media label:    ""
                                media id:       4bf9ed40-6377-4926-be62-1bf7b59b1619
xfsdump: Dump Status: SUCCESS

The invalid start and end inode information cause xfsrestore to consider
that non-directory files do not reside in the current media and will
fail to restore them.

The behaviour of an initial restore may succeed if the position of the
tape is such that the data file is encountered before the inventory
file. Subsequent restores will use the invalid on-line inventory and
fail to restore files.

Fix this by correctly unpacking the inventory data. Also handle multiple
streams and untangle the logic where stobj_unpack_sessinfo is called.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 inventory/inv_stobj.c | 38 ++++++++++++++------------------------
 restore/content.c     | 13 +++++--------
 2 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index c20e71c..efaf46d 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -1008,7 +1008,7 @@ stobj_unpack_sessinfo(
         size_t             bufsz,
 	invt_sessinfo_t   *s)
 {
-	uint 		 i;
+	uint 		 i, j;
 	char	         *tmpbuf;
 	char 		 *p = (char *)bufp;
 
@@ -1080,35 +1080,25 @@ stobj_unpack_sessinfo(
 	p += sizeof(invt_session_t);
 
 	/* the array of all the streams belonging to this session */
-	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
-	bcopy(tmpbuf, p, sizeof(invt_stream_t));
 	s->strms = (invt_stream_t *)p;
-	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
+        for (i = 0; i < s->ses->s_cur_nstreams; i++) {
+                xlate_invt_stream((invt_stream_t *)p, 
+				  (invt_stream_t *)tmpbuf, 1);
+                bcopy(tmpbuf, p, sizeof(invt_stream_t));
+                p += sizeof(invt_stream_t);
+        }
 
 	/* all the media files */
 	s->mfiles = (invt_mediafile_t *)p;
-
-#ifdef INVT_DELETION
-	{
-		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
-		uint j;
-		invt_mediafile_t *mmf = s->mfiles;
-		for (i=0; i< s->ses->s_cur_nstreams; i++) {
-			for (j=0; j< s->strms[i].st_nmediafiles;
-			     j++, mmf++)
-				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
-				bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
-				put_invtrecord(tmpfd, &mmf->mf_moid,
-					 sizeof(uuid_t), 0, SEEK_END, 0);
+	for (i=0; i< s->ses->s_cur_nstreams; i++) {
+		for (j=0; j < s->strms[i].st_nmediafiles; j++) {
+			xlate_invt_mediafile((invt_mediafile_t *)p, 
+					     (invt_mediafile_t *)tmpbuf, 1);
+			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
+			p +=  sizeof(invt_mediafile_t);
 		}
-		close(tmpfd);
 	}
-#endif
-	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
-		p += (size_t) (s->strms[i].st_nmediafiles)
-			* sizeof(invt_mediafile_t);
-	}
-
+	
 	/* sanity check the size of the buffer given to us vs. the size it
 	   should be */
 	if ((size_t) (p - (char *) bufp) != bufsz) {
diff --git a/restore/content.c b/restore/content.c
index b3999f9..bbced2d 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
 			 * desc.
 			 */
 			sessp = 0;
-			if (!buflen) {
-				ok = BOOL_FALSE;
-			} else {
-			    /* extract the session information from the buffer */
-			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
-				ok = BOOL_FALSE;
-			    } else {
+			ok = BOOL_FALSE;
+			/* extract the session information from the buffer */
+			if (buflen && 
+			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
 				stobj_convert_sessinfo(&sessp, &sessinfo);
 				ok = BOOL_TRUE;
-			    }
 			}
+
 			if (!ok || !sessp) {
 				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
 				      "on-media session "
-- 
2.31.1

