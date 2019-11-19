Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848B7C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D99222A2
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3hn9NRN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfKSPo7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:44:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727509AbfKSPo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 10:44:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574178298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A4XpqoC4CyS8LgUnCj7NfdK5hSsUYfsmOzuXIuzMY0k=;
        b=P3hn9NRNM7dHfAW1y2s4mC7aW9JjvPdSZ4i0oiCUFxX5iniwQnnBgMFzVYXUKWAqHSe9ir
        PY1lJ9KrwcBD/SzbjcIWixRefi4bE/vUWu2X/7FecPA393tJhmxArMD2T986hN4gTdD0LB
        G3RqNQ7tHFz5/ABINb0IDmX0AJVfq/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-UqziwvNTPauDXv1EssTwtQ-1; Tue, 19 Nov 2019 10:44:57 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E00664A7D
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 15:44:56 +0000 (UTC)
Received: from orion.redhat.com (ovpn-204-164.brq.redhat.com [10.40.204.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5DEC19C4F
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 15:44:55 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Forbid FIEMAP on RT devices
Date:   Tue, 19 Nov 2019 16:44:53 +0100
Message-Id: <20191119154453.312400-1-cmaiolino@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: UqziwvNTPauDXv1EssTwtQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

By now, FIEMAP users have no way to identify which device contains the
mapping being reported by the ioctl, so, let's forbid FIEMAP on RT
devices/files until FIEMAP can properly report the device containing the
returned mappings.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Hi folks, this change has been previously suggested by Christoph while the
fibmap->fiemap work was being discussed on the last version [1] of that set=
.
And after some thought I do think RT devices shouldn't allow fiemap calls
either, giving the file blocks will actually be on a different device than =
that
displayed on /proc/mounts which can lead to erroneous assumptions.

 fs/xfs/xfs_iops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e532db27d0dc..ec7749cbd3ca 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1138,6 +1138,9 @@ xfs_vn_fiemap(
 {
 =09int=09=09=09error;
=20
+=09if (XFS_IS_REALTIME_INODE(XFS_I(inode)))
+=09=09return -EOPNOTSUPP;
+
 =09xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
 =09if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR) {
 =09=09fieinfo->fi_flags &=3D ~FIEMAP_FLAG_XATTR;
--=20
2.23.0

