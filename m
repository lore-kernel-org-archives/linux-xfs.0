Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D4AC432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 13:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66BE52073F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 13:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="2F++a4kD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKZNhi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 08:37:38 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:47040 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfKZNhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 08:37:38 -0500
Received: by mail-il1-f195.google.com with SMTP id q1so17610502ile.13
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 05:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZVZmU11kUfnFgH2OSqtYsDByBxM7PDgYDRK5D4tJc8=;
        b=2F++a4kDvucovV5L57OeobrhiEuSTrObMDR0AtkpqXkfRps0YwHii+mope5DJQtN5B
         oRBmXyQBWoLig4GX7xFHIyE9rjrAcQAEBcTuxlKk9S3RNaVFcHKKsBwZJFSsdzDDZJE3
         pA6h8x546c6bG08tY4FEp3ynLWeHMxFPi2i7n1MdTrHSkZ4LMyZCB0xVK4BObIk0Kz7o
         S037T5BIH8BA3gi1acrgSOLMA+D8+I6luAqd5pnRE0AkQ3WB3c/RgM1hxnA8rwBCjexT
         mIer4HbJ82jieJifMBrqEzDa+xQCDJn9zVsuVXS2Sb9YynLx4U8Fkt/ilQvzH+/oC/j4
         EdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZVZmU11kUfnFgH2OSqtYsDByBxM7PDgYDRK5D4tJc8=;
        b=dMRmnaX0Nrvz38mGkTTXz3eubFrYaJP3cOM98zwmvxBVSOfDkmoRK/gUg1C/m0pX1a
         rFhqW5kiZrUCZGUIm+8wVft0ozDMzin5aGjCFukWWO2W+Uh3n/ZFZpKvEj72+yXxWnQt
         3OKojEnipBbkfDEgBkATLq6da+Rad5ybvPatfGCXtxv3X6FkjarMEl/ttWhXb/90Adka
         3UACxxA0P16vqWLcUGOiHtQKTk9ot1ryUrBUA7oKv0O2JuU8IGnAy2wwYOqzoaOIXS5n
         rYCPmSl5piVdcUn2BBsPjoCyylaSeRP1hZQMEKbFxxBEsIsZNiOE2OJd/98/2QVahFQi
         FJjw==
X-Gm-Message-State: APjAAAXvXZRDxmXXk1inwfTHDoTxjAPyWKgoKeD2wIj6ZTgK+sP8+8TM
        XKWNHcwbCVyCka463qc7zKS2f08RvpG4vxcVbIobHkf/
X-Google-Smtp-Source: APXvYqylE7byczk/iFG5WLdl9ybC2IBhl4aRGbMxUcVdj3Wg1HDJFzyamX5XB60NRouUy7mawz4D3fyYf9ruIJ+h4lw=
X-Received: by 2002:a92:5b86:: with SMTP id c6mr37481911ilg.135.1574775456900;
 Tue, 26 Nov 2019 05:37:36 -0800 (PST)
MIME-Version: 1.0
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster> <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster> <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster>
In-Reply-To: <20191126115415.GA50477@bfoster>
From:   Alex Lyakas <alex@zadara.com>
Date:   Tue, 26 Nov 2019 15:37:25 +0200
Message-ID: <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
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

Thank you for your response.

