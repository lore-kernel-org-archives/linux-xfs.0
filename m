Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8PDUDIA061891 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 08:30:13 -0500
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B3671C3FA5A
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 06:30:10 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com
	with ESMTP id jQ5nENAMxSgGAymN for <xfs@oss.sgi.com>;
	Sun, 25 Sep 2011 06:30:10 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
Date: Sun, 25 Sep 2011 15:32:19 +0200
References: <4E1C70AD.1010101@u-club.de> <201109250056.12545.rjw@sisk.pl>
	<4E7F04B7.4020002@u-club.de>
In-Reply-To: <4E7F04B7.4020002@u-club.de>
MIME-Version: 1.0
Message-Id: <201109251532.20025.rjw@sisk.pl>
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
To: Christoph <cr2005@u-club.de>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

On Sunday, September 25, 2011, Christoph wrote:
> test results of the patch below:
> 
> 1. real machine
> 
> suspends fine but on wakeup, after loading image: hard reset.
> nvidia gpu => disabled compitz  => wakeup worked two times.

Hmm, so there's a separate bug related to NVidia I guess.

> 2. virtualbox / stress test / xfs and ext4
> 
> on 3rd resume, it booted up "normal" like this:
> 
> [    3.351813] Freeing unused kernel memory: 568k freed
> [    3.460973] Freeing unused kernel memory: 284k freed
> 
> [   17.328356] PM: Preparing processes for restore.
> 
> [   17.328357] Freezing user space processes ...
> [   37.345414] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [   37.475244]  ffff88001f06fd68 0000000000000086 0000000000000000
> 0000000000000000
> [   37.526163]  ffff88001f06e010 ffff88001f4c4410 0000000000012ec0
> ffff88001f06ffd8
> [   37.580110]  ffff88001f06ffd8 0000000000012ec0 ffffffff8160d020
> ffff88001f4c4410
> [   37.626167] Call Trace:
> [   37.626769]  [<ffffffff81049944>] schedule+0x55/0x57
> [   37.674925]  [<ffffffff81360dbe>] __mutex_lock_common+0x117/0x178
> [   37.792559]  [<ffffffff81113ef2>] ? user_path_at+0x61/0x90
> [   37.888501]  [<ffffffff81360e35>] __mutex_lock_slowpath+0x16/0x18
> [   37.986966]  [<ffffffff81360efb>] mutex_lock+0x1e/0x32
> [   38.086931]  [<ffffffffa00a4d43>] show_manufacturer+0x23/0x51 [usbcore]
> [   38.212500]  [<ffffffff8125cd44>] dev_attr_show+0x22/0x49
> [   38.282319]  [<ffffffff810c6f8c>] ? __get_free_pages+0x9/0x38
> [   38.397449]  [<ffffffff8115febb>] sysfs_read_file+0xa9/0x12b
> [   38.491607]  [<ffffffff81107ff6>] vfs_read+0xa6/0x102
> [   38.541994]  [<ffffffff81105ebf>] ? do_sys_open+0xee/0x100
> [   38.564907]  [<ffffffff8110810b>] sys_read+0x45/0x6c
> [   38.578397]  [<ffffffff81368412>] system_call_fastpath+0x16/0x1b
> [   38.590083]
> [   38.598046] Restarting tasks ... done.
> [   38.660448] XFS (sda3): Mounting Filesystem
> 
> restarted the test runs, increased delay between awake and sleep from 20
> to 25 sec:
> 
> 36 time successful hibernate+resume so far.

OK, cool.  Thanks for testing!

Rafael


