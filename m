Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03257C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 14:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D5A20714
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 14:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acuWWB5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgBKOcA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 09:32:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39383 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729822AbgBKOb7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 09:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581431518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YYNNsCZprBdvMDKAGIFlxBZaW5kPD+7JHMbdRMldxx4=;
        b=acuWWB5duYF4i5ev5sPNI02vFgtaQR1BdMMYshWIir9mYY6byVeIDvbVlXtp6z3CEqvXwc
        5lsGKJTy5T3NdmZVwzgZxgbpYvACJlbPOkF3X6gNcYGTBA4inEj0qyFIGhJ2bjswxD8foX
        AOawq32x/3y6i41CVUKcvlImNjy4hKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-TJpd24nDPrefhVtsPce37Q-1; Tue, 11 Feb 2020 09:31:56 -0500
X-MC-Unique: TJpd24nDPrefhVtsPce37Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAEEE800D50;
        Tue, 11 Feb 2020 14:31:55 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA47C60BF1;
        Tue, 11 Feb 2020 14:31:54 +0000 (UTC)
Subject: Re: [PATCH] xfs_repair: fix bad next_unlinked field
To:     John Jore <john@jore.no>, linux-xfs <linux-xfs@vger.kernel.org>
References: <f5b8a2a9-e691-3bf5-c2c7-f4986a933454@redhat.com>
 <9e40d95fa3fe4fce9f4326fe7d7d1b8c@jore.no>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <794e2d32-edb1-d3fc-ed44-f52c5de2cabc@redhat.com>
Date:   Tue, 11 Feb 2020 08:31:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9e40d95fa3fe4fce9f4326fe7d7d1b8c@jore.no>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/11/20 4:11 AM, John Jore wrote:
> Hi and thanks for this one.
>=20
> Ran it twice. No errors were found on the second run.
>=20
> Let me know if you need a dump or anything for validation purposes?

Nah it's all good, thanks for the report.

-Eric

>=20
> John
>=20
> ---
> From: Eric Sandeen <sandeen@redhat.com>
> Sent: 11 February 2020 02:42
> To: linux-xfs
> Cc: John Jore
> Subject: [PATCH] xfs_repair: fix bad next_unlinked field
> =C2=A0  =20
> As of xfsprogs-4.17 we started testing whether the di_next_unlinked fie=
ld
> on an inode is valid in the inode verifiers. However, this field is nev=
er
> tested or repaired during inode processing.
>=20
> So if, for example, we had a completely zeroed-out inode, we'd detect a=
nd
> fix the broken magic and version, but the invalid di_next_unlinked fiel=
d
> would not be touched, fail the write verifier, and prevent the inode fr=
om
> being properly repaired or even written out.
>=20
> Fix this by checking the di_next_unlinked inode field for validity and
> clearing it if it is invalid.
>=20
> Reported-by: John Jore <john@jore.no>
> Fixes: 2949b4677 ("xfs: don't accept inode buffers with suspicious unli=
nked chains")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>=20
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 8af2cb25..c5d2f350 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2272,6 +2272,7 @@ process_dinode_int(xfs_mount_t *mp,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const int=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_=
free =3D 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const int=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is_=
used =3D 1;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkmap_t=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 *dblkmap =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xfs_agino_t=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlinked_ino;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *dirty =3D *isa_dir =3D=
 0;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *used =3D is_used;
> @@ -2351,6 +2352,23 @@ process_dinode_int(xfs_mount_t *mp,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlinked_ino =3D be32_to_cpu(dino=
->di_next_unlinked);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!xfs_verify_agino_or_null(mp,=
 agno, unlinked_ino)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 retval =3D 1;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!uncertain)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_warn(_("b=
ad next_unlinked 0x%x on inode %" PRIu64 "%c"),
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (__s32)dino->di_next_unlinked, lino,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 verify_mode ? '\n' : ',');
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!verify_mode) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!no_modi=
fy) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_warn(_(" resetting next_unlinked\n")=
);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clear_dinode_unlinked(mp, dino);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *dirty =3D 1;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_warn(_(" would reset next_unlinked\n=
"));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We don't bothe=
r checking the CRC here - we cannot guarantee that when
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * we are called =
here that the inode has not already been modified in
>=20
>     =20
>=20

