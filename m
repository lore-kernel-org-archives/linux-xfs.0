Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 63FA07F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 18:55:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 470918F8037
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 16:55:56 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kMIsvt1JYgcMQPVD for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 16:55:54 -0800 (PST)
Date: Sat, 23 Feb 2013 11:55:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inode64 superblock flag is still worth
Message-ID: <20130223005552.GC26081@dastard>
References: <20130222132721.GA10079@andromeda.usersys.redhat.com>
	<20130222161713.GV22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130222161713.GV22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Fri, Feb 22, 2013 at 10:17:13AM -0600, Ben Myers wrote:
> Hi Carlos,
> 
> On Fri, Feb 22, 2013 at 10:27:21AM -0300, Carlos Maiolino wrote:
> > I was looking the "Ideas for XFS" wiki page, and noticed a topic about the
> > implementation of a flag in superblock to identify the filesystem is using
> > 64-bit inodes. Once we use it by default now, is this idea still worth?

IMO, no.

> > I can
> > work on it, but I don't think this is still worth to be implemented.
> > If still looks worth, I'd suggest a flag set when 32-bit inodes only is used not
> > 64, but I really dunno how this might be useful for kernel.

What's the point? current kernels (and anything since about 2.6.28
(IIRC) support 64 bit inodes even on 32 bit machines. All that
adding a bit to the superblock will do is prevent these filesystems
from bein usable on older kernels, even when the kernel is perfectly
capable of working with that filesystem.

It's more trouble than it's worth at this point.

> > From a user
> > perspective, it might help, but `mount` command or mtab already shows inode32
> > option when it's used.
> 
> So the inode32 allocation policy becomes persistent and no longer need to be
> set at mount time.  This is definately worth working on, IMO.

It has nothing to do with allocation policy, so I'd advise against
trying to conflate the two.

> We should think
> about something more general before making on-disk changes for this.  For
> example, Rich recently posted the agskip data allocation policy which (like
> inode32) was implemented as a mount option.  If agskip=5 were to be made
> persistent we'd need space in the superblock to keep track of the 5.

Definitely not. The superblock is not a dumping ground for random
allocation policy configuration data.

FWIW, if you paid attention to the allocation policy patch set that I
pointed Rich at, allocation policies have to be defined in the
kernel code and there's support for up to 2^32 different
identifiers. IIRC, it allowed for 2^16 policy templates (e.g.
inode64 is a policy template) and 2^16 policy instances (e.g.
inode32 with agskip=2 is an instance, and inode32/agskip=4 is a
second instance). There is no way the superblock is big enough to
keep this sort of information in it, so we should not be even
thinking of doing that sort of hack for allocation policy data.

Storing allocatin policy template/instance information needs a
separate tree structure that allows rapid lookup and persistent
storage. e.g. in a btree. This is where the alloc policy patch set
was going - that it would use the generic btree infrastructure for
persistent storage of alloc policy information. It just never got
there....

> The interface for changing alloc policies should
> probably be in xfs_io or xfs_mkfs.

xfs_spaceman is intended to be the interface for manipulating stuff
like allocation policies, filessytem geometry information, etc.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
