Return-Path: <SRS0=28RO=ZQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAEEC432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 09:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54FFD20748
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 09:13:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="HE4sz1P7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfKXJNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Nov 2019 04:13:21 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35195 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfKXJNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Nov 2019 04:13:21 -0500
Received: by mail-io1-f66.google.com with SMTP id x21so12827814ior.2
        for <linux-xfs@vger.kernel.org>; Sun, 24 Nov 2019 01:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bw7nvM4MsV7wVtYOnPNFoYouuJtte28a24hxsoeRKV8=;
        b=HE4sz1P7HhqKRjaDNIYMrgrh0YfjdRBE1y3WHlBm1Ofq+3XIucT99htm9im1PLrqdK
         l3G1lrz8CrzfuI+R+P8gf5OGlYJ2+1I/QDUfZ7KpvyzEExM7hTr1+kqxjFCLR0qo+s2P
         u3rdQdsamhXVlsX7ukP0eYtZeCVgxyqFLxJsl5rQx8c2SXxdzYSGQbS5ghqd1IpnKGal
         ysZRgcZroYai3EwQti6aRaIzclM90FHpvsoRwYgNvYlzHImkV9bXdq/uKmTR834wmoDz
         gMZ12XdCRavQ4nx7CTpSHTDaOLU4/ZoMeLqroU6iZ0lDzFcqewTA4Jd2wnJBDkPNUwWK
         SH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bw7nvM4MsV7wVtYOnPNFoYouuJtte28a24hxsoeRKV8=;
        b=fyDMCJb/iAroirwnbpcMC1rqWb+u4n73It7jdABHFbPkA5HrnnGb5fLIGkAHkQzpg4
         B6D/wKnrU4XjTZFUzkIZrg9RW8oB0zXmC3Z7ra9rJi+GUjlJuAKJNVWb4rD/6nctUdHk
         o6yGrJv8DOAsGJ2wn927na97ofe3KCFoXaKQQekREUcOH2foR/wbUylMEM46cQhjzZa9
         eB9mMQ+fgycuZU8qff+c78/WKmOJ9hz1E7Ax57hw4aabx5FMjjPNpoqeFmHDBh6uHODf
         D+MlhUOBwXPiNPUkS1UULjyyY5jXlVNgf1crcgxbqw4n6yQHVjYK4WSOKEwdGtrLqhfE
         2jjg==
X-Gm-Message-State: APjAAAVxNXhzrwQyGVpTgMez9kF7SvK0L7VVzlovI1mg7IWd5+1Ks5Fx
        UC7oDDHqN3xXkL/+tTCxxebRK1drDTSqBu2J8F+atQ==
X-Google-Smtp-Source: APXvYqyu8mxRpRMWFjnr4qh6BehHvwg/4Ba9dnyPka0UyQf1UeVeu0+fyL7ke1bJvHV9e8w8c9qf4I9zqscgUW1LJT8=
X-Received: by 2002:a6b:5908:: with SMTP id n8mr6997482iob.157.1574586800233;
 Sun, 24 Nov 2019 01:13:20 -0800 (PST)
MIME-Version: 1.0
References: <1574359699-10191-1-git-send-email-alex@zadara.com> <20191122154314.GA31076@bfoster>
In-Reply-To: <20191122154314.GA31076@bfoster>
From:   Alex Lyakas <alex@zadara.com>
Date:   Sun, 24 Nov 2019 11:13:09 +0200
Message-ID: <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
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

On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > We are hitting the following issue: if XFS is mounted with sunit/swidth different from those
> > specified during mkfs, then xfs_repair reports false corruption and eventually segfaults.
> >
> > Example:
> >
> > # mkfs
> > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda
> >
> > #mount with a different sunit/swidth:
> > mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs
> >
>
> FYI, I couldn't reproduce this at first because sparse inodes is enabled
> by default and that introduces more strict inode alignment requirements.
> I'm assuming that sparse inodes is disabled in your example, but it
> would be more helpful if you included the exact configuration and mkfs
> output in such reports.
Providing more details about configuration:

kernel: 4.14.99
xfsprogs: 4.9.0+nmu1ubuntu2
content of /etc/zadara/xfs.protofile is captured in [1]
mkfs output is captured in [2]

