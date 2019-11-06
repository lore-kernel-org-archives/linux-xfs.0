Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7060BC5DF62
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 12:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2201D2187F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 12:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkJgVYoD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfKFMtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 07:49:43 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20719 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727652AbfKFMtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 07:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573044581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4OSbEFdbYke0F0Tg5Q2GKjQ+9XCoZ9WgPp97MYM6aA=;
        b=gkJgVYoDxL57Qbo06GZ0pEIeGreV7ZP5Yp05zYQ7vYesqTPttLOe7mps/HSDNeJoxkzVOw
        xs2vjMNd+tN6MnEwRyUBrk23XozAHi8WvlffXxYoheoXZGSoz61oblUANYLoysmNdSNUgq
        by0b8TVkQHp6pJCXMiCOH9QtjUG7PRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-7wNsmyQQPb6N9C8elh9gsA-1; Wed, 06 Nov 2019 07:49:38 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73CD51005500;
        Wed,  6 Nov 2019 12:49:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4D695D6D4;
        Wed,  6 Nov 2019 12:49:34 +0000 (UTC)
Date:   Wed, 6 Nov 2019 07:49:32 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191106124932.GA37080@bfoster>
References: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
 <20191106045630.GO15221@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191106045630.GO15221@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 7wNsmyQQPb6N9C8elh9gsA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 08:56:30PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 05, 2019 at 05:52:12PM +0800, kaixuxia wrote:
