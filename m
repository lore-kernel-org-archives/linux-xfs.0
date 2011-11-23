Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANKUNI7234171 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 14:30:24 -0600
Date: Wed, 23 Nov 2011 14:30:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [REVIEW] xfssyncd lost wakes circa 2.6.32
Message-ID: <20111123203041.GO749@sgi.com>
References: <20111123163046.GQ29840@sgi.com>
	<20111124064216.5ff54077@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111124064216.5ff54077@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: nfbrown@suse.com, Alex Elder <elder@linux.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, ataschner@novell.com

On Thu, Nov 24, 2011 at 06:42:16AM +1100, NeilBrown wrote:
> On Wed, 23 Nov 2011 10:30:46 -0600 Ben Myers <bpm@sgi.com> wrote:
> > Index: linux/fs/xfs/linux-2.6/xfs_sync.c
> > ===================================================================
> > --- linux.orig/fs/xfs/linux-2.6/xfs_sync.c
> > +++ linux/fs/xfs/linux-2.6/xfs_sync.c
> > @@ -620,13 +620,25 @@ xfssyncd(
> >  	set_freezable();
> >  	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
> >  	for (;;) {
> > -		timeleft = schedule_timeout_interruptible(timeleft);
> > -		/* swsusp */
> > -		try_to_freeze();
> > -		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
> > +		set_current_state(TASK_INTERRUPTIBLE);
> > +		spin_lock(&mp->m_sync_lock);
> > +
> > +		if (list_empty(&mp->m_sync_list) && !kthread_should_stop()) {
> > +			spin_unlock(&mp->m_sync_lock);
> > +
> > +			timeleft = schedule_timeout_interruptible(timeleft);
> 
> This should be just "schedule_timeout(timeleft)".
> This call sets TASK_INTERRUPTIBLE so we will go to sleep even if we were
> only just woken up.
> 
> I don't really know the XFS code well enough to the rest looks right, but
> with that small fix it certainly doesn't look wrong :-)

Thanks Neil!   I'll get that fixed up.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