On Tue, Nov 26, 2019 at 1:54 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Tue, Nov 26, 2019 at 10:49:22AM +0200, Alex Lyakas wrote:
> > Hi Brian,
> >
> > On Mon, Nov 25, 2019 at 3:07 PM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> > > > Hi Brian,
> > > >
> > > > Thank you for your response.
> > > >
> > > > On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wrote:
> > > > >
> > > > > On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > > > > > We are hitting the following issue: if XFS is mounted with sunit/swidth different from those
> > > > > > specified during mkfs, then xfs_repair reports false corruption and eventually segfaults.
> > > > > >
> > > > > > Example:
> > > > > >
> > > > > > # mkfs
> > > > > > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda
> > > > > >
> > > > > > #mount with a different sunit/swidth:
> > > > > > mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs
> > > > > >
> > > > >
> > > > > FYI, I couldn't reproduce this at first because sparse inodes is enabled
> > > > > by default and that introduces more strict inode alignment requirements.
> > > > > I'm assuming that sparse inodes is disabled in your example, but it
> > > > > would be more helpful if you included the exact configuration and mkfs
> > > > > output in such reports.
> > > > Providing more details about configuration:
> > > >
> > > > kernel: 4.14.99
> > > > xfsprogs: 4.9.0+nmu1ubuntu2
> > > > content of /etc/zadara/xfs.protofile is captured in [1]
> > > > mkfs output is captured in [2]
> > > >
> > > > >
> > > > > > #umount
> > > > > > umount /mnt/xfs
> > > > > >
> > > > > ...
> > > > > >
> > > > > > Looking at the kernel code of XFS, there seems to be no need to update the superblock sunit/swidth if the mount-provided sunit/swidth are different.
> > > > > > The superblock values are not used during runtime.
> > > > > >
> > > > >
> > > > > I'm not really sure what the right answer is here. On one hand, this
> > > > > patch seems fundamentally reasonable to me. I find it kind of odd for
> > > > > mount options to override and persist configuration set in the
> > > > > superblock like this. OTOH, this changes a historical behavior which may
> > > > > (or may not) cause disruption for users. I also think it's somewhat
> > > > > unfortunate to change kernel mount option behavior to accommodate
> > > > > repair,
> > > > This is very critical for us to have a working repair in production. I
> > > > presume the same is true for most users.
> > > >
> > >
> > > Of course.
> > >
> > > > > but I think the mount option behavior being odd argument stands
> > > > > on its own regardless.
> > > > >
> > > > > What is your actual use case for changing the stripe unit/width at mount
> > > > > time like this?
> > > > Our use case is like this: during mkfs the overall system does not
> > > > know yet the exact sunit/swidth to be used. Also, the underlying
> > > > storage can change its sunit/swidth alignment as part of some storage
> > > > migration scenarios. During mount we already know the proper
> > > > sunit/swidth. But the problem is that in order to specify sunit/swidth
> > > > during mount, XFS superblock must be marked as "supporting data
> > > > alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
> > > > XFS refuses to mount and says:
> > > >
> > > >             xfs_warn(mp,
> > > >     "cannot change alignment: superblock does not support data alignment");
> > > >             return -EINVAL;
> > > >
> > > > In order for the superblock to be marked like this, *some*
> > > > sunit/swidth need to be specified during mkfs.
> > > >
> > >
> > > What do you mean by "the overall system doesn't know the stripe unit
> > > values" at mkfs time? Shouldn't these values originate from the
> > > underlying storage? Is there some additional configuration at play in
> > > this particular use case?
> > I checked the code, and it turns out that the only reason for
> > specifying sunit/swidth during mkfs is to mark the superblock as
> > "supporting data alignment". The real sunit/swidth is always
> > determined during mount, based on the underlying storage. The
> > significant property of the storage is the deduplication granularity;
> > we saw that we get best deduplication results when XFS sunit/swidth
> > are aligned to deduplication granularity. During storage migrations,
> > an XFS share can be migrated to a storage with different deduplication
> > parameters; hence we need to be able to update the runtime
> > sunit/swidth.
> >
>
> Ok, but that doesn't really answer my question of why can't you set it
> at mkfs time? Presumably you have the same access to the storage at mkfs
> time as at mount time?
Yes, we have the access and we can set the proper sunit/swidth during
mkfs. But our thinking was that during mkfs we want only to mark the
superblock as "supporting data alignment", which is what specifying
sunit/swidth during mkfs does. During mount, we look at the underlying
storage config, and pass the proper sunit/swidth. The underlying
storage could be different from one that existed at mkfs time. I hope
this explains our situation better.

>I can't really speak to how your dedup stuff
> accounts for dynamic changes in relation to existing data that was
> placed based an old stripe unit, etc., so I'll just assume that works
> for your purposes in the migration case.
>
> Note that Dave chimed in with some historical context on IRC:
>
> ...
> 14:31 <dchinner_> keep in mind that the sunit/swidth mount options were only added to work around a CXFS client mount bug that caused the superblock values on disk to get zeroed
> 14:31 <sandeen> hah, that rings a bell
> 14:32 <sandeen> still, it's been there for /years/ now
> 14:32 <dchinner_> it was never intended as a mechanism to actually change the layout
> 14:32 <djwong> aha, there's the context i was missing :)
> 14:32 <dchinner_> it turned out to be kinda useful for the crazy md raid restripers
> 14:32 <dchinner_> but, really, the use it's being put to here is just .... not supportable
> 14:34 <sandeen> usecase aside, it seems that if the kernel code allows you to rewrite it, xfs_repair shouldn't choke on the results
> 14:34 <dchinner_> yes, you can do it, but you get to keep all the broken bits when your crazy storage changes alignments and layouts dynamically.
> 14:34 <dchinner_> the kernel doesn't validate it properly
> 14:34 <sandeen> ok so something  else to fix
> 14:35 <dchinner_> so if we are going to say "you can change it" then the kernel must validate that it is compatible with the existing on-disk layout
> 14:35 <dchinner_> i.e. root inode location, ag header location, inode cluster size and alignment, etc
> ...
>
Fascinating!

From our perspective, when the underlying storage alignment changes,
we are ok for all already-allocated extents to keep their existing
alignment. We only want the newly-allocated extents to use the
newly-specified sunit/swidth. My understanding is that such filesystem
is not "broken bits", as everything is consistent, except different
extents may have different alignments.

