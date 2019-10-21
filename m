Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D63CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 14:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6D2320640
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 14:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6opDYOs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfJUOe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 10:34:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47102 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727040AbfJUOe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 10:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571668496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/43XNaQxiXDAvzT4qVM4BARY4zkRTUMfi5MBBSEd+w=;
        b=H6opDYOsY7vpe7aduN+eUtD1g6/+D99zPHzg1yNtfg8KDaOspCSAv4u8NGgoLJwAOXxvGz
        uEp194lGJECExnQokdIOzHapBBoBSMq+w4P9D9FBa0sfqT7uEHTcVxBs97K12Fn4KZlD/G
        N/V/I5IIOCcBZ9V0zpyKs6TY+LVpJNE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-MgLrePOMNv2kPzCYy94h5Q-1; Mon, 21 Oct 2019 10:34:55 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C6E8107AD31;
        Mon, 21 Oct 2019 14:34:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B92015DA60;
        Mon, 21 Oct 2019 14:34:53 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:34:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: replace open-coded bitmap weight logic
Message-ID: <20191021143452.GD26105@bfoster>
References: <157063973592.2913318.8246472567175058111.stgit@magnolia>
 <157063975219.2913318.17554625502389919068.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063975219.2913318.17554625502389919068.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: MgLrePOMNv2kPzCYy94h5Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Add a xbitmap_hweight helper function so that we can get rid of the
> open-coded loop.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |   12 ++----------
>  fs/xfs/scrub/bitmap.c          |   15 +++++++++++++++
>  fs/xfs/scrub/bitmap.h          |    1 +
>  3 files changed, 18 insertions(+), 10 deletions(-)
>=20
>=20
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repai=
r.c
> index 9fbb6035f4e2..f35596cc26fb 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -482,8 +482,6 @@ xrep_agfl_collect_blocks(
>  =09struct xrep_agfl=09ra;
>  =09struct xfs_mount=09*mp =3D sc->mp;
>  =09struct xfs_btree_cur=09*cur;
> -=09struct xbitmap_range=09*br;
> -=09struct xbitmap_range=09*n;
>  =09int=09=09=09error;
> =20
>  =09ra.sc =3D sc;
> @@ -527,14 +525,8 @@ xrep_agfl_collect_blocks(
>  =09 * Calculate the new AGFL size.  If we found more blocks than fit in
>  =09 * the AGFL we'll free them later.
>  =09 */
> -=09*flcount =3D 0;
> -=09for_each_xbitmap_extent(br, n, agfl_extents) {
> -=09=09*flcount +=3D br->len;
> -=09=09if (*flcount > xfs_agfl_size(mp))
> -=09=09=09break;
> -=09}
> -=09if (*flcount > xfs_agfl_size(mp))
> -=09=09*flcount =3D xfs_agfl_size(mp);
> +=09*flcount =3D min_t(uint64_t, xbitmap_hweight(agfl_extents),
> +=09=09=09 xfs_agfl_size(mp));
>  =09return 0;
> =20
>  err:
> diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
> index 5b07b46c89c9..8b704d7b5855 100644
> --- a/fs/xfs/scrub/bitmap.c
> +++ b/fs/xfs/scrub/bitmap.c
> @@ -296,3 +296,18 @@ xbitmap_set_btblocks(
>  {
>  =09return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock, bitmap);
>  }
> +
> +/* How many bits are set in this bitmap? */
> +uint64_t
> +xbitmap_hweight(
> +=09struct xbitmap=09=09*bitmap)
> +{
> +=09struct xbitmap_range=09*bmr;
> +=09struct xbitmap_range=09*n;
> +=09uint64_t=09=09ret =3D 0;
> +
> +=09for_each_xbitmap_extent(bmr, n, bitmap)
> +=09=09ret +=3D bmr->len;
> +
> +=09return ret;
> +}
> diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
> index 8db4017ac78e..900646b72de1 100644
> --- a/fs/xfs/scrub/bitmap.h
> +++ b/fs/xfs/scrub/bitmap.h
> @@ -32,5 +32,6 @@ int xbitmap_set_btcur_path(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
>  int xbitmap_set_btblocks(struct xbitmap *bitmap,
>  =09=09struct xfs_btree_cur *cur);
> +uint64_t xbitmap_hweight(struct xbitmap *bitmap);
> =20
>  #endif=09/* __XFS_SCRUB_BITMAP_H__ */
>=20

