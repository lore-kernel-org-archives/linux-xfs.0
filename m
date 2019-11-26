Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B22C432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E996020722
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="yTWBkJYI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfKZItg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 03:49:36 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44658 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfKZItg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 03:49:36 -0500
Received: by mail-il1-f196.google.com with SMTP id z12so7463133iln.11
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 00:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=po5QIbgI5FeFOzQzXgxR0HudiKnuIgX89GizLeEjSFI=;
        b=yTWBkJYIj84IxmeHrtEy2kfmDp+YygNtodYg7miEu03CKL2oLoXvhO+UCYR6a5L0Dk
         VP9hKq1dAXC9NcadiNard+TsH84Ay203wEFLPg3vn4grXHiZuVnVOr4DdXSyrlbxKIOO
         9z9+vbG/KVKrVg59F3s22X0Ra8BwJTheCjMmCSBBXbF4pP6BIxeHwbWjFmMhHHc+XvRP
         PdwgE8/wDDLSmBG+vqWdTJon5nh13Vc3Ym/7VY8StO3tsw1cFgGlbF+Y+k40esbBMpv7
         IDdt/IJpbYliyK6XnLB0dXhH+0QeIO2FaIfmzDbi9XFABLHmyAijqQxP0C1f39BCDNi0
         S9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=po5QIbgI5FeFOzQzXgxR0HudiKnuIgX89GizLeEjSFI=;
        b=PjoGHxjsQYa171DvAF/XPZwV7jgPCE1E8iBMFXF6ULWeBW6Gbj8n127LmiEVkZnLBu
         FIHQOxgeRYV14NxSyaQP+cV3WbcrgcJU1coYAuXR/uTlAFylrL71mXHfLxNRKtboH3zz
         drdmG4vx5ZRYGz9tBhEKJMmicIxHfhod5Q/ZuuO9IQMrolcHi9FUoOIFzlCKVprx8C3R
         PdnOqXzTfBGFsmBX3H6jtEJftdTla6O0UqpdIBiDyiu2JWeiJ+LPm7nrpwEk5rq+A2lx
         QSo2sH5ApROzGqoF4Rjjmj7nfnUbtTAuKKjmC4fmsh9yzCFpCOuKY7NTp+NkbBOSa0zL
         AMRA==
X-Gm-Message-State: APjAAAUgvvOkvH3ae2v+kUUA+FuRjwElzXR/2Y0mA96Rrnkh0DYGgrxO
        LwHuLfP09t4M1aSixsycZOpawhUNtZMoT5G73AYKBRy0
X-Google-Smtp-Source: APXvYqz8+C2mFBmJeALtszP+mr46zqrxaV2PeqXkM3FJrBhi0Dd765Y3cEnZ6vJrmnT3FhRM8+PlrUMuln04r/5yRRo=
X-Received: by 2002:a92:889c:: with SMTP id m28mr37490260ilh.157.1574758174413;
 Tue, 26 Nov 2019 00:49:34 -0800 (PST)
MIME-Version: 1.0
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster> <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
In-Reply-To: <20191125130744.GA44777@bfoster>
From:   Alex Lyakas <alex@zadara.com>
Date:   Tue, 26 Nov 2019 10:49:22 +0200
Message-ID: <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Mon, Nov 25, 2019 at 3:07 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> > Hi Brian,
> >
> > Thank you for your response.
> >
> > On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > > > We are hitting the following issue: if XFS is mounted with sunit/swidth different from those
> > > > specified during mkfs, then xfs_repair reports false corruption and eventually segfaults.
> > > >
> > > > Example:
> > > >
> > > > # mkfs
> > > > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda
> > > >
> > > > #mount with a different sunit/swidth:
> > > > mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs
> > > >
> > >
> > > FYI, I couldn't reproduce this at first because sparse inodes is enabled
> > > by default and that introduces more strict inode alignment requirements.
> > > I'm assuming that sparse inodes is disabled in your example, but it
> > > would be more helpful if you included the exact configuration and mkfs
> > > output in such reports.
> > Providing more details about configuration:
> >
> > kernel: 4.14.99
> > xfsprogs: 4.9.0+nmu1ubuntu2
> > content of /etc/zadara/xfs.protofile is captured in [1]
> > mkfs output is captured in [2]
> >
> > >
> > > > #umount
> > > > umount /mnt/xfs
> > > >
> > > ...
> > > >
> > > > Looking at the kernel code of XFS, there seems to be no need to update the superblock sunit/swidth if the mount-provided sunit/swidth are different.
> > > > The superblock values are not used during runtime.
> > > >
> > >
> > > I'm not really sure what the right answer is here. On one hand, this
> > > patch seems fundamentally reasonable to me. I find it kind of odd for
> > > mount options to override and persist configuration set in the
> > > superblock like this. OTOH, this changes a historical behavior which may
> > > (or may not) cause disruption for users. I also think it's somewhat
> > > unfortunate to change kernel mount option behavior to accommodate
> > > repair,
> > This is very critical for us to have a working repair in production. I
> > presume the same is true for most users.
> >
>
> Of course.
>
> > > but I think the mount option behavior being odd argument stands
> > > on its own regardless.
> > >
> > > What is your actual use case for changing the stripe unit/width at mount
> > > time like this?
> > Our use case is like this: during mkfs the overall system does not
> > know yet the exact sunit/swidth to be used. Also, the underlying
> > storage can change its sunit/swidth alignment as part of some storage
> > migration scenarios. During mount we already know the proper
> > sunit/swidth. But the problem is that in order to specify sunit/swidth
> > during mount, XFS superblock must be marked as "supporting data
> > alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
> > XFS refuses to mount and says:
> >
> >             xfs_warn(mp,
> >     "cannot change alignment: superblock does not support data alignment");
> >             return -EINVAL;
> >
> > In order for the superblock to be marked like this, *some*
> > sunit/swidth need to be specified during mkfs.
> >
>
> What do you mean by "the overall system doesn't know the stripe unit
> values" at mkfs time? Shouldn't these values originate from the
> underlying storage? Is there some additional configuration at play in
> this particular use case?
I checked the code, and it turns out that the only reason for
specifying sunit/swidth during mkfs is to mark the superblock as
"supporting data alignment". The real sunit/swidth is always
determined during mount, based on the underlying storage. The
significant property of the storage is the deduplication granularity;
we saw that we get best deduplication results when XFS sunit/swidth
are aligned to deduplication granularity. During storage migrations,
an XFS share can be migrated to a storage with different deduplication
parameters; hence we need to be able to update the runtime
sunit/swidth.

