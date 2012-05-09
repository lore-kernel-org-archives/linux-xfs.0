Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q496v061075796 for <xfs@oss.sgi.com>; Wed, 9 May 2012 01:57:00 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id YJc0Yk2LCsPur4NK
	for <xfs@oss.sgi.com>; Tue, 08 May 2012 23:56:58 -0700 (PDT)
Message-ID: <4FAA153D.1030606@hardwarefreak.com>
Date: Wed, 09 May 2012 01:57:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
In-Reply-To: <4FA82B07.1020102@profihost.ag>
Reply-To: stan@hardwarefreak.com
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 5/7/2012 3:05 PM, Stefan Priebe wrote:
> Am 07.05.2012 18:36, schrieb Stan Hoeppner:

>> Stefan, at this point in your filesystem's aging process, it may not
>> matter how much space you keep freeing up, as your deletion of small
>> files simply adds more heavily fragmented free space to the pool.  It's
>> the nature of your workload causing this.
> This makes sense - do you have any idea or solution for this? Are
> Filesystems, Block layers or something else which suits this problem /
> situation?

The problem isn't the block layer nor the filesystem.  The problem is a
combination of the workload and filling the FS to near capacity.

Any workload that regularly allocates and then deletes large quantities
of small files and fills up the filesystem is going to suffer poor
performance from free space fragmentation as the water in the FS gets
close to the rim of the glass.  Two other example workloads are large
mail spools on very busy internet mail servers, and maildir storage on
IMAP/POP servers.

In your case there are two solutions to this problem, the second of
which is also the solution for these mail workloads:

1.  Use a backup methodology that writes larger files
2.  Give your workload a much larger sandbox to play in

Regarding #1, if you're using rsnapshot your disk space shouldn't be
continuously growing, which is does seem to be.  If you're not using
rsnapshot look into it.

Regarding #2 ...

>> What I would suggest is doing an xfsdump to a filesystem on another LUN
>> or machine, expand the size of this LUN by 50% or more (I gather this is
>> an external RAID), format it appropriately, then xfsrestore.  This will
>> eliminate your current free space fragmentation, and the 50% size
>> increase will delay the next occurrence of this problem.  If you can't
>> expand the LUN, simply do the xfsdump/format/xfsrestore, which will give
>> you contiguous free space.
> But this will only help for a few month or perhaps a year.

So you are saying your backup solution will fill up an additional 2.3TB
in less than a year?  In that case I'd say you have dramatically
undersized your backup storage and/or are not using file compression to
your advantage.  And you're obviously not using archiving to your
advantage or you'd not have the free space fragmentation issue because
you'd be dealing with much larger files.

So the best solution to your current problem, and one that will save you
disk space and thus $$, is to use a backup solution that makes use of
both tar and gzip/bzip2.

You can't fix this fundamental small file free space fragmentation
problem by tuning/tweaking XFS, or switching to another filesystem, as
again, the problem is the workload, not the block layer or FS.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
