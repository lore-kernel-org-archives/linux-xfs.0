Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77D3D7F54
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:18:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 152C2AC005
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:18:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mWrOmUOLnlHI6ea6 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 11:18:01 -0700 (PDT)
Message-ID: <55DCB158.20505@sandeen.net>
Date: Tue, 25 Aug 2015 13:18:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant mount xfs lvm. Experimental Features?
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
In-Reply-To: <5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
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
To: weber@zbfmail.de, Xfs <xfs@oss.sgi.com>

On 8/25/15 11:51 AM, Marko Weber|8000 wrote:
> 
> dave,
> 
> Am 2015-08-25 13:54, schrieb Dave Chinner:
>> On Tue, Aug 25, 2015 at 10:25:16AM +0200, Marko Weber|8000 wrote:
>>>
>>> Hello List, Hello Dave...
>>>
>>>
>>> i try to mount on my backup server an Lvm Partition and get errors
>>> in stdout and log:
>>>
>>> /var/log/messages:
>>>
>>> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Version 5
>>> superblock detected. This kernel has EXPERIMENTAL support enabled!
>>> Aug 25 10:20:31 backupserver kernel: Use of these features in this
>>> kernel is at your own risk!
>>> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Superblock has
>>> unknown read-only compatible features (0x1) enabled.
>>> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Attempted to mount
>>> read-only compatible filesystem read-write.
>>> Aug 25 10:20:31 backupserver kernel: Filesystem can only be safely
>>> mounted read only.
>>> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): SB validate failed
>>> with error 22.
>>
>> You need to run the same version kernel on both servers. The primary
>> has a more recent kernel and feature set than your older backup
>> server is running.
>>
>> Cheers,
>>
>> Dave.
> 
> you was right.
> There was new kernel built. /usr/src/linux pointed to new kernel source.
> But machine was not rebooted. So kernel version before kernel built was loaded.
> I rebooted machine.
> i renoved logical volume
> i created logical volume

Hope it landed back in the same place!

> i tried to mount it and get:
> 
> Aug 25 18:43:15 backupserver kernel: md4: unknown partition table
> Aug 25 18:43:15 backupserver syslog-ng[1417]: Internal error, alarm_set() called while an alarm is still active;
> Aug 25 18:43:56 backupserver kernel: md4: unknown partition table
> Aug 25 18:44:01 backupserver kernel: XFS (dm-2): Invalid superblock magic number
> 
> pvdisplay shows:
> 
> # pvdisplay
>   --- Physical volume ---
>   PV Name               /dev/md4
>   VG Name               VolGroup01
>   PV Size               2.69 TiB / not usable 1.25 MiB
> 
> 
> so what is XFS missing?

what does blkid /dev/md4 say?

It looks like you might have a storage problem, now, and xfs can't even find a proper magic number on that device.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
