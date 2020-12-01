Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8741C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701842151B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 19:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQdKbL3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390579AbgLATRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 14:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390538AbgLATRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 14:17:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606850173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C5gybIPW832unrodPZ1+1bzfkhFMyt67HdxF6XX7P3A=;
        b=bQdKbL3sYCs5zgUuvPgKODDa4VfMLJaweEHuHl5/h/zRBEe62qDY2SB5UGx/i4Ut5vHvg2
        lYF0i+OSS8OPgMoi1jcCu86ZTrnJB27FWkHZravTK/pz20zRvwqZyhkiNEBf2EuhxsA4wh
        b7NKyBf0pEQGADzBVlegh04XpsHrJ44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-YV7AGMXCMWGvrzxeUKMkiQ-1; Tue, 01 Dec 2020 14:16:11 -0500
X-MC-Unique: YV7AGMXCMWGvrzxeUKMkiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 416CF805BE5
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:16:10 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1958F5D705
        for <linux-xfs@vger.kernel.org>; Tue,  1 Dec 2020 19:16:10 +0000 (UTC)
Subject: [PATCH 1/2] xfs: don't catch dax+reflink inodes as corruption in
 verifier
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Message-ID: <4b655a26-0e3c-3da7-2017-6ed88a46a611@redhat.com>
Date:   Tue, 1 Dec 2020 13:16:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We don't yet support dax on reflinked files, but that is in the works.

Further, having the flag set does not automatically mean that the inode
is actually "in the CPU direct access state," which depends on several
other conditions in addition to the flag being set.

As such, we should not catch this as corruption in the verifier - simply
not actually enabling S_DAX on reflinked files is enough for now.

Fixes: 4f435ebe7d04 ("xfs: don't mix reflink and DAX mode for now")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c667c63f2cb0..4d7410e49db4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -547,10 +547,6 @@ xfs_dinode_verify(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
 		return __this_address;
 
-	/* don't let reflink and dax mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
-		return __this_address;
-
 	/* COW extent size hint validation */
 	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
 			mode, flags, flags2);
-- 
2.17.0

