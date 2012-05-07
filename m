Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q476dIQp210166 for <xfs@oss.sgi.com>; Mon, 7 May 2012 01:39:18 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id niQHLFTaKFhCAtBI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 23:39:15 -0700 (PDT)
Message-ID: <4FA76E11.1070708@profihost.ag>
Date: Mon, 07 May 2012 08:39:13 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
In-Reply-To: <20120507013456.GW5091@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

after deleting 400GB it was faster. Now there are still 300GB free but
it is slow as hell again ;-(

Am 07.05.2012 03:34, schrieb Dave Chinner:
> On Sun, May 06, 2012 at 11:01:14AM +0200, Stefan Priebe wrote:
>> Hi,
>>
>> since a few days i've experienced a really slow fs on one of our
>> backup systems.
>>
>> I'm not sure whether this is XFS related or related to the
>> Controller / Disks.
>>
>> It is a raid 10 of 20 SATA Disks and i can only write to them with
>> about 700kb/s while doing random i/o.
> 
> What sort of random IO? size, read, write, direct or buffered, data
> or metadata, etc?
There are 4 rsync processes running and doing backups of other severs.

> iostat -x -d -m 5 and vmstat 5 traces would be
> useful to see if it is your array that is slow.....

~ # iostat -x -d -m 5
Linux 2.6.40.28intel (server844-han)    05/07/2012      _x86_64_
(8 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0,00     0,00  254,80   25,40     1,72     0,16
13,71     0,86    3,08   2,39  67,06
sda               0,00     0,20    0,00    1,20     0,00     0,00
6,50     0,00    0,00   0,00   0,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0,00     0,00  187,40   24,20     1,26     0,19
14,05     0,75    3,56   3,33  70,50
sda               0,00     0,00    0,00    0,40     0,00     0,00
4,50     0,00    0,00   0,00   0,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0,00    11,20  242,40   92,00     1,56     0,89
15,00     4,70   14,06   1,58  52,68
sda               0,00     0,20    0,00    2,60     0,00     0,02
12,00     0,00    0,00   0,00   0,00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0,00     0,00  166,20   24,00     0,99     0,17
12,51     0,57    3,02   2,40  45,56
sda               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00   0,00

qDevice:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb               0,00     0,00  188,00   25,40     1,22     0,16
13,23     0,44    2,04   1,78  38,02
sda               0,00     0,00    0,00    0,00     0,00     0,00
0,00     0,00    0,00   0,00   0,00


# vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 7  0      0 788632     48 12189652    0    0   173   395   13   45  1
16 82  1
[root@server844-han /serverbackup (master)]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 4  0      0 778148     48 12189776    0    0   173   395   13   45  1
16 82  1
[root@server844-han /serverbackup (master)]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 2  0      0 774372     48 12189876    0    0   173   395   13   45  1
16 82  1
[root@server844-han /serverbackup (master)]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 5  0      0 771240     48 12189936    0    0   173   395   13   45  1
16 82  1
[root@server844-han /serverbackup (master)]# vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 6  0      0 768636     48 12190000    0    0   173   395   13   45  1
16 82  1

> 
>> I tried vanilla Kernel 3.0.30
>> and 3.3.4 - no difference. Writing to another partition on another
>> xfs array works fine.
>>
>> Details:
>> #~ df -h
>> /dev/sdb1             4,6T  4,4T  207G  96% /mnt
> 
> Your filesystem is near full - the allocation algorithms definitely
> slow down as you approach ENOSPC, and IO efficiency goes to hell
> because of a lack of contiguous free space to allocate from.
I've now 94% used but it is still slow. It seems it was just getting
fast with more than 450GB free space.

/dev/sdb1             4,6T  4,3T  310G  94% /mnt

>> #~ df -i
>> /dev/sdb1            4875737052 4659318044 216419008  96% /mnt
> You have 4.6 *billion* inodes in your filesystem?
Yes - it backups around 100 servers with a lot of files.

Greet Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
