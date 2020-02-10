Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8235C352A3
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 15:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE8E2080C
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 15:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZ5cJhPB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgBJPmk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:42:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21620 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726816AbgBJPmk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Feb 2020 10:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581349358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Z9+Cz2iEGZG9sFK4xGHYvpvxqm1B7W9IDatw3D4fVU=;
        b=KZ5cJhPBzo16NTFRNeSs3mf+iiaES4iUDPUKCDTbL48r0Bq/K3iVW29J+KPL9n2fxz9/IO
        VX0wdge4sJCekLztSAfozeODOdgyYBJzmYSA1zgWQAFolAd4zhkUEb6nre0Vy6bgnHMcVn
        Y9nshkTnTWsMTAofzRO+1+VxUJGa3ZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-Zjh_sm5pNni10svekwVLMQ-1; Mon, 10 Feb 2020 10:42:31 -0500
X-MC-Unique: Zjh_sm5pNni10svekwVLMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C26481052BA6;
        Mon, 10 Feb 2020 15:42:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8817D60BF1;
        Mon, 10 Feb 2020 15:42:29 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     John Jore <john@jore.no>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix bad next_unlinked field
Message-ID: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
Date:   Mon, 10 Feb 2020 09:42:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As of xfsprogs-4.17 we started testing whether the di_next_unlinked field
on an inode is valid in the inode verifiers. However, this field is never
tested or repaired during inode processing.

So if, for example, we had a completely zeroed-out inode, we'd detect and
fix the broken magic and version, but the invalid di_next_unlinked field
would not be touched, fail the write verifier, and prevent the inode from
being properly repaired or even written out.

Fix this by checking the di_next_unlinked inode field for validity and
clearing it if it is invalid.

Reported-by: John Jore <john@jore.no>
Fixes: 2949b4677 ("xfs: don't accept inode buffers with suspicious unlinked chains")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 8af2cb25..c5d2f350 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2272,6 +2272,7 @@ process_dinode_int(xfs_mount_t *mp,
 	const int		is_free = 0;
 	const int		is_used = 1;
 	blkmap_t		*dblkmap = NULL;
+	xfs_agino_t		unlinked_ino;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2351,6 +2352,23 @@ process_dinode_int(xfs_mount_t *mp,
 		}
 	}
 
+	unlinked_ino = be32_to_cpu(dino->di_next_unlinked);
+	if (!xfs_verify_agino_or_null(mp, agno, unlinked_ino)) {
+		retval = 1;
+		if (!uncertain)
+			do_warn(_("bad next_unlinked 0x%x on inode %" PRIu64 "%c"),
+				(__s32)dino->di_next_unlinked, lino,
+				verify_mode ? '\n' : ',');
+		if (!verify_mode) {
+			if (!no_modify) {
+				do_warn(_(" resetting next_unlinked\n"));
+				clear_dinode_unlinked(mp, dino);
+				*dirty = 1;
+			} else
+				do_warn(_(" would reset next_unlinked\n"));
+		}
+	}
+
 	/*
 	 * We don't bother checking the CRC here - we cannot guarantee that when
 	 * we are called here that the inode has not already been modified in

