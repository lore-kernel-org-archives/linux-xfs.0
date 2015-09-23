Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685427F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 17:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A1AA304048
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 15:35:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7RDZo7ZHyz6PGJN8 for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 15:35:09 -0700 (PDT)
Date: Thu, 24 Sep 2015 08:25:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, bad generic tests 009 and 308
Message-ID: <20150923222515.GQ19114@dastard>
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
	<56014C62.1070403@nomovok.com> <20150922212740.GJ19114@dastard>
	<56026DB0.8070104@nomovok.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56026DB0.8070104@nomovok.com>
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
To: Angelo Dureghello <angelo.dureghello@nomovok.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 11:15:28AM +0200, Angelo Dureghello wrote:
> Hi Dave,
> 
> many thanks.
> 
> On 22/09/2015 23:27, Dave Chinner wrote:
> >Urk, the command should be "fsync", not "sync". Regardless, the
> >last bmap/fiemap pair shows something interesting:
> >
> >bmap-vp:
> >
> >>/media/p6/testfile:
> >>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> >>    0: [0..127]:        96..223           0 (96..223)          128 00000
> >>    1: [128..2047]:     hole                                  1920
> >>    2: [2048..2559]:    2144..2655        0 (2144..2655)       512 10000
> >fiemap -v:
....
> >and so should look the same as the fiemap output. Can you run this
> >test again, this time with s/sync/fsync so the files are clean when

Ok, so a preceding fsync results in bmap displaying all data ranges
being written. Hmmm - I'll need to look into that, it's likely not
a problem but just a longstanding bmap wart that fiemap doesn't have...

> >Next, can you compile your kernel with CONFIG_XFS_DEBUG=y and rerun
> >the tests? Does anything interesting appear in dmesg during the test
> >run?

Nothing in dmesg?

> >Not actually useful - I need to know what is happening inside the
> >unlinkat() call.  I'm going to need a trace-cmd event dump of that
> >xfs_io command and the subsequent rm (at least for the first couple
> >of seconds of the rm). Please put the output file from the trace-cmd
> >record command on a tmpfs filesystem so it doesn't pollute the xfs
> >event trace ;)
> >
> I set some traces inside fs/namei.c  do_unlinkat()
> 
> root[243] vpc24 (master) /home/angelo/xfstests
> # ./start_xfs_test.sh
> QA output created by 308
> [  144.822616] XFS (mmcblk0p5): Mounting V4 Filesystem
> [  145.074537] XFS (mmcblk0p5): Starting recovery (logdev: internal)
> [  145.107298] XFS (mmcblk0p5): Ending recovery (logdev: internal)
> Silence is golden
> [  145.413606] do_unlinkat(): entering
> [  145.417124] do_unlinkat(): retry
> [  145.421156] do_unlinkat(): retry_delegate
> [  145.425920] do_unlinkat(): vfs_unlink returns 0
> [  145.430950] do_unlinkat(): exit2

I think you'll find it's the deferred __fput() run from
task_work_run() that does all the work of freeing the extents in
the file. task_work_run() is executed before the process returns
to userspace....

> At least that function "seems" to complete, but, as from my previous
> message
> looks like strace was not showing nothig over it.
> 
> I captured about 10 seconds of events after the "hang" on 308. Hope
> they are
> enough.

I need to see the events that lead up to the hang, so you need to
start tracing before you run the test script, then stop tracing once
the hang has occurred. If the trace doesn't have events from the
processes the test runs, then you haven't captured the right
events...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