> > When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
> > need to hold the AGF lock to allocate more blocks, and then invoking
> > the xfs_droplink() call to hold AGI lock to drop target_ip onto the
> > unlinked list, so we get the lock order AGF->AGI. This would break the
> > ordering constraint on AGI and AGF locking - inode allocation locks
> > the AGI, then can allocate a new extent for new inodes, locking the
> > AGF after the AGI.
> >=20
> > In this patch we check whether the replace operation need more
> > blocks firstly. If so, acquire the agi lock firstly to preserve
> > locking order(AGI/AGF). Actually, the locking order problem only
> > occurs when we are locking the AGI/AGF of the same AG. For multiple
> > AGs the AGI lock will be released after the transaction committed.
> >=20
> > Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> > ---
> > Changes in v2:
> >  - Add xfs_dir2_sf_replace_needblock() helper in
> >    xfs_dir2_sf.c.
> >=20
> >  fs/xfs/libxfs/xfs_dir2.c      | 23 +++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_dir2.h      |  2 ++
> >  fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
> >  fs/xfs/libxfs/xfs_dir2_sf.c   | 24 ++++++++++++++++++++++++
> >  fs/xfs/xfs_inode.c            | 14 ++++++++++++++
> >  5 files changed, 65 insertions(+)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > index 867c5de..1917990 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.c
> > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > @@ -463,6 +463,29 @@
> >  }
> > =20
> >  /*
> > + * Check whether the replace operation need more blocks. Ignore
> > + * the parameters check since the real replace() call below will
> > + * do that.
> > + */
> > +bool
> > +xfs_dir_replace_needblock(
>=20
> xfs_dir2, to be consistent.
>=20
> > +=09struct xfs_inode=09*dp,
> > +=09xfs_ino_t=09=09inum)
>=20
> If you passed the inode pointer (instead of ip->i_ino) here then you
> don't need to revalidate the inode number.
>=20
> > +{
> > +=09int=09=09=09rval;
> > +
> > +=09rval =3D xfs_dir_ino_validate(dp->i_mount, inum);
> > +=09if (rval)
> > +=09=09return false;
> > +
> > +=09/*
> > +=09 * Only convert the shortform directory to block form maybe
> > +=09 * need more blocks.
> > +=09 */
> > +=09return xfs_dir2_sf_replace_needblock(dp, inum);
>=20
> =09if (dp->i_d.di_format !=3D XFS_DINODE_FMT_LOCAL)
> =09=09return xfs_dir2_sf_replace_needblock(...);
>=20
> Also, do other directories formats need extra blocks allocated?
>=20
> > +}
> > +
> > +/*
> >   * Replace the inode number of a directory entry.
> >   */
> >  int
> > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > index f542447..e436c14 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.h
> > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, str=
uct xfs_inode *dp,
> >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *=
dp,
> >  =09=09=09=09struct xfs_name *name, xfs_ino_t ino,
> >  =09=09=09=09xfs_extlen_t tot);
> > +extern bool xfs_dir_replace_needblock(struct xfs_inode *dp,
> > +=09=09=09=09xfs_ino_t inum);
> >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> >  =09=09=09=09struct xfs_name *name, xfs_ino_t inum,
> >  =09=09=09=09xfs_extlen_t tot);
> > diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_pri=
v.h
> > index 59f9fb2..002103f 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> > +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> > @@ -116,6 +116,8 @@ extern int xfs_dir2_block_to_sf(struct xfs_da_args =
*args, struct xfs_buf *bp,
> >  extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino=
);
> >  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
> >  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
> > +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > +=09=09xfs_ino_t inum);
> >  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
> >  extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
> > =20
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index 85f14fc..0906f91 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -945,6 +945,30 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t =
*args, int objchange,
> >  }
> > =20
> >  /*
> > + * Check whether the replace operation need more blocks.
> > + */
> > +bool
> > +xfs_dir2_sf_replace_needblock(
>=20
> Urgggh.  This is a predicate that we only ever call from xfs_rename(),
> right?  And it addresses a particular quirk of the locking when the
> caller wants us to rename on top of an existing entry and drop the link
> count of the old inode, right?  So why can't this just be a predicate in
> xfs_inode.c ?  Nobody else needs to know this particular piece of
> information, AFAICT.
>=20
> (Apologies, for Brian and I clearly aren't on the same page about
> that...)
>=20

Hmm.. the crux of my feedback on the previous version was simply that if
we wanted to take this approach of pulling up lower level dir logic into
the higher level rename code, to simply factor out the existing checks
down in the dir replace code that currently trigger a format conversion,
and use that new helper in both places. That doesn't appear to be what
this patch does, and I'm not sure why there are now two new helpers that
each only have one caller instead of one new helper with two callers...

Brian

> > +=09struct xfs_inode=09*dp,
> > +=09xfs_ino_t=09=09inum)
> > +{
> > +=09int=09=09=09newsize;
> > +=09xfs_dir2_sf_hdr_t=09*sfp;
> > +
> > +=09if (dp->i_d.di_format !=3D XFS_DINODE_FMT_LOCAL)
> > +=09=09return false;
>=20
> This check should be used up in xfs_dir2_replace_needblock() to decide
> if we're calling xfs_dir2_sf_replace_needblock(), or just returning
> false.
>=20
> > +
> > +=09sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> > +=09newsize =3D dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> > +
> > +=09if (inum > XFS_DIR2_MAX_SHORT_INUM &&
> > +=09    sfp->i8count =3D=3D 0 && newsize > XFS_IFORK_DSIZE(dp))
> > +=09=09return true;
> > +=09else
> > +=09=09return false;
>=20
> return inum > XFS_DIR2_MAX_SHORT_INUM && (all the rest of that);
>=20
> > +}
> > +
> > +/*
> >   * Replace the inode number of an entry in a shortform directory.
> >   */
> >  int=09=09=09=09=09=09/* error */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 18f4b26..c239070 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3196,6 +3196,7 @@ struct xfs_iunlink {
> >  =09struct xfs_trans=09*tp;
> >  =09struct xfs_inode=09*wip =3D NULL;=09=09/* whiteout inode */
> >  =09struct xfs_inode=09*inodes[__XFS_SORT_INODES];
> > +=09struct xfs_buf=09=09*agibp;
> >  =09int=09=09=09num_inodes =3D __XFS_SORT_INODES;
> >  =09bool=09=09=09new_parent =3D (src_dp !=3D target_dp);
> >  =09bool=09=09=09src_is_directory =3D S_ISDIR(VFS_I(src_ip)->i_mode);
> > @@ -3361,6 +3362,19 @@ struct xfs_iunlink {
> >  =09=09 * In case there is already an entry with the same
> >  =09=09 * name at the destination directory, remove it first.
> >  =09=09 */
> > +
> > +=09=09/*
> > +=09=09 * Check whether the replace operation need more blocks.
> > +=09=09 * If so, acquire the agi lock firstly to preserve locking
>=20
>                                                "first"
>=20
> > +=09=09 * order(AGI/AGF).
>=20
> Nit: space between "order" and "(AGI/AGF)".
> > +=09=09 */
> > +=09=09if (xfs_dir_replace_needblock(target_dp, src_ip->i_ino)) {
> > +=09=09=09error =3D xfs_read_agi(mp, tp,
> > +=09=09=09=09=09XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
>=20
> Overly long line here.
>=20
> --D
>=20
> > +=09=09=09if (error)
> > +=09=09=09=09goto out_trans_cancel;
> > +=09=09}
> > +
> >  =09=09error =3D xfs_dir_replace(tp, target_dp, target_name,
> >  =09=09=09=09=09src_ip->i_ino, spaceres);
> >  =09=09if (error)
> > --=20
> > 1.8.3.1
> >=20

