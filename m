Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC0EC43603
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 16:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B8A2173E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 16:00:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DUzE3Rii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfLFQAt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 11:00:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726315AbfLFQAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 11:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575648048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9vmGSBkIg8FX5IYVhU5/3BLCS4raIJJAG6wblB7PGMs=;
        b=DUzE3Rii+akngeKHKuCjWirCZstJgcdakq9ibp835GxqCqTTPyzRiuPi2j2Q5/j7D3WEe9
        GgNZzJ8jwlaT99hagZCYGEVFok98ELuu/GwEdSKIzBYiwAFskQdJWM3l9Vb/nTPgNXdYxi
        ROzoZZBk+rRSz0JDrWDm10EIJ2LT5xo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-amf2hrZ9NwC9DkTHCa2qtA-1; Fri, 06 Dec 2019 11:00:46 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 906A2800D5B;
        Fri,  6 Dec 2019 16:00:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0443D19C7F;
        Fri,  6 Dec 2019 16:00:44 +0000 (UTC)
Date:   Fri, 6 Dec 2019 11:00:44 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/6] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20191206160044.GB56473@bfoster>
References: <157547906289.974712.8933333382010386076.stgit@magnolia>
 <157547908374.974712.5696639212883074825.stgit@magnolia>
 <20191205143727.GC48368@bfoster>
 <20191205162818.GC13260@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191205162818.GC13260@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: amf2hrZ9NwC9DkTHCa2qtA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 05, 2019 at 08:28:18AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 05, 2019 at 09:37:27AM -0500, Brian Foster wrote:
> > On Wed, Dec 04, 2019 at 09:04:43AM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >=20
> > > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g=
.
> > > AG headers).  mkfs never formats filesystems that way and it looks li=
ke
> > > an error, so purge the check.  After this, we always complain if inod=
es
> > > overlap with AG headers because that should never happen.
> > >=20
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> >=20
> > Strange.. This seems reasonable to me, but any idea on how this might
> > have been used in the past?
>=20
> I don't have a clue -- this code has been there since the start of the
> xfsprogs git repo and I don't have the pre-git history.  Dave said
> "hysterical raisins".
>=20

Heh, Ok.

> > The only thing I can see so far is that
> > perhaps if the superblock (blocksize/sectorsize) is corrupted, the
> > in-core state trees could be badly initialized such that the inode fall=
s
> > into the "in use" state. Of course if that were the case the fs probabl=
y
> > has bigger problems..
>=20
> Yeah.  These days if all those things collide (or look like they
> collide) then chances are the filesystem is already toast.
>=20

I guess I'm curious if/how this could change behavior in some way. It
kind of looks like this could be some kind of override to try and
preserve/prioritize the root inode if something else happens to be
corrupted and conflict. E.g., what happens if a stray rmapbt record
(incorrectly) categorizes this range as something other than inodes
before the inode scan gets to it? Would this change recovery behavior
from something that treats that as a broken rmapbt to something broader,
or is the outcome generally the same?

It looks to me it _could_ change behavior, but that's also considering a
very targeted corruption vs. something more likely to manifest in the
wild. This code clearly predates rmapbt, so that's obviously not the
original intent. I do also find it odd the hysterical code doesn't warn
if this condition occurs..

Brian

