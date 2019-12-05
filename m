Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AF0C2D0C1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ECD621835
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 14:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CI8rOj9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbfLEOgi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:36:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729406AbfLEOgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 09:36:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0L4A6dvfzccocVMmMFkHVVGWo99V0vrlDQwR9nJDic4=;
        b=CI8rOj9dfy5dpzQ0ApW9ewcXTRnANdo3cB4nky7vldcn4aQ6+lSRVgFX9SKGPgHrBL0dt2
        IkJh+5sLyloo/T34whZLgrusrpHQ21ipAt86Uu5/DHKJKydHgOl3pCV7gj6Om7AzWU+8hD
        A7LKNfTCQSCpmjm2ctozH9bEm55lNws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-TmlW9zJXNd-erzkEI6XjSQ-1; Thu, 05 Dec 2019 09:36:33 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC2761005509;
        Thu,  5 Dec 2019 14:36:31 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 594E310013D9;
        Thu,  5 Dec 2019 14:36:31 +0000 (UTC)
Date:   Thu, 5 Dec 2019 09:36:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 2/6] mkfs: check root inode location
Message-ID: <20191205143631.GB48368@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547907575.974712.18261328888206083261.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157547907575.974712.18261328888206083261.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: TmlW9zJXNd-erzkEI6XjSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 09:04:35AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Make sure the root inode gets created where repair thinks it should be
> created.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/libxfs_api_defs.h |    1 +
>  mkfs/xfs_mkfs.c          |   39 +++++++++++++++++++++++++++++++++------
>  2 files changed, 34 insertions(+), 6 deletions(-)
>=20
>=20
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 645c9b1b..f8e7d82d 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -156,5 +156,6 @@
> =20
>  #define xfs_ag_init_headers=09=09libxfs_ag_init_headers
>  #define xfs_buf_delwri_submit=09=09libxfs_buf_delwri_submit
> +#define xfs_ialloc_calc_rootino=09=09libxfs_ialloc_calc_rootino
> =20
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 18338a61..71be033d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3521,6 +3521,38 @@ rewrite_secondary_superblocks(
>  =09libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>  }
> =20
> +static void
> +check_root_ino(
> +=09struct xfs_mount=09*mp)
> +{
> +=09xfs_ino_t=09=09ino;
> +
> +=09if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) !=3D 0) {
> +=09=09fprintf(stderr,
> +=09=09=09_("%s: root inode created in AG %u, not AG 0\n"),
> +=09=09=09progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> +=09=09exit(1);
> +=09}
> +
> +=09/*
> +=09 * The superblock points to the root directory inode, but xfs_repair
> +=09 * expects to find the root inode in a very specific location compute=
d
> +=09 * from the filesystem geometry for an extra level of verification.
> +=09 *
> +=09 * Fail the format immediately if those assumptions ever break, becau=
se
> +=09 * repair will toss the root directory.
> +=09 */
> +=09ino =3D libxfs_ialloc_calc_rootino(mp, -1);
> +=09if (mp->m_sb.sb_rootino !=3D ino) {
> +=09=09fprintf(stderr,
> +=09_("%s: root inode (%llu) not allocated in expected location (%llu)\n"=
),
> +=09=09=09progname,
> +=09=09=09(unsigned long long)mp->m_sb.sb_rootino,
> +=09=09=09(unsigned long long)ino);
> +=09=09exit(1);
> +=09}
> +}
> +
>  int
>  main(
>  =09int=09=09=09argc,
> @@ -3807,12 +3839,7 @@ main(
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

