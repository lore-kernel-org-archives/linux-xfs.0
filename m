Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46465 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbeHVCyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 22:54:50 -0400
Date: Wed, 22 Aug 2018 09:32:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/10] xfs: consolidate mount option features in
 m_features
Message-ID: <20180821233234.GL31495@dastard>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-4-david@fromorbit.com>
 <20180821132152.GB15030@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821132152.GB15030@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 09:21:53AM -0400, Brian Foster wrote:
> On Mon, Aug 20, 2018 at 02:48:44PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This provides separation of mount time feature flags from runtime
> > mount flagsi and mount option state. It also makes the feature
> 
> s/flagsi/flags/
> 
> > checks use the same interface as the superblock features. i.e. we
> > don't care if the feature is enabled by superblock flags or mount
> > options, we just care if it's enabled or not.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.h | 36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 92d947f17c69..74a128fe316b 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -225,6 +225,21 @@ typedef struct xfs_mount {
> >  #define XFS_FEAT_META_UUID	(1ULL << 20)	/* metadata UUID */
> >  #define XFS_FEAT_REALTIME	(1ULL << 21)	/* realtime device present */
> >  
> > +#define XFS_FEAT_WSYNC		(1ULL << 22)	/* synchronous metadata ops */
> > +#define XFS_FEAT_DIRSYNC	(1ULL << 23)	/* synchronous directory ops */
> > +#define XFS_FEAT_DISCARD	(1ULL << 24)	/* discard unused blocks */
> > +#define XFS_FEAT_GRPID		(1ULL << 25)	/* group-ID assigned from directory */
> > +#define XFS_FEAT_SMALL_INUMS	(1ULL << 26)	/* user wants 32bit inodes */
> > +#define XFS_FEAT_IKEEP		(1ULL << 27)	/* keep empty inode clusters*/
> > +#define XFS_FEAT_SWALLOC	(1ULL << 28)	/* stripe width allocation */
> > +#define XFS_FEAT_FILESTREAMS	(1ULL << 29)	/* enable the filestreams
> > +						   allocator */
> > +#define XFS_FEAT_DAX		(1ULL << 30)	/* TEST ONLY! */
> > +#define XFS_FEAT_COMPAT_IOSIZE	(1ULL << 31)	/* don't report large preferred
> > +						 * I/O size in stat() */
> > +#define XFS_FEAT_NORECOVERY	(1ULL << 32)	/* no recovery - dirty fs */
> > +#define XFS_FEAT_NOUUID		(1ULL << 33)	/* ignore uuid during mount */
> 
> Similar indentation issue here..? Otherwise looks fine modulo the
> previous comments on the broader API.

That's just the diff changing layout of tabs because everything is
indented one space.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
