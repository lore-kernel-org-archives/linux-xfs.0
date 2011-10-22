Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9MLX6lD184887 for <xfs@oss.sgi.com>; Sat, 22 Oct 2011 16:33:07 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45738161A269
	for <xfs@oss.sgi.com>; Sat, 22 Oct 2011 14:33:04 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id UT5C3tXqPxyOwNmN for <xfs@oss.sgi.com>;
	Sat, 22 Oct 2011 14:33:04 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Sat, 22 Oct 2011 23:35:29 +0200
References: <4E1C70AD.1010101@u-club.de> <201109260010.50649.rjw@sisk.pl>
	<4EA2DDD3.8080306@u-club.de>
In-Reply-To: <4EA2DDD3.8080306@u-club.de>
MIME-Version: 1.0
Message-Id: <201110222335.29573.rjw@sisk.pl>
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
To: Christoph <cr2005@u-club.de>, Takashi Iwai <tiwai@suse.de>
Cc: Theodore Ts'o <tytso@mit.edu>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Saturday, October 22, 2011, Christoph wrote:
> > PM / Freezer: Freeze filesystems while freezing processes (v2)
> > 
> > On Sunday, August 07, 2011, Dave Chinner wrote:
> >> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>> 
> >>> Freeze all filesystems during the freezing of tasks by calling 
> >>> freeze_bdev() for each of them and thaw them during the thawing of
> >>> tasks with the help of thaw_bdev().
> >>> 
> >>> This is needed by hibernation, because some filesystems (e.g. XFS) 
> >>> deadlock with the preallocation of memory used by it if the memory 
> >>> pressure caused by it is too heavy.
> >>> 
> ...
> > 
> > Below is an alternative fix, the changelog pretty much explains the
> > idea.
> > 
> > I've tested it on Toshiba Portege R500, but I don't have an XFS
> > partition to verify that it really helps, so I'd appreciate it if
> > someone able to reproduce the original issue could test it and report
> > back.
> 
> Hi Rafael!
> 
> Well, the kernel bugtracker is still down and I just like to post my
> experience with kernel (x64) v3.1-rc8/9 + patches. My machine is a
> MacBookPro, doomed with 4GB RAM running debian.
> 
> Bug #1
> 
> on the way to hibernate, machine hangs on
> 
> "PM: Preallocating image memory..."
> 
> this patch worked for me now for weeks:
> "[PATCH] PM / Freezer: Freeze filesystems while freezing processes (v2)"
> https://lkml.org/lkml/2011/9/24/77

This patch is going to be merged into 3.2.

> I was able to reproduce this bug with virtualbox and tested the patch ~40
> cycles.
> 
> Bug#2
> 
> on resume from hibernate, hard reset (x64 only):
> http://marc.info/?l=linux-kernel&m=131653513414314&w=2
> 
> With this patch I haven't got this issue again the last weeks.

Hmm.  This issue appears to be still under investigation to me, but perhaps
that's taken too much already.

Takashi, perhaps you can repost the patch as a proper submission?  It would
be good to have this regression fixed even if we don't know the real source of
it.

> I wasn't able to reproduce this bug with virtualbox.
> 
> 
> 
> 
> 
> I only got one pm-hibernate issue. Last line:
> 
> Disabling non-boot CPUs ...
> 
> This time I've enabled debug hung task :)
> 
> schedule_timeout
> ...
> workqueue_cpu_callback
> notifier_call_chain
> ...
> __cpu_notify
> _cpu_down
> printk
> disable_nonboot_cpus
> hibernation_snapshot
> hibernate
> ...
> 
> Any other idea besides the possibility it's caused by evil earth
> radiation, isn't it?

I'm not exactly sure what happened from your description, care to explain?

Rafael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
