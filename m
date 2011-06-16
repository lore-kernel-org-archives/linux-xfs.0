Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5G5oKol003087 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 00:50:21 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D674FDBBFF7
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 22:50:18 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id Tfz820wuZbShsFOa
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 22:50:18 -0700 (PDT)
Message-ID: <4DF9999B.7000209@hardwarefreak.com>
Date: Thu, 16 Jun 2011 00:50:19 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: md 3.2.1 and xfs kernel panic on Linux 2.6.38
References: <BANLkTimCyX=fBuXfuYx30X7M-ninCULq4Q@mail.gmail.com>
	<20110616115531.298328f2@notabene.brown>
In-Reply-To: <20110616115531.298328f2@notabene.brown>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: NeilBrown <neilb@suse.de>
Cc: "fibreraid@gmail.com" <fibreraid@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 6/15/2011 8:55 PM, NeilBrown wrote:
> On Sun, 12 Jun 2011 11:50:01 -0700 "fibreraid@gmail.com"
> <fibreraid@gmail.com> wrote:
> =

>> Hi All,

Hi guys.

I was racking my brain trying to figure out why this thread wasn't
hitting the XFS list, and finally figured it out.  Palm to forehead.

It's 'xfs@oss.sgi.com' not 'linux-xfs@vger.kernel.org'

>> I am benchmarking md RAID with XFS on a server running Linux 2.6.38
>> kernel. The server has 24 x HDD's, dual 2.4GHz 6-core CPUs, and 24GB
>> RAM.

What HBA(s)/RAID card(s)?  BBWC enabled?

>> I created an md0 array using RAID 5, 64k chunk, 23 active drives, and
>> 1 hot-spare. I then created a LVM2 volume group from this md0, and
>> created an LV out of it. The volume was formatted XFS as follows:
>>
>> /sbin/mkfs.xfs =96f =96l lazy-count=3D1 -l size=3D128m -s size=3D4096
>> /dev/mapper/pool1-vol1

With 22 stripe spindles you should have at least specified '-d sw=3D22' in
mkfs.xfs.  This would give better performance, though it should have
nothing to do with the panic.

>> I then mounted it as follows:
>>
>> /dev/mapper/pool1-vol1 on /volumes/pool1/vol1 type xfs
>> (rw,_netdev,noatime,nodiratime,osyncisdsync,nobarrier,logbufs=3D8,delayl=
og)

I'm wondering if specifying nobarrier might have something to do with
the OP's issue.  Does the system panic when using only

defaults,delaylog

>> Once md synchronization was complete, I removed one of the active 23
>> drives. After attempting some IO, the md0 array began to rebuild to
>> the hot-spare. In a few hours, it was complete and the md0 array was
>> listed as active and healthy again (though now lacking a hot-spare
>> obviously).
>>
>> As a test, I removed one more drive to see what would happen. As
>> expected, mdadm reported the array as active but degraded, and since
>> there was no hot-spare available, there was no rebuilding happening.
>>
> ....
>>
>> What surprised me though is that I was no longer able to run IO on the
>> md0 device. As a test, I am using fio to generate IO to the XFS
>> mountpoint /volumes/pool1/vol1. However, IO failed. A few minutes
>> later, I received the following kernel dumps in /var/log/messages. Any
>> ideas?

What happens when you test with something other than FIO?  How about
simply touching a file or creating a directory?

>>
>>
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936575] fio             D
>> ffff88060c6e1a50     0 30463      1 0x00000000
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936578]  ffff880609887778
>> 0000000000000086 0000000000000001 0000000000000086
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936581]  0000000000011e40
>> ffff88060c6e16c0 ffff88060c6e1a50 ffff880609887fd8
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936583]  ffff88060c6e1a58
>> 0000000000011e40 ffff880609886010 0000000000011e40
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936586] Call Trace:
>> Jun 12 11:33:54 TESTBA16 kernel: [59435.936594]  [<ffffffffa025e698>]
>> make_request+0x138/0x3d0 [raid456]
> =

>>
>> The errors seem to be a combination of XFS and md related messages.
>> Any insight into this issue would be greatly appreciated. Thanks!
>>
> =

> Very peculiar!
> =

> It appears that make_request in raid5.c is entering schedule() in an
> uninterruptible wait.
> There are 4 places where make_request calls schedule.
> 2 can only happen if the  array is being reshaped (e.2. 5 drives to 6 dri=
ves)
> but that does not appear to be happening.
> 1 causes and interruptible wait, so it cannot be that one.
> =

> That just leaves the one on line 4105.
> This requires either than the stripe is being reshaped (which we already
> decided isn't happening) or that md/raid5 has received overlapping reques=
ts.
> =

> i.e. while one request (either read or write) was pending, another request
> (either read or write, not necessarily the same) arrives for a range of
> sectors which over-laps the previous request.
> =

> When this happens (which it shouldn't because it would be dumb for a
> filesystem to do that, but you never know) md/raid5 will wait for the fir=
st
> request to be completely handled before letting the second proceed.
> So we should be waiting here for at most a small fraction of a second.
> Clearly we are waiting longer than that...

With nobarrier set, I'm wondering if XFS is issuing overlapping writes
to the same sector on the log device.  Maybe the drives aren't
responding quickly enough, causing the excess wait.

> So this cannot possibly happen (as is so often the case when debugging :-)
> =

> Hmmm... maybe we are missing the wakeup call.  I can find where we wake-up
> anyone waiting for an overlapping read request to complete, but I cannot =
find
> where we wake-up someone waiting for when an overlapping write request
> completes.  That should probably go in handle_stripe_clean_event.

I'm beginning to think this is a case of non enterprise drives (no TLER,
etc) being used with a cache less HBA and without write barriers.  This
would definitely be a recipe for disaster from a data loss standpoint,
though I'm not sure it should cause a kernel panic.

> Do you have the system still hanging in this state?  If not, can you get =
it
> back into this state easily?
> If so, you can force a wakeup with the magic incantation:
> =

>  cat /sys/block/mdXX/md/suspend_lo > /sys/block/mdXX/md/suspend_lo
> =

> (with 'XX' suitably substituted).
> =

> If that makes a difference, then I know I am on the right track

Is there any downside to introducing such a wake-up for writers?

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
