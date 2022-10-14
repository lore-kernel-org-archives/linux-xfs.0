Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD294C43219
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 07:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJNH7M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 03:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJNH7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 03:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C85317C0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665734348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vV5nbGN+Fjt+fqoenGe4Sq/4qYnTyDa9tFvq3HrYH8w=;
        b=LcQ3J2Iz1k7kdOg5sh2UXDBENXapGGjd1sS3J8LmLW89SkUshaGAjljqvdnlAIw7N+9KRh
        6IGyOdzekx/2Q3isYf26/VIjf8hbxbFt+wENPA7wyfSaolhQF0cqQqW31C0qDH7zf2O9cs
        F4r43Tega3LnNIZ0oHjTlD93oz5Sse4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-wuPO3_LmNbGaI2KErxEFXQ-1; Fri, 14 Oct 2022 03:59:04 -0400
X-MC-Unique: wuPO3_LmNbGaI2KErxEFXQ-1
Received: by mail-pg1-f200.google.com with SMTP id p18-20020a63e652000000b0046b27534651so841533pgj.17
        for <linux-xfs@vger.kernel.org>; Fri, 14 Oct 2022 00:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vV5nbGN+Fjt+fqoenGe4Sq/4qYnTyDa9tFvq3HrYH8w=;
        b=dHo/DktQ4N+B3Q5ahYVEW7kVbID2c2NeAVn6TyYXe5nCrecCF9k3TBLkW3RDSnBobr
         Nq702ugRkhoBguTL4etDwki/lNke2i+1b1+0UQiszui/opZlP6pFDs/w+lnuGbhYb1Vj
         fH4+ETL8zMVytLwBgJz6BpLUabIbD/3+aKqTc72ASACovNenz6tg14goRZecVxQtV7OS
         SCi8bxfByM1OQaGCtUGDdHVkVL+vmeJOr7Md+Q45EVL7dpyZs7RXxrVluWgpMI//0mRo
         h3LuLZeR32fOx7EjtF3d/OSGs2L4F1qqqmyw+Jco3EvN0xiTJ3ml5ki8K+1+KxKrE5wm
         f7qw==
X-Gm-Message-State: ACrzQf3sDg8vMrjhKewokVZv/HURaSSCmSn7Zb/tK66DOW1tEdchAppt
        BClwg/KTsWInyEb/SzRm3EbUlqjdsEbjK+s+n1rKUf0QoN+Dhq463GT3AvFMUjY7N7Yw18o4pFm
        wKtDVPFXW4REpjJRx75Qk/qeOQp5xyVjbHmGDC2dO26OY9HDPa93Z9wkxR7tHOQ/VjOrKlrPt
X-Received: by 2002:a63:c4e:0:b0:45f:795:c20a with SMTP id 14-20020a630c4e000000b0045f0795c20amr3537300pgm.559.1665734343155;
        Fri, 14 Oct 2022 00:59:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4K+hgvZ9k9EuIkusvdWqZSvhuhksiU29dnNVcHDT8/Gg/OxAsOB1C6SlQAkA/6AkR4rtJF0w==
X-Received: by 2002:a63:c4e:0:b0:45f:795:c20a with SMTP id 14-20020a630c4e000000b0045f0795c20amr3537278pgm.559.1665734342806;
        Fri, 14 Oct 2022 00:59:02 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id nn13-20020a17090b38cd00b0020b21019086sm8550382pjb.3.2022.10.14.00.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:59:02 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 3/4] xfsdump: fix on-media inventory stream packing
Date:   Fri, 14 Oct 2022 18:58:46 +1100
Message-Id: <20221014075847.2047427-4-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221014075847.2047427-1-ddouwsma@redhat.com>
References: <20221014075847.2047427-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the on-media inventory now being restored for multiple streams we
can see that the restored streams both claim to be for /dev/nst0.

[root@rhel8 xfsdump-dev]# xfsdump -L "Test" -f /dev/nst0 -M tape1 -f /dev/nst1 -M tape2 /boot
...
[root@rhel8 ~]# rm -rf /var/lib/xfsdump/inventory
[root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test -f /dev/nst0 -f /dev/nst1 /tmp/test
restore/xfsrestore: using scsi tape (drive_scsitape) strategy
restore/xfsrestore: using scsi tape (drive_scsitape) strategy
restore/xfsrestore: version 3.1.10 (dump format 3.0) - type ^C for status and control
...
restore/xfsrestore: Restore Summary:
restore/xfsrestore:   stream 0 /dev/nst0 OK (success)
restore/xfsrestore:   stream 1 /dev/nst1 ALREADY_DONE (another stream completed the operation)
restore/xfsrestore: Restore Status: SUCCESS
[root@rhel8 xfsdump-dev]# xfsdump -I
file system 0:
	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
	session 0:
		mount point:	rhel8:/boot
		device:		rhel8:/dev/sda1
		time:		Fri Oct 14 18:31:40 2022
		session label:	"Test"
		session id:	96538a3d-2af8-4a79-8865-afec6e3e55f4
		level:		0
		resumed:	NO
		subtree:	NO
		streams:	2
		stream 0:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	YES
			media files:	1
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	165675008
				mfile start:	ino 133 offset 0
				mfile end:	ino 28839 offset 0
				media label:	"tape1"
				media id:	8a9d0ced-61f6-4332-a0c1-f1e38641c4e6
		stream 1:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	YES
			media files:	1
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	166723584
				mfile start:	ino 28839 offset 0
				mfile end:	ino 1572997 offset 0
				media label:	"tape2"
				media id:	7d569377-6bfb-4c02-b299-4dbe753bb048
xfsdump: Dump Status: SUCCESS
[root@rhel8 xfsdump-dev]#

Fix this by indexing the stream being packed for the on-media inventory.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 inventory/inv_stobj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 025d431..fb4d93a 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -798,7 +798,7 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 	sesbuf += sizeof(invt_session_t);
 
 	for (i = 0; i < ses->s_cur_nstreams; i++) {
-		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
+		xlate_invt_stream(&strms[i], (invt_stream_t *)sesbuf, 1);
 		sesbuf += sizeof(invt_stream_t);
 	}
 
-- 
2.31.1

