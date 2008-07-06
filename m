Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 10:23:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66HN1pG024060
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 10:23:04 -0700
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 597D22BE5C8
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 10:24:03 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com [216.241.235.118]) by cuda.sgi.com with ESMTP id 4mdiisWqlEp9fTU7 for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 10:24:03 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Sun, 6 Jul 2008 10:24:32 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <486FA095.1050106@sandeen.net>
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com


Sagar Borikar wrote:
> Copy is of the same file to 30 different directories and it is
basically
> overwrite.
> 
> Here is the setup:
> 
> It's a JBOD with Volume size 20 GB. The directories are empty and this
> is basically continuous copy of the file on all thirty directories.
But
> surprisingly none of the copy succeeds. All the copy processes are in 
> Uninterruptible sleep state and xfs_repair log I have already attached

> With the prep. As mentioned it is with 2.6.24 Fedora kernel.

It would probably be best to try a 2.6.26 kernel from rawhide to be sure
you're closest to the bleeding edge.

<Sagar> Sure Eric but I reran the test and I got similar errors with
2.6.24 kernel on x86. I am still confused with the results that I see on
2.6.24 kernel on x86 machine. I see that the used size shown by ls is
way too huge than the actual size. Here is the log of the system

[root@lab00 ~/test_partition]# ls -lSah
total 202M
-rw-r--r--  1 root root 202M Jul  4 14:06 original ---> this I sthe file
Which I  copy.
drwxr-x--- 65 root root  12K Jul  6 21:57 ..
-rwxr-xr-x  1 root root  189 Jul  4 16:31 runall
-rwxr-xr-x  1 root root   50 Jul  4 16:32 copy
drwxr-xr-x  2 root root   45 Jul  6 22:07 .

 -------> Total size is roughly 202MB. 

[root@lab00 ~/test_partition]# df -lh .
Filesystem            Size  Used Avail Use% Mounted on
/mnt/xfstest          9.6G  7.7G  2.0G  80% /root/test_partition

Size reported by df is 7.7G which is complete anomaly here. This is
10GB loopback partition and it mentions that only 2 GB is available.

[root@lab00 ~/test_partition]# cat /etc/mtab
/dev/mapper/VolGroup00-LogVol00 / ext3 rw 0 0
proc /proc proc rw 0 0
sysfs /sys sysfs rw 0 0
devpts /dev/pts devpts rw,gid=5,mode=620 0 0
/dev/sda1 /boot ext3 rw 0 0
tmpfs /dev/shm tmpfs rw 0 0
automount(pid3151) /net autofs rw,fd=4,pgrp=3151,minproto=2,maxproto=4 0
0
/mnt/xfstest /root/test_partition xfs rw,loop=/dev/loop0 0 0 ---> XFS
partition.


Here is the fragmentation result
[root@lab00 ~/test_partition]# xfs_db  -c frag -r /mnt/xfstest
actual 7781, ideal 32, fragmentation factor 99.59%

Here is the kernel version:

[root@lab00 ~/test_partition]# uname -a
Linux lab00 2.6.24 #1 SMP Fri Jul 4 12:20:56 IST 2008 i686 i686 i386
GNU/Linux


I tested on 2.6.24.7-92.fc8 on x86_64, and I did this, specifically, in
the root of a 30G xfs fs:



# for I in `seq 1 30`; do mkdir dir$I; done
# vi copyit.sh (your script)
# chmod +x copyit.sh
# dd if=/dev/zero of=300mbfile bs=1M count=300
# for I in `seq 1 30`; do ./copyit.sh 300mbfile dir$I & done

I got no errors or corruption after several iterations.

<Sagar> Surprising. I see it every time. I do it on 20 GB and 10GB
partition on loopback device. When looked for the bad inode, 

Might also be worth checking dmesg for any errors when you run.

<Sagar> dmesg log doesn't give any information. Here is XFS related
info:

XFS mounting filesystem loop0
Ending clean XFS mount for filesystem: loop0
Which is basically for mounting XFS cleanly. But there is no exception
in XFS. 


Filesystem has become completely sluggish and response time is increased
to 
3-4 minutes for every command.  Not a single copy is complete and all
the copy processes are sleeping continuously. Xfs_repair starts
reporting severe bugs:

        - agno = 1
entry "testfile" in shortform directory 16777472 references free inode
16777473
would have junked entry "testfile" in directory inode 16777472
        - agno = 0
