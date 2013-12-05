Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B69A7F3F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 02:11:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB6B4AC005
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 00:10:56 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TbJFjRlkqPksvHpl
	for <xfs@oss.sgi.com>; Thu, 05 Dec 2013 00:10:55 -0800 (PST)
Message-ID: <52A03513.6030408@hardwarefreak.com>
Date: Thu, 05 Dec 2013 02:10:59 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Sudden File System Corruption
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
In-Reply-To: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Dacre <mike.dacre@gmail.com>, xfs@oss.sgi.com

On 12/4/2013 8:55 PM, Mike Dacre wrote:
...
> I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an XFS.

It's a 9260-4i, not a 9240, a huge difference.  I went digging through
your dmesg output because I knew the 9240 doesn't support RAID6.  A few
questions.  What is the LSI RAID configuration?

1.  Level -- confirm RAID6
2.  Strip size?  (eg 512KB)
3.  Stripe size? (eg 7168KB, 14*256)
4.  BBU module?
5.  Is write cache enabled?

What is the XFS geometry?

5.  xfs_info /dev/sda

A combination of these these being wrong could very well be part of your
problems.

...
> IO errors when any requests were made.  This happened while it was being

I didn't see any IO errors in your dmesg output.  None.

> accessed by  5 different users, one was doing a very large rm operation (rm
> *sh on thousands on files in a directory).  Also, about 30 minutes before
> we had connected the globus connect endpoint to allow easy file transfers
> to SDSC.

With delaylog enabled, which I believe it is in RHEL/CentOS 6, a single
big rm shouldn't kill the disks.  But with the combination of other
workloads it seems you may have been seeking the disks to death.

...
> In the end, I successfully repaired the filesystem with `xfs_repair -L
> /dev/sda1`.  However, I am nervous that some files may have been corrupted.

I'm sure your users will let you know.  I'd definitely have a look in
the directory that was targeted by the big rm operation which apparently
didn't finish when XFS shutdown.

> Do any of you have any idea what could have caused this problem?

Yes.  A few things.  The first is this, and it's a big one:

Dec  4 18:15:28 fruster kernel: io scheduler noop registered
Dec  4 18:15:28 fruster kernel: io scheduler anticipatory registered
Dec  4 18:15:28 fruster kernel: io scheduler deadline registered
Dec  4 18:15:28 fruster kernel: io scheduler cfq registered (default)

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

"As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much
of the parallelization in XFS."

*Never* use the CFQ elevator with XFS, and never with a high performance
storage system.  In fact, IMHO, never use CFQ period.  It was horrible
even before 3.2.12.  It is certain that CFQ is playing a big part in
your 120s timeouts, though it may not be solely responsible for your IO
bottleneck.  Switch to deadline or noop immediately, deadline if LSI
write cache is disabled, noop if it is enabled.  Execute this manually
now, and add it to a startup script and verify it is being set at
startup, as it's not permanent:

echo deadline > /sys/block/sda/queue/scheduler

This one simple command line may help pretty dramatically, immediately,
assuming your hardware array parameters aren't horribly wrong for your
workloads, and your XFS alignment correctly matches the hardware geometry.

-- 
Stan





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