> My takeaway from that is the behavior of updating the superblock from
> the mount options could probably be nuked off (as your patch does), but
> I'd suggest to get feedback from Eric and Darrick to see whether they
> agree or would prefer to maintain existing behavior with proper
> validation...

Let's wait for their additional feedback, then.

Thanks,
Alex.


>
> Brian
>
> > Thanks,
> > Alex.
> >
> >
> > >
> > > The migration use case certainly sounds valid, though my understanding
> > > is that if an existing stripe configuration is in place, it's usually
> > > best for the new storage configuration to take that into consideration
> > > (and use some multiple of stripe unit or something, for example).
> > >
> > > > >
> > > > > > With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.
> > > > > >
> > > > > > However, I am not sure whether this is the proper approach. Otherwise, should we not allow specifying different sunit/swidth during mount?
> > > > > >
> > > > > ...
> > > > > >
> > > > > > Signed-off-by: Alex Lyakas <alex@zadara.com>
> > > > > > ---
> > > > > >  fs/xfs/xfs_mount.c | 18 ++++++------------
> > > > > >  1 file changed, 6 insertions(+), 12 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > > index ba5b6f3..e8263b4 100644
> > > > > > --- a/fs/xfs/xfs_mount.c
> > > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > > @@ -399,19 +399,13 @@
> > > > > >               }
> > > > > >
> > > > > >               /*
> > > > > > -              * Update superblock with new values
> > > > > > -              * and log changes
> > > > > > +              * If sunit/swidth specified during mount do not match
> > > > > > +              * those in the superblock, use the mount-specified values,
> > > > > > +              * but do not update the superblock.
> > > > > > +              * Otherwise, xfs_repair reports false corruption.
> > > > > > +              * Here, only verify that superblock supports data alignment.
> > > > > >                */
> > > > > > -             if (xfs_sb_version_hasdalign(sbp)) {
> > > > > > -                     if (sbp->sb_unit != mp->m_dalign) {
> > > > > > -                             sbp->sb_unit = mp->m_dalign;
> > > > > > -                             mp->m_update_sb = true;
> > > > > > -                     }
> > > > > > -                     if (sbp->sb_width != mp->m_swidth) {
> > > > > > -                             sbp->sb_width = mp->m_swidth;
> > > > > > -                             mp->m_update_sb = true;
> > > > > > -                     }
> > > > > > -             } else {
> > > > > > +             if (!xfs_sb_version_hasdalign(sbp)) {
> > > > >
> > > > > Would this change xfs_info behavior on a filesystem mounted with
> > > > > different runtime fields from the superblock? I haven't tested it, but
> > > > > it looks like we pull the fields from the superblock.
> > > > xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls the
> > > > values from the run-time copy of the superblock:
> > > >
> > > > int
> > > > xfs_fs_geometry(
> > > >     xfs_mount_t        *mp,
> > > >     xfs_fsop_geom_t        *geo,
> > > >     int            new_version)
> > > > ...
> > > >     if (new_version >= 2) {
> > > >         geo->sunit = mp->m_sb.sb_unit;
> > > >         geo->swidth = mp->m_sb.sb_width;
> > > >     }
> > > >
> > > > So if during mount we have updated the superblock, we will pull the
> > > > updated values. If we do not update (as the proposed patch), we will
> > > > report the values stored in the superblock. Perhaps we need to update
> > > > the geomtery ioctl to report runtime values?
> > > >
> > >
> > > Ok, thanks. I'd argue that we should return the runtime results if we
> > > took the proposed approach, but we should probably settle on a solution
> > > first..
> > >
> > > Brian
> > >
> > > > Thanks,
> > > > Alex.
> > > >
> > > > >
> > > > > Brian
> > > > >
> > > > > >                       xfs_warn(mp,
> > > > > >       "cannot change alignment: superblock does not support data alignment");
> > > > > >                       return -EINVAL;
> > > > > > --
> > > > > > 1.9.1
> > > > > >
> > > > >
> > > >
> > > > [1]
> > > > root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
> > > > dummy                   : bootfilename, not used, backward compatibility
> > > > 0 0                             : numbers of blocks and inodes, not
> > > > used, backward compatibility
> > > > d--777 0 0              : set 777 perms for the root dir
> > > > $
> > > > $
> > > >
> > > > [2]
> > > > root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d
> > > > sunit=64,swidth=64 -l sunit=32 /dev/vda
> > > > meta-data=/dev/vda               isize=512    agcount=16, agsize=163832 blks
> > > >          =                       sectsz=512   attr=2, projid32bit=1
> > > >          =                       crc=1        finobt=1, sparse=0,
> > > > rmapbt=0, reflink=0
> > > > data     =                       bsize=4096   blocks=2621312, imaxpct=25
> > > >          =                       sunit=8      swidth=8 blks
> > > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > > log      =internal log           bsize=4096   blocks=2560, version=2
> > > >          =                       sectsz=512   sunit=4 blks, lazy-count=1
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > >
> > >
> >
>
