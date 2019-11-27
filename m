Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13070C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 13:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D40212071E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 13:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bUPsnWfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfK0NFX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 08:05:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43978 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726520AbfK0NFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 08:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574859921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0TEe5a6QgXLHJmVYOQJnqQqWhbeJM6HxR3GqU+X+RY=;
        b=bUPsnWfqkCTZS8qG37yEB+wSHzEG/jez//2iwTssRXk2snCktJFTzCZ8u21KC9Msa7kwTH
        ofpYX59FnqCgkoNnkfKQ29/qx7iBQ0YjlQ6bY5XQAv6YyZWgaHfCcgZgFMm1PgbXNzzsA6
        m9taMDJTXSMnQknUmitQR2rz04GvkBE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-h3s32XGkNyuBZt1XKeav6w-1; Wed, 27 Nov 2019 08:05:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEC6C8C5DD1;
        Wed, 27 Nov 2019 13:05:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 988865D6A7;
        Wed, 27 Nov 2019 13:05:18 +0000 (UTC)
Date:   Wed, 27 Nov 2019 08:05:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow parent directory scans to be interrupted with
 fatal signals
Message-ID: <20191127130518.GA56266@bfoster>
References: <20191126161517.GO6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191126161517.GO6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: h3s32XGkNyuBZt1XKeav6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 08:15:17AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Allow a fatal signal to interrupt us when we're scanning a directory to
> verify a parent pointer.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/parent.c |   25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index 17100a83e23e..5705adc43a75 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -32,8 +32,10 @@ xchk_setup_parent(
> =20
>  struct xchk_parent_ctx {
>  =09struct dir_context=09dc;
> +=09struct xfs_scrub=09*sc;
>  =09xfs_ino_t=09=09ino;
>  =09xfs_nlink_t=09=09nlink;
> +=09bool=09=09=09cancelled;
>  };
> =20
>  /* Look for a single entry in a directory pointing to an inode. */
> @@ -47,11 +49,21 @@ xchk_parent_actor(
>  =09unsigned=09=09type)
>  {
>  =09struct xchk_parent_ctx=09*spc;
> +=09int=09=09=09error =3D 0;
> =20
>  =09spc =3D container_of(dc, struct xchk_parent_ctx, dc);
>  =09if (spc->ino =3D=3D ino)
>  =09=09spc->nlink++;
> -=09return 0;
> +
> +=09/*
> +=09 * If we're facing a fatal signal, bail out.  Store the cancellation
> +=09 * status separately because the VFS readdir code squashes error code=
s
> +=09 * into short directory reads.
> +=09 */
> +=09if (xchk_should_terminate(spc->sc, &error))
> +=09=09spc->cancelled =3D true;
> +
> +=09return error;
>  }
> =20
>  /* Count the number of dentries in the parent dir that point to this ino=
de. */
> @@ -62,10 +74,9 @@ xchk_parent_count_parent_dentries(
>  =09xfs_nlink_t=09=09*nlink)
>  {
>  =09struct xchk_parent_ctx=09spc =3D {
> -=09=09.dc.actor =3D xchk_parent_actor,
> -=09=09.dc.pos =3D 0,
> -=09=09.ino =3D sc->ip->i_ino,
> -=09=09.nlink =3D 0,
> +=09=09.dc.actor=09=3D xchk_parent_actor,
> +=09=09.ino=09=09=3D sc->ip->i_ino,
> +=09=09.sc=09=09=3D sc,
>  =09};
>  =09size_t=09=09=09bufsize;
>  =09loff_t=09=09=09oldpos;
> @@ -97,6 +108,10 @@ xchk_parent_count_parent_dentries(
>  =09=09error =3D xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
>  =09=09if (error)
>  =09=09=09goto out;
> +=09=09if (spc.cancelled) {
> +=09=09=09error =3D -EAGAIN;
> +=09=09=09goto out;
> +=09=09}
>  =09=09if (oldpos =3D=3D spc.dc.pos)
>  =09=09=09break;
>  =09=09oldpos =3D spc.dc.pos;
>=20

