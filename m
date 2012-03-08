Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28FbGv4044993 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 09:37:16 -0600
Date: Thu, 8 Mar 2012 09:37:21 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
Message-ID: <20120308153721.GS7762@sgi.com>
References: <4F5798F9.2050809@redhat.com> <20120308013413.GL3592@dastard>
	<4F5813D8.8070305@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F5813D8.8070305@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Mar 07, 2012 at 08:05:12PM -0600, Eric Sandeen wrote:
> On 3/7/12 7:34 PM, Dave Chinner wrote:
> > On Wed, Mar 07, 2012 at 11:20:57AM -0600, Eric Sandeen wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >>
> >> Default to allowing 64-bit inodes on the filesystem.
> >>
> >> Add a feature bit to the the superblock to record whether 64 bit inodes have
> >> been allocated on the filesystem or not. This allows us to reject mounting the
> >> filesytem with inode32 if 64 bit inodes are present.
> >>
> >> Once a 64 bitinode is allocated, the inode64 superblock feature bit will be set.
> >> Once the superblock feature bit is set, the filesystem will default to 64 bit
> >> inodes regardless of whether inode64 is specified as a mount option.
> >>
> >> To ensure only 32 bit inodes are created, the inode32 mount option must be
> >> used. If there are already 64 bit inodes as flagged by the superblock feature
> >> bit, then the inode32 mount will be refused.
> >>
> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >> ---
> >>
> >> Passing this along to revive the old discussion ... 
> > 
> > I have no objections to do this. However, the kernel patch is just
> > the tip of the iceberg when it comes to implementing this.
> > 
> > Were there patches for userspace support of the feature bit? I don't
> > recall if there were. I'm thinking that xfs_info needs to output
> > whether this is set, which means the flag needs to be added to the
> > xfs geometry ioctls in the kernel.
> 
> Nope, you just put this patch out as a suggestion, and pointed out
> that userspace needed updates too.
> 
> If people are in agreement about this then we can proceed with the rest...

Please do.  I too have been burned by mounting a filesystem with big
inos without the correct mount option.  This is a great idea.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
