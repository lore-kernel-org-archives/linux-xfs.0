Return-Path: <SRS0=hCPB=2A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A6FC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 14:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B4A720652
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Dec 2019 14:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NopciiVR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfLJOCT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 09:02:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727007AbfLJOCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Dec 2019 09:02:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575986538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nk0MAMhtx9wdjgDP/f6Udiz9jTL0lpg7NDhHxC4S8AA=;
        b=NopciiVRL+BaLn7AN2plNxKPJNo3J8531YrgES53LGfU7fk42R0KMWqaUW/dupwuhTtHNZ
        284S9Wsh/iSVNrqusOf/9O5JRdUuOhtnEAtBC+gZ28PV0RKuVhwwmjJLIk7Xw+ggarZRfp
        FKk2o2NBW263Ctln2cW55LYAEyvg5r4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-iZOtO6T3Nf6a0_gAQWHQ7A-1; Tue, 10 Dec 2019 09:02:16 -0500
Received: by mail-wm1-f70.google.com with SMTP id f4so647168wml.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2019 06:02:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=JbvIdp1h3tKPIRl0i8eTh05M3uetPpFb3D5MMHw0Oro=;
        b=FspVEQEXMD5IHLH5Jufi/mI7QSYlwbrxv9ju1AJjbFUKB0m3C+aAv7LkU01WOfE/af
         NB0kqk48Ne+bvVqPwZJGqDma8T9rNSbKmOvqs8VDv0nbsT2XcuV9GqE2oN79+y7isfYN
         /co7pHIRZNg12qnKOzW6ekFg9JFwEOYlKzBdu1aaUBlQ5R6rOORFu1Yqz9b6qrVTNfn7
         Z7qvOdO4KBLnIGxFow4CVyDNPzdRfspKiQs51XzgQ9F4fa3itM9bgPcDcqYdu02OzSoQ
         bm1BBl0QQIRphl61Uv0EgM1x4BjD/DsQFR0FpVbBMsEpKeS64JSDmLD2JfnCVChZ7Wv4
         yH8g==
X-Gm-Message-State: APjAAAUOfUEzHBTezJ6TAV4TRHUABc75zGQbgafkblNQpjnvoiEJlZDO
        qtHsoBrKApQ8B8uqdipyiPypxnXW8HDco/VwtM2nNDUaulsri/tKEc0vYqnTByVDpmYr5QAbcF+
        jF8P8bPOCSiiqmYpX9IZM
X-Received: by 2002:a5d:6652:: with SMTP id f18mr1989914wrw.246.1575986535102;
        Tue, 10 Dec 2019 06:02:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJenyxkipYlAIC1NogG9Nk7Me+8PZQLyYmnZwb5G7F79JkWvpTyWftDoAMGDAo0RCskuBhCg==
X-Received: by 2002:a5d:6652:: with SMTP id f18mr1989873wrw.246.1575986534773;
        Tue, 10 Dec 2019 06:02:14 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id u8sm3222310wmm.15.2019.12.10.06.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:02:14 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:02:11 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191210140211.wggjajbvtslumzgi@orion>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <20191210132340.11330-1-bfoster@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210132340.11330-1-bfoster@redhat.com>
X-MC-Unique: iZOtO6T3Nf6a0_gAQWHQ7A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> generic/522 (fsx) occasionally fails with a file corruption due to
> an insert range operation. The primary characteristic of the
> corruption is a misplaced insert range operation that differs from
> the requested target offset. The reason for this behavior is a race
> between the extent shift sequence of an insert range and a COW
> writeback completion that causes a front merge with the first extent
> in the shift.
>=20
> The shift preparation function flushes and unmaps from the target
> offset of the operation to the end of the file to ensure no
> modifications can be made and page cache is invalidated before file
> data is shifted. An insert range operation then splits the extent at
> the target offset, if necessary, and begins to shift the start
> offset of each extent starting from the end of the file to the start
> offset. The shift sequence operates at extent level and so depends
> on the preparation sequence to guarantee no changes can be made to
> the target range during the shift. If the block immediately prior to
> the target offset was dirty and shared, however, it can undergo
> writeback and move from the COW fork to the data fork at any point
> during the shift. If the block is contiguous with the block at the
> start offset of the insert range, it can front merge and alter the
> start offset of the extent. Once the shift sequence reaches the
> target offset, it shifts based on the latest start offset and
> silently changes the target offset of the operation and corrupts the
> file.
>=20
> To address this problem, update the shift preparation code to
> stabilize the start boundary along with the full range of the
> insert. Also update the existing corruption check to fail if any
> extent is shifted with a start offset behind the target offset of
> the insert range. This prevents insert from racing with COW
> writeback completion and fails loudly in the event of an unexpected
> extent shift.
>=20
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This looks ok.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>=20
> This has survived a couple fstests runs (upstream) so far as well as an
> overnight loop test of generic/522 (on RHEL). The RHEL based kernel just
> happened to be where this was originally diagnosed and provides a fairly
> reliable failure rate of within 30 iterations or so. The current test is
> at almost 70 iterations and still running.
>=20
> Brian
>=20
>  fs/xfs/libxfs/xfs_bmap.c |  3 +--
>  fs/xfs/xfs_bmap_util.c   | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index a9ad1f991ba3..4a802b3abe77 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5972,8 +5972,7 @@ xfs_bmap_insert_extents(
>  =09=09goto del_cursor;
>  =09}
> =20
> -=09if (XFS_IS_CORRUPT(mp,
> -=09=09=09   stop_fsb >=3D got.br_startoff + got.br_blockcount)) {
> +=09if (XFS_IS_CORRUPT(mp, stop_fsb > got.br_startoff)) {
>  =09=09error =3D -EFSCORRUPTED;
>  =09=09goto del_cursor;
>  =09}
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2efd78a9719e..e62fb5216341 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -992,6 +992,7 @@ xfs_prepare_shift(
>  =09struct xfs_inode=09*ip,
>  =09loff_t=09=09=09offset)
>  {
> +=09struct xfs_mount=09*mp =3D ip->i_mount;
>  =09int=09=09=09error;
> =20
>  =09/*
> @@ -1004,6 +1005,17 @@ xfs_prepare_shift(
>  =09=09=09return error;
>  =09}
> =20
> +=09/*
> +=09 * Shift operations must stabilize the start block offset boundary al=
ong
> +=09 * with the full range of the operation. If we don't, a COW writeback
> +=09 * completion could race with an insert, front merge with the start
> +=09 * extent (after split) during the shift and corrupt the file. Start
> +=09 * with the block just prior to the start to stabilize the boundary.
> +=09 */
> +=09offset =3D round_down(offset, 1 << mp->m_sb.sb_blocklog);
> +=09if (offset)
> +=09=09offset -=3D (1 << mp->m_sb.sb_blocklog);
> +
>  =09/*
>  =09 * Writeback and invalidate cache for the remainder of the file as we=
're
>  =09 * about to shift down every extent from offset to EOF.
> --=20
> 2.20.1
>=20

--=20
Carlos

