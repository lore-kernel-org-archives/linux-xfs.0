Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 517FC7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:12:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B576304066
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 21:12:43 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 0LkvN6Wp6As8tW3A
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 21:12:42 -0700 (PDT)
Message-ID: <51DE30BC.1050905@hardwarefreak.com>
Date: Wed, 10 Jul 2013 23:12:44 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Corruption of root fs during git bisect of drm system hang
References: <20130710090634.GA356@x4> <20130711003122.GR3438@dastard>
	<20130711033621.GB362@x4> <20130711035827.GA3438@dastard>
In-Reply-To: <20130711035827.GA3438@dastard>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On 7/10/2013 10:58 PM, Dave Chinner wrote:
> On Thu, Jul 11, 2013 at 05:36:21AM +0200, Markus Trippelsdorf wrote:

>> I was loosing my KDE settings bit by bit with every reboot during the
>> bisection. First my window-rules disappeared, then my desktop background
>> changed to default, then my taskbar moved from top to the bottom, etc.
>> In the end I had to restore all my .files from backup. =

> =

> That's not filesystem corruption. That sounds more like someone not
> using fsync in the apropriate place when overwriting a file....

>From Sandeen's blog, March 2009:

"I dunno how to resolve this right now.  I talked to some nice KDE folks
on irc; they basically want atomic writes, either you get your old file
or your new file post-crash; and tempfile/sync/rename does this =96 but
the fsync hurts on 78% of the Linux filesystems out there.  So their
KSaveFile class doesn=92t fsync.  So what to do, what to do.."



That's 4 years ago.  Is it possible the KDE devs are still not using
fsync?  Sure seems likely given Markus' problem.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
