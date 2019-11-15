Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87500C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF1F206D9
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 19:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIHmDDzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKOTfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 14:35:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52441 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726912AbfKOTff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 14:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573846534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=w2MfITMLd3mc2bmC1hdCNCQhZV5T6IDDPYoyDliOQKs=;
        b=MIHmDDzuZrUDzeR8l13vLn++jq8EgzTS2a93IYyqUzCSQCINnLDnjrnWp03adUf20vFZqU
        q5TvJ83Hyx8/wUegJ6AFA9/SN3OSgAYK/VTl5K74IQKYZeRvdR1cC7GhX1u7N94URUKER5
        CFiIO3yVfCOcYX03G+gNNfwSHX5F+5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-_DwsqG2CN4CN3gl2dLQJKg-1; Fri, 15 Nov 2019 14:35:33 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37B1A802FA4
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 19:35:32 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F50F5D6D0
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2019 19:35:31 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: remove stray libxfs whitespace
Message-ID: <57d4cc5d-6ec5-6977-1903-17a285202d79@redhat.com>
Date:   Fri, 15 Nov 2019 13:35:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: _DwsqG2CN4CN3gl2dLQJKg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Not quite sure how these crept in but now's as good a time as any
to remove stray newline deltas vs. the kernel code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5dba5fbc..6ca43c73 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -755,6 +755,7 @@ struct xfs_scrub_metadata {
 #  define XFS_XATTR_LIST_MAX 65536
 #endif
=20
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -825,7 +826,6 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY=09     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT=09     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS=09     _IOR ('X', 128, struct xfs_inumbers_req)
-
 /*=09XFS_IOC_GETFSUUID ---------- deprecated 140=09 */
=20
 /* reflink ioctls; these MUST match the btrfs ioctl definitions */
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index fbdce4d6..4859b739 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -15,6 +15,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
=20
+
 /*
  * Check that none of the inode's in the buffer have a next
  * unlinked field of 0.
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index 3a09ee76..7fa0c184 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -11,6 +11,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
=20
+
 /*
  * Add a locked inode to the transaction.
  *

