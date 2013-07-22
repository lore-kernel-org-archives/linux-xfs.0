Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 166D47F4E
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 17:56:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0101F304051
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 15:56:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YwIm5Sj6u2TCLJGi for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 15:56:42 -0700 (PDT)
Date: Tue, 23 Jul 2013 08:56:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: di_flushiter considered harmful
Message-ID: <20130722225640.GB19986@dastard>
References: <1374488304-13044-1-git-send-email-david@fromorbit.com>
	<20130722110732.GA365@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130722110732.GA365@x4>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On Mon, Jul 22, 2013 at 01:07:32PM +0200, Markus Trippelsdorf wrote:
> On 2013.07.22 at 20:18 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we made all inode updates transactional, we no longer needed
> > the log recovery detection for inodes being newer on disk than the
> > transaction being replayed - it was redundant as replay of the log
> > would always result in the latest version of the inode woul dbe on
> > disk. It was redundant, but left in place because it wasn't
> > considered to be a problem.
> > 
> > However, with the new "don't read inodes on create" optimisation,
> > flushiter has come back to bite us. Essentially, the optimisation
> > made always initialises flushiter to zero in the create transaction,
> > and so if we then crash and run recovery and the inode already on
> > disk has a non-zero flushiter it will skip recovery of that inode.
> > As a result, log recovery does the wrong thing and we end up with a
> > corrupt filesystem.
> > 
> > Because we have to support old kernel to new kernl upgrades, we
> > can't just get rid of the flushiter support in log recovery as we
> > might be upgrading from a kernel that doesn't have fully transaction
> > inode updates.  Unfortunately, for v4 superblocks there is no way to
> > guarantee that log recovery knows about this fact.
> > 
> > We cannot add a new inode format flag to say it's a "special inode
> > create" because it won't be understood by older kernels and so
> > recovery could do the wrong thing on downgrade. We cannot specially
> > detect the combination of zero mode/non-zero flushiter on disk to
> > non-zero mode, zero flushiter in the log item during recovery
> > because wrapping of the flushiter can result in false detection.
> > 
> > Hence that makes this "don't use flushiter" optimisation limited to
> > a disk format that guarantees that we don't need it. And that means
> > the only fix here is to limit the "no read IO on create"
> > optimisation to version 5 superblocks....
> 
> I think your patch misses the following part:
> 
> @@ -1054,17 +1056,15 @@ xfs_iread(
>  
>         /* shortcut IO on inode allocation if possible */
>         if ((iget_flags & XFS_IGET_CREATE) &&
> -           !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> +           !(mp->m_flags & XFS_MOUNT_IKEEP) &&
> +           xfs_sb_version_hascrc(&mp->m_sb)) {
>                 /* initialise the on-disk inode core */
>                 memset(&ip->i_d, 0, sizeof(ip->i_d));
>                 ip->i_d.di_magic = XFS_DINODE_MAGIC;
>                 ip->i_d.di_gen = prandom_u32();
> -               if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -                       ip->i_d.di_version = 3;
> -                       ip->i_d.di_ino = ip->i_ino;
> -                       uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
> -               } else
> -                       ip->i_d.di_version = 2;
> +               ip->i_d.di_version = 3;
> +               ip->i_d.di_ino = ip->i_ino;
> +               uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
>                 return 0;
>         }

Sure, it's dead code so doesn't affect the behaviour of the patch.
I'll update it, but I need you to reproduce the problem in a simple
manner as Mark did with this patch in place so I can find out what
the real problem you are seeing is....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
