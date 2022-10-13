Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED9AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 03:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJMDPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJMDPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 23:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2B3D03BB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665630946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UUn9mTE/CtTxZ1M+0xe9Y+UJkklaVOEWr1FvYYh+nxE=;
        b=DCKT3MB+sRPys3jWupDGHsEZp3QgfBY2bVpFCTZg9sH7jtURxUJ+pGscianDq9u3odmsCV
        GHmt0IYxFrTAywZcViNCrZxAB472JmJF7pzkglRp4mlcVRv93JK+ucbWyPojJPyBRFe0ak
        84DAQNZyrGeFQGMgdtH41yIIgJo8feo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-1QY3H4aNMRilGcRIWwtUag-1; Wed, 12 Oct 2022 23:15:45 -0400
X-MC-Unique: 1QY3H4aNMRilGcRIWwtUag-1
Received: by mail-pl1-f199.google.com with SMTP id d18-20020a170903231200b0018031042fb6so485059plh.19
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUn9mTE/CtTxZ1M+0xe9Y+UJkklaVOEWr1FvYYh+nxE=;
        b=nwCoiI/douHBBjqRrQIvMmyelA8QE3/+x63hF6kjs0Z6vEXjC91xL7x6mLWGys/zkC
         3zV0GpmIXzGMQSMlueMyUo8ZzCgYcidnDgNF9Cz5yQm88TxwfShVWnRyBLZu4WXLPHBc
         ENwRgmXoHZdZHOa5/a/uaxkZj+7qwFGsLokYwi0T0oIJdQbMy6ENZzj7nu5ng2/M18aP
         p7WJkjiUL/SgzNsGN3CowKbymbDtq3g8BlkchxiiTEVaCZw6s56xJzDLRYp/lxdyBkA/
         +8m3pGthI1zDIcQCtGbKSRtmsYY+9UzCp1nj756YqXXjKGiKm2N0mzEBzEzMJFAY2bQV
         UOfQ==
X-Gm-Message-State: ACrzQf09uWuhGo++/ktn6JpgkwgPJ7y4adsED5Kyv2d5Q0pR8ddio7LE
        2inbV+Civ7zx7lM//lNgrm9d9C93dTlPiHKMD4Ovcg8tgxj57Pysb8W6dxdGzkVXxETH6swnmNZ
        QbberfRHBKkH6RnXctsREG3XFps6aZrYWgkyOKZ5qbVyu/cDrnsnIk2t5X3yv6MdHVyg0ExOL
X-Received: by 2002:a17:90a:ad82:b0:20c:feb2:bceb with SMTP id s2-20020a17090aad8200b0020cfeb2bcebmr8544927pjq.93.1665630944206;
        Wed, 12 Oct 2022 20:15:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM78uFKwlRyt3mjZGkwKdrXlyqB/sIwo0F+QNSHpQ6HUGvGWkFzWCSP6GwLS/5pIfPBEQSoKdQ==
X-Received: by 2002:a17:90a:ad82:b0:20c:feb2:bceb with SMTP id s2-20020a17090aad8200b0020cfeb2bcebmr8544901pjq.93.1665630943801;
        Wed, 12 Oct 2022 20:15:43 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00176b84eb29asm11273085plk.301.2022.10.12.20.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 20:15:43 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 2/4] xfsrestore: fix on-media inventory stream unpacking
Date:   Thu, 13 Oct 2022 14:15:16 +1100
Message-Id: <20221013031518.1815861-3-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013031518.1815861-1-ddouwsma@redhat.com>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsdump can create multiple streams, when restoring the online inventory
with multiple streams we fail to process these and assert when the
inventory buffer is not fully decoded.

