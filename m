Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E8a68m149719 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 03:36:06 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id TJXR2m73trCCQd5U
	for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 01:36:05 -0700 (PDT)
Message-ID: <4F605877.2030304@hardwarefreak.com>
Date: Wed, 14 Mar 2012 03:36:07 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: How to deal with XFS stripe geometry mismatch with hardware RAID5
References: <33498437.post@talk.nabble.com>
In-Reply-To: <33498437.post@talk.nabble.com>
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
To: troby <Thorn.Roby@harlandfs.com>
Cc: xfs@oss.sgi.com

On 3/13/2012 6:21 PM, troby wrote:

> Short of recreating the filesystem with the correct stripe width, would it
> make sense to change the mount options to define a stripe width that
> actually matches either the filesystem (11 stripe elements wide) or the
> hardware (12 stripe elements wide)? Is there a danger of filesystem
> corruption if I give fstab a mount geometry that doesn't match the values
> used at filesystem creation time?

What would make sense is for you to first show

$ cat /etc/fstab
$ xfs_info /dev/raid_device_name

before we recommend any changes.

> I'm unclear on the role of the RAID hardware cache in this. Since the writes
> are sequential, 

This seems to be an assumption at odds with other information you've
provided.

> and since the volume of data written is such that it would
> take about 3 minutes to actually fill the RAID cache, 

The PERC 700 operates in write-through cache mode if no BBU is present
or the battery is degraded or has failed.  You did not state whether
your PERC 700 has the BBU installed.  If not, you can increase write
performance and decrease latency pretty substantially by adding the BBU
which enables the write-back cache mode.

You may want to check whether MongoDB uses fsync writes by default.  If
it does, and you don't have the BBU and write-back cache, this is
affecting your write latency and throughput as well.

> I would think the data
> would be resident in the cache long enough to assemble a full-width stripe
> at the hardware level and avoid the 4 I/O RAID5 penalty. 

Again, write-back-cache is only enabled with BBU on the PERC 700.  Do
note that achieving full stripe width writes is as much a function of
your application workload and filesystem tuning as it is the RAID
firmware, especially if the cache is in write-through mode, in which
case the firmware can't do much, if anything, to maximize full width
stripes.

And keep in mind you won't hit the parity read-modify-write penalty on
new stripe writes.  This only happens when rewriting existing stripes.
Your reported 50ms of latency for 100KB write IOs seems to suggest you
don't have the BBU installed and you're actually doing RMW on existing
stripes, not strictly new stripe writes.  This is likely because...

As an XFS filesystem gets full (you're at ~87%), file blocks may begin
to be written into free space within existing partially occupied RAID
stripes.  This is where the RAID5/6 RMW penalty really kicks you in the
a$$, especially if you have misaligned the filesystem geometry to the
underlying RAID geometry.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
