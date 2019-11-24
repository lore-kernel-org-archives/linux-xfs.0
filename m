Return-Path: <SRS0=28RO=ZQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F97AC432C0
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 16:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED162075E
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Nov 2019 16:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R8GxHhGV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKXQkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Nov 2019 11:40:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfKXQkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Nov 2019 11:40:21 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAOGd9Vo062378;
        Sun, 24 Nov 2019 16:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Lu5fY+yTyj8gSQxtCHc+hXsAorXT6hqU/Isx7ofG/lo=;
 b=R8GxHhGVfAOdnpQ0Jt/dPo0h3w86j13kpbvZENK4xAKSLshl7/+5RV0Hqb3Pb6W3U7F6
 gpqVQH4H/DySZM7ZZ/wdHmA5tcbY/PUbPRqHugJDBQPQjgtl1pU0h3MgfBZciEnyDj1L
 8hk7Fq11YW3j7LR+VLs+6NH0bY2vYffQQH1Z9iV3+o1ZL1wiMylGzEB0BRDti8/S9rHt
 xnx0ImzR2sioN14GvWWfS+4NWicRwRDc4plfUw2QesobVHVC8gFzNVzdixLetCp+4XXl
 I5WcXYkVZwlorI0H+LWYLG95g1vLetB/+H6upzZppHWv8Hixqv9b07TgonARRTj9bota yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wev6tugwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 Nov 2019 16:40:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAOGciM9093434;
        Sun, 24 Nov 2019 16:40:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wfew93as6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 24 Nov 2019 16:40:15 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAOGeDIQ009419;
        Sun, 24 Nov 2019 16:40:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 24 Nov 2019 08:40:13 -0800
Date:   Sun, 24 Nov 2019 08:40:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191124164012.GL6219@magnolia>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9450 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911240161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9450 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911240161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> Hi Brian,
> 
> Thank you for your response.
> 
> On Fri, Nov 22, 2019 at 5:43 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Thu, Nov 21, 2019 at 08:08:19PM +0200, Alex Lyakas wrote:
> > > We are hitting the following issue: if XFS is mounted with sunit/swidth different from those
> > > specified during mkfs, then xfs_repair reports false corruption and eventually segfaults.
> > >
> > > Example:
> > >
> > > # mkfs
> > > mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda
> > >
> > > #mount with a different sunit/swidth:
> > > mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs
> > >
> >
> > FYI, I couldn't reproduce this at first because sparse inodes is enabled
> > by default and that introduces more strict inode alignment requirements.
> > I'm assuming that sparse inodes is disabled in your example, but it
> > would be more helpful if you included the exact configuration and mkfs
> > output in such reports.
> Providing more details about configuration:
> 
> kernel: 4.14.99
> xfsprogs: 4.9.0+nmu1ubuntu2
> content of /etc/zadara/xfs.protofile is captured in [1]
> mkfs output is captured in [2]
> 
> >
> > > #umount
> > > umount /mnt/xfs
> > >
> > ...
> > >
> > > Looking at the kernel code of XFS, there seems to be no need to update the superblock sunit/swidth if the mount-provided sunit/swidth are different.
> > > The superblock values are not used during runtime.
> > >
> >
> > I'm not really sure what the right answer is here. On one hand, this
> > patch seems fundamentally reasonable to me. I find it kind of odd for
> > mount options to override and persist configuration set in the
> > superblock like this. OTOH, this changes a historical behavior which may
> > (or may not) cause disruption for users. I also think it's somewhat
> > unfortunate to change kernel mount option behavior to accommodate
> > repair,
> This is very critical for us to have a working repair in production. I
> presume the same is true for most users.
> 
> > but I think the mount option behavior being odd argument stands
> > on its own regardless.
> >
> > What is your actual use case for changing the stripe unit/width at mount
> > time like this?
> Our use case is like this: during mkfs the overall system does not
> know yet the exact sunit/swidth to be used. Also, the underlying
> storage can change its sunit/swidth alignment as part of some storage
> migration scenarios. During mount we already know the proper
> sunit/swidth. But the problem is that in order to specify sunit/swidth
> during mount, XFS superblock must be marked as "supporting data
> alignment", i.e., XFS_SB_VERSION_DALIGNBIT has to be set. Otherwise,
> XFS refuses to mount and says:
> 
>             xfs_warn(mp,
>     "cannot change alignment: superblock does not support data alignment");
>             return -EINVAL;
> 
> In order for the superblock to be marked like this, *some*
> sunit/swidth need to be specified during mkfs.
> 
> >
> > > With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.
> > >
> > > However, I am not sure whether this is the proper approach.
> > > Otherwise, should we not allow specifying different sunit/swidth
> > > during mount?

