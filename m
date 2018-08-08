Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37063 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbeHHPcM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Aug 2018 11:32:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so1991815wrr.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Aug 2018 06:12:33 -0700 (PDT)
Date: Wed, 8 Aug 2018 15:12:30 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] design: Document project quota inode
Message-ID: <20180808131230.nc67uu7yyhbosy6w@odin.usersys.redhat.com>
References: <20180806211032.16777-1-mbenatto@redhat.com>
 <20180807151050.GB30972@magnolia>
 <20180807152806.GD30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807152806.GD30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Marco Benatto <mbenatto@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Aug 07, 2018 at 08:28:06AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 07, 2018 at 08:10:50AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 06, 2018 at 06:10:32PM -0300, Marco Benatto wrote:
> > > A project quota inode was introduced into V5 superblock allowing
> > > project quotas and group quotas to be used simultaneously. However
> > > on "Quota Inodes" section we still mention it's not possible to
> > > use project and group quotas at sametime.
> > > 
> > > This patch documents this behavior for V5 and later superblocks,
> > > while keeps documented the old behavior for earlier versions.
> > > 
> > > Signed-off-by: Marco Benatto <mbenatto@redhat.com>
> > 
> > Looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > > ---
> > >  design/XFS_Filesystem_Structure/internal_inodes.asciidoc | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
> > > index f5c2654..b694e74 100644
> > > --- a/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
> > > +++ b/design/XFS_Filesystem_Structure/internal_inodes.asciidoc
> > > @@ -8,9 +8,12 @@ accessible from the superblock.
> > >  [[Quota_Inodes]]
> > >  == Quota Inodes
> > >  
> > > -If quotas are used, two inodes are allocated for user and group quota
> > > -management. If project quotas are used, these replace the group quota management
> > > -and therefore uses the group quota inode.
> > > +If quotas are used, prior to version 5 superblocks, two inodes are allocated for
> > > +user and group management. In this case if project quotas are used, these replace
> > > +the group quota management and therefore uses the group quota inode.
> > > +
> > > +In version 5 superblock or later a third inode will be allocated to project quota
> > > +management, making it possible to use group and project quotas management simultaneously.
> 
> Ugh, /me has post-review regrets... mind if I rearrange this a little?
> 
> "Prior to version 5 filesystems, two inodes can be allocated for quota
> management.  The first inode will be used for user quotas.  The second
> inode will be used for group quotas or project quotas, depending on
> mount options.  Group and project quotas are mutually exclusive features
> in these environments.
> 
> "In version 5 or later filesystems, each quota type is allocated its own
> inode, making it possible to use group and project quota management
> simultaneously."
> 

FWIW

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>



> --D
> 
> > >  
> > >  * Project quota's primary purpose is to track and monitor disk usage for
> > >  directories. For this to occur, the directory inode must have the
> > > @@ -28,7 +31,7 @@ multiplied by the size of +xfs_dqblk_t+ (136 bytes).
> > >  .Quota inode layout
> > >  image::images/76.png[]
> > >  
> > > -Quota information is stored in the data extents of the two reserved quota
> > > +Quota information is stored in the data extents of the reserved quota
> > >  inodes as an array of the +xfs_dqblk+ structures, where there is one array
> > >  element for each ID in the system:
> > >  
> > > -- 
> > > 2.9.5
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
