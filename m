Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F92C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 07:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJNH7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 03:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJNH7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 03:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DCB317C0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665734341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wmuhRiMUfeqXX9acLWNCY0G1BBH8QsHMianSlQ0tkmY=;
        b=N2qYSVRW4uTQT7VOZWs5PWOoZmfmzJ8Pz8IRrrB11p//slVDwq4cRCN5mmrT9/HKTLeUR9
        EtURGgmo/Dd6W65YG2LWBzidHyR8hKGVMbFg/JQ6AMX4gjTm8FAUq0mrFEyf5lmVKFUFK1
        LXduuFYWzyw05ot6th2aywq27vbpNGo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-tKe_ro9EMfSSh5b8tPfm1Q-1; Fri, 14 Oct 2022 03:58:59 -0400
X-MC-Unique: tKe_ro9EMfSSh5b8tPfm1Q-1
Received: by mail-pl1-f198.google.com with SMTP id f18-20020a170902ce9200b0017f9ac4cfb5so2853884plg.22
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wmuhRiMUfeqXX9acLWNCY0G1BBH8QsHMianSlQ0tkmY=;
        b=rCMxrUX8JD8OAwuwrJvyIuUxrzIvWDPuEcwN9lcCtzFkAPZDetk8Yn/kwvZV3uNrab
         l87iLR3KFiNn/x89o261qEmQzP15me0PtQYuBySNDOcDsprrf89df+6MyWyXvtP4HKQK
         iHeqspE6b7G0OC/rtpRkiUoLAr00Nao/4UabPWzwK+AYq2JQInqwjHO6I57ky5Gj6Fw3
         NCFSkgKzo6cPIAkoBOUQIE6jSJoK0ZACg6A8H1AVIZcq7FA2ZpkZ8XftxC5H4HDCTBpX
         KBUYqoVxAifbC5GBle/DPsaeuiOEmJ/fTM+DbySskKXQuGcAng2AYSUqBsYmoUx9v8Qh
         +1ew==
X-Gm-Message-State: ACrzQf0FWuxYbeZIhEOVwnh69y0Q+C3KrDdZ6oOkzLWP4dEJNVcX1Kxe
        J6kNfjsNVG82y1a8AA3Xtud3NQwXNotF58tsjP9cq4/MMevoqBGUCAphI6WRIXyVvoA5pmfddFM
        8OmEMPjRBvOrNDEcAclmm9rd502H4mOKtY7n0JnGw5VZ09tBVn8tuKTFyG4+WtH4WUfX08FKd
X-Received: by 2002:a05:6a00:18a9:b0:563:95bd:269e with SMTP id x41-20020a056a0018a900b0056395bd269emr4061029pfh.49.1665734338405;
        Fri, 14 Oct 2022 00:58:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Fo1yyingVyQ/LOZmlP4tS4u1i4XOhqgqcUXMjY4btt7FX/sRHBuqQRe42v61JSxh5DBjpCw==
X-Received: by 2002:a05:6a00:18a9:b0:563:95bd:269e with SMTP id x41-20020a056a0018a900b0056395bd269emr4061008pfh.49.1665734338009;
        Fri, 14 Oct 2022 00:58:58 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id nn13-20020a17090b38cd00b0020b21019086sm8550382pjb.3.2022.10.14.00.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:58:57 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 1/4] xfsrestore: fix on-media inventory media unpacking
Date:   Fri, 14 Oct 2022 18:58:44 +1100
Message-Id: <20221014075847.2047427-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221014075847.2047427-1-ddouwsma@redhat.com>
References: <20221014075847.2047427-1-ddouwsma@redhat.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 inventory/inv_stobj.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index c20e71c..b461666 100644
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
-		}
-		close(tmpfd);
-	}
-#endif
 	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
-		p += (size_t) (s->strms[i].st_nmediafiles)
-			* sizeof(invt_mediafile_t);
+		for(j = 0; j < s->strms[i].st_nmediafiles; j++) {
+			xlate_invt_mediafile((invt_mediafile_t *)p,
+					     (invt_mediafile_t *)tmpbuf, 1);
+			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
+			p +=  sizeof(invt_mediafile_t);
+		}
 	}
 
 	/* sanity check the size of the buffer given to us vs. the size it
-- 
2.31.1

