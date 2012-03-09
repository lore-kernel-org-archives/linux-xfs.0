Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2928LL0112889 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 20:08:21 -0600
Date: Thu, 8 Mar 2012 20:08:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
Message-ID: <20120309020827.GA8545@sgi.com>
References: <4F5798F9.2050809@redhat.com> <20120308013413.GL3592@dastard>
	<4F5813D8.8070305@sandeen.net> <20120308153721.GS7762@sgi.com>
	<4F58D35D.7080504@sandeen.net> <20120308163832.GV8545@sgi.com>
	<20120308233953.GP5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308233953.GP5091@dastard>
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
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Hi Dave,

On Fri, Mar 09, 2012 at 10:39:53AM +1100, Dave Chinner wrote:
> On Thu, Mar 08, 2012 at 10:38:32AM -0600, Ben Myers wrote:
> > On Thu, Mar 08, 2012 at 09:42:21AM -0600, Eric Sandeen wrote:
> > > So, after thinking about this (and talking on irc) some more, I'm
> > > not convinced that a feature flag is the way to go.
> > > 
> > > If we set a feature flag, suddenly old filesystems with 64-bit
> > > inodes will grow a new feature, and this will force a userspace
> > > upgrade - but there is no real new feature.  This seems like a bad
> > > idea.  My original patch (which Dave responded to with this one)
> > > simply made inode64 default, with no feature flags.
> > > 
> > > Unless someone has a really compelling argument for the flag,
> > > I'm thinking this is the wrong approach after all.
> > > 
> > > Perhaps I should resend the just-make-it-default patch.
> > > 
> > > Comments?
> > 
> > Ew!  Forcing a userspace upgrade is not desireable.  Since we would only
> > want to set the feature bit if userspace were already upgraded, and only
> > if there are 64 bit inos...  How about two bits:  one is set by mkfs and
> > checked by the kernel to see if it is ok to set the other.  ;)
> > 
> > The first bit could also act as 'now its ok to default to inode64'.
> 
> Too complex, IMO. Just add an xfs_admin command to set the inode64
> feature bit. That then overrides the inode64/inode32 mount option,
> and guarantees that the user has already upgraded userspace.
> 
> i.e. the mount options are only valid if the feature bit it not set,
> and the feature bit can only be set via xfs_admin after a userspace
> upgrade. Kernels that don't understand the feature bit will refuse
> to mount, keeping in line with the current practise of requiring
> both kernel and userspace upgrades to occur in step to use new
> features....

When I hit this problem it was because I had mounted the filesystem w/
inode64 and created large inos, and then forgot all about it sometime
later and didn't use the mount option.  Unless the inode64 mount option
is completely disabled in favor of using the 'override inode*' feature
bit exclusively, this aspect of the problem is not resolved.

That'd be just fine, imo.  I wonder if there are others that would be
better tracked in the superblock than as mount options.  'dmi' comes to
mind.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
