Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40B2D7F50
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:36:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30180304059
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:36:24 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id NFPlGzHFq4MyhQfF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 20:36:23 -0700 (PDT)
Date: Thu, 11 Jul 2013 05:36:21 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130711033621.GB362@x4>
References: <20130710090634.GA356@x4>
 <20130711003122.GR3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130711003122.GR3438@dastard>
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
Cc: xfs@oss.sgi.com

On 2013.07.11 at 10:31 +1000, Dave Chinner wrote:
> On Wed, Jul 10, 2013 at 11:06:34AM +0200, Markus Trippelsdorf wrote:
> > While bisecting a system hang, caused by the drm gpu subsystem, my root fs got
> > corrupted:
> 
> I don't see any corruption being repaired....
> 
> > 
> >  # xfs_repair /dev/sdc2
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > agi unlinked bucket 6 is 682886 in ag 3 (inode=101346182)
> > agi unlinked bucket 7 is 11335 in ag 3 (inode=100674631)
> > agi unlinked bucket 10 is 682890 in ag 3 (inode=101346186)
> > agi unlinked bucket 21 is 981 in ag 3 (inode=100664277)
> > agi unlinked bucket 23 is 5704343 in ag 3 (inode=106367639)
> > agi unlinked bucket 29 is 211421 in ag 3 (inode=100874717)
> > agi unlinked bucket 31 is 7681375 in ag 3 (inode=108344671)
> > agi unlinked bucket 34 is 3480162 in ag 3 (inode=104143458)
> > agi unlinked bucket 40 is 211432 in ag 3 (inode=100874728)
> > agi unlinked bucket 41 is 2704937 in ag 3 (inode=103368233)
> > agi unlinked bucket 45 is 594669 in ag 3 (inode=101257965)
> > agi unlinked bucket 62 is 11902 in ag 3 (inode=100675198)
> 
> That's a filesystem that has unlinked inodes on the unlinked list.
> They get cleaned up during log replay. All the other "errors" are
> related to cleaning these up....
> 
> So what is making you think there is a corruption? What's the error
> being reported when you are using the filesystem? i.e. what's the
> entire process you go through before you get to finding this
> problem?

I was loosing my KDE settings bit by bit with every reboot during the
bisection. First my window-rules disappeared, then my desktop background
changed to default, then my taskbar moved from top to the bottom, etc.
In the end I had to restore all my .files from backup. 
And please note that xfs_repair unlinked the inodes _after_ the
filesystem has been mounted and unmounted normally. 

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
