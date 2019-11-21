Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2474C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77BB2206CC
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 21:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="grt1iDmY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUVo5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 16:44:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726510AbfKUVo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 16:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574372696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUim+xkoBATMQNJjINLolvMAo3g/OGRYXFAlwi9fPm0=;
        b=grt1iDmYG5V5lffBl3NVuZG08H/XuRKdtQ1MCQBmfe4x2A1Xymc1FZSbEUjCL2Y0XIimh1
        B0DZetlXssKOjclgJ23Im0IOXNb9XIcNDLnY0hHlDbbeTDOU8zUpE+iPv1fFkPpb6anfwP
        Q7UCrcMBB81ni6JlDELBbx3qPeoRelM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-j8jTjzgYOSi2bxdEF8kYbQ-1; Thu, 21 Nov 2019 16:44:54 -0500
Received: by mail-wm1-f72.google.com with SMTP id h191so2453896wme.5
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2019 13:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=swintG8v5UR9afp5pQom+mtxKSY1k+Wt96x59fIY0qA=;
        b=sai0Rq3r2OYKBO5IiXQY1k1QCu8mp6sKiZtf9zA70IE7GlEhONlyv1UPlqhXJ86TUb
         9CrGdaXtUbk2QcNKciaBMAP1VvpEO81XuKV6AaN8i5zrRUP4QvhPcP46y6TRaUUN2rCH
         TRKaYfX0rgiYdb9JmxP/ueGHSPTXw3n52Fq0bpbuNJvd+GAi4U0IaEDFKJ4wbFW3m8EI
         BjrSFZ0nib73It8iUJkUQ+KOXfJB1CTqmENdG006LLii49I8qPxYyGRdhy8e5PfL7HmH
         hPsec3sSWLQjLocwKpVWi+Eh9FDQXmAFmhzQh5SA3asDHEJDIed+Bfzr99OiqvzsOjbW
         CoYA==
X-Gm-Message-State: APjAAAXviCU9WzjGFfzgf7DVRWtZtIPxecahUJU8XCiWNnx1Ie8qKgut
        ofoAVEJlGXOheTAmbA1DWlsto3kEERKofXbPLWAmMl/CtxcrUEpPYYoqwg2MRtUXQVRg7pmfiek
        jNW2o0YpdeBA9JFCdD+IN
X-Received: by 2002:a5d:640d:: with SMTP id z13mr14638406wru.68.1574372693587;
        Thu, 21 Nov 2019 13:44:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXWJWXErKgGezEx/ove0Xmed/s/ESn552GA0CqPX2HuMZNL9S/wILPAYPTrhT+4iSwtIivSw==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr14638386wru.68.1574372693433;
        Thu, 21 Nov 2019 13:44:53 -0800 (PST)
Received: from preichl.redhat.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id d18sm5093617wrm.85.2019.11.21.13.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 13:44:52 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
Date:   Thu, 21 Nov 2019 22:44:44 +0100
Message-Id: <20191121214445.282160-2-preichl@redhat.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121214445.282160-1-preichl@redhat.com>
References: <20191121214445.282160-1-preichl@redhat.com>
MIME-Version: 1.0
X-MC-Unique: j8jTjzgYOSi2bxdEF8kYbQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 mkfs/xfs_mkfs.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 18338a61..a02d6f66 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1242,15 +1242,33 @@ done:
 static void
 discard_blocks(dev_t dev, uint64_t nsectors)
 {
-=09int fd;
+=09int=09=09fd;
+=09uint64_t=09offset=09=09=3D 0;
+=09/* Maximal chunk of bytes to discard is 2GB */
+=09const uint64_t=09step=09=09=3D (uint64_t)2<<30;
+=09/* Sector size is 512 bytes */
+=09const uint64_t=09count=09=09=3D nsectors << 9;
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
+
+=09while (offset < count) {
+=09=09uint64_t=09tmp_step =3D step;
+
+=09=09if ((offset + step) > count)
+=09=09=09tmp_step =3D count - offset;
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
 }
=20
 static __attribute__((noreturn)) void
--=20
2.23.0

