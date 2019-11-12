Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAC2C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 17:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D986C21D7F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 17:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+KPcjGa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKLRAD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 12:00:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726718AbfKLRAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 12:00:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573578001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1riVO35dl25+BhaDbytolvWStOD8AN3S7GlSIm+98D4=;
        b=E+KPcjGaZq302BIQSfK52d8SKBwgYXEa/eF9Yq9Dxolrro7qTup0f+U2lpn80Fn8SasQ2i
        nQd15eAqFy3cakdNEU0vuW9tQG3owcsK5xhVTfWR0ySZIwKmqFDhvOUGuch5dKf37WsfA7
        B5gWgeE9J9y/bcnPiIW7PkZ8zw9viOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-QscljdisOjOL_Hyv00P3NA-1; Tue, 12 Nov 2019 12:00:00 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F22D31909ABF;
        Tue, 12 Nov 2019 16:59:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 420305DDA8;
        Tue, 12 Nov 2019 16:59:58 +0000 (UTC)
Date:   Tue, 12 Nov 2019 11:59:56 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v4] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191112165956.GC46980@bfoster>
References: <1573557210-6241-1-git-send-email-kaixuxia@tencent.com>
 <20191112163414.GA6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191112163414.GA6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: QscljdisOjOL_Hyv00P3NA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 12, 2019 at 08:34:14AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 12, 2019 at 07:13:30PM +0800, kaixuxia wrote:
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
> > Changes in v4:
> >  -Remove the typedef usages.
> >  -Invoke xfs_dir2_sf_replace_needblock() in
> >   xfs_dir2_sf_replace() directly.
> >=20
> >  fs/xfs/libxfs/xfs_dir2.h    |  2 ++
> >  fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
> >  fs/xfs/xfs_inode.c          | 15 +++++++++++++++
> >  3 files changed, 40 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> > index f542447..01b1722 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.h
> > +++ b/fs/xfs/libxfs/xfs_dir2.h
> > @@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, str=
uct xfs_inode *dp,
> >  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *=
dp,
> >  =09=09=09=09struct xfs_name *name, xfs_ino_t ino,
> >  =09=09=09=09xfs_extlen_t tot);
> > +extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
> > +=09=09=09=09xfs_ino_t inum);
> >  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
> >  =09=09=09=09struct xfs_name *name, xfs_ino_t inum,
> >  =09=09=09=09xfs_extlen_t tot);
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index 85f14fc..0e112e1 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> > @@ -945,6 +945,27 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_t =
*args, int objchange,
> >  }
> > =20
> >  /*
> > + * Check whether the sf dir replace operation need more blocks.
> > + */
> > +bool
> > +xfs_dir2_sf_replace_needblock(
> > +=09struct xfs_inode=09*dp,
> > +=09xfs_ino_t=09=09inum)
> > +{
> > +=09int=09=09=09newsize;
> > +=09struct xfs_dir2_sf_hdr=09*sfp;
> > +
> > +=09if (dp->i_d.di_format !=3D XFS_DINODE_FMT_LOCAL)
> > +=09=09return false;
> > +
> > +=09sfp =3D (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
> > +=09newsize =3D dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
> > +
> > +=09return inum > XFS_DIR2_MAX_SHORT_INUM &&
> > +=09       sfp->i8count =3D=3D 0 && newsize > XFS_IFORK_DSIZE(dp);
> > +}
> > +
> > +/*
> >   * Replace the inode number of an entry in a shortform directory.
> >   */
> >  int=09=09=09=09=09=09/* error */
> > @@ -980,17 +1001,14 @@ static int xfs_dir2_sf_addname_pick(xfs_da_args_=
t *args, int objchange,
> >  =09 */
> >  =09if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count =3D=3D =
0) {
> >  =09=09int=09error;=09=09=09/* error return value */
> > -=09=09int=09newsize;=09=09/* new inode size */
> > =20
> > -=09=09newsize =3D dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIF=
F;
> >  =09=09/*
> >  =09=09 * Won't fit as shortform, convert to block then do replace.
> >  =09=09 */
> > -=09=09if (newsize > XFS_IFORK_DSIZE(dp)) {
> > +=09=09if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
> >  =09=09=09error =3D xfs_dir2_sf_to_block(args);
> > -=09=09=09if (error) {
> > +=09=09=09if (error)
> >  =09=09=09=09return error;
> > -=09=09=09}
> >  =09=09=09return xfs_dir2_block_replace(args);
> >  =09=09}
> >  =09=09/*
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 18f4b26..5dc3796 100644
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
> > @@ -3361,6 +3362,20 @@ struct xfs_iunlink {
> >  =09=09 * In case there is already an entry with the same
> >  =09=09 * name at the destination directory, remove it first.
> >  =09=09 */
> > +
> > +=09=09/*
> > +=09=09 * Check whether the replace operation need more blocks.
> > +=09=09 * If so, acquire the agi lock firstly to preserve locking
> > +=09=09 * order (AGI/AGF). Only convert the shortform directory to
> > +=09=09 * block form maybe need more blocks.
>=20
> The comment still seems a little clunky.  How about:
>=20
> "Check whether the replace operation will need to allocate blocks.  This
> happens when the shortform directory lacks space and we have to convert
> it to a block format directory.  When more blocks are necessary we must
> lock the AGI first to preserve locking order (AGI -> AGF)."
>=20
> > +=09=09 */
> > +=09=09if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
> > +=09=09=09error =3D xfs_read_agi(mp, tp,
> > +=09=09=09=09XFS_INO_TO_AGNO(mp, target_ip->i_ino), &agibp);
>=20
> The second line needs a double indent.
>=20
> I can fix both of these on commit if Brian doesn't have any further
> suggestions.
>=20
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20

I was hoping for a little more cleanup of the existing
xfs_dir2_sf_replace() logic, but that can always come later. This looks
correct to me and we might as well get this bug fixed. With Darrick's
adjustments:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
>=20