> On 25.09.2011 00:56, Rafael J. Wysocki wrote:
> > On Sunday, August 07, 2011, Dave Chinner wrote:
> >> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
> >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> >>>
> >>> Freeze all filesystems during the freezing of tasks by calling
> >>> freeze_bdev() for each of them and thaw them during the thawing
> >>> of tasks with the help of thaw_bdev().
> >>>
> >>> This is needed by hibernation, because some filesystems (e.g. XFS)
> >>> deadlock with the preallocation of memory used by it if the memory
> >>> pressure caused by it is too heavy.
> >>>
> >>> The additional benefit of this change is that, if something goes
> >>> wrong after filesystems have been frozen, they will stay in a
> >>> consistent state and journal replays won't be necessary (e.g. after
> >>> a failing suspend or resume).  In particular, this should help to
> >>> solve a long-standing issue that in some cases during resume from
> >>> hibernation the boot loader causes the journal to be replied for the
> >>> filesystem containing the kernel image and initrd causing it to
> >>> become inconsistent with the information stored in the hibernation
> >>> image.
> >>>
> >>> This change is based on earlier work by Nigel Cunningham.
> >>>
> >>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>> ---
> > 
> > Below is an alternative fix, the changelog pretty much explains the idea.
> > 
> > I've tested it on Toshiba Portege R500, but I don't have an XFS partition
> > to verify that it really helps, so I'd appreciate it if someone able to
> > reproduce the original issue could test it and report back.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Hibernate: Freeze kernel threads after preallocating memory
> > 
> > There is a problem with the current ordering of hibernate code which
> > leads to deadlocks in some filesystems' memory shrinkers.  Namely,
> > some filesystems use freezable kernel threads that are inactive when
> > the hibernate memory preallocation is carried out.  Those same
> > filesystems use memory shrinkers that may be triggered by the
> > hibernate memory preallocation.  If those memory shrinkers wait for
> > the frozen kernel threads, the hibernate process deadlocks (this
> > happens with XFS, for one example).
> > 
> > Apparently, it is not technically viable to redesign the filesystems
> > in question to avoid the situation described above, so the only
> > possible solution of this issue is to defer the freezing of kernel
> > threads until the hibernate memory preallocation is done, which is
> > implemented by this change.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  include/linux/freezer.h  |    4 +++-
> >  kernel/power/hibernate.c |   12 ++++++++----
> >  kernel/power/power.h     |    3 ++-
> >  kernel/power/process.c   |   30 ++++++++++++++++++++----------
> >  4 files changed, 33 insertions(+), 16 deletions(-)
> > 
> > Index: linux/kernel/power/process.c
> > ===================================================================
> > --- linux.orig/kernel/power/process.c
> > +++ linux/kernel/power/process.c
> > @@ -135,7 +135,7 @@ static int try_to_freeze_tasks(bool sig_
> >  }
> >  
> >  /**
> > - *	freeze_processes - tell processes to enter the refrigerator
> > + * freeze_processes - Signal user space processes to enter the refrigerator.
> >   */
> >  int freeze_processes(void)
> >  {
> > @@ -143,20 +143,30 @@ int freeze_processes(void)
> >  
> >  	printk("Freezing user space processes ... ");
> >  	error = try_to_freeze_tasks(true);
> > -	if (error)
> > -		goto Exit;
> > -	printk("done.\n");
> > +	if (!error) {
> > +		printk("done.");
> > +		oom_killer_disable();
> > +	}
> > +	printk("\n");
> > +	BUG_ON(in_atomic());
> > +
> > +	return error;
> > +}
> > +
> > +/**
> > + * freeze_kernel_threads - Make freezable kernel threads go to the refrigerator.
> > + */
> > +int freeze_kernel_threads(void)
> > +{
> > +	int error;
> >  
> >  	printk("Freezing remaining freezable tasks ... ");
> >  	error = try_to_freeze_tasks(false);
> > -	if (error)
> > -		goto Exit;
> > -	printk("done.");
> > +	if (!error)
> > +		printk("done.");
> >  
> > -	oom_killer_disable();
> > - Exit:
> > -	BUG_ON(in_atomic());
> >  	printk("\n");
> > +	BUG_ON(in_atomic());
> >  
> >  	return error;
> >  }
> > Index: linux/include/linux/freezer.h
> > ===================================================================
> > --- linux.orig/include/linux/freezer.h
> > +++ linux/include/linux/freezer.h
> > @@ -49,6 +49,7 @@ extern int thaw_process(struct task_stru
> >  
> >  extern void refrigerator(void);
> >  extern int freeze_processes(void);
> > +extern int freeze_kernel_threads(void);
> >  extern void thaw_processes(void);
> >  
> >  static inline int try_to_freeze(void)
> > @@ -171,7 +172,8 @@ static inline void clear_freeze_flag(str
> >  static inline int thaw_process(struct task_struct *p) { return 1; }
> >  
> >  static inline void refrigerator(void) {}
> > -static inline int freeze_processes(void) { BUG(); return 0; }
> > +static inline int freeze_processes(void) { return -ENOSYS; }
> > +static inline int freeze_kernel_threads(void) { return -ENOSYS; }
> >  static inline void thaw_processes(void) {}
> >  
> >  static inline int try_to_freeze(void) { return 0; }
> > Index: linux/kernel/power/power.h
> > ===================================================================
> > --- linux.orig/kernel/power/power.h
> > +++ linux/kernel/power/power.h
> > @@ -228,7 +228,8 @@ extern int pm_test_level;
> >  #ifdef CONFIG_SUSPEND_FREEZER
> >  static inline int suspend_freeze_processes(void)
> >  {
> > -	return freeze_processes();
> > +	int error = freeze_processes();
> > +	return error ? : freeze_kernel_threads();
> >  }
> >  
> >  static inline void suspend_thaw_processes(void)
> > Index: linux/kernel/power/hibernate.c
> > ===================================================================
> > --- linux.orig/kernel/power/hibernate.c
> > +++ linux/kernel/power/hibernate.c
> > @@ -334,13 +334,17 @@ int hibernation_snapshot(int platform_mo
> >  	if (error)
> >  		goto Close;
> >  
> > -	error = dpm_prepare(PMSG_FREEZE);
> > -	if (error)
> > -		goto Complete_devices;
> > -
> >  	/* Preallocate image memory before shutting down devices. */
> >  	error = hibernate_preallocate_memory();
> >  	if (error)
> > +		goto Close;
> > +
> > +	error = freeze_kernel_threads();
> > +	if (error)
> > +		goto Close;
> > +
> > +	error = dpm_prepare(PMSG_FREEZE);
> > +	if (error)
> >  		goto Complete_devices;
> >  
> >  	suspend_console();
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
