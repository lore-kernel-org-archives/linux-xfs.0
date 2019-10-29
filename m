Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A1DCA9EC0
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 03:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0892D20717
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 03:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ayi2Svba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfJ2DX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:23:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726025AbfJ2DX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 23:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572319434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=e4Y8MDLIi8jbEkMG0u+JQ1zIEgwL1hnxlyrxsyYvqZU=;
        b=Ayi2Svba/Iwjh5CeP0iHKpUkCzZaPFHcpRAG2YfFwqKTlt90Y3YRM+hDO+pf5gg4BEzMth
        6F5ua9Z1228fDIz1GyTM7xcaa3kxOsgHUskoidCQPbEwGCfvp5fcaSFuDs9pBgRjn+lvI4
        pdnG7Cdws5azY7DTwBrC6J2UEJexR4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-2nMmc0gqPKu9YExcDP1MfQ-1; Mon, 28 Oct 2019 23:23:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 705485E6
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 03:23:52 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 457D8600C1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 03:23:52 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_growfs: allow mounted device node as argument
Message-ID: <0283f073-88d8-977f-249c-f813dabd9390@redhat.com>
Date:   Mon, 28 Oct 2019 22:23:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 2nMmc0gqPKu9YExcDP1MfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Up until:

 b97815a0 xfs_growfs: ensure target path is an active xfs mountpoint

xfs_growfs actually accepted a mounted block device name as the
primary argument, because it could be found in the mount table.

It turns out that Ansible was making use of this undocumented behavior,
and it's trivial to allow it, so put it back in place and document
it this time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I can clone tests/xfs/289 to do tests of similar permutations for
device names.

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 20089d2b..4224c5a0 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -140,6 +140,9 @@ main(int argc, char **argv)
 =09}
=20
 =09fs =3D fs_table_lookup_mount(rpath);
+=09if (!fs)
+=09=09fs =3D fs_table_lookup_blkdev(rpath);
+
 =09if (!fs) {
 =09=09fprintf(stderr, _("%s: %s is not a mounted XFS filesystem\n"),
 =09=09=09progname, argv[optind]);
diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index 7e6a387c..60a88189 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -35,7 +35,12 @@ xfs_growfs \- expand an XFS filesystem
 .B \-R
 .I size
 ]
+[
 .I mount-point
+|
+.I block-device
+]
+
 .br
 .B xfs_growfs \-V
 .SH DESCRIPTION
@@ -45,7 +50,10 @@ expands an existing XFS filesystem (see
 The
 .I mount-point
 argument is the pathname of the directory where the filesystem
-is mounted. The filesystem must be mounted to be grown (see
+is mounted. The
+.I block-device
+argument is the device name of a mounted XFS filesystem.
+The filesystem must be mounted to be grown (see
 .BR mount (8)).
 The existing contents of the filesystem are undisturbed, and the added spa=
ce
 becomes available for additional file storage.