entry "testfile_3" at block 0 offset 664 in directory inode 128
references free inode 138
        would clear inode number in entry at offset 664...
entry "testfile_4" at block 0 offset 712 in directory inode 128
references free inode 140
        would clear inode number in entry at offset 712...
entry "testfile_5" at block 0 offset 760 in directory inode 128
references free inode 142
        would clear inode number in entry at offset 760...
entry "testfile_6" at block 0 offset 808 in directory inode 128
references free inode 143
        would clear inode number in entry at offset 808...
entry "testfile_7" at block 0 offset 856 in directory inode 128
references free inode 144
        would clear inode number in entry at offset 856...
entry "testfile_8" at block 0 offset 904 in directory inode 128
references free inode 146
        would clear inode number in entry at offset 904...
entry "testfile_9" at block 0 offset 952 in directory inode 128
references free inode 148
        would clear inode number in entry at offset 952...
entry "testfile_10" at block 0 offset 976 in directory inode 128
references free inode 149
        would clear inode number in entry at offset 976...
entry "testfile_12" at block 0 offset 1048 in directory inode 128
references free inode 150
        would clear inode number in entry at offset 1048...
entry "testfile_11" at block 0 offset 1072 in directory inode 128
references free inode 151
        would clear inode number in entry at offset 1072...
entry "testfile_13" at block 0 offset 1144 in directory inode 128
references free inode 154
data fork in ino 16777473 claims dup extent, off - 5266, start -
2164956, cnt 192
bad data fork in inode 16777473
would have cleared inode 16777473
entry "testfile" in shortform directory 16777474 references free inode
16777475
would have junked entry "testfile" in directory inode 16777474
        would clear inode number in entry at offset 1144...
entry "testfile_14" at block 0 offset 1168 in directory inode 128
references free inode 155
        would clear inode number in entry at offset 1168...
entry "testfile_15" at block 0 offset 1240 in directory inode 128
references free inode 156
        would clear inode number in entry at offset 1240...
entry "testfile_16" at block 0 offset 1264 in directory inode 128
references free inode 157
        would clear inode number in entry at offset 1264...
entry "testfile_17" at block 0 offset 1336 in directory inode 128
references free inode 160
        would clear inode number in entry at offset 1336...
entry "testfile_18" at block 0 offset 1360 in directory inode 128
references free inode 161
        would clear inode number in entry at offset 1360...
entry "testfile_19" at block 0 offset 1432 in directory inode 128
references free inode 162
        would clear inode number in entry at offset 1432...
entry "testfile_20" at block 0 offset 1456 in directory inode 128
references free inode 163
        would clear inode number in entry at offset 1456...
entry "testfile_2" at block 0 offset 3032 in directory inode 128
references free inode 137
        would clear inode number in entry at offset 3032...
data fork in ino 16777475 claims dup extent, off - 8178, start -
3200553, cnt 104
bad data fork in inode 16777475
would have cleared inode 16777475
entry "testfile" in shortform directory 16777476 references free inode
16777477
would have junked entry "testfile" in directory inode 16777476
data fork in ino 16777477 claims dup extent, off - 9402, start -
3221565, cnt 56
bad data fork in inode 16777477
would have cleared inode 16777477
entry "testfile" in shortform directory 16777478 references free inode
16777479
would have junked entry "testfile" in directory inode 16777478
data fork in ino 16777479 claims dup extent, off - 9586, start - 170361,
cnt 96
bad data fork in inode 16777479
would have cleared inode 16777479
entry "testfile" in shortform directory 16777480 references free inode
16777481
would have junked entry "testfile" in directory inode 16777480
data fork in ino 16777481 claims dup extent, off - 8338, start -
3203018, cnt 128
bad data fork in inode 16777481
would have cleared inode 16777481
        - agno = 2
entry "testfile" in shortform directory 33595712 references free inode
33595713
would have junked entry "testfile" in directory inode 33595712
bad data fork in inode 33595713
would have cleared inode 33595713
entry "testfile" in shortform directory 33595714 references free inode
33595715
would have junked entry "testfile" in directory inode 33595714
imap claims in-use inode 33595715 is free, correcting imap
entry "testfile" in shortform directory 33595716 references free inode
33595717
would have junked entry "testfile" in directory inode 33595716
data fork in ino 33595717 claims dup extent, off - 0, start - 3281880,
cnt 6180
bad data fork in inode 33595717
would have cleared inode 33595717
entry "testfile" in shortform directory 33595718 references free inode
33595719
would have junked entry "testfile" in directory inode 33595718
bad data fork in inode 33595719
would have cleared inode 33595719
entry "testfile" in shortform directory 33595720 references free inode
33595721
would have junked entry "testfile" in directory inode 33595720
bad data fork in inode 33595721
would have cleared inode 33595721
        - agno = 3
