Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6O15I4k233220 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 20:05:18 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 463B91623085
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 18:08:19 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id e0J73391lQHudwEa for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 18:08:19 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100724005426.GN32635@dastard>
Date: Fri, 23 Jul 2010 18:08:08 -0700
Message-Id: <F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On Jul 23, 2010, at 5:54 PM, Dave Chinner wrote:

> On Fri, Jul 23, 2010 at 01:30:40AM -0700, Eli Morris wrote:
>> On Jul 12, 2010, at 4:47 AM, Emmanuel Florac wrote:
>> =

>>> Le Sun, 11 Jul 2010 18:10:41 -0700
>>> Eli Morris <ermorris@ucsc.edu> =E9crivait:
>>> =

>>>> Here are some of the log files from my XFS problem. Yes, I think this
>>>> all started with a hardware failure of some sort. My storage is RAID
>>>> 6, a an Astra SecureStor ES.
>>>> =

>>> =

>>> There are IO errors on sdc, sdd and sdg. Aren't these jbods connected
>>> through the same cable, for instance? You must correct the hardware
>>> problems before attempting any repair or it will do more harm than good.
>>> =

>>> -- =

>>> ------------------------------------------------------------------------
>>> Emmanuel Florac     |   Direction technique
>>>                   |   Intellique
>>>                   |	<eflorac@intellique.com>
>>>                   |   +33 1 78 94 84 02
>>> ------------------------------------------------------------------------
>> =

>> Hi Emmanuel,
>> =

>> I think the raid tech support and me found and corrected the
>> hardware problems associated with the RAID. I'm still having the
>> same problem though. I expanded the filesystem to use the space of
>> the now corrected RAID and that seems to work OK. I can write
>> files to the new space OK. But then, if I run xfs_repair on the
>> volume, the newly added space disappears and there are tons of
>> error messages from xfs_repair (listed below).
> =

> Can you post the full output of the xfs_repair? The superblock is
> the first thing that is checked and repaired, so if it is being
> "repaired" to reduce the size of the volume then all the other errors
> are just a result of that. e.g. the grow could be leaving stale
> secndary superblocks around and repair is seeing a primary/secondary
> mismatch and restoring the secondary which has the size parameter
> prior to the grow....
> =

> Also, the output of 'cat /proc/partitions' would be interesting
> from before the grow, after the grow (when everything is working),
> and again after the xfs_repair when everything goes bad....
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com

Hi Dave,

Thanks for replying. Here is the output I think you're looking for....

thanks!

Eli

The problem partition is an LVM2 volume:

/dev/mapper/vg1-vol5



[root@nimbus /]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb2              24G  7.6G   15G  34% /
/dev/sda5             1.7T  1.3T  391G  77% /export
/dev/sda2             3.8G  1.5G  2.2G  40% /var
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sdb1             995G  946G   19G  99% /storage
tmpfs                 7.7G  7.9M  7.7G   1% /var/lib/ganglia/rrds
/dev/mapper/vg1-vol5   51T   51T   90M 100% /export/vol5


[root@nimbus /]# cat /proc/partitions
major minor  #blocks  name

   8     0 1843200000 sda
   8     1    8193118 sda1
   8     2    4096575 sda2
   8     3    1020127 sda3
   8     4          1 sda4
   8     5 1829883793 sda5
   8    16 1084948480 sdb
   8    17 1059342133 sdb1
   8    18   25599577 sdb2
   8    32 13671872256 sdc
   8    33 13671872222 sdc1
   8    48 13668734464 sdd
   8    49 12695309918 sdd1
   8    64 13671872256 sde
   8    65 13671872222 sde1
   8    80 13671872256 sdf
   8    81 13671869225 sdf1
   8    96 12695309952 sdg
   8    97 12695309918 sdg1
 253     0 66406219776 dm-0
 =

[root@nimbus /]# xfs_growfs /dev/mapper/vg1-vol5
meta-data=3D/dev/vg1/vol5          isize=3D256    agcount=3D126, agsize=3D1=
06811488 blks
         =3D                       sectsz=3D512   attr=3D1
data     =3D                       bsize=3D4096   blocks=3D13427728384, ima=
xpct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096  =

log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
[root@nimbus /]# umount /export/vol5
[root@nimbus /]# mount /export/vol5
[root@nimbus /]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb2              24G  7.6G   15G  34% /
/dev/sda5             1.7T  1.3T  391G  77% /export
/dev/sda2             3.8G  1.5G  2.2G  40% /var
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sdb1             995G  946G   19G  99% /storage
tmpfs                 7.7G  7.9M  7.7G   1% /var/lib/ganglia/rrds
/dev/mapper/vg1-vol5   62T   51T   12T  81% /export/vol5

[root@nimbus /]# cat /proc/partitions
major minor  #blocks  name

   8     0 1843200000 sda
   8     1    8193118 sda1
   8     2    4096575 sda2
   8     3    1020127 sda3
   8     4          1 sda4
   8     5 1829883793 sda5
   8    16 1084948480 sdb
   8    17 1059342133 sdb1
   8    18   25599577 sdb2
   8    32 13671872256 sdc
   8    33 13671872222 sdc1
   8    48 13668734464 sdd
   8    49 12695309918 sdd1
   8    64 13671872256 sde
   8    65 13671872222 sde1
   8    80 13671872256 sdf
   8    81 13671869225 sdf1
   8    96 12695309952 sdg
   8    97 12695309918 sdg1
 253     0 66406219776 dm-0