>
> > #umount
> > umount /mnt/xfs
> >
> ...
> >
> > Looking at the kernel code of XFS, there seems to be no need to update the superblock sunit/swidth if the mount-provided sunit/swidth are different.
> > The superblock values are not used during runtime.
> >
>
> I'm not really sure what the right answer is here. On one hand, this
> patch seems fundamentally reasonable to me. I find it kind of odd for
> mount options to override and persist configuration set in the
> superblock like this. OTOH, this changes a historical behavior which may
> (or may not) cause disruption for users. I also think it's somewhat
> unfortunate to change kernel mount option behavior to accommodate
> repair,
This is very critical for us to have a working repair in production. I
presume the same is true for most users.

> but I think the mount option behavior being odd argument stands
> on its own regardless.
>
> What is your actual use case for changing the stripe unit/width at mount
> time like this?
Our use case is like this: during mkfs the overall system does not
know yet the exact sunit/swidth to be used. Also, the underlying
storage can change its sunit/swidth alignment as part of some storage
migration scenarios. During mount we already know the proper
sunit/swidth. But the problem is that in order to specify sunit/swidth
during mount, XFS superblock must be marked as "supporting data
alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
XFS refuses to mount and says:

            xfs_warn(mp,
    "cannot change alignment: superblock does not support data alignment");
            return -EINVAL;

In order for the superblock to be marked like this, *some*
sunit/swidth need to be specified during mkfs.

>
> > With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.
> >
> > However, I am not sure whether this is the proper approach. Otherwise, should we not allow specifying different sunit/swidth during mount?
> >
> ...
> >
> > Signed-off-by: Alex Lyakas <alex@zadara.com>
> > ---
> >  fs/xfs/xfs_mount.c | 18 ++++++------------
> >  1 file changed, 6 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index ba5b6f3..e8263b4 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -399,19 +399,13 @@
> >               }
> >
> >               /*
> > -              * Update superblock with new values
> > -              * and log changes
> > +              * If sunit/swidth specified during mount do not match
> > +              * those in the superblock, use the mount-specified values,
> > +              * but do not update the superblock.
> > +              * Otherwise, xfs_repair reports false corruption.
> > +              * Here, only verify that superblock supports data alignment.
> >                */
> > -             if (xfs_sb_version_hasdalign(sbp)) {
> > -                     if (sbp->sb_unit != mp->m_dalign) {
> > -                             sbp->sb_unit = mp->m_dalign;
> > -                             mp->m_update_sb = true;
> > -                     }
> > -                     if (sbp->sb_width != mp->m_swidth) {
> > -                             sbp->sb_width = mp->m_swidth;
> > -                             mp->m_update_sb = true;
> > -                     }
> > -             } else {
> > +             if (!xfs_sb_version_hasdalign(sbp)) {
>
> Would this change xfs_info behavior on a filesystem mounted with
> different runtime fields from the superblock? I haven't tested it, but
> it looks like we pull the fields from the superblock.
xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls the
values from the run-time copy of the superblock:

int
xfs_fs_geometry(
    xfs_mount_t        *mp,
    xfs_fsop_geom_t        *geo,
    int            new_version)
...
    if (new_version >= 2) {
        geo->sunit = mp->m_sb.sb_unit;
        geo->swidth = mp->m_sb.sb_width;
    }

So if during mount we have updated the superblock, we will pull the
updated values. If we do not update (as the proposed patch), we will
report the values stored in the superblock. Perhaps we need to update
the geomtery ioctl to report runtime values?

Thanks,
Alex.

>
> Brian
>
> >                       xfs_warn(mp,
> >       "cannot change alignment: superblock does not support data alignment");
> >                       return -EINVAL;
> > --
> > 1.9.1
> >
>

[1]
root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
dummy                   : bootfilename, not used, backward compatibility
0 0                             : numbers of blocks and inodes, not
used, backward compatibility
d--777 0 0              : set 777 perms for the root dir
$
$

[2]
root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d
sunit=64,swidth=64 -l sunit=32 /dev/vda
meta-data=/dev/vda               isize=512    agcount=16, agsize=163832 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0,
rmapbt=0, reflink=0
data     =                       bsize=4096   blocks=2621312, imaxpct=25
         =                       sunit=8      swidth=8 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
