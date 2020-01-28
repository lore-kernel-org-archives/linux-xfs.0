Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AD8C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F9424685
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 16:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZSi8ztu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA1QHK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:07:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726107AbgA1QHK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 11:07:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580227628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=MvUxM16Pq/3hxkzaymxdIrXJhhitfrqPhjLdvdr+DrA=;
        b=SZSi8ztu0Hup7zLjc5+VhuTFTO6QSWrhbvaGC/vp4RZT1OoH0qQXpQEyxYfuvJmCApv38N
        Fob4rN6jskjcDBbQm8SgPKBoTxABiuh8pyRv7XJTakAFSatISnyBcYdc/Ssoz0zbHNoLoA
        YKNsUWEZoPLRVdUEx3+coK3RTS6QDyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88--LX_rsvlNV6g1HRbztcubg-1; Tue, 28 Jan 2020 11:07:03 -0500
X-MC-Unique: -LX_rsvlNV6g1HRbztcubg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D36E910054E3
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 16:07:02 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E1E5C1D8
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 16:07:02 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: mkfs: don't default to the physical sector size if it's bigger than XFS_MAX_SECTORSIZE
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 28 Jan 2020 11:07:01 -0500
Message-ID: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

In testing on ppc64, I ran into the following error when making a file
system:

# ./mkfs.xfs -b size=65536 -f /dev/ram0
illegal sector size 65536

Which is odd, because I didn't specify a sector size!  The problem is
that validate_sectorsize defaults to the physical sector size, but in
this case, the physical sector size is bigger than XFS_MAX_SECTORSIZE.

# cat /sys/block/ram0/queue/physical_block_size 
65536

Fall back to the default (logical sector size) if the physical sector
size is greater than XFS_MAX_SECTORSIZE.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 606f79da..dc9858af 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1803,8 +1803,13 @@ validate_sectorsize(
 		if (!ft->lsectorsize)
 			ft->lsectorsize = XFS_MIN_SECTORSIZE;
 
-		/* Older kernels may not have physical/logical distinction */
-		if (!ft->psectorsize)
+		/*
+		 * Older kernels may not have physical/logical distinction.
+		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
+		 * In that case, a ramdisk or persistent memory device may
+		 * advertise a physical sector size that is too big to use.
+		 */
+		if (!ft->psectorsize || ft->psectorsize > XFS_MAX_SECTORSIZE)
 			ft->psectorsize = ft->lsectorsize;
 
 		cfg->sectorsize = ft->psectorsize;

