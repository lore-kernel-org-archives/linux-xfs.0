Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 603BA7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 15:58:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 300778F8033
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 13:58:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZEGHtyi9ckF1UmpG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2016 13:57:59 -0700 (PDT)
Date: Mon, 6 Jun 2016 16:57:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: cancel eofblocks background trimming on remount
	read-only
Message-ID: <20160606205756.GA18035@bfoster.bfoster>
References: <1465233175-6701-1-git-send-email-bfoster@redhat.com>
	<e26dbc36-1c0f-4808-79cf-3cac685e43fa@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e26dbc36-1c0f-4808-79cf-3cac685e43fa@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 06, 2016 at 03:24:10PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/6/16 12:12 PM, Brian Foster wrote:
> > The filesystem quiesce sequence performs the operations necessary to
> > drain all background work, push pending transactions through the log
> > infrastructure and wait on I/O resulting from the final AIL push. We
> > have had reports of remount,ro hangs in xfs_log_quiesce() ->
> > xfs_wait_buftarg(), however, and some instrumentation code to detect
> > transaction commits at this point in the quiesce sequence has inculpated
> > the eofblocks background scanner as a cause.
> > 
> > While higher level remount code generally prevents user modifications by
> > the time the filesystem has made it to xfs_log_quiesce(), the background
> > scanner may still be alive and can perform pending work at any time. If
> > this occurs between the xfs_log_force() and xfs_wait_buftarg() calls
> > within xfs_log_quiesce(), this can lead to an indefinite lockup in
> > xfs_wait_buftarg().
> > 
> > To prevent this problem, cancel the background eofblocks scan worker
> > during the remount read-only quiesce sequence. This suspends background
> > trimming when a filesystem is remounted read-only. This is only done in
> > the remount path because the freeze codepath has already locked out new
> > transactions by the time the filesystem attempts to quiesce (and thus
> > waiting on an active work item could deadlock). Kick the eofblocks
> > worker to pick up where it left off once an fs is remounted back to
> > read-write.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > To confirm the problem, I have managed to manufacture the remount,ro
> > hang issue described above by hacking in some delays/coordination
> > between the quiesce and eofblocks background worker.
> > 
> > Also, an alternative approach that I was considering is to run a
> > synchronous scan around the same place this patch cancels the background
> > scan. The idea is that the background scan would then have no work to do
> > on the subsequent iteration and then die off naturally (until
> > preallocation occurs once again). I suppose the downside is that a
> > remount might not necessarily be expected to muck with preallocation
> > state of affected files. This patch seemed more simple, but I'm open to
> > either. Thoughts?
> 
> Your approach makes sense to me - "finishing" the scan prior to quiesce
> could take a relatively unknown amount of time as well, right?  And I guess
> I don't see a real advantage to that; we don't wait for it on unmount
> (right?)
> 

Yes, it could take an unknown amount of time. It would probably be
similar to what we would do on an unmount. We don't explicitly wait for
a scan on unmount (though we destroy the workqueue at some point), but I
believe we have to reclaim all cached inodes, which then trims eofblocks
for every inode where appropriate (via xfs_inactive()).

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>  

Thanks!

Brian

> > Brian
> > 
> >  fs/xfs/xfs_icache.c | 2 +-
> >  fs/xfs/xfs_icache.h | 1 +
> >  fs/xfs/xfs_super.c  | 8 ++++++++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 99ee6eee..fb39a66 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -765,7 +765,7 @@ restart:
> >   * Background scanning to trim post-EOF preallocated space. This is queued
> >   * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
> >   */
> > -STATIC void
> > +void
> >  xfs_queue_eofblocks(
> >  	struct xfs_mount *mp)
> >  {
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 62f1f91..05bac99 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -68,6 +68,7 @@ void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> >  int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
> >  int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
> >  void xfs_eofblocks_worker(struct work_struct *);
> > +void xfs_queue_eofblocks(struct xfs_mount *);
> >  
> >  int xfs_inode_ag_iterator(struct xfs_mount *mp,
> >  	int (*execute)(struct xfs_inode *ip, int flags, void *args),
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 4700f09..7965371 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1294,6 +1294,7 @@ xfs_fs_remount(
> >  		 */
> >  		xfs_restore_resvblks(mp);
> >  		xfs_log_work_queue(mp);
> > +		xfs_queue_eofblocks(mp);
> >  	}
> >  
> >  	/* rw -> ro */
> > @@ -1306,6 +1307,13 @@ xfs_fs_remount(
> >  		 * return it to the same size.
> >  		 */
> >  		xfs_save_resvblks(mp);
> > +
> > +		/*
> > +		 * Cancel background eofb scanning so it cannot race with the
> > +		 * final log force+buftarg wait and deadlock the remount.
> > +		 */
> > +		cancel_delayed_work_sync(&mp->m_eofblocks_work);
> > +
> >  		xfs_quiesce_attr(mp);
> >  		mp->m_flags |= XFS_MOUNT_RDONLY;
> >  	}
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