I propose a (somewhat) different solution to this problem:

Port to libxfs the code that determines where mkfs/repair expect the
root inode.  Whenever we want to update the geometry information in the
superblock from mount options, we can test the new ones to see if that
would cause sb_rootino to change.  If there's no change, we update
everything like we do now.  If it would change, either we run with those
parameters incore only (which I think is possible for su/sw?) or refuse
them (because corruption is bad).

This way we don't lose the su/sw updating behavior we have now, and we
also gain the ability to shut down an entire class of accidental sb
geometry corruptions.

--D

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
> > > +              * those in the superblock, use the mount-specified values,
> > > +              * but do not update the superblock.
> > > +              * Otherwise, xfs_repair reports false corruption.
> > > +              * Here, only verify that superblock supports data alignment.
> > >                */
> > > -             if (xfs_sb_version_hasdalign(sbp)) {
> > > -                     if (sbp->sb_unit != mp->m_dalign) {
> > > -                             sbp->sb_unit = mp->m_dalign;
> > > -                             mp->m_update_sb = true;
> > > -                     }
> > > -                     if (sbp->sb_width != mp->m_swidth) {
> > > -                             sbp->sb_width = mp->m_swidth;
> > > -                             mp->m_update_sb = true;
> > > -                     }
> > > -             } else {
> > > +             if (!xfs_sb_version_hasdalign(sbp)) {
> >
> > Would this change xfs_info behavior on a filesystem mounted with
> > different runtime fields from the superblock? I haven't tested it, but
> > it looks like we pull the fields from the superblock.
> xfs_info uses XFS_IOC_FSGEOMETRY to get the values, and this pulls the
> values from the run-time copy of the superblock:
> 
> int
> xfs_fs_geometry(
>     xfs_mount_t        *mp,
>     xfs_fsop_geom_t        *geo,
>     int            new_version)
> ...
>     if (new_version >= 2) {
>         geo->sunit = mp->m_sb.sb_unit;
>         geo->swidth = mp->m_sb.sb_width;
>     }
> 
> So if during mount we have updated the superblock, we will pull the
> updated values. If we do not update (as the proposed patch), we will
> report the values stored in the superblock. Perhaps we need to update
> the geomtery ioctl to report runtime values?
> 
> Thanks,
> Alex.
> 
> >
> > Brian
> >
> > >                       xfs_warn(mp,
> > >       "cannot change alignment: superblock does not support data alignment");
> > >                       return -EINVAL;
> > > --
> > > 1.9.1
> > >
> >
> 
> [1]
> root@vc-20-01-48-dev:~# cat /etc/zadara/xfs.protofile
> dummy                   : bootfilename, not used, backward compatibility
> 0 0                             : numbers of blocks and inodes, not
> used, backward compatibility
> d--777 0 0              : set 777 perms for the root dir
> $
> $
> 
> [2]
> root@vc-20-01-48-dev:~# mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d
> sunit=64,swidth=64 -l sunit=32 /dev/vda
> meta-data=/dev/vda               isize=512    agcount=16, agsize=163832 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0,
> rmapbt=0, reflink=0
> data     =                       bsize=4096   blocks=2621312, imaxpct=25
>          =                       sunit=8      swidth=8 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=4 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
