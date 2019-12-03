Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141DDC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB0CF206EC
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 13:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXrETamp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbfLCNDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 08:03:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbfLCNDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 08:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575378179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSiM2GjgiJJhRswJloxpc8Z3eh0K183zTuKo0JytKCo=;
        b=LXrETamp5G6J13hZEbNuBypX+OGe8vmsa1m5FxeIZ31QUUtQHWowLk5Y7EwQaxFvthg/8O
        W+9DyvjHaZE5f0SWg9nqUzwgd0ToSFFjIt3HaBB1DpF4R3cK+O1nzzycdwcPfIa2FCE+gj
        X7KnuT9PNwTrtRvNd5xlBe4lIidRZLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-2LpjP44lMwiIuzHO8hKXIA-1; Tue, 03 Dec 2019 08:02:56 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE51E477;
        Tue,  3 Dec 2019 13:02:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E3AB5C57E;
        Tue,  3 Dec 2019 13:02:53 +0000 (UTC)
Date:   Tue, 3 Dec 2019 08:02:53 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 2/4] mkfs: check root inode location
Message-ID: <20191203130253.GA18418@bfoster>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
 <157530817131.126767.4542572453231190489.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157530817131.126767.4542572453231190489.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 2LpjP44lMwiIuzHO8hKXIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 09:36:11AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Make sure the root inode gets created where repair thinks it should be
> created.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  mkfs/xfs_mkfs.c          |   29 +++++++++++++++++++++++------
>  2 files changed, 24 insertions(+), 6 deletions(-)
>=20
>=20
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 645c9b1b..8f6b9fc2 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -156,5 +156,6 @@
> =20
>  #define xfs_ag_init_headers=09=09libxfs_ag_init_headers
>  #define xfs_buf_delwri_submit=09=09libxfs_buf_delwri_submit
> +#define xfs_ialloc_find_prealloc=09libxfs_ialloc_find_prealloc
> =20

Perhaps this should be in the previous patch..?


>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..5143d9b4 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3521,6 +3521,28 @@ rewrite_secondary_superblocks(
>  =09libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  }
> =20
> +static void
> +check_root_ino(
> +=09struct xfs_mount=09*mp)
> +{
> +=09xfs_agino_t=09=09first, last;
> +
> +=09if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) !=3D 0) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: root inode created in AG %u, not AG 0\n"),
> +=09=09=09progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> +=09=09exit(1);
> +=09}
> +
> +=09libxfs_ialloc_find_prealloc(mp, &first, &last);
> +=09if (mp->m_sb.sb_rootino !=3D XFS_AGINO_TO_INO(mp, 0, first)) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: root inode (%llu) not created in first chunk\n"),
> +=09=09=09progname, (unsigned long long)mp->m_sb.sb_rootino);

If the root inode ended up somewhere in the middle of the first chunk,
we'd fail (rightly), but with a misleading error message. Perhaps
something like "root inode (..) not allocated in expected location"
would be better? I'd also like to see a comment somewhere in here to
explain why we have this check. For example:

"The superblock refers directly to the root inode, but repair makes
hardcoded assumptions about its location based on filesystem geometry
for an extra level of verification. If this assumption ever breaks, we
should flag it immediately and fail the mkfs. Otherwise repair may
consider the filesystem corrupt and toss the root inode."

Feel free to reword that however appropriate (given the behavior change
in subsequent patches), of course..

Brian

> +=09=09exit(1);
> +=09}
> +}
> +
>  int
>  main(
>  =09int=09=09=09argc,
> @@ -3807,12 +3829,7 @@ main(
>  =09/*
>  =09 * Protect ourselves against possible stupidity
>  =09 */
> -=09if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) !=3D 0) {
> -=09=09fprintf(stderr,
> -=09=09=09_("%s: root inode created in AG %u, not AG 0\n"),
> -=09=09=09progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> -=09=09exit(1);
> -=09}
> +=09check_root_ino(mp);
> =20
>  =09/*
>  =09 * Re-write multiple secondary superblocks with rootinode field set
>=20

