Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E08A7F58
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 22:33:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE7388F8054
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:33:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	e2tt3AUnHdBBitGS for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 20:33:35 -0700 (PDT)
Date: Wed, 10 Sep 2014 13:33:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Corrupted files
Message-ID: <20140910033331.GA27048@dastard>
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net> <20140910015331.GJ20518@dastard>
	<540FC135.8010601@mygrande.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540FC135.8010601@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 09, 2014 at 10:10:45PM -0500, Leslie Rhorer wrote:
> On 9/9/2014 8:53 PM, Dave Chinner wrote:
> >On Tue, Sep 09, 2014 at 08:12:38PM -0500, Leslie Rhorer wrote:
> >>On 9/9/2014 5:06 PM, Dave Chinner wrote:
> >>>Fristly, more infomration is required, namely versions and actual
> >>>error messages:
> >>
> >>	Indubitably:
> >>
> >>RAID-Server:/# xfs_repair -V
> >>xfs_repair version 3.1.7
> >>RAID-Server:/# uname -r
> >>3.2.0-4-amd64
> >
> >Ok, so a relatively old xfs_repair. That's important - read on....
> 
> 	OK, a good reason is a good reason.
> 
> >>4.0 GHz FX-8350 eight core processor
> >>
> >>RAID-Server:/# cat /proc/meminfo /proc/mounts /proc/partitions
> >>MemTotal:        8099916 kB
> >....
> >>/dev/md0 /RAID xfs
> >>rw,relatime,attr2,delaylog,sunit=2048,swidth=12288,noquota 0 0
> >
> >FWIW, you don't need sunit=2048,swidth=12288 in the mount options -
> >they are stored on disk and the mount options are only necessray to
> >change the on-disk values.
> 
> 	They aren't.  Those were created automatically, weather at creation
> time or at mount time, I don't know, but the filesystem was created
> with

Ah, my mistake. Normally it's only mount options in that code - I
forgot that we report sunit/swidth unconditionally if it is set in
the superblock.

> >>	I'm not sure what is meant by "write cache status" in this context.
> >>The machine has been rebooted more than once during recovery and the
> >>FS has been umounted and xfs_repair run several times.
> >
> >Start here and read the next few entries:
> >
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F
> 
> 	I knew that, but I still don't see the relevance in this context.
> There is no battery backup on the drive controller or the drives,
> and the drives have all been powered down and back up several times.
> Anything in any cache right now would be from some operation in the
> last few minutes, not four days ago.

There is no direct relevance to your situation, but for a lot of
other common problems it definitely is. That's why we ask people to
report it with all the other information about their system

> >>	I don't know for what the acronym BBWC stands.
> >
> >"battery backed write cache". If you're not using a hardware RAID
> >controller, it's unlikely you have one.
> 
> 	See my previous.  I do have one (a 3Ware 9650E, given to me by a
> friend when his company switched to zfs for their server).  It's not
> on this system.  This array is on a HighPoint RocketRAID 2722.

Ok. We have seen over time that those 3ware controllers can do
strange things in error conditions - we've had reports of entire
hardware luns dying and being completely unrecoverable after a
disk was kicked out due to an error. I can't comment on the
highpoint controller - either not many people use them or they just
don't report problems if there do. Either way, I'd suggest that if
you aren't running the latest firmware it would be to update them
as these problems were typically fixed by newer firmware releases.

> >>[192173.364460]  [<ffffffff810fe45a>] ? vfs_fstatat+0x32/0x60
> >>[192173.364471]  [<ffffffff810fe590>] ? sys_newstat+0x12/0x2b
> >>[192173.364483]  [<ffffffff813509f5>] ? page_fault+0x25/0x30
> >>[192173.364495]  [<ffffffff81355452>] ? system_call_fastpath+0x16/0x1b
> >>[192173.364503] XFS (md0): Corruption detected. Unmount and run xfs_repair
> >>
> >>	That last line, by the way, is why I ran umount and xfs_repair.
> >
> >Right, that's the correct thing to do, but sometimes there are
> >issues that repair doesn't handle properly. This *was* one of them,
> >and it was fixed by commit e1f43b4 ("repair: update extent count
> >after zapping duplicate blocks") which was added to xfs_repair
> >v3.1.8.
> >
> >IOWs, upgrading xfsprogs to the latest release and re-running
> >xfs_repair should fix this error.
> 
> 	OK. I'll scarf the source and compile.  All I need is to git clone
> git://oss.sgi.com/xfs/xfs and git://oss.sgi.com/xfs/cmds/xfsprogs,
> right?

Just clone git://oss.sgi.com/xfs/cmds/xfsprogs and check out the
v3.2.1 tag and build that..

> 	I've never used git on a package maintained in my distro.  Will I
> have issues when I upgrade to Debian Jessie in a few months, since
> this is not being managed by apt / dpkg?  It looks like Jessie has
> 3.2.1 of xfs-progs.

If you're using debian you can build debian packages directly from
the git tree via "make deb" (I use it all the time for pushing
new builds to my test machines) and so when you upgrade to Jessie it
should just replace your custom built package correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
