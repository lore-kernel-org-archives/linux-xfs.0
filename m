Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF40C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 10:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 669C920714
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 10:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=jore.no header.i=@jore.no header.b="jHY8T2i7";
	dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b="gpiR13FV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgBKK11 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 05:27:27 -0500
Received: from outbound3d.ore.mailhop.org ([54.186.57.195]:40932 "EHLO
        outbound3d.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728284AbgBKK10 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 05:27:26 -0500
X-Greylist: delayed 971 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 05:27:25 EST
ARC-Seal: i=1; a=rsa-sha256; t=1581415871; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=T+efqx9tcrWWx4QiWEd0Ex/Qe9GQ6fqvireLMr/c7lYPf4OkYHX12nBFmdJKgpHqvQrQUYbcmix5s
         gJbK7EUfcanKUpAVE/1aEXEm4tln78bCorGAS7Gvt1dm3QtVa/y9SoDenlxrtf1jB4gHDQf6f4+ru4
         OYUdc0PkI8k8MjV3Y8JotIe/cXHDOF0BfCPz8fRBejFBK7PdDyHCAHLpofUu9P1MCZlib9qgVPJVFd
         Ao4hcx+RIhaK9nX6obeltdcDEM29LeeY3jNTIgGHodk8I92oUxIOUjFew5+5nHQrcVeK873cubP5XB
         1xno2jd2Vcw1qfmHU57ibyzwqzT82OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:dkim-signature:dkim-signature:from;
        bh=N5a0wm6cCJNnPuBDHWLoZc8KQ/n/qZ8WFA97Roj/xRo=;
        b=sDZEDgx851M4Onx34/sckxjJINfScQU4vruZ/jAG4nZl+Nx0uIyQrCOB7KTjwINtVPMD6dtb9HyD+
         lx2thKniO4spnDpWVavYT2dry2r2zpcZcZ5HoHe2zHO8GstNLkXO/EAdGfWQ3xb6Q2lXbr8SMdwkR8
         boBmAYM37l+S1TuIs00a8YF6zyn0oX7sBMDwkLmqOhB+XpGPzQ+crIm661kHrYy4gQ1f9z6i+BlBW2
         s0j4Ib1VkN7zsFEtO2pFcWRQu9bU9SSI52l4LEp85C8R8dhhuAeM4w2aVyQvsgvOjNIGc4ZKw9SZhg
         g4Tau92S7nuxXUT/Mg7Xm4iVAnZ3wDg==
ARC-Authentication-Results: i=1; outbound3.ore.mailhop.org;
        spf=pass smtp.mailfrom=jore.no smtp.remote-ip=27.96.199.243;
        dmarc=none header.from=jore.no;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jore.no; s=duo-1579427507040-bf9c4b8d;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:from;
        bh=N5a0wm6cCJNnPuBDHWLoZc8KQ/n/qZ8WFA97Roj/xRo=;
        b=jHY8T2i706m0vCrY4NqXVyVp1sI/Ws7esgLpqj3D4uBgQW/FRga9FIbCzwp4d/UkRsxrciSO466g0
         U4L2OoOLxjXmYi5loq+wYC1T0BNbQ6ob4HZ0/7WlHokzPdciMRbnpuMRMyg0ZQJizsYAscX24cCW2N
         ZATZZj5zXQQymNVA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=mime-version:content-transfer-encoding:content-type:in-reply-to:references:
         message-id:date:subject:to:from:from;
        bh=N5a0wm6cCJNnPuBDHWLoZc8KQ/n/qZ8WFA97Roj/xRo=;
        b=gpiR13FVdM+FNwxdrAfTgl/Ggw4bbRrzpnrHWS3ckorIqpakf1kYo/uzrNpGH5fXy2+bDrl49LDZ5
         UpOvk/iOJZ3IhpFSJ3pQVDz4fnMir90JdESnZ2YbsRsgXsEXiZJuqjnc2fWFDhRbttV5QWAHvbHFLr
         dvo4SMlAtz7woCYDmE/pRKKyDzdpzRrfGdRV5nQBFzypmuWnMOjayXbxksuWGe8EACjVrH3zz4NkdS
         6gE5CG253cdBlDxcqCmkLTLLcSQT8n+sM0XyM/BsMuUjtDDYJDVuleoUVf2jaZ30NxXZWzNqmox1Lf
         ycp2AkdhcfttVNe5jW6DVBpvx6WxYvQ==
X-MHO-RoutePath: am9obmpvcmU=
X-MHO-User: cfaf6ebe-4cb6-11ea-b80d-052b4a66b6b2
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mail.jore.no (unknown [27.96.199.243])
        by outbound3.ore.mailhop.org (Halon) with ESMTPSA
        id cfaf6ebe-4cb6-11ea-b80d-052b4a66b6b2;
        Tue, 11 Feb 2020 10:11:07 +0000 (UTC)
Received: from SNHNEXE02.skynet.net (192.168.1.14) by SNHNEXE02.skynet.net
 (192.168.1.14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.330.5; Tue, 11 Feb 2020
 21:11:03 +1100
Received: from SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b]) by
 SNHNEXE02.skynet.net ([fe80::ad3a:937:9347:f03b%12]) with mapi id
 15.02.0330.010; Tue, 11 Feb 2020 21:11:02 +1100
