Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3714EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 07:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJNH7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 03:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJNH7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 03:59:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7A7317CE
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665734343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nwOMt3ttbO8Px4J5UR+PbpFZx/ZDEh5Tw+F9P0+vS5w=;
        b=eqtda1Fw34JD7N1/33viINvp1qtwx9iA/KO2La+bHbM1NhVUk6edzokg5tHUGMX3BsU4WK
        v06TKje0h44+sqLpVDw956pDRov+4d/vr+GfYCF5KO+4i/DDrQJLYbnNr3wQmxFFFTsT4C
        QR4QXNViNxNtPOy1PabNCtpufv8tXwE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-436-FeobtQFmOUmUsLVqOKtTVg-1; Fri, 14 Oct 2022 03:59:02 -0400
X-MC-Unique: FeobtQFmOUmUsLVqOKtTVg-1
Received: by mail-pl1-f197.google.com with SMTP id o1-20020a170902d4c100b00177f59a9889so2855913plg.13
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nwOMt3ttbO8Px4J5UR+PbpFZx/ZDEh5Tw+F9P0+vS5w=;
        b=Q1Ze1N3LrxykmFrieFlKLx2qAanJZ0nUduI+BJ2aen1wbx/PwrWWOTyAnt7PS71ZPw
         FDLEOoNIAUS6HY0nvRnn/6dlCuwkhOejRYJJ+vVY97KmNSKlxxRcpvGXf2hNvH4xSLJD
         x3kI9ICeWo5gCdceU9wqeHuvLO4F3IiiEen/Igl06o7/mCsiumtZL5cnk3W5uI3DcemS
         EhQdZlcPBVp9qljEpV6yRqSwUtCN2GbEVCPElEc1itXE1a38VPtvmcsMHmKhg2cce3A9
         n8Fg373wW9zFseyfg7aTGFN4XgjdIc1B77IbvPCZzch0XvgK+XwqSrlPSkz1GnwkDWx6
         ZQTw==
X-Gm-Message-State: ACrzQf0exmHWTrIAdUbUQxX4pvNZey0z6agLGkKjE7wZxAzaJyhkZriz
        cPnFep5KNZi4y6h2liv08enFWuSiWD9whvLa6s90VQRQyMxfP/4LmFvg8ai61oMmkcraZYu7oYV
        yQeKK2Qt5Z9H8P7WCZUdM8m7O8oaohdaTzxZR1YnQoTUpwqiTt/jCNAnxyeziCbP4/BFVis+N
X-Received: by 2002:a17:90a:1c1:b0:20a:e745:bc30 with SMTP id 1-20020a17090a01c100b0020ae745bc30mr16405750pjd.131.1665734340734;
        Fri, 14 Oct 2022 00:59:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5oIK/Rp2X/JjP0PAJRXvXLADAV8USV+5IvmivYJC8O/LIdHzfEexeM97R5Eu5832XgkPGSgg==
X-Received: by 2002:a17:90a:1c1:b0:20a:e745:bc30 with SMTP id 1-20020a17090a01c100b0020ae745bc30mr16405721pjd.131.1665734340307;
        Fri, 14 Oct 2022 00:59:00 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id nn13-20020a17090b38cd00b0020b21019086sm8550382pjb.3.2022.10.14.00.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:58:59 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 2/4] xfsrestore: fix on-media inventory stream unpacking
Date:   Fri, 14 Oct 2022 18:58:45 +1100
Message-Id: <20221014075847.2047427-3-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221014075847.2047427-1-ddouwsma@redhat.com>
References: <20221014075847.2047427-1-ddouwsma@redhat.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

