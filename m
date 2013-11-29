Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FC0F29E10
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 19:47:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E4AB304039
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 17:47:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2DcVx2niEsfsHnCV for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 17:47:16 -0800 (PST)
Date: Fri, 29 Nov 2013 12:46:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131129014648.GU10988@dastard>
References: <20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131128234441.GQ10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 11:44:41PM +0000, Al Viro wrote:
> On Fri, Nov 29, 2013 at 09:51:02AM +1100, Dave Chinner wrote:
> 
> > > Looks like adding if (!nd->inode) { a bunch of printks } in the end of
> > > path_init() makes the sucker disappear (so far 2 times out of 2, and
> > > with a test run taking a bit under two hours, well...)  The plain
> > > WARN_ON(!nd->inode) in that place triggers just fine.
> > 
> > I usually find that when printk() makes race conditions go away,
> > switching to tracepoints works better. It's still not as good as
> > reliable as when the debug is not there, but it seems to perturb
> > race conditions a lot less.
> 
> Actually, I've just got the output from this run, and it's really interesting.
> We get path_init() setting NULL nd->inode for open() of "/dev/ptmx" (from
> /sbin/startpar).  And what we have at the time we get to link_path_walk() is
> 	* LOOKUP_RCU | LOOKUP_FOLLOW | LOOKUP_PARENT | LOOKUP_JUMPED in
> nd->flags (as expected)
> 	* current->fs->root, current->fs->pwd and nd->path being the same
> vfsmount/dentry pair.
> 	* dentry in question has ->d_sb->s_id containing "sda1", as expected
> for root fs.
> 	* ->mnt_root of that vfsmount being equal to dentry
> So far, so good, right?
> 	* d_count(dentry) is -128

void lockref_mark_dead(struct lockref *lockref)
{
        assert_spin_locked(&lockref->lock);
        lockref->count = -128;
}
EXPORT_SYMBOL(lockref_mark_dead);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
