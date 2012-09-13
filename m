Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DGgfoB184063 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 11:42:41 -0500
Date: Thu, 13 Sep 2012 11:43:44 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs: stop the sync worker before xfs_unmountfs
Message-ID: <20120913164344.GV25175@sgi.com>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
	<20120830172549.GG3274@sgi.com> <20120830223504.GE15292@dastard>
	<5040FF25.1010501@sgi.com> <20120901230824.GB6896@infradead.org>
	<20120912183347.GO3274@sgi.com> <20120912231406.GJ11511@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120912231406.GJ11511@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi Dave,

On Thu, Sep 13, 2012 at 09:14:06AM +1000, Dave Chinner wrote:
> On Wed, Sep 12, 2012 at 01:33:47PM -0500, Ben Myers wrote:
> > See what you think of this.  Not heavily tested yet, and not pretty... but it
> > is fairly minimal. 
> ....
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> >
> > Index: xfs/fs/xfs/xfs_super.c
> > ===================================================================
> > --- xfs.orig/fs/xfs/xfs_super.c
> > +++ xfs/fs/xfs/xfs_super.c
> > @@ -919,6 +919,7 @@ xfs_fs_put_super(
> >  	struct xfs_mount	*mp = XFS_M(sb);
> >
> >  	xfs_filestream_unmount(mp);
> > +	cancel_delayed_work_sync(&mp->m_sync_work);
> >  	xfs_unmountfs(mp);
> >  	xfs_syncd_stop(mp);
> >  	xfs_freesb(mp);
> 
> This is the only hunk in the patch needed to fix the problem.
> 
> The rest of the patch does not change the order in which the sync
> worker is started and stopped - it just open codes it next to the
> xfs_syncd_start/stop calls. Essentially, all it does is obfuscate
> the real fix that is being made here and makes it harder to
> understand what the relationship between xfs_sync_worker() and
> xfs_syncd_start/stop is supposed to be.
> 
> So a minimal patch, IMO, is just the above hunk....

Ah, you're right.  I was working on the assumption that it is best not to
cancel the work twice.  There really is no harm in cancel_delayed_work_sync
both in xfs_fs_put_super and in xfs_syncd_stop.  However, we don't want them
spread around willy nilly.  That can become obfuscatory too.  I suggest we
should remove the cancel_delayed_work_sync(&mp->m_sync_work) in
xfs_log_unmount, leftover from commit 11159a05.  It seems like that one hasn't
been effective.  

Maybe we don't want to do that in this patch...  I'll just add a comment and
repost.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
