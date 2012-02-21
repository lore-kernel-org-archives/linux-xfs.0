Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1LHdOlO201702 for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 11:39:25 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id jv03yYFXdtrtIFdT
	for <xfs@oss.sgi.com>; Tue, 21 Feb 2012 09:39:23 -0800 (PST)
Message-ID: <4F43D6CB.3010508@hardwarefreak.com>
Date: Tue, 21 Feb 2012 11:39:23 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
In-Reply-To: <4F4387A7.2070009@gmail.com>
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
To: kadafax@gmail.com
Cc: xfs@oss.sgi.com

On 2/21/2012 6:01 AM, kfx wrote:

> After a crash, a lot of files on a xfs file system report an empty size
> with "ls -a" but not with "du".
> xfs_check and xfs_repair don't report any problem to repair (although an
> internal log is used) :(
> So if I understand correctly, those empty files actually use space on
> the disk but are incorrectly reported as empty by the system.
> Is there a way to copy back the used blocks to recover the files ?

What was the nature of the crash?  Kernel panic?  Power failure?  Other?

Do you have have backups of previously existing files that are now shown
as zero size?  If so delete and restore, maybe just overwrite.

For new files that were in the process of being created you're simply
out of luck.  The metadata may have hit the journal but the file data in
buffer cache was lost.

In memory write buffering/ordering techniques are what give modern
filesystems their write throughput performance.  Unfortunately this
comes at a cost, when systems crash.  As Peter mentioned, one way to
mitigate this is coding apps to sync their writes.  This obviously has a
performance impact.  Another is possibly to mount filesystems with the
sync option, which will obviously severely impact write performance.
Both will prevent or at least lessen the carnage you've seen as a result
of this crash.  You may not be able to live the performance of the
latter, though.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
