Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2D6C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 03:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJMDPv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJMDPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 23:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15FD9DF8E
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665630944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wmuhRiMUfeqXX9acLWNCY0G1BBH8QsHMianSlQ0tkmY=;
        b=cDBYeCioz5Ylq0nOSbrPei7nc8mXM61MkA1D1bEYWL4dMwI0/KLYPYELiYYtgE4P2qXWKU
        +/191ha5FRrJ9ZfHRdWUybwEbfwGj2fgr9uOlfoSUz3ItpeKOyo0fMwLutu65I6eAmkxWO
        I91pXd4RB56qkK4WUl/Fv0zKRo8lVNE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-2RqiQep3N4eGOb0cnsK2-w-1; Wed, 12 Oct 2022 23:15:43 -0400
X-MC-Unique: 2RqiQep3N4eGOb0cnsK2-w-1
Received: by mail-pf1-f198.google.com with SMTP id cu10-20020a056a00448a00b00562f2ff1058so456199pfb.23
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wmuhRiMUfeqXX9acLWNCY0G1BBH8QsHMianSlQ0tkmY=;
        b=vrEb++phpDEMrolzqS4aY3a+TYx7A0ihW+7E8iXpyHHV2dNFe5ceAtI3dfFGux6V5B
         BFKj9s358a1fjAL6WElie5QY0TxDoyxQiUmVmDXK8NoHaRApTj2tB3F9Re2QUE6OxaXZ
         KV2Y/8oi3VxQDwFDbjUAUXnn86UERGAOvGySPHLb9HoanHyX4HhsoXerNJo8i1xe0dHn
         FHWjjjzcCkT4gPJ6aTEqmo+D//hdGpgAe3eis7E/PFbsxEI/Pj8Fn8xjHgLxi0SR8DPh
         m+VEcv/QNs/i57hTM98RXdKCCqpNN52oPeGM+zSUul/XwlvvngNMTH/gaI2+XU6wzdnG
         tGmQ==
X-Gm-Message-State: ACrzQf0KxP7Jukv4Ctco2roc7bWkBP+Nr/RdqKlVoMaUjPrUNJSAzfCI
        QhiNJ1gcDHOiewJaM3fIMzxs6pSl/P/QhcqbxlLFaUKPvpeiOJMkywTrR9uZVi3wkpUYJ+PaM3O
        vbTf4rHl7d2CtncQVBS1vjR34Bw2NgRVYVU3YpsjU/uC8l5NNOFrHlOtLe7qSx5CElhwRCyMI
X-Received: by 2002:a17:90b:350d:b0:20d:5438:f59a with SMTP id ls13-20020a17090b350d00b0020d5438f59amr8461423pjb.41.1665630942037;
        Wed, 12 Oct 2022 20:15:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4hO4hRAlN/Ux0T8yrOU6+80QeULqWjLpOGI8M3NS1Ap5gqfN5qcf67iIoCgEG9MwtHZubUig==
X-Received: by 2002:a17:90b:350d:b0:20d:5438:f59a with SMTP id ls13-20020a17090b350d00b0020d5438f59amr8461401pjb.41.1665630941679;
        Wed, 12 Oct 2022 20:15:41 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00176b84eb29asm11273085plk.301.2022.10.12.20.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 20:15:41 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 1/4] xfsrestore: fix on-media inventory media unpacking
Date:   Thu, 13 Oct 2022 14:15:15 +1100
Message-Id: <20221013031518.1815861-2-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013031518.1815861-1-ddouwsma@redhat.com>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
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

