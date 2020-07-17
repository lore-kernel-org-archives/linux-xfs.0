Return-Path: <SRS0=+9Bg=A4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889C4C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 11:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C42E20775
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jul 2020 11:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5susvLD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgGQL7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jul 2020 07:59:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725950AbgGQL7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jul 2020 07:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594987163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/d4ategapYmq7jTNfltCzCzaKQ6L6d3r2+5Pzn4gj0g=;
        b=B5susvLDbMded/eBZD7lWs/yrYNFhz8bBtSCICd8PLIW41kYpILojjUtp9ob1yoSlElvzU
        8fNS9neijXJuEZ4qcWdvIdunaac0FGIJCecx5YYICbh3qmRi8DK152O+lGKZNlUUQV8yKn
        orpUYopbGldM8macM+hoyHd1Z/IJ0jY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-H4TPl8KaODO93KNkVw6Mnw-1; Fri, 17 Jul 2020 07:59:21 -0400
X-MC-Unique: H4TPl8KaODO93KNkVw6Mnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA05380046E
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2020 11:59:20 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DDB4619C4
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2020 11:59:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] repair: use fs rootino for dummy parent value instead of zero
Date:   Fri, 17 Jul 2020 07:59:20 -0400
Message-Id: <20200717115920.59986-1-bfoster@redhat.com>
In-Reply-To: <20200715140836.10197-4-bfoster@redhat.com>
References: <20200715140836.10197-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If a directory inode has an invalid parent ino on disk, repair
replaces the invalid value with a dummy value of zero in the buffer
and NULLFSINO in the in-core parent tracking. The zero value serves
no functional purpose as it is still an invalid value and the parent
must be repaired by phase 6 based on the in-core state before the
buffer can be written out. A consequence of using an invalid dummy
value is that phase 6 requires custom verifier infrastructure to
detect the invalid parent inode and temporarily replace it while the
core fork verifier runs. If we use a valid inode number as a dummy
value earlier in repair, this workaround can be removed.

An obvious choice for a valid dummy parent inode value is the
orphanage inode. However, the orphanage inode is not allocated until
much later in repair when the filesystem structure is established as
sound and placement of orphaned inodes is imminent. In this case, it
is too early to know for sure whether the associated inodes are
orphaned because a directory traversal later in repair can locate
references to the inode and repair the parent value based on the
structure of the directory tree.

Given all of this, escalate the preexisting workaround from the
custom verifier in phase 6 and set the root inode value as a dummy
parent for shortform directories with an invalid on-disk parent. The
in-core parent is still tracked as NULLFSINO and so forces repair to
either update the parent or orphan the inode before repair
completes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

v2:
- Update patch subject and commit log.

 repair/dir2.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index caf6963d..9c789b4a 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -165,7 +165,6 @@ process_sf_dir2(
 	int			tmp_elen;
 	int			tmp_len;
 	xfs_dir2_sf_entry_t	*tmp_sfep;
-	xfs_ino_t		zero = 0;
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
@@ -497,7 +496,7 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -532,7 +531,7 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			libxfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
-- 
2.21.3

