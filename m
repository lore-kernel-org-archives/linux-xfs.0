Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11281C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FB5205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 14:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BDpkVJic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgGOOIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:08:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728606AbgGOOIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 10:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uLbbNEuwfskoC+txv83mwsvMAMmCEa+R4kfWRkohd7I=;
        b=BDpkVJicr8Zp5tBZ0f5nqEepfQy1aNxMRzz4pBnAXEsmBQpI90SA8x3ELyfkXrsKOOC+zI
        elt1/msr31YS3Og9Rjt4nJJsBizu/6wMc6B2sIN8NScUI5mXsGDN3buPYqrGmew09Y4yMZ
        IN1Sihgp+ciPv8J4UqPvd5zChac4hCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-3-w46AH_OmyIFO8Sup0juA-1; Wed, 15 Jul 2020 10:08:39 -0400
X-MC-Unique: 3-w46AH_OmyIFO8Sup0juA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 578E910059AA
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:38 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A2C85D9C5
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 14:08:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] repair: use fs root ino for dummy parent value instead of zero
Date:   Wed, 15 Jul 2020 10:08:35 -0400
Message-Id: <20200715140836.10197-4-bfoster@redhat.com>
In-Reply-To: <20200715140836.10197-1-bfoster@redhat.com>
References: <20200715140836.10197-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If a directory inode has an invalid parent ino on disk, repair
replaces the invalid value with a dummy value of zero in the buffer
and NULLFSINO in the in-core parent tracking. The zero value serves
no functional purpose as it is still an invalid value and the parent
must be repaired by phase 6 based on the in-core state before the
buffer can be written out.  Instead, use the root fs inode number as
a catch all for invalid parent values so phase 6 doesn't have to
create custom verifier infrastructure just to work around this
behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
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