entry "testfile" in shortform directory 50331904 references free inode
50331905
would have junked entry "testfile" in directory inode 50331904
bad data fork in inode 50331905
would have cleared inode 50331905
entry "testfile" in shortform directory 50331906 references free inode
50331907
would have junked entry "testfile" in directory inode 50331906
data fork in ino 50331907 claims dup extent, off - 609, start - 3151886,
cnt 311
bad data fork in inode 50331907
would have cleared inode 50331907
entry "testfile" in shortform directory 50331908 references free inode
50331909
would have junked entry "testfile" in directory inode 50331908
imap claims in-use inode 50331909 is free, correcting imap
entry "testfile" in shortform directory 50331910 references free inode
50331911
would have junked entry "testfile" in directory inode 50331910
bad data fork in inode 50331911
would have cleared inode 50331911
entry "testfile" in shortform directory 50331912 references free inode
50331913
would have junked entry "testfile" in directory inode 50331912
data fork in ino 50331913 claims dup extent, off - 6358, start -
3224389, cnt 469
bad data fork in inode 50331913
would have cleared inode 50331913
data fork in regular inode 133 claims used block 1075592
would have cleared inode 133
data fork in regular inode 136 claims used block 1075930
would have cleared inode 136
data fork in regular inode 137 claims used block 2162044
would have cleared inode 137
data fork in regular inode 138 claims used block 1075938
would have cleared inode 138
entry "testfile" in shortform directory 139 references free inode 141
would have junked entry "testfile" in directory inode 139
data fork in ino 140 claims dup extent, off - 12298, start - 202587, cnt
30
bad data fork in inode 140
would have cleared inode 140
data fork in ino 141 claims dup extent, off - 8562, start - 160071, cnt
384
bad data fork in inode 141
would have cleared inode 141
data fork in ino 142 claims dup extent, off - 1458, start - 80521, cnt
32
bad data fork in inode 142
would have cleared inode 142
data fork in ino 143 claims dup extent, off - 13770, start - 235117, cnt
96
bad data fork in inode 143
would have cleared inode 143
bad magic # 0 in inode 144 (data fork) bmbt block 3262925
bad data fork in inode 144
would have cleared inode 144
entry "testfile" in shortform directory 145 references free inode 147
would have junked entry "testfile" in directory inode 145
data fork in ino 146 claims dup extent, off - 8082, start - 138272, cnt
32
bad data fork in inode 146
would have cleared inode 146
data fork in regular inode 147 claims used block 1075759
would have cleared inode 147
data fork in regular inode 148 claims used block 3231076
would have cleared inode 148
data fork in ino 149 claims dup extent, off - 9426, start - 168635, cnt
8
bad data fork in inode 149
would have cleared inode 149
data fork in ino 150 claims dup extent, off - 3607, start - 105990, cnt
59
bad data fork in inode 150
would have cleared inode 150
data fork in regular inode 151 claims used block 1076476
would have cleared inode 151
entry "testfile" in shortform directory 152 references free inode 153
would have junked entry "testfile" in directory inode 152
bad magic # 0 in inode 153 (data fork) bmbt block 3271407
bad data fork in inode 153
would have cleared inode 153
data fork in regular inode 154 claims used block 1076388
would have cleared inode 154
data fork in regular inode 155 claims used block 1076068
would have cleared inode 155
data fork in regular inode 156 claims used block 3224002
would have cleared inode 156
data fork in ino 157 claims dup extent, off - 9554, start - 170265, cnt
96
bad data fork in inode 157
would have cleared inode 157
entry "testfile" in shortform directory 158 references free inode 159
would have junked entry "testfile" in directory inode 158
data fork in regular inode 159 claims used block 1076564
would have cleared inode 159
data fork in ino 160 claims dup extent, off - 9394, start - 168489, cnt
8
bad data fork in inode 160
would have cleared inode 160
data fork in ino 161 claims dup extent, off - 14662, start - 253175, cnt
32
bad data fork in inode 161
would have cleared inode 161
data fork in regular inode 162 claims used block 2209542
would have cleared inode 162
bad magic # 0 in inode 163 (data fork) bmbt block 3270098
bad data fork in inode 163
would have cleared inode 163
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - agno = 0
entry "testfile_3" in directory inode 128 points to free inode 138,
would junk entry
entry "testfile_4" in directory inode 128 points to free inode 140,
would junk entry
entry "testfile_5" in directory inode 128 points to free inode 142,
would junk entry
entry "testfile_6" in directory inode 128 points to free inode 143,
would junk entry
entry "testfile_7" in directory inode 128 points to free inode 144,
would junk entry
entry "testfile_8" in directory inode 128 points to free inode 146,
would junk entry
entry "testfile_9" in directory inode 128 points to free inode 148,
would junk entry
entry "testfile_10" in directory inode 128 points to free inode 149,
would junk entry
entry "testfile_12" in directory inode 128 points to free inode 150,
would junk entry
entry "testfile_11" in directory inode 128 points to free inode 151,
would junk entry
entry "testfile_13" in directory inode 128 points to free inode 154,
would junk entry
entry "testfile_14" in directory inode 128 points to free inode 155,
would junk entry
entry "testfile_15" in directory inode 128 points to free inode 156,
would junk entry
entry "testfile_16" in directory inode 128 points to free inode 157,
would junk entry
entry "testfile_17" in directory inode 128 points to free inode 160,
would junk entry
entry "testfile_18" in directory inode 128 points to free inode 161,
would junk entry
entry "testfile_19" in directory inode 128 points to free inode 162,
would junk entry
entry "testfile_20" in directory inode 128 points to free inode 163,
would junk entry
entry "testfile_1" in directory inode 128 points to free inode 136,
would junk entry
entry "testfile_2" in directory inode 128 points to free inode 137,
would junk entry
bad hash table for directory inode 128 (no data entry): would rebuild
entry "testfile" in shortform directory inode 132 points to free inode
133would junk entry
entry "testfile" in shortform directory inode 139 points to free inode
141would junk entry
entry "testfile" in shortform directory inode 145 points to free inode
147would junk entry
entry "testfile" in shortform directory inode 152 points to free inode
153would junk entry
entry "testfile" in shortform directory inode 158 points to free inode
159would junk entry
        - agno = 1
