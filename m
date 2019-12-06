Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8C4C43603
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 10:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D460124659
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 10:57:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9gfl7Zm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfLFK56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 05:57:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbfLFK56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 05:57:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575629876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RILR/rvIRSst/Pf/1tTkhwJ00BX9bnUxR6RYNloq984=;
        b=W9gfl7ZmpnT0aLBjLGdZmcowwmNfKiv/vmKjp0LTx+z8zeeD99m1BkOBNPq2SkCKjOtfo/
        J7mDxxeDIqyI60a3OA6U9uFzfI4Dmi7Ua+o0YChjTOf52feYFWhIfqAGDXhVagVImuKN39
        kxNZlBLOSrGBH2VmD0XF3GOQEmAkFms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-eok3PKmgNX-d0cAEI60Ncw-1; Fri, 06 Dec 2019 05:57:53 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01D94800D41;
        Fri,  6 Dec 2019 10:57:52 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 785FB691BF;
        Fri,  6 Dec 2019 10:57:51 +0000 (UTC)
Date:   Fri, 6 Dec 2019 05:57:51 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
Message-ID: <20191206105751.GA55746@bfoster>
References: <20191204170340.GR7335@magnolia>
 <20191205143618.GA48368@bfoster>
 <20191205214222.GE13260@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191205214222.GE13260@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: eok3PKmgNX-d0cAEI60Ncw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 05, 2019 at 01:42:22PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 05, 2019 at 09:36:18AM -0500, Brian Foster wrote:
> > On Wed, Dec 04, 2019 at 09:03:40AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> > > Alex Lyakas reported[1] that mounting an xfs filesystem with new suni=
t
> > > and swidth values could cause xfs_repair to fail loudly.  The problem
> > > here is that repair calculates the where mkfs should have allocated t=
he
> > > root inode, based on the superblock geometry.  The allocation decisio=
ns
> > > depend on sunit, which means that we really can't go updating sunit i=
f
> > > it would lead to a subsequent repair failure on an otherwise correct
> > > filesystem.
> > >=20
> > > Port the computation code from xfs_repair and teach mount to avoid th=
e
> > > ondisk update if it would cause problems for repair.  We allow the mo=
unt
> > > to proceed (and new allocations will reflect this new geometry) becau=
se
> > > we've never screened this kind of thing before.
> > >=20
> > > [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/=
T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> > >=20
> > > Reported-by: Alex Lyakas <alex@zadara.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: compute the root inode location directly
> > > ---
> > >  fs/xfs/libxfs/xfs_ialloc.c |   81 ++++++++++++++++++++++++++++++++++=
++++++++++
> > >  fs/xfs/libxfs/xfs_ialloc.h |    1 +
> > >  fs/xfs/xfs_mount.c         |   51 ++++++++++++++++++----------
> > >  3 files changed, 115 insertions(+), 18 deletions(-)
> > >=20
...
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index fca65109cf24..a4eb3ae34a84 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
...
> > > @@ -398,28 +399,42 @@ xfs_update_alignment(xfs_mount_t *mp)
> > >  =09=09=09}
> > >  =09=09}
> > > =20
> > > -=09=09/*
> > > -=09=09 * Update superblock with new values
> > > -=09=09 * and log changes
> > > -=09=09 */
> > > -=09=09if (xfs_sb_version_hasdalign(sbp)) {
> > > -=09=09=09if (sbp->sb_unit !=3D mp->m_dalign) {
> > > -=09=09=09=09sbp->sb_unit =3D mp->m_dalign;
> > > -=09=09=09=09mp->m_update_sb =3D true;
> > > -=09=09=09}
> > > -=09=09=09if (sbp->sb_width !=3D mp->m_swidth) {
> > > -=09=09=09=09sbp->sb_width =3D mp->m_swidth;
> > > -=09=09=09=09mp->m_update_sb =3D true;
> > > -=09=09=09}
> > > -=09=09} else {
> > > +=09=09/* Update superblock with new values and log changes. */
> > > +=09=09if (!xfs_sb_version_hasdalign(sbp)) {
> > >  =09=09=09xfs_warn(mp,
> > >  =09"cannot change alignment: superblock does not support data alignm=
ent");
> > >  =09=09=09return -EINVAL;
> > >  =09=09}
> > > +
> > > +=09=09if (sbp->sb_unit =3D=3D mp->m_dalign &&
> > > +=09=09    sbp->sb_width =3D=3D mp->m_swidth)
> > > +=09=09=09return 0;
> > > +
> > > +=09=09/*
> > > +=09=09 * If the sunit/swidth change would move the precomputed root
> > > +=09=09 * inode value, we must reject the ondisk change because repai=
r
> > > +=09=09 * will stumble over that.  However, we allow the mount to
> > > +=09=09 * proceed because we never rejected this combination before.
> > > +=09=09 */
> > > +=09=09if (sbp->sb_rootino !=3D
> > > +=09=09    xfs_ialloc_calc_rootino(mp, mp->m_dalign)) {
> > > +=09=09=09xfs_warn(mp,
> > > +=09"cannot change stripe alignment: would require moving root inode"=
);
> > > +
> >=20
> > FWIW, I read this error message as the mount option was ignored. I don'=
t
> > much care whether we ignore the mount option or simply the on-disk
> > update, but the error could be a bit more clear in the latter case.
>=20
> Ok, I'll add a message about how we're skipping the sb update.
>=20
> > Also, what is the expected behavior for xfs_info in the latter
> > situation?
>=20
> A previous revision of the patch had the ioctl feeding xfs_info using
> the incore values, but Dave objected so I dropped it.
>=20

Ok, could you document the expected behavior for this new state in the
commit log so it's clear when looking back at it? I.e., xfs_info should
return superblock values, xfs_growfs should update based on superblock
values, etc.

Brian

> --D
>=20
> > Brian
> >=20
> > > +=09=09=09/*
> > > +=09=09=09 * XXX: Next time we add a new incompat feature, this
> > > +=09=09=09 * should start returning -EINVAL.
> > > +=09=09=09 */
> > > +=09=09=09return 0;
> > > +=09=09}
> > > +
> > > +=09=09sbp->sb_unit =3D mp->m_dalign;
> > > +=09=09sbp->sb_width =3D mp->m_swidth;
> > > +=09=09mp->m_update_sb =3D true;
> > >  =09} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) !=3D XFS_MOUNT_NOALI=
GN &&
> > >  =09=09    xfs_sb_version_hasdalign(&mp->m_sb)) {
> > > -=09=09=09mp->m_dalign =3D sbp->sb_unit;
> > > -=09=09=09mp->m_swidth =3D sbp->sb_width;
> > > +=09=09mp->m_dalign =3D sbp->sb_unit;
> > > +=09=09mp->m_swidth =3D sbp->sb_width;
> > >  =09}
> > > =20
> > >  =09return 0;
> > >=20
> >=20
>=20