> --D
>=20
> > Brian
> >=20
> > >  repair/globals.c    |    1 -
> > >  repair/globals.h    |    1 -
> > >  repair/scan.c       |   19 -------------------
> > >  repair/xfs_repair.c |    7 -------
> > >  4 files changed, 28 deletions(-)
> > >=20
> > >=20
> > > diff --git a/repair/globals.c b/repair/globals.c
> > > index dcd79ea4..8a60e706 100644
> > > --- a/repair/globals.c
> > > +++ b/repair/globals.c
> > > @@ -73,7 +73,6 @@ int=09lost_gquotino;
> > >  int=09lost_pquotino;
> > > =20
> > >  xfs_agino_t=09first_prealloc_ino;
> > > -xfs_agino_t=09last_prealloc_ino;
> > >  xfs_agblock_t=09bnobt_root;
> > >  xfs_agblock_t=09bcntbt_root;
> > >  xfs_agblock_t=09inobt_root;
> > > diff --git a/repair/globals.h b/repair/globals.h
> > > index 008bdd90..2ed5c894 100644
> > > --- a/repair/globals.h
> > > +++ b/repair/globals.h
> > > @@ -114,7 +114,6 @@ extern int=09=09lost_gquotino;
> > >  extern int=09=09lost_pquotino;
> > > =20
> > >  extern xfs_agino_t=09first_prealloc_ino;
> > > -extern xfs_agino_t=09last_prealloc_ino;
> > >  extern xfs_agblock_t=09bnobt_root;
> > >  extern xfs_agblock_t=09bcntbt_root;
> > >  extern xfs_agblock_t=09inobt_root;
> > > diff --git a/repair/scan.c b/repair/scan.c
> > > index c383f3aa..05707dd2 100644
> > > --- a/repair/scan.c
> > > +++ b/repair/scan.c
> > > @@ -1645,13 +1645,6 @@ scan_single_ino_chunk(
> > >  =09=09=09=09break;
> > >  =09=09=09case XR_E_INUSE_FS:
> > >  =09=09=09case XR_E_INUSE_FS1:
> > > -=09=09=09=09if (agno =3D=3D 0 &&
> > > -=09=09=09=09    ino + j >=3D first_prealloc_ino &&
> > > -=09=09=09=09    ino + j < last_prealloc_ino) {
> > > -=09=09=09=09=09set_bmap(agno, agbno, XR_E_INO);
> > > -=09=09=09=09=09break;
> > > -=09=09=09=09}
> > > -=09=09=09=09/* fall through */
> > >  =09=09=09default:
> > >  =09=09=09=09/* XXX - maybe should mark block a duplicate */
> > >  =09=09=09=09do_warn(
> > > @@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt =
block - agno %d, bno %d, inopb %d\
> > >  =09=09=09=09break;
> > >  =09=09=09case XR_E_INUSE_FS:
> > >  =09=09=09case XR_E_INUSE_FS1:
> > > -=09=09=09=09if (agno =3D=3D 0 &&
> > > -=09=09=09=09    ino + j >=3D first_prealloc_ino &&
> > > -=09=09=09=09    ino + j < last_prealloc_ino) {
> > > -=09=09=09=09=09do_warn(
> > > -_("inode chunk claims untracked block, finobt block - agno %d, bno %=
d, inopb %d\n"),
> > > -=09=09=09=09=09=09agno, agbno, mp->m_sb.sb_inopblock);
> > > -
> > > -=09=09=09=09=09set_bmap(agno, agbno, XR_E_INO);
> > > -=09=09=09=09=09suspect++;
> > > -=09=09=09=09=09break;
> > > -=09=09=09=09}
> > > -=09=09=09=09/* fall through */
> > >  =09=09=09default:
> > >  =09=09=09=09do_warn(
> > >  _("inode chunk claims used block, finobt block - agno %d, bno %d, in=
opb %d\n"),
> > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > index 9295673d..3e9059f3 100644
> > > --- a/repair/xfs_repair.c
> > > +++ b/repair/xfs_repair.c
> > > @@ -460,13 +460,6 @@ calc_mkfs(xfs_mount_t *mp)
> > >  =09=09first_prealloc_ino =3D XFS_AGB_TO_AGINO(mp, fino_bno);
> > >  =09}
> > > =20
> > > -=09ASSERT(M_IGEO(mp)->ialloc_blks > 0);
> > > -
> > > -=09if (M_IGEO(mp)->ialloc_blks > 1)
> > > -=09=09last_prealloc_ino =3D first_prealloc_ino + XFS_INODES_PER_CHUN=
K;
> > > -=09else
> > > -=09=09last_prealloc_ino =3D XFS_AGB_TO_AGINO(mp, fino_bno + 1);
> > > -
> > >  =09/*
> > >  =09 * now the first 3 inodes in the system
> > >  =09 */
> > >=20
> >=20
>=20