entry "testfile" in shortform directory inode 16777472 points to free
inode 16777473would junk entry
entry "testfile" in shortform directory inode 16777474 points to free
inode 16777475would junk entry
entry "testfile" in shortform directory inode 16777476 points to free
inode 16777477would junk entry
entry "testfile" in shortform directory inode 16777478 points to free
inode 16777479would junk entry
entry "testfile" in shortform directory inode 16777480 points to free
inode 16777481would junk entry
        - agno = 2
entry "testfile" in shortform directory inode 33595712 points to free
inode 33595713would junk entry
entry "testfile" in shortform directory inode 33595716 points to free
inode 33595717would junk entry
entry "testfile" in shortform directory inode 33595718 points to free
inode 33595719would junk entry
entry "testfile" in shortform directory inode 33595720 points to free
inode 33595721would junk entry
        - agno = 3
entry "testfile" in shortform directory inode 50331904 points to free
inode 50331905would junk entry
entry "testfile" in shortform directory inode 50331906 points to free
inode 50331907would junk entry
entry "testfile" in shortform directory inode 50331910 points to free
inode 50331911would junk entry
entry "testfile" in shortform directory inode 50331912 points to free
inode 50331913would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

        XFS_REPAIR Summary    Sun Jul  6 22:43:36 2008

Phase           Start           End             Duration
Phase 1:        07/06 22:39:18  07/06 22:39:33  15 seconds
Phase 2:        07/06 22:39:33  07/06 22:41:47  2 minutes, 14 seconds
Phase 3:        07/06 22:41:47  07/06 22:43:15  1 minute, 28 seconds
Phase 4:        07/06 22:43:15  07/06 22:43:36  21 seconds
Phase 5:        Skipped
Phase 6:        07/06 22:43:36  07/06 22:43:36
Phase 7:        07/06 22:43:36  07/06 22:43:36

Total run time: 4 minutes, 18 seconds


When checked for bad inode in xfs_db, then the parent inode was shown as
-1
I presume it should point to right parent directory inode.
1:
        byte offset 2560065792, length 256
        buffer block 5000128 (fsbno 1048592), 8 bbs
        inode 16777473, dir inode -1, type inode

I don't know what I am doing wrong here.
Sagar
