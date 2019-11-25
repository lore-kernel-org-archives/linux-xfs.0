Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C938C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4911120862
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBUF+NBA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfKYNHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:07:52 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbfKYNHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 08:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574687269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iogLa1nPazJtIaT3DuGrWYF0ZgEH6q2tbCxJtYrehg=;
        b=dBUF+NBAV7so+uRZjkYfOT4RUzZ4nG8dyZFjA6K9opBdh88gwysNBmS4fJwGeui2TDn5ML
        UjyEbVN+HSWMs3ORBP0ETmEkIeCosRNdT/K+fYkYVPtyGBwmRI1hOBON6E7yPEtfQAtyIT
        5CbmnCDVEmrcQRSFtwILkBPwtsyn1Nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-C__AmArwNjSc2kU1w9eipg-1; Mon, 25 Nov 2019 08:07:46 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 583EA801E5E;
        Mon, 25 Nov 2019 13:07:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BACB860C81;
        Mon, 25 Nov 2019 13:07:44 +0000 (UTC)
Date:   Mon, 25 Nov 2019 08:07:44 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191125130744.GA44777@bfoster>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: C__AmArwNjSc2kU1w9eipg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> Hi Brian,
>=20
> Thank you for your response.
>=20
> On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > > We are hitting the following issue: if XFS is mounted with sunit/swid=
th different from those
> > > specified during mkfs, then xfs_repair reports false corruption and e=
ventually segfaults.
> > >
> > > Example:
> > >
> > > # mkfs
> > > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=3D64,swidth=3D64=
 -l sunit=3D32 /dev/vda
> > >
> > > #mount with a different sunit/swidth:
> > > mount -onoatime,sync,nouuid,sunit=3D32,swidth=3D32 /dev/vda /mnt/xfs
> > >
> >
> > FYI, I couldn't reproduce this at first because sparse inodes is enable=
d
> > by default and that introduces more strict inode alignment requirements=
.
> > I'm assuming that sparse inodes is disabled in your example, but it
> > would be more helpful if you included the exact configuration and mkfs
> > output in such reports.
> Providing more details about configuration:
>=20
> kernel: 4.14.99
> xfsprogs: 4.9.0+nmu1ubuntu2
> content of /etc/zadara/xfs.protofile is captured in [1]
> mkfs output is captured in [2]
>=20
> >
> > > #umount
> > > umount /mnt/xfs
> > >
> > ...
> > >
> > > Looking at the kernel code of XFS, there seems to be no need to updat=
e the superblock sunit/swidth if the mount-provided sunit/swidth are differ=
ent.
> > > The superblock values are not used during runtime.
> > >
> >
> > I'm not really sure what the right answer is here. On one hand, this
> > patch seems fundamentally reasonable to me. I find it kind of odd for
> > mount options to override and persist configuration set in the
> > superblock like this. OTOH, this changes a historical behavior which ma=
y
> > (or may not) cause disruption for users. I also think it's somewhat
> > unfortunate to change kernel mount option behavior to accommodate
> > repair,
> This is very critical for us to have a working repair in production. I
> presume the same is true for most users.
>=20

Of course.

> > but I think the mount option behavior being odd argument stands
> > on its own regardless.
> >
> > What is your actual use case for changing the stripe unit/width at moun=
t
> > time like this?
> Our use case is like this: during mkfs the overall system does not
> know yet the exact sunit/swidth to be used. Also, the underlying
> storage can change its sunit/swidth alignment as part of some storage
> migration scenarios. During mount we already know the proper
> sunit/swidth. But the problem is that in order to specify sunit/swidth
> during mount, XFS superblock must be marked as "supporting data
> alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
> XFS refuses to mount and says:
>=20
>             xfs_warn(mp,
>     "cannot change alignment: superblock does not support data alignment"=
);
>             return -EINVAL;
>=20
> In order for the superblock to be marked like this, *some*
> sunit/swidth need to be specified during mkfs.
>=20

