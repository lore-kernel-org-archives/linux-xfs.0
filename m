Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2923B7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:30:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADF53AC00B
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:30:49 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id PGd4A3PexB7WUYnV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:30:47 -0700 (PDT)
Date: Tue, 16 Sep 2014 23:30:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [BUG, 3.17-rc4] dentry still in use during unmount
Message-ID: <20140916223043.GY7996@ZenIV.linux.org.uk>
References: <20140916215336.GL4322@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140916215336.GL4322@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 17, 2014 at 07:53:36AM +1000, Dave Chinner wrote:
> Hi Al,
> 
> One of my xfstest rigs tripped over this last night when running
> xfs/301 on a pair of 4G ramdisks during an auto group run:
> 
> BUG: Dentry ffff8803c14fc870{i=0,n=dir}  still in use (-127) [unmount of xfs ram1]

Umm... -127 == "already got past the beginning of __dentry_kill()".  And if
it had been seen by d_walk() callback, it must have gotten past the point where
__dentry_kill() unlocks that sucker.

Very interesting...  I don't see how that could happen, TBH - __dentry_kill()
is called with parent and victim locked; it sets DCACHE_DENTRY_KILLED and
removes the victim from parent's ->d_subdirs before dropping either lock.
Moreover, the victim can't have any children at that point - it must have
had the last reference held by called of __dentry_kill() and each child
would've contributed to refcount.

And d_walk() goes through the list of children with parent kept locked.
It does unlock the parent after walking one level deeper, but on the
way back it
	* checks that there had been no renames
	* checks that child isn't marked with DCACHE_DENTRY_KILLED
after relocking the parent.  In case of anything fishy it restarts the
whole thing with renames excluded.  If those tests succeed, we are guaranteed
that we'll continue walking the parent's list of children with parent locked,
AFAICS, not that there could legitimately be anything playing with the
dentry tree modifications in parallel with fs shutdown...

It might be interesting to slap WARN_ON(dentry->d_flags & DCACHE_DENTRY_KILLED)
for dentry and target in __d_move() and for anon in __d_materialise_dentry(),
after dentry_lock_for_move() in both functions.  And see if it triggers.
IOW, whether it's possible for doomed dentry to be readded to someone's
->d_subdirs after it has entered __dentry_kill().

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
