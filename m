Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 15:22:20 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SMMFkM024703
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 15:22:16 -0700
Date: Fri, 28 Sep 2007 18:22:08 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Truncated Filesystem
In-Reply-To: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
Message-ID: <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Benjamin Carr <bcarr@whoi.edu>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Including LKML on this one as it may be a partition size limit?  Sdc1 is 
not 11TB.

Justin.

On Fri, 28 Sep 2007, Benjamin Carr wrote:

> For the second time in two weeks, a system restart has resulted in a
> truncated filesystem on my server. The server is running 64bit SuSE with a
> fibrechannel connection to a Promise VTrak M500f. The array is populated
> with Hitachi 1TB drives. The filesystem should be ~12TB but is only 1.8TB
> after the system is brough online.
>
> I have tried to collect the relevant information for diagnosing the
> problem. I sought help on #xfs and was referred to the mailing list for
> help.
>
> If you can think of any other useflul information please let me know.
>
> -Ben
>
> ----------------------------------------------------------------------------
>
> messages:
> Sep 28 16:14:13 climate kernel: attempt to access beyond end of device
> Sep 28 16:14:13 climate kernel: sdc1: rw=0, want=25390571776,
> limit=3915735307
> Sep 28 16:14:13 climate kernel: I/O error in filesystem ("sdc1") meta-data
> dev sdc1 block 0x5e96560ff       ("xfs_read_buf") error 5 buf count 512
> Sep 28 16:14:13 climate kernel: XFS: size check 2 failed
>
> climate:/var/log # file -s /dev/sdc1
> /dev/sdc1: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
>
> climate:/var/log # grep sdc /proc/partitions
>   8    32 12695301632 sdc
>   8    33 1957867653 sdc1
>
> climate:/var/log # xfs_db -r /dev/sdc1
> xfs_db> sb 0
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3173821472
> rblocks = 0
> rextents = 0
> uuid = 55e7458f-309a-43e4-90ca-91e72ac63f48
> logstart = 2147483652
> rootino = 128
> rbmino = 129
> rsumino = 130
> rextsize = 16
> agblocks = 99181921
> agcount = 32
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3084
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 27
> rextslog = 0
> inprogress = 0
> imax_pct = 25
> icount = 1472
> ifree = 76
> fdblocks = 3166809019
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
> xfs_db> sb 1
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3173821472
> rblocks = 0
> rextents = 0
> uuid = 55e7458f-309a-43e4-90ca-91e72ac63f48
> logstart = 2147483652
> rootino = null
> rbmino = null
> rsumino = null
> rextsize = 16
> agblocks = 99181921
> agcount = 32
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3084
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 27
> rextslog = 0
> inprogress = 1
> imax_pct = 25
> icount = 0
> ifree = 0
> fdblocks = 3173788576
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
> xfs_db> sb 1
> xfs_db> p
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3173821472
> rblocks = 0
> rextents = 0
> uuid = 55e7458f-309a-43e4-90ca-91e72ac63f48
> logstart = 2147483652
> rootino = null
> rbmino = null
> rsumino = null
> rextsize = 16
> agblocks = 99181921
> agcount = 32
> rbmblocks = 0
> logblocks = 32768
> versionnum = 0x3084
> sectsize = 512
> inodesize = 256
> inopblock = 16
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 9
> inodelog = 8
> inopblog = 4
> agblklog = 27
> rextslog = 0
> inprogress = 1
> imax_pct = 25
> icount = 0
> ifree = 0
> fdblocks = 3173788576
> frextents = 0
> uquotino = 0
> gquotino = 0
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 0
> width = 0
> dirblklog = 0
> logsectlog = 0
> logsectsize = 0
> logsunit = 0
> features2 = 0
>
> climate:~ # time xfs_check /dev/sdc1
> XFS: totally zeroed log
> can't seek in filesystem at bb 3967276840
> can't read superblock for ag 5
> can't seek in filesystem at bb 4760732208
> can't read superblock for ag 6
> can't seek in filesystem at bb 5554187576
> can't read superblock for ag 7
> can't seek in filesystem at bb 6347642944
> can't read superblock for ag 8
> can't seek in filesystem at bb 7141098312
> can't read superblock for ag 9
> can't seek in filesystem at bb 7934553680
> can't read superblock for ag 10
> can't seek in filesystem at bb 8728009048
> can't read superblock for ag 11
> can't seek in filesystem at bb 9521464416
> can't read superblock for ag 12
> can't seek in filesystem at bb 10314919784
> can't read superblock for ag 13
> can't seek in filesystem at bb 11108375152
> can't read superblock for ag 14
> can't seek in filesystem at bb 11901830520
> can't read superblock for ag 15
> can't seek in filesystem at bb 12695285888
> can't read superblock for ag 16
> can't seek in filesystem at bb 13488741256
> can't read superblock for ag 17
> can't seek in filesystem at bb 14282196624
> can't read superblock for ag 18
> can't seek in filesystem at bb 15075651992
> can't read superblock for ag 19
> can't seek in filesystem at bb 15869107360
> can't read superblock for ag 20
> can't seek in filesystem at bb 16662562728
> can't read superblock for ag 21
> can't seek in filesystem at bb 17456018096
> can't read superblock for ag 22
> can't seek in filesystem at bb 18249473464
> can't read superblock for ag 23
> can't seek in filesystem at bb 19042928832
> can't read superblock for ag 24
> can't seek in filesystem at bb 19836384200
> can't read superblock for ag 25
> can't seek in filesystem at bb 20629839568
> can't read superblock for ag 26
> can't seek in filesystem at bb 21423294936
> can't read superblock for ag 27
> can't seek in filesystem at bb 22216750304
> can't read superblock for ag 28
> can't seek in filesystem at bb 23010205672
> can't read superblock for ag 29
> can't seek in filesystem at bb 23803661040
> can't read superblock for ag 30
> can't seek in filesystem at bb 24597116408
> can't read superblock for ag 31
>
>
