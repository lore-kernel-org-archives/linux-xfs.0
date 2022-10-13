Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8617C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 03:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJMDPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Oct 2022 23:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJMDPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Oct 2022 23:15:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9297D0CFB
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665630949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKbZRrXx0PfDM02qQ/CpNcNDatA7RHunHC1Au6KU6fM=;
        b=Vdg1EerlfLRFTHP7oWgHugqm3fQT+Kzf2GfV73GJ6BFdRR5Ze283ZDZY2xM6dZONB1mMD1
        j12UHnUE8bH66EdP0AMsPSbgr5KbSVRQcZtfAKu7o5T4t5Ke6yFqDGZML5jZVHQ+HWFZgG
        Rw9st87bUpXbf7+rcExXI4Kt0/fx+jI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-KLtmQII4MKqm8GfkDl41zg-1; Wed, 12 Oct 2022 23:15:48 -0400
X-MC-Unique: KLtmQII4MKqm8GfkDl41zg-1
Received: by mail-pj1-f69.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so422294pjb.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2022 20:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NKbZRrXx0PfDM02qQ/CpNcNDatA7RHunHC1Au6KU6fM=;
        b=AbA/EcTSTLrCZLqPrjRv4VOv15ZGujf/YIsA3PzjYpHMNDzh7uInMMJazmTT4S7C0c
         5q8PngC1PrW8E8vfILvTNpJGfCjNYk0JpjoOa/uIzHlPr00IoNrS6vbnwixtmamnwjAS
         twKN8dZdwv4hWuOyDVt4V7JCaj7afl0XVwMng7IpUab1/83bba2AtAzR9bVe+8GZlxdh
         OiHGQrup4Y52vAA52jvlQX4pX3lOcPGbgILa/BNd0R0OzAsB8/zkhkKYIZcAhRPDlQYw
         uzUwdfJgTAcg470TV1R+Ix1tMSbCi/f7b1dli+rg+6b8Kv52EwQkWcTkXB2sro+2A0MU
         EpnA==
X-Gm-Message-State: ACrzQf2R0zgihJtKt6RxZs+/0gEhA6GfOrUMHAzEc7Fi6WVYSsfOxpU4
        EXMxx0t/SiQ8Yu5olLA3yRuNJsT71Wm7v02VKu8U3GNyrtr4svQHrWbCh2F9O8DHd83gqxM/pis
        QCi9db8aNEeOWLyxgjXVloCz04n0IuwbRujmESh3B7K1hvuk0zBFjRmiSuil0/aZ3NNz9gz8Q
X-Received: by 2002:a17:902:8c92:b0:178:29d4:600f with SMTP id t18-20020a1709028c9200b0017829d4600fmr33408492plo.40.1665630946639;
        Wed, 12 Oct 2022 20:15:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6SnMuL8TOBbzX8fV8T7ww/knCmv+DNOXD5EjJVvUKwmpfES6sDfwdkEwxEv9buyLQ/sAUqqA==
X-Received: by 2002:a17:902:8c92:b0:178:29d4:600f with SMTP id t18-20020a1709028c9200b0017829d4600fmr33408459plo.40.1665630946255;
        Wed, 12 Oct 2022 20:15:46 -0700 (PDT)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b00176b84eb29asm11273085plk.301.2022.10.12.20.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 20:15:45 -0700 (PDT)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 3/4] xfsdump: fix on-media inventory stream packing
Date:   Thu, 13 Oct 2022 14:15:17 +1100
Message-Id: <20221013031518.1815861-4-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013031518.1815861-1-ddouwsma@redhat.com>
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the on-media inventory now being restored for multiple streams we
can see that the restored streams both claim to be for /dev/nst0.

[root@rhel8 xfsdump-dev]# xfsdump -L "Test2" -f /dev/nst0 -M "tape1" -f /dev/nst1 -M "tape2" /boot
...
[root@rhel8 xfsdump-dev]# rm -rf /var/lib/xfsdump/inventory /tmp/test1/*
[root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test2 -f /dev/nst0 -f /dev/nst1 /tmp/test2
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
        fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
        session 0:
                mount point:    rhel8:/boot
                device:         rhel8:/dev/sda1
                time:           Wed Oct 12 15:36:55 2022
                session label:  "Test2"
                session id:     50be3b17-d9f9-414d-885b-ababf660e189
                level:          0
                resumed:        NO
                subtree:        NO
                streams:        2
                stream 0:
                        pathname:       /dev/nst0
                        start:          ino 133 offset 0
                        end:            ino 28839 offset 0
                        interrupted:    YES
                        media files:    1
                        media file 0:
                                mfile index:    2
                                mfile type:     data
                                mfile size:     165675008
                                mfile start:    ino 133 offset 0
                                mfile end:      ino 28839 offset 0
                                media label:    "test"
                                media id:       e2e6978d-5546-4f1f-8c9e-307168071889
                stream 1:
                        pathname:       /dev/nst0
                        start:          ino 133 offset 0
                        end:            ino 28839 offset 0
                        interrupted:    YES
                        media files:    1
                        media file 0:
                                mfile index:    0
                                mfile type:     data
                                mfile size:     166723584
                                mfile start:    ino 28839 offset 0
                                mfile end:      ino 1572997 offset 0
                                media label:    "tape2"
                                media id:       1ad6d919-7159-42fb-a20f-5a2c4e3e24b1
xfsdump: Dump Status: SUCCESS
[root@rhel8 xfsdump-dev]#

Fix this by indexing the stream being packed for the on-media inventory.

Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
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