What do you mean by "the overall system doesn't know the stripe unit
values" at mkfs time? Shouldn't these values originate from the
underlying storage? Is there some additional configuration at play in
this particular use case?

The migration use case certainly sounds valid, though my understanding
is that if an existing stripe configuration is in place, it's usually
best for the new storage configuration to take that into consideration
(and use some multiple of stripe unit or something, for example).

> >
> > > With the suggested patch, xfs repair is working properly also when mo=
unt-provided sunit/swidth are different.
> > >
> > > However, I am not sure whether this is the proper approach. Otherwise=
, should we not allow specifying different sunit/swidth during mount?
> > >
> > ...
> > >
> > > Signed-off-by: Alex Lyakas <alex@zadara.com>
> > > ---
> > >  fs/xfs/xfs_mount.c | 18 ++++++------------
> > >  1 file changed, 6 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > index ba5b6f3..e8263b4 100644
> > > --- a/fs/xfs/xfs_mount.c
> > > +++ b/fs/xfs/xfs_mount.c
> > > @@ -399,19 +399,13 @@
> > >               }
> > >
> > >               /*
> > > -              * Update superblock with new values
> > > -              * and log changes
> > > +              * If sunit/swidth specified during mount do not match
> > > +              * those in the superblock, use the mount-specified val=
ues,
> > > +              * but do not update the superblock.
> > > +              * Otherwise, xfs_repair reports false corruption.
> > > +              * Here, only verify that superblock supports data alig=
nment.
> > >                */
> > > -             if (xfs_sb_version_hasdalign(sbp)) {
> > > -                     if (sbp->sb_unit !=3D mp->m_dalign) {
> > > -                             sbp->sb_unit =3D mp->m_dalign;
> > > -                             mp->m_update_sb =3D true;
> > > -                     }
> > > -                     if (sbp->sb_width !=3D mp->m_swidth) {
> > > -                             sbp->sb_width =3D mp->m_swidth;
> > > -                             mp->m_update_sb =3D true;
> > > -                     }
> > > -             } else {
> > > +             if (!xfs_sb_version_hasdalign(sbp)) {
> >
> > Would this change xfs_info behavior on a filesystem mounted with
> > different runtime fields from the superblock? I haven't tested it, but
> > it looks like we pull the fields from the superblock.
> xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls the
> values from the run-time copy of the superblock:
>=20
> int
> xfs_fs_geometry(
>     xfs_mount_t        *mp,
>     xfs_fsop_geom_t        *geo,
>     int            new_version)
> ...
>     if (new_version >=3D 2) {
>         geo->sunit =3D mp->m_sb.sb_unit;
>         geo->swidth =3D mp->m_sb.sb_width;
>     }
>=20
> So if during mount we have updated the superblock, we will pull the
> updated values. If we do not update (as the proposed patch), we will
> report the values stored in the superblock. Perhaps we need to update
> the geomtery ioctl to report runtime values?
>=20

Ok, thanks. I'd argue that we should return the runtime results if we
took the proposed approach, but we should probably settle on a solution
first..

Brian

> Thanks,
> Alex.
>=20
> >
> > Brian
> >
> > >                       xfs_warn(mp,
> > >       "cannot change alignment: superblock does not support data alig=
nment");
> > >                       return -EINVAL;
> > > --
> > > 1.9.1
> > >
> >
>=20
> [1]
> root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
> dummy                   : bootfilename, not used, backward compatibility
> 0 0                             : numbers of blocks and inodes, not
> used, backward compatibility
> d--777 0 0              : set 777 perms for the root dir
> $
> $
>=20
> [2]
> root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d
> sunit=3D64,swidth=3D64 -l sunit=3D32 /dev/vda
> meta-data=3D/dev/vda               isize=3D512    agcount=3D16, agsize=3D=
163832 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D0,
> rmapbt=3D0, reflink=3D0
> data     =3D                       bsize=3D4096   blocks=3D2621312, imaxp=
ct=3D25
>          =3D                       sunit=3D8      swidth=3D8 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=
=3D2
>          =3D                       sectsz=3D512   sunit=3D4 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>=20

