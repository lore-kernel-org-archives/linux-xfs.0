Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B18C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 05:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiI1Fxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 01:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiI1Fxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 01:53:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CAB10FE06
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664344410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0zml6KOfyMgziivNv3YuNmIlroGjpBThHE9t4G6pP7M=;
        b=QEB9QRIcDz2bICCs6sqNZBYKtOrRvTXk0JOs4Vg3RrOLkTal4AVKOi8es4gOhDl2AgWYl3
        geBwx0Fi3OQaFKaHe8zNjun8yTCtLdhH1SzNp0LOUopUK/1jePCReVys9vUzsel8SJyC+D
        /Mo0yTcj+dAnt7V3cge5XWqI9mKpmwg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-438-ZaZyKVslNiqw7qxVlMc0ww-1; Wed, 28 Sep 2022 01:53:28 -0400
X-MC-Unique: ZaZyKVslNiqw7qxVlMc0ww-1
Received: by mail-pf1-f200.google.com with SMTP id q22-20020a62e116000000b005428fb66124so6859114pfh.16
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 22:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0zml6KOfyMgziivNv3YuNmIlroGjpBThHE9t4G6pP7M=;
        b=FWx5ZSM5Mm7DaCRw+aIrjsE0aUzI8x/tbeyXWL6mqlAh1KOrdbYVAzJH3E9Dt/AX0W
         EckJKDjvsqpylpZRQCHEp14AH7LJpPZyjM5YOe4BCslQVefQNJEt1BB46etvBbSMe6+G
         k6B0IbCtnk6HNlOPua8eN0rO0MFPF4O4Afbw8um9xlccIG32pua26RouRiOowNZXt/+M
         4xxWG5l2B3bHEFwut5wYMx1ppeiVX4GA7kcFLOAbOYP9w58/+OD8SUujjH95U6tiqZDV
         4Noyn13CuwRQf4GhPT7QRVLqhsQfyoUuWTJHXO3T5p1gxueWwSsKP84x1bWOrhwfj/C9
         UDNw==
X-Gm-Message-State: ACrzQf3u3uYQCzkkSS4whNWUQhRg8V+egS+DCoGuHKMzjnlxibEe/SHj
        dfxdhYAw1e50dMLoR4lK9EDnD+9jU0KfK+Q27m3a+9+ZgsJxqnRD4HS/elyj4kPbH8DsoWfcGzA
        bdCIu/jj8M9kp9lnlF2Y6oyrij+B2JvhDEHCOfV7iZ2xblulpXWaQAIU66gi48od/1FkiVtgU
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id j15-20020a056a00174f00b0053768458b1amr33788916pfc.68.1664344407154;
        Tue, 27 Sep 2022 22:53:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7miIsnE7PMKr1GMNG8BmTXjDM+rVwteDnqHtEkRqtBwoIF2W6xBq+dxdgG4Mox/Opw7HNz5Q==
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id j15-20020a056a00174f00b0053768458b1amr33788898pfc.68.1664344406763;
        Tue, 27 Sep 2022 22:53:26 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id o129-20020a62cd87000000b005544229b992sm2912971pfg.22.2022.09.27.22.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 22:53:26 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 1/3] xfsrestore: fix inventory unpacking
Date:   Wed, 28 Sep 2022 15:53:05 +1000
Message-Id: <20220928055307.79341-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220928055307.79341-1-ddouwsma@redhat.com>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When xfsrestore reads the inventory from tape media it fails to convert
media file records from bigendian. If the xfsdump inventory is not
available xfsrestore will write this invalid record to the on-line
inventory.

[root@rhel8 ~]# xfsdump -L Test1 -M "" -f /dev/st0 /boot > /dev/null
[root@rhel8 ~]# xfsdump -L Test2 -M "" -f /dev/st0 /boot > /dev/null
[root@rhel8 ~]# rm -rf /var/lib/xfsdump/inventory/
[root@rhel8 ~]# mt -f /dev/nst0 asf 2
[root@rhel8 ~]# xfsrestore -f /dev/nst0 -L Test2 /tmp/test2
xfsrestore: using scsi tape (drive_scsitape) strategy
xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
xfsrestore: searching media for dump
xfsrestore: preparing drive
xfsrestore: examining media file 3
xfsrestore: found dump matching specified label:
xfsrestore: hostname: rhel8
xfsrestore: mount point: /boot
xfsrestore: volume: /dev/sda1
xfsrestore: session time: Tue Sep 27 16:05:28 2022
xfsrestore: level: 0
xfsrestore: session label: "Test2"
xfsrestore: media label: ""
xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
xfsrestore: session id: 62402423-7ae0-49ed-8ecb-9e5bc7642b91
xfsrestore: media id: 47ba45ca-3417-4006-ab10-3dc6419b83e2
xfsrestore: incorporating on-media session inventory into online inventory
xfsrestore: /var/lib/xfsdump/inventory created
xfsrestore: using on-media session inventory
xfsrestore: searching media for directory dump
xfsrestore: rewinding
xfsrestore: examining media file 0
xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
xfsrestore: examining media file 1
xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
xfsrestore: examining media file 2
xfsrestore: reading directories
xfsrestore: 9 directories and 320 entries processed
xfsrestore: directory post-processing
xfsrestore: restore complete: 0 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /dev/nst0 OK (success)
xfsrestore: Restore Status: SUCCESS
[root@rhel8 ~]# xfsdump -I
file system 0:
        fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
        session 0:
                mount point:    rhel8:/boot
                device:         rhel8:/dev/sda1
                time:           Tue Sep 27 16:05:28 2022
                session label:  "Test2"
                session id:     62402423-7ae0-49ed-8ecb-9e5bc7642b91
                level:          0
                resumed:        NO
                subtree:        NO
                streams:        1
                stream 0:
                        pathname:       /dev/st0
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
                                media id:       47ba45ca-3417-4006-ab10-3dc6419b83e2
xfsdump: Dump Status: SUCCESS
[root@rhel8 ~]#
[root@rhel8 ~]# ls /tmp/test2
efi  grub2  loader

The invalid start and end inode information cause xfsrestore to consider
that non-directory files do not reside in the current media and will
fail to restore them.

The behaviour of an initial restore may succeed if the position of the
tape is such that the data file is encountered before the inventory
file, or if there is only one dump session on tape, xfsrestore is
somewhat inconsistent in this regard. Subsequent restores will use the
invalid on-line inventory and fail to restore files.

Fix this by correctly unpacking the inventory data.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 inventory/inv_stobj.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index c20e71c..5075ee4 100644
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
 
@@ -1087,26 +1087,13 @@ stobj_unpack_sessinfo(
 
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
-	}
-#endif
-	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
-		p += (size_t) (s->strms[i].st_nmediafiles)
-			* sizeof(invt_mediafile_t);
 	}
 
 	/* sanity check the size of the buffer given to us vs. the size it
-- 
2.31.1

