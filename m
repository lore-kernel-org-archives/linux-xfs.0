Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773FBC2D0C4
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5A72073B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 11:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yb+nFItr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLJLs0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:48:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727693AbfLJLs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 06:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575978505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RBaDerO5m1QBPWzoq0igJSlGppQzcNjGlqrOv8f6/iw=;
        b=Yb+nFItrOfWsiR1HPiTSPzlONwOwyvmAS+jd9pnrHyhtWFa3PcY2kQoV8Z3gIHkAESgyVm
        Ro5s5cJqjO76VqYxRHAoqNE4fs6Tpf9+1OGCpRKbo2+z7wkQk4kt4XweJgTKAZUDKm41Dx
        mmNE3UGXboUKMbWviffUhOLyPkD3ABo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-2XlxopTOPdCy1sQQF6aqAA-1; Tue, 10 Dec 2019 06:48:19 -0500
Received: by mail-wm1-f72.google.com with SMTP id l13so899587wmj.8
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 03:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BGf1nl8mK8BLFMrPnS/NtXMadtN9Ny4M+NfXyxu1AHA=;
        b=B9MCSoG/TlcaW3AkXH4L9S8QsiIGLxyvQzxdGNptKrQBBNsibX4GpX3GBIBnRTGTqf
         GBZAusDkgtkRqldphSTjMQEF+Qz9FTmXavZrbydt5eaMtPSH/Y6HUdwhKu2CI9T4oYNK
         i8RqBNNI2WgWU6RQyXYNVQg9zPQfGooaxSwYSroZgWuVHhjQa8270LNc9+h0pV5abcxG
         ahJzsarXVXuPfD6v3KILNpNxTvHZSC4dfHsy6ckKwZei3rVnInXte2e2F0RsJBK/az4T
         jKvp2gel7jAdqvsqK96L8gtbRKnYtdRV1FPUvSbGy+fZy2F2dYizTPnSUsgFLT9Pe9RH
         S61w==
X-Gm-Message-State: APjAAAXVAhrDK6N+Kuid0Yh5L2G5FDKw/qD6xgqNTyAevdaVCPLO5bqi
        H4SndXclwtYbyaCYsTEeHFGj3T6nUIopfqCA2XjDvWV4LRdZtDCO5dCbk6kE+sJGfJrmCg5X8wA
        IVphSWAvbFZ8a9AcaXemw
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr2777831wrq.43.1575978497954;
        Tue, 10 Dec 2019 03:48:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqwTKr7+fq2DhHzxKGQjb9hnay1Pkr58RNSv+F1GPFidwKvOxaISPugjFfqtrwAE8usjEAk0Kg==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr2777803wrq.43.1575978497630;
        Tue, 10 Dec 2019 03:48:17 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id b10sm3017434wrt.90.2019.12.10.03.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:48:17 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v4] mkfs: Break block discard into chunks of 2 GB
Date:   Tue, 10 Dec 2019 12:48:07 +0100
Message-Id: <20191210114807.161927-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: 2XlxopTOPdCy1sQQF6aqAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Some users are not happy about the BLKDISCARD taking too long and at the sa=
me
time not being informed about that - so they think that the command actuall=
y
hung.

This commit changes code so that progress reporting is possible and also ty=
ping
the ^C will cancel the ongoing BLKDISCARD.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
Changelog:
=09V4: Limit the reporting about discarding to a single line

 mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 18338a61..4bfdebf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1240,17 +1240,40 @@ done:
 }
=20
 static void
-discard_blocks(dev_t dev, uint64_t nsectors)
+discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
 {
-=09int fd;
+=09int=09=09fd;
+=09uint64_t=09offset =3D 0;
+=09/* Discard the device 2G at a time */
+=09const uint64_t=09step =3D 2ULL << 30;
+=09const uint64_t=09count =3D BBTOB(nsectors);
=20
-=09/*
-=09 * We intentionally ignore errors from the discard ioctl.  It is
-=09 * not necessary for the mkfs functionality but just an optimization.
-=09 */
 =09fd =3D libxfs_device_to_fd(dev);
-=09if (fd > 0)
-=09=09platform_discard_blocks(fd, 0, nsectors << 9);
+=09if (fd <=3D 0)
+=09=09return;
+=09if (!quiet) {
+=09=09printf("Discarding blocks...");
+=09=09fflush(stdout);
+=09}
+
+=09/* The block discarding happens in smaller batches so it can be
+=09 * interrupted prematurely
+=09 */
+=09while (offset < count) {
+=09=09uint64_t=09tmp_step =3D min(step, count - offset);
+
+=09=09/*
+=09=09 * We intentionally ignore errors from the discard ioctl. It is
+=09=09 * not necessary for the mkfs functionality but just an
+=09=09 * optimization. However we should stop on error.
+=09=09 */
+=09=09if (platform_discard_blocks(fd, offset, tmp_step))
+=09=09=09return;
+
+=09=09offset +=3D tmp_step;
+=09}
+=09if (!quiet)
+=09=09printf("Done.\n");
 }
=20
 static __attribute__((noreturn)) void
@@ -2507,18 +2530,19 @@ open_devices(
=20
 static void
 discard_devices(
-=09struct libxfs_xinit=09*xi)
+=09struct libxfs_xinit=09*xi,
+=09int=09=09=09quiet)
 {
 =09/*
 =09 *=C2=A0This function has to be called after libxfs has been initialize=
d.
 =09 */
=20
 =09if (!xi->disfile)
-=09=09discard_blocks(xi->ddev, xi->dsize);
+=09=09discard_blocks(xi->ddev, xi->dsize, quiet);
 =09if (xi->rtdev && !xi->risfile)
-=09=09discard_blocks(xi->rtdev, xi->rtsize);
+=09=09discard_blocks(xi->rtdev, xi->rtsize, quiet);
 =09if (xi->logdev && xi->logdev !=3D xi->ddev && !xi->lisfile)
-=09=09discard_blocks(xi->logdev, xi->logBBsize);
+=09=09discard_blocks(xi->logdev, xi->logBBsize, quiet);
 }
=20
 static void
@@ -3749,7 +3773,7 @@ main(
 =09 * All values have been validated, discard the old device layout.
 =09 */
 =09if (discard && !dry_run)
-=09=09discard_devices(&xi);
+=09=09discard_devices(&xi, quiet);
=20
 =09/*
 =09 * we need the libxfs buffer cache from here on in.
--=20
2.23.0

