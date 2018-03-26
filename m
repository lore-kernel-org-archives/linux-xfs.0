Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbeCZMqw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 08:46:52 -0400
Date: Mon, 26 Mar 2018 08:46:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <20180326124649.GD34912@bfoster.bfoster>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180324162049.GP4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
> > Now that unlinked inode recovery is done outside of
> > log recovery, there is no need to dirty the log on
> > snapshots just to handle unlinked inodes.  This means
> > that readonly snapshots can be mounted without requiring
> > -o ro,norecovery to avoid the log replay that can't happen
> > on a readonly block device.
> > 
> > (unlinked inodes will just hang out in the agi buckets until
> > the next writable mount)
> 
> FWIW I put these two in a test kernel to see what would happen and
> generic/311 failures popped up.  It looked like the _check_scratch_fs
> found incorrect block counts on the snapshot(?)
> 

Interesting. Just a wild guess, but perhaps it has something to do with
lazy sb accounting..? I see we call xfs_initialize_perag_data() when
mounting an unclean fs.

Brian

> --D
> 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 93588ea..5669525 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1419,9 +1419,10 @@ struct proc_xfs_info {
> >  
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> > - * need to take care of the metadata. Once that's done sync the superblock
> > - * to the log to dirty it in case of a crash while frozen. This ensures that we
> > - * will recover the unlinked inode lists on the next mount.
> > + * need to take care of the metadata.
> > + * Any unlinked inode lists will remain at this point, and be recovered
> > + * on the next writable mount if we crash while frozen, or create
> > + * a snapshot from the frozen filesystem.
> >   */
> >  STATIC int
> >  xfs_fs_freeze(
> > @@ -1431,7 +1432,7 @@ struct proc_xfs_info {
> >  
> >  	xfs_save_resvblks(mp);
> >  	xfs_quiesce_attr(mp);
> > -	return xfs_sync_sb(mp, true);
> > +	return 0;
> >  }
> >  
> >  STATIC int
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