[root@rhel8 ~]# xfsdump -L "Test1" -f /dev/nst0 -M tape1 -f /dev/nst1 -M tape2 /boot
xfsdump: using scsi tape (drive_scsitape) strategy
xfsdump: using scsi tape (drive_scsitape) strategy
xfsdump: version 3.1.8 (dump format 3.0) - type ^C for status and control
xfsdump: level 0 dump of rhel8:/boot
xfsdump: dump date: Thu Oct  6 13:50:45 2022
xfsdump: session id: aa25fa48-4493-45c7-9027-61e53e486445
xfsdump: session label: "Test1"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: identifying stream starting points
xfsdump: stream 0: ino 133 offset 0 to ino 28839 offset 0
xfsdump: stream 1: ino 28839 offset 0 to end
xfsdump: ino map construction complete
xfsdump: estimated dump size: 328720704 bytes
xfsdump: estimated dump size per stream: 164375728 bytes
xfsdump: /var/lib/xfsdump/inventory created
xfsdump: drive 0: preparing drive
xfsdump: drive 1: preparing drive
xfsdump: drive 1: creating dump session media file 0 (media 0, file 0)
xfsdump: drive 1: dumping ino map
xfsdump: drive 1: dumping non-directory files
xfsdump: drive 0: creating dump session media file 0 (media 0, file 0)
xfsdump: drive 0: dumping ino map
xfsdump: drive 0: dumping directories
xfsdump: drive 0: dumping non-directory files
xfsdump: drive 1: ending media file
xfsdump: drive 1: media file size 166723584 bytes
xfsdump: drive 1: waiting for synchronized session inventory dump
xfsdump: drive 0: ending media file
xfsdump: drive 0: media file size 165675008 bytes
xfsdump: drive 0: waiting for synchronized session inventory dump
xfsdump: drive 0: dumping session inventory
xfsdump: drive 0: beginning inventory media file
xfsdump: drive 0: media file 1 (media 0, file 1)
xfsdump: drive 0: ending inventory media file
xfsdump: drive 0: inventory media file size 2097152 bytes
xfsdump: drive 0: writing stream terminator
xfsdump: drive 0: beginning media stream terminator
xfsdump: drive 0: media file 2 (media 0, file 2)
xfsdump: drive 0: ending media stream terminator
xfsdump: drive 0: media stream terminator size 1048576 bytes
xfsdump: drive 1: dumping session inventory
xfsdump: drive 1: beginning inventory media file
xfsdump: drive 1: media file 1 (media 0, file 1)
xfsdump: drive 1: ending inventory media file
xfsdump: drive 1: inventory media file size 2097152 bytes
xfsdump: drive 1: writing stream terminator
xfsdump: drive 1: beginning media stream terminator
xfsdump: drive 1: media file 2 (media 0, file 2)
xfsdump: drive 1: ending media stream terminator
xfsdump: drive 1: media stream terminator size 1048576 bytes
xfsdump: dump size (non-dir files) : 328189016 bytes
xfsdump: dump complete: 4 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /dev/nst0 OK (success)
xfsdump:   stream 1 /dev/nst1 OK (success)
xfsdump: Dump Status: SUCCESS
[root@rhel8 ~]# xfsdump -I
file system 0:
	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
	session 0:
		mount point:	rhel8:/boot
		device:		rhel8:/dev/sda1
		time:		Thu Oct  6 13:50:45 2022
		session label:	"Test1"
		session id:	aa25fa48-4493-45c7-9027-61e53e486445
		level:		0
		resumed:	NO
		subtree:	NO
		streams:	2
		stream 0:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	NO
			media files:	2
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	165675008
				mfile start:	ino 133 offset 0
				mfile end:	ino 28839 offset 0
				media label:	"tape1"
				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
			media file 1:
				mfile index:	1
				mfile type:	inventory
				mfile size:	2097152
				media label:	"tape1"
				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
		stream 1:
			pathname:	/dev/nst1
			start:		ino 28839 offset 0
			end:		ino 1572997 offset 0
			interrupted:	NO
			media files:	2
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	166723584
				mfile start:	ino 28839 offset 0
				mfile end:	ino 1572997 offset 0
				media label:	"tape2"
				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
			media file 1:
				mfile index:	1
				mfile type:	inventory
				mfile size:	2097152
				media label:	"tape2"
				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
xfsdump: Dump Status: SUCCESS
[root@rhel8 ~]# mv /var/lib/xfsdump/inventory /var/lib/xfsdump/inventory_two_sessions
[root@rhel8 ~]# xfsdump -I
xfsdump: Dump Status: SUCCESS

[root@rhel8 ~]# xfsrestore -L Test1 -f /dev/nst0 /tmp/test1/
xfsrestore: using scsi tape (drive_scsitape) strategy
xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
xfsrestore: searching media for dump
xfsrestore: preparing drive
xfsrestore: examining media file 2
xfsrestore: found dump matching specified label:
xfsrestore: hostname: rhel8
xfsrestore: mount point: /boot
xfsrestore: volume: /dev/sda1
xfsrestore: session time: Thu Oct  6 13:50:45 2022
xfsrestore: level: 0
xfsrestore: session label: "Test1"
xfsrestore: media label: "tape1"
xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
xfsrestore: session id: aa25fa48-4493-45c7-9027-61e53e486445
xfsrestore: media id: adb31f2a-f026-4597-a20a-326f28ecbaf1
xfsrestore: searching media for directory dump
xfsrestore: rewinding
xfsrestore: examining media file 0
xfsrestore: reading directories
xfsrestore: 9 directories and 320 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: examining media file 1
xfsrestore: inv_stobj.c:1119: stobj_unpack_sessinfo: Assertion `(size_t) ( p - (char *) bufp ) == bufsz' failed.
Aborted (core dumped)

Make sure we unpack multiple streams when restoring the online
inventory from media.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 inventory/inv_stobj.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index b461666..025d431 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
 		return BOOL_FALSE;
 	}
 
+	/* get the seshdr and then, the remainder of the session */
 	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
 	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
-
-	/* get the seshdr and then, the remainder of the session */
 	s->seshdr = (invt_seshdr_t *)p;
 	s->seshdr->sh_sess_off = -1;
 	p += sizeof(invt_seshdr_t);
 
-
 	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
 	bcopy (tmpbuf, p, sizeof(invt_session_t));
 	s->ses = (invt_session_t *)p;
 	p += sizeof(invt_session_t);
 
 	/* the array of all the streams belonging to this session */
-	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
-	bcopy(tmpbuf, p, sizeof(invt_stream_t));
 	s->strms = (invt_stream_t *)p;
-	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
+	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
+		xlate_invt_stream((invt_stream_t *)p,
+				  (invt_stream_t *)tmpbuf, 1);
+		bcopy(tmpbuf, p, sizeof(invt_stream_t));
+		p += sizeof(invt_stream_t);
+	}
 
 	/* all the media files */
 	s->mfiles = (invt_mediafile_t *)p;
-- 
2.31.1

