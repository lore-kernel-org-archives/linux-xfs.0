Return-Path: <SRS0=tu3U=ZU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C8AC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Nov 2019 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A32D215E5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Nov 2019 06:21:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="esnGITZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfK1GVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Nov 2019 01:21:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbfK1GVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Nov 2019 01:21:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574922107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ft5yxO8d7A1Fh+AS+3Bq5HVNyFAbPRkwR0B+RA2gyQs=;
        b=esnGITZOvfHBfEC9XaCFuLZxiNBCEOLDY+x2siWXyKPmyj3jKxg4usmCfSmBSxtv0MaLIz
        PysE4mFVKgiFJpj8nqTh5PpM/cCTJUc03659eTdwf5gSuJ/AXop7lqbMiclHtc10zx2P0D
        cAgU1jBtNwkRjOO7Q9d7vGI/SouxZFw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-fz7uLDfCOg-3Qm_aMflJyA-1; Thu, 28 Nov 2019 01:21:46 -0500
Received: by mail-wm1-f69.google.com with SMTP id 199so3317301wmb.0
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2019 22:21:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4No1VioR6bF9K1PWWIgI+y5EH7oNNrbNNSfEd+8Nfac=;
        b=PsYDPMW5lNjZHjk/R64iAWeqmEVyK5swNE0D2q7MPMAnmv04T2NmEXdFQQLWaUYw+N
         2ju13LzJEGw6234C4Gqg0k7G/E7iOjSQTx42ArfPLXhGVlsvtCDdxGt+Ggcx2wqAqbuu
         G/fYAxNFlCkzkIYZHWgpsxwj26db5TMpWxGLwkf6za8cDu13zo/Ip5t0QNPTFYHs765t
         TA7fDBLLGrA2/cuh0aYA2y1eOOrKkA42exiWCNgwv/IIIXqZLyp2efwwKa0V0Igk4dXw
         JftTw6T/7tEYK0YPx5gq2FMmRhfq3W8dqObBT0ZZdw838oLGzbm4qQVGDfdthermJOq+
         9Gew==
X-Gm-Message-State: APjAAAUOWYmG2Nwq6ltoWcHFQpz2h2Q9mKJG6E7unwpSrITLs4CZQ1pI
        7t4qYPLwzM/tbneeLGPWakznX+GJNv+5URAkd4nM4bEWrBSMqB5a/pNaXQnoXkhFhCGt0tsnvE6
        eU1xDTw4MZowqLpJb2rCa
X-Received: by 2002:adf:f58a:: with SMTP id f10mr1373702wro.105.1574922104608;
        Wed, 27 Nov 2019 22:21:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqySf1Sjq+CcvwGxDlnAIrWVV1mdbr0QYEmjN98c4JDHOPgHd87R1ZmOMSg0eZNv8QOnSq52Eg==
X-Received: by 2002:adf:f58a:: with SMTP id f10mr1373682wro.105.1574922104372;
        Wed, 27 Nov 2019 22:21:44 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id w188sm9977303wmg.32.2019.11.27.22.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 22:21:43 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH v3] mkfs: Break block discard into chunks of 2 GB
Date:   Thu, 28 Nov 2019 07:21:39 +0100
Message-Id: <20191128062139.93218-1-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
X-MC-Unique: fz7uLDfCOg-3Qm_aMflJyA-1
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
index 18338a61..0defadb2 100644
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
+=09=09printf("Discarding blocks...\n");
+=09=09printf("...\n");
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

