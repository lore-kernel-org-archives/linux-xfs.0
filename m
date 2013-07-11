Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9479B7F59
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:15:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 822A28F8039
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 21:15:03 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id GtbaHCBWbevXIRx2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 21:15:02 -0700 (PDT)
Date: Thu, 11 Jul 2013 06:15:00 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130711041500.GD362@x4>
References: <20130710090634.GA356@x4> <20130711003122.GR3438@dastard>
	<20130711033621.GB362@x4> <20130711035827.GA3438@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130711035827.GA3438@dastard>
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

On 2013.07.11 at 13:58 +1000, Dave Chinner wrote:
> On Thu, Jul 11, 2013 at 05:36:21AM +0200, Markus Trippelsdorf wrote:
> > On 2013.07.11 at 10:31 +1000, Dave Chinner wrote:
> > > On Wed, Jul 10, 2013 at 11:06:34AM +0200, Markus Trippelsdorf wrote:
> > > > While bisecting a system hang, caused by the drm gpu subsystem, my root fs got
> > > > corrupted:
> > > 
> > > That's a filesystem that has unlinked inodes on the unlinked list.
> > > They get cleaned up during log replay. All the other "errors" are
> > > related to cleaning these up....
> > > 
> > > So what is making you think there is a corruption? What's the error
> > > being reported when you are using the filesystem? i.e. what's the
> > > entire process you go through before you get to finding this
> > > problem?
> > 
> > I was loosing my KDE settings bit by bit with every reboot during the
> > bisection. First my window-rules disappeared, then my desktop background
> > changed to default, then my taskbar moved from top to the bottom, etc.
> > In the end I had to restore all my .files from backup. 
> 
> That's not filesystem corruption. That sounds more like someone not
> using fsync in the apropriate place when overwriting a file....

Ok. Sorry for using the wrong term.

> > And please note that xfs_repair unlinked the inodes _after_ the
> > filesystem has been mounted and unmounted normally. 
> 
> Which means we might not be processing the unlinked lists correctly
> and leaking them. If repair is finding the inodes in the AGI
> unlinked lists, then recovery should be finding them, too. Not
> processing them and not clearing the AGI bucket tends to imply that
> recovery failed to read the AGI buffer.
> 
> What error messages are in dmesg, if any? And what kernel are you
> running?

There are no error messages in dmesg. I'm running the latest Linus tree.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
