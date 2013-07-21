Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 09C8629DF8
	for <xfs@oss.sgi.com>; Sun, 21 Jul 2013 02:37:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 67CBDAC001
	for <xfs@oss.sgi.com>; Sun, 21 Jul 2013 00:37:39 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NVEhlurlyq8lGBh2 for <xfs@oss.sgi.com>;
	Sun, 21 Jul 2013 00:37:37 -0700 (PDT)
Date: Sun, 21 Jul 2013 17:37:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
Message-ID: <20130721073732.GB11674@dastard>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4> <51E9AB80.4000700@sgi.com>
	<20130720031840.GA11674@dastard> <51EAC72B.905@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EAC72B.905@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

On Sat, Jul 20, 2013 at 12:21:47PM -0500, Mark Tinguely wrote:
> On 07/19/13 22:18, Dave Chinner wrote:
> >On Fri, Jul 19, 2013 at 04:11:28PM -0500, Mark Tinguely wrote:
> >>On 07/19/13 07:22, Markus Trippelsdorf wrote:
> >>>
> >>>I've bisected this issue to the following commit:
> >>>
> >>>  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
> >>>  Author: Dave Chinner<dchinner@redhat.com>
> >>>  Date:   Thu Jun 27 16:04:49 2013 +1000
> >>>
> >>>      xfs: don't do IO when creating an new inode
> >>>
> >>>Reverting this commit on top of the Linus tree "solves" all problems for
> >>>me. IOW I no longer loose my KDE and LibreOffice config files during a
> >>>crash. Log recovery now works fine and xfs_repair shows no issues.
....
> >I've only reproduced the problem *once* with this method - the first
> >time I tried. Then I mkfs'd the filesystem rather than repairing it
> >and I haven't been able to reproduce it since.  So the problem is
> >far more subtle that just copying some files, running sync and
> >crashing the machine - there's some kind of initial or timing
> >condition that we are missing that triggers it...
> >
> >The one interesting thing I noticed was that the generation number
> >in the crash case was non-zero. That's an important piece of
> >information, and:
....
> >That means it has actually been allocated and written to disk at
> >some point in time. That is, inodes allocated by mkfs in the root
> >inode chunk have a generation number of zero. For this to have a
> >non-zero generation number, it means that had to be written after
> >allocation - either before the sync or during log recovery.
> >
> >Unfortunately, without the 'xfs_logprint -t -i<dev>' output from
> >prior to mounting the filesystem which demonstrates te problem, I
> >can't tell if the issue is a recovery problem or something that
> >happened before the crash....
....
> I tried the script today and it did not reproduce the problem. The
> logprint and the mounted filesystem was empty. I will rebuild the
> sources to eliminate some patched kernel versions on that box and
> experiment with the sync and the shooting of the kernel.

No need - I've worked out yesterday how to reproduce it reliably and
what the root cause of the problem is. My 'net connection was down
yesterday, so I wasn't even sure if my emails would get out after
queued them and left for an overnight trip....

Basically, the problem takes two iterations to trigger. Do this:

mkfs.xfs
mount
copy files
umount
mount
remove files
umount.

This gives files in the inode chunk mode = 0 and flushiter = 2. now
run:

mount
copy files
sync
godown (*)
umount

(*) you don't need to crash the box to trip this problem.

And when you run:

mount
ls -l

The output of ls will have missing files.

The problem is log recovery sees the flushiter of the inodes being
allocated as 0 (because that's what the patch that avoids reading
the inodes during create sets it too), but the flushiter of the
inode on disk is 2, and then log recovery says "inode on disk is
more recent than the inode core being recovered, don't do recovery".

And that's all there is to it. di_flushiter is no longer necessary
as we log all inode modifications now, but we left it there because
we thought it was harmless:

        /*
         * bump the flush iteration count, used to detect flushes which
         * postdate a log record during recovery. This is redundant as we now
         * log every change and hence this can't happen. Still, it doesn't hurt.
         */
        ip->i_d.di_flushiter++;

In this case, clearly it does hurt. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
