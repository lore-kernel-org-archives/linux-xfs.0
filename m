Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7543DC432C3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 21:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AF382064B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 21:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gqyaSapy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfK0VXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 16:23:44 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732123AbfK0VXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 16:23:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574889821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C+UrTFLEnpVw4U4uln54jZCp9fZwwpqvF5uRYadAcGs=;
        b=gqyaSapyEpO3U919lR6UcASdpzt2MtVNFugiVLS2vLg/py7x68XEdpACXIeRmjA5Gw7bsG
        zM1EtwAn36L4EsBzednw4qANf/wFlDmBXa6SpRCZuEA95YhrnNcuLlx7jGM8JSO2vWAr/t
        ICfLLO0rnNO5Avm2GAQxe0p1fmGtMbc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-ER4OrVYKP8yVaMt5yX8-Gg-1; Wed, 27 Nov 2019 16:23:40 -0500
Received: by mail-wm1-f70.google.com with SMTP id f191so3034794wme.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2019 13:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8jvHnMMY82NxsQfU3ObPnkFVGRfsFwK5JBV/oAcPvA=;
        b=IvhQ+d5PZ8QqItqg6yorl6BLyVhggMggDcxErmg2T+Wp/e5fTltZQUuAOv1KZGCZhR
         zsmRFYA/+Y+CwshDaKY1sVkKdZk2UNS7kZtxhIM8TuslV+1G+JAwZIjz5I1HJ7nKsX91
         wuXCRg9n0UxVhWm6ZoetdYxNH5WjrcKYdOB2DKDfvzji8c7HFqfeBB8yt3OAuDEqoi2N
         jbXGYqB7vQ63Db+/ah3xWaEecTj9JDa8FJgqqkt/+5pO+9YTFcJ3eV0aIXOdbCjCnZk/
         iYEnfaLsQ33PTZ4id8hPCNL2rK4CpIZZVRa3jkQf797xH3TIxMckfeCApoSC5Ao5y5vH
         096w==
X-Gm-Message-State: APjAAAUZnaHROU5gFx4YQF3X9+MnopTT+lQll5OfiRyiVIRSbctW3j+e
        znynmDuX0c+e7GldMYdOnHwrXkwR3VWX3RaEogtgvQ5/PEzTBaLNi17G6ou03/2Jnpwh1s2N243
        K9tBK62Xv8XKw79KJmDBG
X-Received: by 2002:a1c:8153:: with SMTP id c80mr6469159wmd.58.1574889818885;
        Wed, 27 Nov 2019 13:23:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJ2IC/x5NNXcw4UaDtlxjkrB5hR+eC/IsoanHPvn9DnXlBBDnwP/UFFAVpvpZH0IGRp79GNg==
X-Received: by 2002:a1c:8153:: with SMTP id c80mr6469145wmd.58.1574889818644;
        Wed, 27 Nov 2019 13:23:38 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id z4sm8656755wmf.36.2019.11.27.13.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 13:23:38 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v2 1/1] mkfs: Break block discard into chunks of 2 GB
Date:   Wed, 27 Nov 2019 22:21:52 +0100
Message-Id: <20191127212152.69780-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: ER4OrVYKP8yVaMt5yX8-Gg-1
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
 mkfs/xfs_mkfs.c | 50 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 18338a61..7fa4af0e 100644
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
+=09=09printf("...");
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

