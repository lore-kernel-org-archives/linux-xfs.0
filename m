Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 410387F6D
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 10:22:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADDE2AC002
	for <xfs@oss.sgi.com>; Tue, 27 Jan 2015 08:22:42 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YiwBq687MBHyrTL7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Jan 2015 08:22:37 -0800 (PST)
Message-ID: <54C7BB78.4060203@oracle.com>
Date: Tue, 27 Jan 2015 19:23:20 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: Re: maxpct option for small xfs filesystems
References: <54C667F3.8040303@oracle.com> <20150126223715.GA7621@dastard>
In-Reply-To: <20150126223715.GA7621@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On 01/27/2015 01:37 AM, Dave Chinner wrote:
> On Mon, Jan 26, 2015 at 07:14:43PM +0300, Alexander Tsvetkov wrote:
>> Hello,
>>
>> I'm trying to understand the expected behaviour of "maxpct" option
>> in case of small xfs filesystem
>> comparing the maximum percentage defined for this option with the
>> percentage of actually allocated
>> inodes in filesystem, but the result of prepared test case doesn't
>> correspond to the expectations:
>>
>> [root@fedora ~]#mkfs.xfs -f -d size=16m -i maxpct=1 /dev/sdb2
> On 3.19-rc5, immediately after mount:
>
> # df -i /mnt/scratch
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/ram1         640     3   637    1% /mnt/scratch
>
> Which indicates that imaxpct=1 is being calculated correctly, before
> we even look at whether it is being enforced correctly or not.
>
> So, what kernel version?
>
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
I use Fedora20 on vbox virtual machine with latest kernel version available
from fedora repos: 3.17.8-200.fc20.x86_64 and xfsprogs-3.2.1-1.fc20.x86_64.

/dev/sdb test storage is of VDI format, fixed size:
[root@fedora ~]# fdisk -l

Disk /dev/sda: 10.3 GiB, 11005845504 bytes, 21495792 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000011de

Device    Boot     Start       End  Blocks  Id System
/dev/sda1 *         2048   1026047  512000  83 Linux
/dev/sda2        1026048  20469759 9721856  83 Linux
/dev/sda3       20469760  21493759  512000  82 Linux swap / Solaris


Disk /dev/sdb: 8 GiB, 8589934592 bytes, 16777216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00006ee7

Device    Boot     Start       End  Blocks  Id System
/dev/sdb1           2048   8390655 4194304  83 Linux
/dev/sdb2        8390656  16777215 4193280  83 Linux


>> [root@fedora ~]# for i in {0..100000}; do str=$(mktemp
>> --tmpdir=/mnt/scratch tmp.XXXXXXXXXX); echo $str; done
> Which is a complex (and very slow!) way of doing:
>
> # for i in {0..100000}; do echo > /mnt/scratch/$i ; done 2> /dev/null
>
>> filesystem is full with created files:
>>
>> [root@fedora ~]# df -Th | grep scratch
>> /dev/sdb2      xfs        13M   13M  148K  99% /mnt/scratch
> # df -Th /mnt/scratch
> Filesystem     Type  Size  Used Avail Use% Mounted on
> /dev/ram1      xfs    13M  1.1M   12M   9% /mnt/scratch
> # df -i /mnt/scratch
> Filesystem     Inodes IUsed IFree IUse% Mounted on
> /dev/ram1         640   640     0  100% /mnt/scratch
>
>> and from the number of actually created inodes:
>>
>> [root@fedora ~]# xfs_db -c "blockget -n" -c "ncheck" /dev/sdb2 | wc -l
>> 40512
> That's a directory structure entry count, equivalent to 'find
> /mnt/scratch | wc -l', not an allocated inode count which is what
> 'df -i' reports.
manual page for xfs_db ncheck says about inode numbers not a
directory entry numbers:

"ncheck [-s] [-i ino] Print name-inode pairs"

> Even so, on 3.19-rc5:
>
> # xfs_db -c "blockget -n" -c "ncheck" /dev/ram1 | wc -l
> 637
>
> which matches what 'df -i' tells us about allocated inodes and hence
> imaxpct is working as expected.
I have not the same results,  just installed 3.19-rc6 and repeated the test,
df -i reports 640 inodes for filesystem, but actually created 40512 files:

[root@fedora ~]# mkfs.xfs -f -d size=16m -i maxpct=1 /dev/sdb2
meta-data=/dev/sdb2              isize=256    agcount=1, agsize=4096 blks
          =                       sectsz=512   attr=2, projid32bit=1
          =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=4096, imaxpct=1
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=853, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@fedora ~]# mount /dev/sdb2 /mnt/scratch/
fill with files until enospc...
[root@fedora ~]# df -i /mnt/scratch/
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sdb2         640   640     0  100% /mnt/scratch
[root@fedora ~]# df -Th /mnt/scratch/
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/sdb2      xfs    13M   13M  156K  99% /mnt/scratch
[root@fedora ~]# umount /mnt/scratch
[root@fedora ~]# xfs_db -c "blockget -n" -c "ncheck" /dev/sdb2 | wc -l
40512

Looking into ncheck output there are 40512 pairs reported in the output 
each with own unique
inode number. ncheck doesn't report inodes count by definition, but what 
does these
40512 reported inode numbers mean if only actually 640 inodes were 
allocated? From another hand
each new file should have associated meta-data in the corresponding 
allocated inode structure, so for
40512 newly created files I expect the same count of allocated inodes, 
is it correct?

> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