[root@nimbus /]# xfs_repair /dev/mapper/vg1-vol5
Phase 1 - find and verify superblock...
writing modified primary superblock
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
        - agno =3D 32
        - agno =3D 33
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 37
        - agno =3D 38
        - agno =3D 39
        - agno =3D 40
        - agno =3D 41
        - agno =3D 42
        - agno =3D 43
        - agno =3D 44
        - agno =3D 45
        - agno =3D 46
        - agno =3D 47
        - agno =3D 48
        - agno =3D 49
        - agno =3D 50
        - agno =3D 51
        - agno =3D 52
        - agno =3D 53
        - agno =3D 54
        - agno =3D 55
        - agno =3D 56
        - agno =3D 57
        - agno =3D 58
        - agno =3D 59
        - agno =3D 60
        - agno =3D 61
        - agno =3D 62
        - agno =3D 63
        - agno =3D 64
        - agno =3D 65
        - agno =3D 66
        - agno =3D 67
        - agno =3D 68
        - agno =3D 69
        - agno =3D 70
        - agno =3D 71
        - agno =3D 72
        - agno =3D 73
        - agno =3D 74
        - agno =3D 75
        - agno =3D 76
        - agno =3D 77
        - agno =3D 78
        - agno =3D 79
        - agno =3D 80
        - agno =3D 81
        - agno =3D 82
        - agno =3D 83
        - agno =3D 84
        - agno =3D 85
        - agno =3D 86
        - agno =3D 87
        - agno =3D 88
        - agno =3D 89
        - agno =3D 90
        - agno =3D 91
        - agno =3D 92
        - agno =3D 93
        - agno =3D 94
        - agno =3D 95
        - agno =3D 96
        - agno =3D 97
        - agno =3D 98
        - agno =3D 99
        - agno =3D 100
        - agno =3D 101
        - agno =3D 102
        - agno =3D 103
        - agno =3D 104
        - agno =3D 105
        - agno =3D 106
        - agno =3D 107
        - agno =3D 108
        - agno =3D 109
        - agno =3D 110
        - agno =3D 111
        - agno =3D 112
        - agno =3D 113
        - agno =3D 114
        - agno =3D 115
        - agno =3D 116
        - agno =3D 117
        - agno =3D 118
        - agno =3D 119
        - agno =3D 120
        - agno =3D 121
        - agno =3D 122
        - agno =3D 123
        - agno =3D 124
        - agno =3D 125
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
        - agno =3D 32
        - agno =3D 33
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 38
        - agno =3D 40
        - agno =3D 37
        - agno =3D 42
        - agno =3D 43
        - agno =3D 44
        - agno =3D 45
        - agno =3D 46
        - agno =3D 47
        - agno =3D 11
        - agno =3D 49
        - agno =3D 51
        - agno =3D 52
        - agno =3D 53
        - agno =3D 54
        - agno =3D 55
        - agno =3D 56
        - agno =3D 58
        - agno =3D 59
        - agno =3D 48
        - agno =3D 60
        - agno =3D 61
        - agno =3D 41
        - agno =3D 64
        - agno =3D 65
        - agno =3D 66
        - agno =3D 67
        - agno =3D 68
        - agno =3D 69
        - agno =3D 70
        - agno =3D 71
        - agno =3D 72
        - agno =3D 73
        - agno =3D 74
        - agno =3D 75
        - agno =3D 76
        - agno =3D 77
        - agno =3D 78
        - agno =3D 79
        - agno =3D 80
        - agno =3D 81
        - agno =3D 82
        - agno =3D 83
        - agno =3D 84
        - agno =3D 85
        - agno =3D 86
        - agno =3D 87
        - agno =3D 88
        - agno =3D 89
        - agno =3D 90
        - agno =3D 91
        - agno =3D 92
        - agno =3D 93
        - agno =3D 94
        - agno =3D 95
        - agno =3D 96
        - agno =3D 97
        - agno =3D 98
        - agno =3D 99
        - agno =3D 100
        - agno =3D 101
        - agno =3D 102
        - agno =3D 103
        - agno =3D 104
        - agno =3D 105
        - agno =3D 106
        - agno =3D 107
        - agno =3D 108
        - agno =3D 109
        - agno =3D 110
        - agno =3D 111
        - agno =3D 112
        - agno =3D 113
        - agno =3D 114
        - agno =3D 115
        - agno =3D 116
        - agno =3D 117
        - agno =3D 118
        - agno =3D 119
        - agno =3D 120
        - agno =3D 121
        - agno =3D 122
        - agno =3D 123
        - agno =3D 124
        - agno =3D 125
        - agno =3D 62
        - agno =3D 63
        - agno =3D 39
        - agno =3D 57
        - agno =3D 50
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

[root@nimbus /]# mount /export/vol5
[root@nimbus /]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb2              24G  7.6G   15G  34% /
/dev/sda5             1.7T  1.3T  391G  77% /export
/dev/sda2             3.8G  1.5G  2.2G  40% /var
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sdb1             995G  946G   19G  99% /storage
tmpfs                 7.7G  7.9M  7.7G   1% /var/lib/ganglia/rrds
/dev/mapper/vg1-vol5   51T   51T   90M 100% /export/vol5
[root@nimbus /]# cat /proc/partitions
major minor  #blocks  name

   8     0 1843200000 sda
   8     1    8193118 sda1
   8     2    4096575 sda2
   8     3    1020127 sda3
   8     4          1 sda4
   8     5 1829883793 sda5
   8    16 1084948480 sdb
   8    17 1059342133 sdb1
   8    18   25599577 sdb2
   8    32 13671872256 sdc
   8    33 13671872222 sdc1
   8    48 13668734464 sdd
   8    49 12695309918 sdd1
   8    64 13671872256 sde
   8    65 13671872222 sde1
   8    80 13671872256 sdf
   8    81 13671869225 sdf1
   8    96 12695309952 sdg
   8    97 12695309918 sdg1
 253     0 66406219776 dm-0




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