From:   John Jore <john@jore.no>
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: fix bad next_unlinked field
Thread-Topic: [PATCH] xfs_repair: fix bad next_unlinked field
Thread-Index: AQHV4CjAnXjCBUz2h0uVPi5IE6PlkagVxV+s
Date:   Tue, 11 Feb 2020 10:11:01 +0000
Message-ID: <9e40d95fa3fe4fce9f4326fe7d7d1b8c@jore.no>
References: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
In-Reply-To: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
Accept-Language: en-GB, nb-NO, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: 27.96.199.243
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi and thanks for this one.

Ran it twice. No errors were found on the second run.

Let me know if you need a dump or anything for validation purposes?


John

---
From: Eric Sandeen <sandeen@redhat.com>
Sent: 11 February 2020 02:42
To: linux-xfs
Cc: John Jore
Subject: [PATCH] xfs_repair: fix bad next_unlinked field
=A0  =20
As of xfsprogs-4.17 we started testing whether the di_next_unlinked field
on an inode is valid in the inode verifiers. However, this field is never
tested or repaired during inode processing.

So if, for example, we had a completely zeroed-out inode, we'd detect and
fix the broken magic and version, but the invalid di_next_unlinked field
would not be touched, fail the write verifier, and prevent the inode from
being properly repaired or even written out.

Fix this by checking the di_next_unlinked inode field for validity and
clearing it if it is invalid.

Reported-by: John Jore <john@jore.no>
Fixes: 2949b4677 ("xfs: don't accept inode buffers with suspicious unlinked=
 chains")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dinode.c b/repair/dinode.c
index 8af2cb25..c5d2f350 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2272,6 +2272,7 @@ process_dinode_int(xfs_mount_t *mp,
=A0=A0=A0=A0=A0=A0=A0=A0 const int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 is_free =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0 const int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 is_used =3D 1;
=A0=A0=A0=A0=A0=A0=A0=A0 blkmap_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 *dblkmap =3D NULL;
+=A0=A0=A0=A0=A0=A0 xfs_agino_t=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unlinke=
d_ino;
=A0
=A0=A0=A0=A0=A0=A0=A0=A0 *dirty =3D *isa_dir =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0 *used =3D is_used;
@@ -2351,6 +2352,23 @@ process_dinode_int(xfs_mount_t *mp,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0
+=A0=A0=A0=A0=A0=A0 unlinked_ino =3D be32_to_cpu(dino->di_next_unlinked);
+=A0=A0=A0=A0=A0=A0 if (!xfs_verify_agino_or_null(mp, agno, unlinked_ino)) =
{
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 retval =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!uncertain)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 do_warn=
(_("bad next_unlinked 0x%x on inode %" PRIu64 "%c"),
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 (__s32)dino->di_next_unlinked, lino,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 verify_mode ? '\n' : ',');
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!verify_mode) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!no=
_modify) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 do_warn(_(" resetting next_unlinked\n"));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 clear_dinode_unlinked(mp, dino);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 *dirty =3D 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 do_warn(_(" would reset next_unlinked\n"));
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0=A0=A0=A0 /*
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * We don't bother checking the CRC here - we ca=
nnot guarantee that when
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * we are called here that the inode has not alr=
eady been modified in

     =
