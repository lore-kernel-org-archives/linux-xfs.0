Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A033C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 11:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0979207DD
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 11:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eElZR9yc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfLDLvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 06:51:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727445AbfLDLvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 06:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575460280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRyjjNazdrfVbtlRsb2Unisi/CQoxe8RBRDtaxpGzPY=;
        b=eElZR9ycv7rDmyq810jiRmqfmITvefU9KBd3Seqoa5fLz+KQLcUZg8sxKm15V8k0PI6g22
        1WY2OuByL7k56CUXqEj+pN/8XboSbXKbEazTbJ4vU0qLSZk/4SXEBE/4vbDlVvO3g8FSOi
        b8n0d72SuK9vurfQD46ZVQkd9AO7xe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-pv5VoQ4zOXGA2bqoAaqLdw-1; Wed, 04 Dec 2019 06:51:16 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9238C10054E3;
        Wed,  4 Dec 2019 11:51:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02BD45D6B7;
        Wed,  4 Dec 2019 11:51:14 +0000 (UTC)
Date:   Wed, 4 Dec 2019 06:51:14 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 2/4] mkfs: check root inode location
Message-ID: <20191204115114.GA40798@bfoster>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
 <157530817131.126767.4542572453231190489.stgit@magnolia>
 <20191203130253.GA18418@bfoster>
 <20191203234007.GL7335@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191203234007.GL7335@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: pv5VoQ4zOXGA2bqoAaqLdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 03:40:07PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2019 at 08:02:53AM -0500, Brian Foster wrote:
> > On Mon, Dec 02, 2019 at 09:36:11AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> > > Make sure the root inode gets created where repair thinks it should b=
e
> > > created.
> > >=20
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  libxfs/libxfs_api_defs.h |    1 +
> > >  mkfs/xfs_mkfs.c          |   29 +++++++++++++++++++++++------
> > >  2 files changed, 24 insertions(+), 6 deletions(-)
> > >=20
> > >=20
> > > diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> > > index 645c9b1b..8f6b9fc2 100644
> > > --- a/libxfs/libxfs_api_defs.h
> > > +++ b/libxfs/libxfs_api_defs.h
> > > @@ -156,5 +156,6 @@
> > > =20
> > >  #define xfs_ag_init_headers=09=09libxfs_ag_init_headers
> > >  #define xfs_buf_delwri_submit=09=09libxfs_buf_delwri_submit
> > > +#define xfs_ialloc_find_prealloc=09libxfs_ialloc_find_prealloc
> > > =20
> >=20
> > Perhaps this should be in the previous patch..?
>=20
> <shrug> I think the libxfs wrapper macro things shouldn't be introduced
> until there's a caller outside of libxfs.
>=20

Ok, fair enough..

> >=20
> > >  #endif /* __LIBXFS_API_DEFS_H__ */
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index 18338a61..5143d9b4 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -3521,6 +3521,28 @@ rewrite_secondary_superblocks(
> > >  =09libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
> > >  }
> > > =20
> > > +static void
> > > +check_root_ino(
> > > +=09struct xfs_mount=09*mp)
> > > +{
> > > +=09xfs_agino_t=09=09first, last;
> > > +
> > > +=09if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) !=3D 0) {
> > > +=09=09fprintf(stderr,
> > > +=09=09=09_("%s: root inode created in AG %u, not AG 0\n"),
> > > +=09=09=09progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> > > +=09=09exit(1);
> > > +=09}
> > > +
> > > +=09libxfs_ialloc_find_prealloc(mp, &first, &last);
> > > +=09if (mp->m_sb.sb_rootino !=3D XFS_AGINO_TO_INO(mp, 0, first)) {
> > > +=09=09fprintf(stderr,
> > > +=09=09=09_("%s: root inode (%llu) not created in first chunk\n"),
> > > +=09=09=09progname, (unsigned long long)mp->m_sb.sb_rootino);
> >=20
> > If the root inode ended up somewhere in the middle of the first chunk,
> > we'd fail (rightly), but with a misleading error message. Perhaps
> > something like "root inode (..) not allocated in expected location"
>=20
> Ok, fixed.
>=20
> > would be better? I'd also like to see a comment somewhere in here to
> > explain why we have this check. For example:
> >=20
> > "The superblock refers directly to the root inode, but repair makes
> > hardcoded assumptions about its location based on filesystem geometry
> > for an extra level of verification. If this assumption ever breaks, we
> > should flag it immediately and fail the mkfs. Otherwise repair may
> > consider the filesystem corrupt and toss the root inode."
>=20
> How about:
>=20
> /*
>  * The superblock points to the root directory inode, but xfs_repair
>  * expects to find the root inode in a very specific location computed
>  * from the filesystem geometry for an extra level of verification.
>  *
>  * Fail the format immediately if those assumptions ever break, because
>  * repair will toss the root directory.
>  */
>=20

Sounds good, thanks!

Brian

> > Feel free to reword that however appropriate (given the behavior change
> > in subsequent patches), of course..
>=20
> Ok.
>=20
> --D
>=20
> > Brian
> >=20
> > > +=09=09exit(1);
> > > +=09}
> > > +}
> > > +
> > >  int
> > >  main(
> > >  =09int=09=09=09argc,
> > > @@ -3807,12 +3829,7 @@ main(
> > >  =09/*
> > >  =09 * Protect ourselves against possible stupidity
> > >  =09 */
> > > -=09if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino) !=3D 0) {
> > > -=09=09fprintf(stderr,
> > > -=09=09=09_("%s: root inode created in AG %u, not AG 0\n"),
> > > -=09=09=09progname, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino));
> > > -=09=09exit(1);
> > > -=09}
> > > +=09check_root_ino(mp);
> > > =20
> > >  =09/*
> > >  =09 * Re-write multiple secondary superblocks with rootinode field s=
et
> > >=20
> >=20
>=20

