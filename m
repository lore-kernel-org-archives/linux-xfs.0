Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBE2CA9EC0
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 15:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE6820862
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 15:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBu/U1tl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfJ1PB4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:01:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32570 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726945AbfJ1PBz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 11:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572274914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvaIO6XQXPJi/Db9tsNtoIPdvm4/oWNAXlvi94nWtY4=;
        b=UBu/U1tltZJ6M3b4s1PWObD3VsvYKc0bbpxNIxIbfh6j9T4LLqHELUEWAqxI0PRXJ0t2se
        MfOuw6kiNYhoIneYu9V71SJ5mJughisWqcmOmBpVCX6sMN4J9yxQk445uF/hc1LdhhQqdb
        cbgmdvM/njXTspBVE4mmJUcU/R5pKYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-yD83FiVrMhWQR831CQNs0g-1; Mon, 28 Oct 2019 11:01:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A297801E64;
        Mon, 28 Oct 2019 15:01:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 130DB3DA6;
        Mon, 28 Oct 2019 15:01:50 +0000 (UTC)
Date:   Mon, 28 Oct 2019 11:01:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: simplify setting bio flags
Message-ID: <20191028150149.GA26529@bfoster>
References: <20191025174213.32143-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20191025174213.32143-1-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: yD83FiVrMhWQR831CQNs0g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 07:42:13PM +0200, Christoph Hellwig wrote:
> Stop using the deprecated bio_set_op_attrs helper, and use a single
> argument to xfs_buf_ioapply_map for the operation and flags.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9640e4174552..1e63dd3d1257 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1261,8 +1261,7 @@ xfs_buf_ioapply_map(
>  =09int=09=09map,
>  =09int=09=09*buf_offset,
>  =09int=09=09*count,
> -=09int=09=09op,
> -=09int=09=09op_flags)
> +=09int=09=09op)
>  {
>  =09int=09=09page_index;
>  =09int=09=09total_nr_pages =3D bp->b_page_count;
> @@ -1297,7 +1296,7 @@ xfs_buf_ioapply_map(
>  =09bio->bi_iter.bi_sector =3D sector;
>  =09bio->bi_end_io =3D xfs_buf_bio_end_io;
>  =09bio->bi_private =3D bp;
> -=09bio_set_op_attrs(bio, op, op_flags);
> +=09bio->bi_opf =3D op;
> =20
>  =09for (; size && nr_pages; nr_pages--, page_index++) {
>  =09=09int=09rbytes, nbytes =3D PAGE_SIZE - offset;
> @@ -1342,7 +1341,6 @@ _xfs_buf_ioapply(
>  {
>  =09struct blk_plug=09plug;
>  =09int=09=09op;
> -=09int=09=09op_flags =3D 0;
>  =09int=09=09offset;
>  =09int=09=09size;
>  =09int=09=09i;
> @@ -1384,15 +1382,14 @@ _xfs_buf_ioapply(
>  =09=09=09=09dump_stack();
>  =09=09=09}
>  =09=09}
> -=09} else if (bp->b_flags & XBF_READ_AHEAD) {
> -=09=09op =3D REQ_OP_READ;
> -=09=09op_flags =3D REQ_RAHEAD;
>  =09} else {
>  =09=09op =3D REQ_OP_READ;
> +=09=09if (bp->b_flags & XBF_READ_AHEAD)
> +=09=09=09op |=3D REQ_RAHEAD;
>  =09}
> =20
>  =09/* we only use the buffer cache for meta-data */
> -=09op_flags |=3D REQ_META;
> +=09op |=3D REQ_META;
> =20
>  =09/*
>  =09 * Walk all the vectors issuing IO on them. Set up the initial offset
> @@ -1404,7 +1401,7 @@ _xfs_buf_ioapply(
>  =09size =3D BBTOB(bp->b_length);
>  =09blk_start_plug(&plug);
>  =09for (i =3D 0; i < bp->b_map_count; i++) {
> -=09=09xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
> +=09=09xfs_buf_ioapply_map(bp, i, &offset, &size, op);
>  =09=09if (bp->b_error)
>  =09=09=09break;
>  =09=09if (size <=3D 0)
> --=20
> 2.20.1
>=20

