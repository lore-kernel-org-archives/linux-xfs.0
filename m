Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6RZl9066312 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:27:35 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EZXgcek3370xLMn2 for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:29:38 -0800 (PST)
Date: Fri, 16 Nov 2012 17:29:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_quota: correctly initialise the default path
Message-ID: <20121116062934.GO14281@dastard>
References: <1353028488-24436-1-git-send-email-david@fromorbit.com>
	<50A5BE8C.1050308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A5BE8C.1050308@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Thu, Nov 15, 2012 at 10:18:20PM -0600, Eric Sandeen wrote:
> On 11/15/12 7:14 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we initial xfs_quota, we place lots of information into the
> > fs_table. This includes all the devices/mount points the user has
> > specified as a global command line parameter to report on, as well
> > as all the paths under project quota control.
> > 
> > There is a "current path" pointer (fs_path) maintained by the code
> > that points somewhere into the fs_table. After the table is
> > initialised, fs_path always points to the last entry in the table,
> > and hence has to be re-initialised to point at the desired entry
> > before it can be used properly.
> > 
> > In the case of xfs_quota, if the command passed on the command line
> > is a non-global command, the command is called multiple times, each
> > time after the libxcmd args_command() callback is run. That starts
> > with an index of 0, and until the callback returns zero it will keep
> > passing whatever the last returned value was into the callback.
> > 
> > xfs_quota supplies such a callback, and it's purpose is to iterate
> > over the fs_table setting fs_path to the next mount point in the
> > table. IOWs, non-global quota functions get called once for each
> > mount point specified on the command line. However, it also means
> > that for global functions, the fs_path pointer is not
> > re-initialised and hence if there are project quotas configured the
> > fs_path pointer does not point to a mount point andhence commands
> > may malfunction..
> > 
> > The problem that demonstrated this is the report function. It does
> > it's own fs_table iteration if the command requires it, and so only
> > should be called once to avoid outputting the same information
> > multiple times.  That's what the previous patch fixed by making the
> > command global, but this now has the effect of making commands that
> > need to operate on the device specified on the global command rely
> > on the fs_path variable pointing at that device.
> > 
> > Further, commands executed by the interactive method are always
> > treated as global commands, so the report command never worked as a
> > global command in the presence of a configured project quota setup.
> > 
> > Fix the problem by initialising the fs_path pointer correctly.
> 
> tl;dr ;)  I'm all for detailed commit messages but you lost me there.
> If I were searching for this fix I'd have no idea what behavior this
> commit actually . . . fixes. :)

Which indicates just how twisty the maze is. I'll try o describe the
call chain for you, because the bug is a result of interactions in 4
different files linked indirectly by callbacks.

Let's see:

quota/init.c::    main()
quota/init.c::      init()
		      parse argv/argc
		        add_command("report -p")
libxcmd/paths.c::     fs_table_initialise("/dev/vdb", NULL pquota args)
			inserts devices in fs_table
			  walks /proc/mounts if none
			inserts projects in fs_table
			  walks /etc/projid if none
>>>>>> fs_path >>>>	leaves fs_path pointing at last table entry

libxcmd/command.c::    add_args_command(quota/init.c::init_args_command)
quota/init.c::    main()
libxcmd/command.c:: command_loop()
                      walks CLI commands
		        if (!GLOBAL_CMD) {
				j = 0;
				while (j == arg_command(j))
quota/init.c::					init_args_command()
>>>>>> !GLOBAL fs_path init >>>>>		  fs_path = fs_table[j];
				  command(argv, argc)
			} else {
>>>>>> No fs_path init! >>>>>
				  command(argv, argc)
quota/report.c::		    report_f()
				      parse command
				      choose report type
quota/report.c::		      report_any_type()
					walks fstable
>>>>>> match fails >>>>>>		 finds specific fs_path match or
					 (-a) dumps the entire fs_table
libxcmd/command.c:: 			fs_cursor_initialise()
libxcmd/command.c:: 			mnt = fs_cursor_next_entry()
					if (user)
quota/report.c::		          report_user_mount()
					if (group)
quota/report.c::		          report_group_mount()
					if (project)
quota/report.c::		          report_project_mount()


> Can you say:
> 
> a) what the "previous patch" commit was, and

Hasn't been committed yet, so I can't put a commit in the
description.

> b) what commandline triggers this problem, and what the result is?

The simplest demonstration is this:

Old behaviour:

# xfs_quota -x -D /tmp/6345.projects -P /tmp/6345.projid -c path /mnt/scratch
      Filesystem          Pathname
 000  /mnt/scratch        /dev/vdb (pquota)
[001] /mnt/scratch        /dev/vdb (project 1, scrach)

Which leaves fs_path pointing at the project quota path, not the
mount point.

Patched behaviour:

$ sudo ~/xfs_quota -x -D /tmp/6345.projects -P /tmp/6345.projid -c path /mnt/scratch
      Filesystem          Pathname
[000] /mnt/scratch        /dev/vdb (pquota)
 001  /mnt/scratch        /dev/vdb (project 1, scrach)

Which points the fs_path back at the mount point. The current dev
tree xfs_quota code behaves like this:

# xfs_quota -x -c "report -p" /dev/vdb
Project quota on /mnt/scratch (/dev/vdb)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                4          0          0     00 [--------]
scrach            540        100        500     00 [--none--]

# xfs_quota -x /dev/vdb
xfs_quota> report -p

xfs_quota>

Which shows that it is broken for interactive behaviour.

After the GLOBAL_CMD fix for the report command, the CLI is also
broken:

# xfs_quota -x -c "report -p" /dev/vdb

#

After this fix:

# xfs_quota -x -c "report -p" /dev/vdb
Project quota on /mnt/scratch (/dev/vdb)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                4          0          0     00 [--------]
scrach            540        100        500     00 [--none--]

# xfs_quota -x /dev/vdb
xfs_quota> report -p
Project quota on /mnt/scratch (/dev/vdb)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                4          0          0     00 [--------]
scrach            540        100        500     00 [--none--]

xfs_quota>

It all works again. And, well, I figured that was all too much to
put in a commit message...

> Sorry if I'm dense,

Not at all, it's convoluted code because it is generic enough to be
used by multiple tools, and until you understand the general
structure of it you will hurt your brian looking at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
