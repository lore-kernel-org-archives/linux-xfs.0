Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JFE4gZ213234 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 10:14:04 -0500
Date: Wed, 19 Sep 2012 10:15:12 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: given a pointer to xfs_inode_t, how to determine path?
Message-ID: <20120919151512.GY3274@sgi.com>
References: <50574709.9000301@genband.com> <20120917162120.GG25175@sgi.com>
	<20120917224957.GI13691@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120917224957.GI13691@dastard>
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
To: Chris Friesen <chris.friesen@genband.com>, Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Hey,

On Tue, Sep 18, 2012 at 08:49:57AM +1000, Dave Chinner wrote:
> On Mon, Sep 17, 2012 at 11:21:20AM -0500, Ben Myers wrote:
> > Hi Chris,
> > 
> > On Mon, Sep 17, 2012 at 09:51:37AM -0600, Chris Friesen wrote:
> > > We're running 2.6.27 (upgrading not currently possible, embedded product).
> > >
> > > We had a situation arise where we could see in stack traces that a
> > > number of tasks were stuck in vn_iowait().  That function takes a
> > > pointer to xfs_inode_t.  Given that, would it be possible to work
> > > backwards to determine a filesystem path corresponding to that
> > > inode?  I realize it would likely only go back to the head of the
> > > filesystem, but that would be fine.
> > 
> > Yep, it's possible.
> > 
> > echo t > /proc/sysrq-trigger won't give you the full stack, but you may be able
> > to get an idea of what is going on, well enough to make some guesses as to the
> > culprit.  That's probably your best first step.
> 
> Doesn't give you the path of the inode, or anything that can tell
> you what the inode number is so you could run "find <dir> -inum
> <num>" after the system has recovered.
> 
> > If you have crash installed:
> > 
> > 1) disassemble vn_iowait and find out which register the xfs_inode_t pointer is in.
> > 2) print out the full stacks of all the processes in the system. 'bt -f', I think.
> 
> 'bt -F <pid>' tells you what entries on the stack are of a
> particular symbol. i.e. they'll show up as [xfs_inode] instead of a
> number for all addresses from inside the xfs inode slab cache.
> comapring the output of 'bt -F' and 'bt -f' will get you the inode
> address without needing to be able to read x86-64 assembly
> language...
> 
> > 3) grep for the xfs_inode_t pointer on those stacks.
> 
> Which doesn't get you the path, either. From there, follow to the
> struct inode, and from there to the struct dentry and grab the file
> name, then walk the d_parent dentry links back up to the root and
> construct the path that way.
> 
> Alternatively, I think you can walk from the top down by looking
> that the open files that a given process has and working down to the
> xfs_inode, but it's been a long time since I've had to come from
> that direction. Indeed, you might even be able to use lsof to do
> this and get an idea from userspace what files are currently
> open on the hung processes.

Yep, I misunderstood the question.  I didn't mean to mislead you Chris!
Really!  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
