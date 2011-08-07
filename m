Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p771gt7s201865 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 20:42:56 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D975553441C
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 18:42:41 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id un9cMDtnbzaduf3E for
	<xfs@oss.sgi.com>; Sat, 06 Aug 2011 18:42:41 -0700 (PDT)
Date: Sun, 7 Aug 2011 03:42:38 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Message-ID: <20110807014237.GA18909@schmorp.de>
References: <20110806122556.GB20341@schmorp.de> <20110806142005.GG3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110806142005.GG3162@dastard>
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
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2011 at 12:20:05AM +1000, Dave Chinner <david@fromorbit.com> wrote:
> > The backtraces look all very similar:
> > 
> >    http://ue.tst.eu/85b9c9f66e36dda81be46892661c5bd0.txt
> 
> Tainted kernel. Please reproduce without the NVidia binary drivers.

This is just because it is form my desktop system. None of my other
machines have a tainted kernel, but getting backtraces from there is much
harder.

> > all the backtraces crash with a null pointer dereference in xfs_iget, or
> > in xfs_trans_log_inode, and always for process xfs_fsr.
> 
> and when you do, please record an event trace of the
> xfs_swap_extent* trace points while xfs_fsr is running and triggers
> a crash. That will tell me if xfs_fsr is corrupting inodes,

Ah - how do I do that?

> > I haven't seen a crash without xfs_fsr.
> 
> Then don't use xfs_fsr until we know if it is the cause of the
> problem (except to reproduce the problem).

Why so defensive? xfs_fsr is an advertised feature and should just work
(and does so with older kernels).

> And as I always ask - why do you need to run xfs_fsr so often?  Do

Did I say I am running it often? IT typically runs once a day for an hour.

> you really have filesystems that get quickly fragmented (or are you

Yes, fragmentation with xfs is enourmous - I have yet to see whether
the changes in recent kernels make a big difference, but for log files,
reading through a log file with 60000 fragments tends to be much slower
than reading through one with just a few fragments (or just one...).

Freenet and other daemons are also creating enourmous fragmentation.

As such. xfs is much much worse at fragmentation than ext4, but at least
it has xfs_fsr, which at least reduces file fragmentation.

> just running it from a cron-job because having on-line
> defragmentation is what all the cool kids do ;)?

Didn't know that, maybe I should run it more often then... Or maybe not,
now that you tell me I shouldn't because xfs implementation quality is so
much lower than for other filesystems?

> If you are getting fragmentation, what is the workload that is causing
> it?

Basically, anything but the OS itself. Copying large video files while the
disk is busy with other things causes lots of fragmentation (usually 30
fragments for a 100mb file), which in turn slows down things enourmously once
the disk reaches 95% full.

Freenet is also a good test case.

As are logfiles.

Or a news spool.

Or database files for databases that grow files (such as mysql myisam) -
fortunately I could move of all those to SSDs this year.

Or simply unpacking an archive.

Simple example - the www.deliantra.net gameserver writes logs to a logfile
and stdout, which is redirected to another logfile in the same directory
(which gets truncated on each restart).

Today I had to reboot the server because of buggy xfs (which prompted the
bugreport, as I am seeing this bug for a while now, but so far didn't want
to exclude e.g. bad ram or simply a corrupt filesystem), and in the 4
hours uptime, I got a 4MB logfile with 8 fragments.

This is clearly an improvement over the 2.6.26 kernel I used before on
that machine. But over a few months this still leads to thousands of
fragments, and scanning through a few gigabytes of log file that has 60000
fragments on a disk that isn't completely idle is not exactly fast.

The webserver accesslog on that machine which is a file on its own in its
own directory is 15MB big (it was restarted beginning last month) and has
1043 fragments (it doesn't get defragmented by xfs_fsr because it is in
use).

OTOH, that filesystem isn't used much and has 300gb free out of 500, so
it is surprising that I still get so many fragments (the files are only
closed when runing xfs_fsr on them, which is once every few weeks).

Freenet fares much worse. The persistent blob has 1757 fragments for 13gb
(not that bad), and the download database has 22756 for 600mb, fragments
(that sucks).

On my tv, the recorded video files that haven't been defragmented yet
have between 11 and 63 fragments (all smaller than 2gb), which is almost
acceptable, but I do not think that without a regular xfs_fsr the fs would
be in that good shape after one or two years of usage.

The cool thing about xfs_fsr is not that the cool kids run it, but that,
unlike other filesystems that also fragment a lot (ext3 is absolutely
horrible for example), it can mostly be fixed.

Given that xfs is clearly the lowest quality of the common filesystems
on linux (which I mean to be reiserfs, ext2/3/4 - and before you ask,
literally each time I run a file system check xfs_repair crashes or hangs,
and the filesystems have some issues, on all my numerous machines, and
the number of bugs I have hit with xfs is easily twice the amount of
bugs I hit with reiserfs and extX together, and I was an early adopter
of reiserfs, before it even had a fsck), it is important to have some
features left that cancel this general lack of quality.

Right now, these features for me are the very tunable nature of xfs (for
example, 512b block size for news spools), the very fast xfs_repair and
the long-term maintainability of the filesystem - a heavily used ext3
filesystem basically becomes unusable after a year.

Another feature was the very good feedback I got from this list in the
past w.r.t. bugs and fixes (while nowadays I have to listen to "xfs is
optimised for nfs not for your use" or "then don't use it" replies to bug
reports).

All that and the fact that I haven't lost a single important file and the
steady improvements to performance in XFS make xfs currently my filesystem
of choice, especially for heavy-duty applications.

PS: I run xfs on a total of about 40TB of filesystems at the moment.

PPS: sorry for being so forcefully truthful about xfs above, but you
really need an attitude change - don't tell people to not use a feature,
or tell them they probably just want to be cool kids - the implementation
quality of xfs is far from that of reiserfs or ext3 (not sure about ext4
yet, but I do expect e2fsck to not let me down as often as xfs_repair),
there are things to do, and I contribute what little I can by testing xfs
with actual workloads.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
