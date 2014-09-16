Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5193B7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:41:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C308CAC008
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:41:12 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0mAsAXehOSLjHDwZ for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:41:10 -0700 (PDT)
Date: Wed, 17 Sep 2014 08:40:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG, 3.17-rc4] dentry still in use during unmount
Message-ID: <20140916224056.GP4322@dastard>
References: <20140916215336.GL4322@dastard>
	<20140916223043.GY7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140916223043.GY7996@ZenIV.linux.org.uk>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 16, 2014 at 11:30:44PM +0100, Al Viro wrote:
> On Wed, Sep 17, 2014 at 07:53:36AM +1000, Dave Chinner wrote:
> > Hi Al,
> > 
> > One of my xfstest rigs tripped over this last night when running
> > xfs/301 on a pair of 4G ramdisks during an auto group run:
> > 
> > BUG: Dentry ffff8803c14fc870{i=0,n=dir}  still in use (-127) [unmount of xfs ram1]
> 
> Umm... -127 == "already got past the beginning of __dentry_kill()".  And if
> it had been seen by d_walk() callback, it must have gotten past the point where
> __dentry_kill() unlocks that sucker.
> 
> Very interesting...  I don't see how that could happen, TBH - __dentry_kill()
> is called with parent and victim locked; it sets DCACHE_DENTRY_KILLED and
> removes the victim from parent's ->d_subdirs before dropping either lock.
> Moreover, the victim can't have any children at that point - it must have
> had the last reference held by called of __dentry_kill() and each child
> would've contributed to refcount.
> 
> And d_walk() goes through the list of children with parent kept locked.
> It does unlock the parent after walking one level deeper, but on the
> way back it
> 	* checks that there had been no renames
> 	* checks that child isn't marked with DCACHE_DENTRY_KILLED
> after relocking the parent.  In case of anything fishy it restarts the
> whole thing with renames excluded.  If those tests succeed, we are guaranteed
> that we'll continue walking the parent's list of children with parent locked,
> AFAICS, not that there could legitimately be anything playing with the
> dentry tree modifications in parallel with fs shutdown...
> 
> It might be interesting to slap WARN_ON(dentry->d_flags & DCACHE_DENTRY_KILLED)
> for dentry and target in __d_move() and for anon in __d_materialise_dentry(),
> after dentry_lock_for_move() in both functions.  And see if it triggers.
> IOW, whether it's possible for doomed dentry to be readded to someone's
> ->d_subdirs after it has entered __dentry_kill().

Ok, I'll add a debug patch to my test kernels that add these and
I'll let you know if anything triggers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