Thanks,
Alex.


>
> The migration use case certainly sounds valid, though my understanding
> is that if an existing stripe configuration is in place, it's usually
> best for the new storage configuration to take that into consideration
> (and use some multiple of stripe unit or something, for example).
>
> > >
> > > > With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.
> > > >
> > > > However, I am not sure whether this is the proper approach. Otherwise, should we not allow specifying different sunit/swidth during mount?
> > > >
> > > ...
> > > >
> > > > Signed-off-by: Alex Lyakas <alex@zadara.com>
> > > > ---
> > > >  fs/xfs/xfs_mount.c | 18 ++++++------------
> > > >  1 file changed, 6 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index ba5b6f3..e8263b4 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> > > > @@ -399,19 +399,13 @@
> > > >               }
> > > >
> > > >               /*
> > > > -              * Update superblock with new values
> > > > -              * and log changes
> > > > +              * If sunit/swidth specified during mount do not match
> > > > +              * those in the superblock, use the mount-specified values,
> > > > +              * but do not update the superblock.
> > > > +              * Otherwise, xfs_repair reports false corruption.
> > > > +              * Here, only verify that superblock supports data alignment.
> > > >                */
> > > > -             if (xfs_sb_version_hasdalign(sbp)) {
> > > > -                     if (sbp->sb_unit != mp->m_dalign) {
> > > > -                             sbp->sb_unit = mp->m_dalign;
> > > > -                             mp->m_update_sb = true;
> > > > -                     }
> > > > -                     if (sbp->sb_width != mp->m_swidth) {
> > > > -                             sbp->sb_width = mp->m_swidth;
> > > > -                             mp->m_update_sb = true;
> > > > -                     }
> > > > -             } else {
> > > > +             if (!xfs_sb_version_hasdalign(sbp)) {
> > >
> > > Would this change xfs_info behavior on a filesystem mounted with
> > > different runtime fields from the superblock? I haven't tested it, but
> > > it looks like we pull the fields from the superblock.
> > xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls the
> > values from the run-time copy of the superblock:
> >
> > int
> > xfs_fs_geometry(
> >     xfs_mount_t        *mp,
> >     xfs_fsop_geom_t        *geo,
> >     int            new_version)
> > ...
> >     if (new_version >= 2) {
> >         geo->sunit = mp->m_sb.sb_unit;
> >         geo->swidth = mp->m_sb.sb_width;
> >     }
> >
> > So if during mount we have updated the superblock, we will pull the
> > updated values. If we do not update (as the proposed patch), we will
> > report the values stored in the superblock. Perhaps we need to update
> > the geomtery ioctl to report runtime values?
> >
>
> Ok, thanks. I'd argue that we should return the runtime results if we
> took the proposed approach, but we should probably settle on a solution
> first..
>
> Brian
>
> > Thanks,
> > Alex.
> >
> > >
> > > Brian
> > >
> > > >                       xfs_warn(mp,
> > > >       "cannot change alignment: superblock does not support data alignment");
> > > >                       return -EINVAL;
> > > > --
> > > > 1.9.1
> > > >
> > >
> >
> > [1]
> > root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
> > dummy                   : bootfilename, not used, backward compatibility
> > 0 0                             : numbers of blocks and inodes, not
> > used, backward compatibility
> > d--777 0 0              : set 777 perms for the root dir
> > $
> > $
> >
> > [2]
> > root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d
> > sunit=64,swidth=64 -l sunit=32 /dev/vda
> > meta-data=/dev/vda               isize=512    agcount=16, agsize=163832 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=0,
> > rmapbt=0, reflink=0
> > data     =                       bsize=4096   blocks=2621312, imaxpct=25
> >          =                       sunit=8      swidth=8 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal log           bsize=4096   blocks=2560, version=2
> >          =                       sectsz=512   sunit=4 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
>
