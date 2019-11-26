Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A063C432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 11:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38F3C2073F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 11:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b/MLat0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKZLyV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 06:54:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbfKZLyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 06:54:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574769258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1n14pLWyw6OwoUTIaJgrzr4TJ2ki78e1cm24KpagVQM=;
        b=b/MLat0fZPlhbS88Ui25dH927l2R6uqxFV9dL/5/cP1lN5/9NPFVZx2fM9sZYZxZMf9RXu
        vftKAq6W84MWdmLCdX2UORcCZr4WChDJhy5zqfxokazteSz1UtjM04U16LHWpdQsgGJJ1u
        YMaBrkW93HDg7Y2AOcuB/4UO0l5H7AM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-XzLe7CYwP-uvdYLu-gnwFg-1; Tue, 26 Nov 2019 06:54:16 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E41B0800D41;
        Tue, 26 Nov 2019 11:54:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C8BA600C8;
        Tue, 26 Nov 2019 11:54:15 +0000 (UTC)
Date:   Tue, 26 Nov 2019 06:54:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191126115415.GA50477@bfoster>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
 <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: XzLe7CYwP-uvdYLu-gnwFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 10:49:22AM +0200, Alex Lyakas wrote:
> Hi Brian,
>=20
> On Mon, Nov 25, 2019 at 3:07 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> > > Hi Brian,
> > >
> > > Thank you for your response.
> > >
> > > On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wro=
te:
> > > >
> > > > On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > > > > We are hitting the following issue: if XFS is mounted with sunit/=
swidth different from those
> > > > > specified during mkfs, then xfs_repair reports false corruption a=
nd eventually segfaults.
> > > > >
> > > > > Example:
> > > > >
> > > > > # mkfs
> > > > > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=3D64,swidth=
=3D64 -l sunit=3D32 /dev/vda
> > > > >
> > > > > #mount with a different sunit/swidth:
> > > > > mount -onoatime,sync,nouuid,sunit=3D32,swidth=3D32 /dev/vda /mnt/=
xfs
> > > > >
> > > >
> > > > FYI, I couldn't reproduce this at first because sparse inodes is en=
abled
> > > > by default and that introduces more strict inode alignment requirem=
ents.
> > > > I'm assuming that sparse inodes is disabled in your example, but it
> > > > would be more helpful if you included the exact configuration and m=
kfs
> > > > output in such reports.
> > > Providing more details about configuration:
> > >
> > > kernel: 4.14.99
> > > xfsprogs: 4.9.0+nmu1ubuntu2
> > > content of /etc/zadara/xfs.protofile is captured in [1]
> > > mkfs output is captured in [2]
> > >
> > > >
> > > > > #umount
> > > > > umount /mnt/xfs
> > > > >
> > > > ...
> > > > >
> > > > > Looking at the kernel code of XFS, there seems to be no need to u=
pdate the superblock sunit/swidth if the mount-provided sunit/swidth are di=
fferent.
> > > > > The superblock values are not used during runtime.
> > > > >
> > > >
> > > > I'm not really sure what the right answer is here. On one hand, thi=
s
> > > > patch seems fundamentally reasonable to me. I find it kind of odd f=
or
> > > > mount options to override and persist configuration set in the
> > > > superblock like this. OTOH, this changes a historical behavior whic=
h may
> > > > (or may not) cause disruption for users. I also think it's somewhat
> > > > unfortunate to change kernel mount option behavior to accommodate
> > > > repair,
> > > This is very critical for us to have a working repair in production. =
I
> > > presume the same is true for most users.
> > >
> >
> > Of course.
> >
> > > > but I think the mount option behavior being odd argument stands
> > > > on its own regardless.
> > > >
> > > > What is your actual use case for changing the stripe unit/width at =
mount
> > > > time like this?
> > > Our use case is like this: during mkfs the overall system does not
> > > know yet the exact sunit/swidth to be used. Also, the underlying
> > > storage can change its sunit/swidth alignment as part of some storage
> > > migration scenarios. During mount we already know the proper
> > > sunit/swidth. But the problem is that in order to specify sunit/swidt=
h
> > > during mount, XFS superblock must be marked as "supporting data
> > > alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
> > > XFS refuses to mount and says:
> > >
> > >             xfs_warn(mp,
> > >     "cannot change alignment: superblock does not support data alignm=
ent");
> > >             return -EINVAL;
> > >
> > > In order for the superblock to be marked like this, *some*
> > > sunit/swidth need to be specified during mkfs.
> > >
> >
> > What do you mean by "the overall system doesn't know the stripe unit
> > values" at mkfs time? Shouldn't these values originate from the
> > underlying storage? Is there some additional configuration at play in
> > this particular use case?
> I checked the code, and it turns out that the only reason for
> specifying sunit/swidth during mkfs is to mark the superblock as
> "supporting data alignment". The real sunit/swidth is always
> determined during mount, based on the underlying storage. The
> significant property of the storage is the deduplication granularity;
> we saw that we get best deduplication results when XFS sunit/swidth
> are aligned to deduplication granularity. During storage migrations,
> an XFS share can be migrated to a storage with different deduplication
> parameters; hence we need to be able to update the runtime
> sunit/swidth.
>=20

Ok, but that doesn't really answer my question of why can't you set it
at mkfs time? Presumably you have the same access to the storage at mkfs
time as at mount time? I can't really speak to how your dedup stuff
accounts for dynamic changes in relation to existing data that was
placed based an old stripe unit, etc., so I'll just assume that works
for your purposes in the migration case.

Note that Dave chimed in with some historical context on IRC:

...
14:31 <dchinner_> keep in mind that the sunit/swidth mount options were onl=
y added to work around a CXFS client mount bug that caused the superblock v=
alues on disk to get zeroed
14:31 <sandeen> hah, that rings a bell
14:32 <sandeen> still, it's been there for /years/ now
14:32 <dchinner_> it was never intended as a mechanism to actually change t=
he layout
14:32 <djwong> aha, there's the context i was missing :)
14:32 <dchinner_> it turned out to be kinda useful for the crazy md raid re=
stripers
14:32 <dchinner_> but, really, the use it's being put to here is just .... =
not supportable
14:34 <sandeen> usecase aside, it seems that if the kernel code allows you =
to rewrite it, xfs_repair shouldn't choke on the results =20
14:34 <dchinner_> yes, you can do it, but you get to keep all the broken bi=
ts when your crazy storage changes alignments and layouts dynamically.
14:34 <dchinner_> the kernel doesn't validate it properly
14:34 <sandeen> ok so something  else to fix
14:35 <dchinner_> so if we are going to say "you can change it" then the ke=
rnel must validate that it is compatible with the existing on-disk layout
14:35 <dchinner_> i.e. root inode location, ag header location, inode clust=
er size and alignment, etc
...

My takeaway from that is the behavior of updating the superblock from
the mount options could probably be nuked off (as your patch does), but
I'd suggest to get feedback from Eric and Darrick to see whether they
agree or would prefer to maintain existing behavior with proper
validation...

Brian

> Thanks,
> Alex.
>=20
>=20
> >
> > The migration use case certainly sounds valid, though my understanding
> > is that if an existing stripe configuration is in place, it's usually
> > best for the new storage configuration to take that into consideration
> > (and use some multiple of stripe unit or something, for example).
> >
> > > >
> > > > > With the suggested patch, xfs repair is working properly also whe=
n mount-provided sunit/swidth are different.
> > > > >
> > > > > However, I am not sure whether this is the proper approach. Other=
wise, should we not allow specifying different sunit/swidth during mount?
> > > > >
> > > > ...
> > > > >
> > > > > Signed-off-by: Alex Lyakas <alex@zadara.com>
> > > > > ---
> > > > >  fs/xfs/xfs_mount.c | 18 ++++++------------
> > > > >  1 file changed, 6 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > index ba5b6f3..e8263b4 100644
> > > > > --- a/fs/xfs/xfs_mount.c
> > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > @@ -399,19 +399,13 @@
> > > > >               }
> > > > >
> > > > >               /*
> > > > > -              * Update superblock with new values
> > > > > -              * and log changes
> > > > > +              * If sunit/swidth specified during mount do not ma=
tch
> > > > > +              * those in the superblock, use the mount-specified=
 values,
> > > > > +              * but do not update the superblock.
> > > > > +              * Otherwise, xfs_repair reports false corruption.
> > > > > +              * Here, only verify that superblock supports data =
alignment.
> > > > >                */
> > > > > -             if (xfs_sb_version_hasdalign(sbp)) {
> > > > > -                     if (sbp->sb_unit !=3D mp->m_dalign) {
> > > > > -                             sbp->sb_unit =3D mp->m_dalign;
> > > > > -                             mp->m_update_sb =3D true;
> > > > > -                     }
> > > > > -                     if (sbp->sb_width !=3D mp->m_swidth) {
> > > > > -                             sbp->sb_width =3D mp->m_swidth;
> > > > > -                             mp->m_update_sb =3D true;
> > > > > -                     }
> > > > > -             } else {
> > > > > +             if (!xfs_sb_version_hasdalign(sbp)) {
> > > >
> > > > Would this change xfs_info behavior on a filesystem mounted with
> > > > different runtime fields from the superblock? I haven't tested it, =
but
> > > > it looks like we pull the fields from the superblock.
> > > xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls th=
e
> > > values from the run-time copy of the superblock:
> > >
> > > int
> > > xfs_fs_geometry(
> > >     xfs_mount_t        *mp,
> > >     xfs_fsop_geom_t        *geo,
> > >     int            new_version)
> > > ...
> > >     if (new_version >=3D 2) {
> > >         geo->sunit =3D mp->m_sb.sb_unit;
> > >         geo->swidth =3D mp->m_sb.sb_width;
> > >     }
> > >
> > > So if during mount we have updated the superblock, we will pull the
> > > updated values. If we do not update (as the proposed patch), we will
> > > report the values stored in the superblock. Perhaps we need to update
> > > the geomtery ioctl to report runtime values?
> > >
> >
> > Ok, thanks. I'd argue that we should return the runtime results if we
> > took the proposed approach, but we should probably settle on a solution
> > first..
> >
> > Brian
> >
> > > Thanks,
> > > Alex.
> > >
> > > >
> > > > Brian
> > > >
> > > > >                       xfs_warn(mp,
> > > > >       "cannot change alignment: superblock does not support data =
alignment");
> > > > >                       return -EINVAL;
> > > > > --
> > > > > 1.9.1
> > > > >
> > > >
> > >
> > > [1]
> > > root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
> > > dummy                   : bootfilename, not used, backward compatibil=
ity
> > > 0 0                             : numbers of blocks and inodes, not
> > > used, backward compatibility
> > > d--777 0 0              : set 777 perms for the root dir
> > > $
> > > $
> > >
> > > [2]
> > > root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -=
d
> > > sunit=3D64,swidth=3D64 -l sunit=3D32 /dev/vda
> > > meta-data=3D/dev/vda               isize=3D512    agcount=3D16, agsiz=
e=3D163832 blks
> > >          =3D                       sectsz=3D512   attr=3D2, projid32b=
it=3D1
> > >          =3D                       crc=3D1        finobt=3D1, sparse=
=3D0,
> > > rmapbt=3D0, reflink=3D0
> > > data     =3D                       bsize=3D4096   blocks=3D2621312, i=
maxpct=3D25
> > >          =3D                       sunit=3D8      swidth=3D8 blks
> > > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=
=3D1
> > > log      =3Dinternal log           bsize=3D4096   blocks=3D2560, vers=
ion=3D2
> > >          =3D                       sectsz=3D512   sunit=3D4 blks, laz=
y-count=3D1
> > > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0
> > >
> >
>=20

