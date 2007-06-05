Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 19:37:09 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.239])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l552b4Wt011960
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 19:37:05 -0700
Received: by nz-out-0506.google.com with SMTP id 4so1046391nzn
        for <xfs@oss.sgi.com>; Mon, 04 Jun 2007 19:37:04 -0700 (PDT)
Message-ID: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
Date: Mon, 4 Jun 2007 22:10:06 -0400
From: "=?ISO-8859-1?Q?Germ=E1n_Po=F3-Caama=F1o?=" <german.poo@gmail.com>
Subject: Reporting a bug
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I having have some problems with a XFS partition in Debian Sarge:

After a clean reboot (it supposed to be), my machine started with
kernel messages of problems, such us XFS_WANT_CORRUPTED_GOTO and
XFS_WANT_CORRUPTED_RETURN.

It mainly was located in /var.  But, after cleaning that, I checked
other partitions.  I guessed that my root partition (/dev/sda5) was in
problems also.  I mounted as readonly partition and  I ran xfs_repair
on it.  xfs_repair moved 6 files (all of them ELF binaries) to
lost+found.  After reboot the machine, it can't boot anymore.

Trying with Sysrescue 0.3.5 I get the following:

# xfs_check /dev/sda5
[...]
dir 1310848 block 8388608 extra leaf entry fc4e7e74 e7
dir 1310848 block 8388608 extra leaf entry fcdbb5f3 8f
dir 1310848 block 8388608 extra leaf entry fddcbf74 164
/usr/bin/xfs_check: line 28: 14691 Segmentation fault
xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1



# xfs_repair -n /dev/sda5
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
bad nextents 12 for inode 786561, would reset to 13
bad directory leaf magic # 0x46e for directory inode 786561 block 8388610
        - agno = 4
        - agno = 5
bmap rec out of order, inode 1310848 entry 2 [o s c] [8388608 81946
1], 1 [8388608 81946 1]
bad data fork in inode 1310848
would have cleared inode 1310848
        - agno = 6
        - agno = 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry "etc" at block 0 offset 128 in directory inode 128 references
free inode 1310848
        would clear inode number in entry at offset 128...
entry ".." at block 0 offset 32 in directory inode 149 references free
inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 970 references free
inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 17805 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 42528 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 1
entry ".." at block 0 offset 32 in directory inode 262276 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 262288 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 2
entry ".." at block 0 offset 32 in directory inode 524569 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 560783 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 3
bad nextents 12 for inode 786561, would reset to 13
entry ".." at block 0 offset 32 in directory inode 786608 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 4
entry ".." at block 0 offset 32 in directory inode 1067905 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1067924 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 5
bmap rec out of order, inode 1310848 entry 2 [o s c] [8388608 81946
1], 1 [8388608 81946 1]
bad data fork in inode 1310848
would have cleared inode 1310848
entry ".." at block 0 offset 32 in directory inode 1310944 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 6
entry ".." at block 0 offset 32 in directory inode 1573000 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1573094 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1573120 references
free inode 1310848
        would clear inode number in entry at offset 32...
        - agno = 7
entry ".." at block 0 offset 32 in directory inode 1835140 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1835168 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1854273 references
free inode 1310848
        would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 1854300 references
free inode 1310848
        would clear inode number in entry at offset 32...
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem starting at / ...
entry "etc" in directory inode 128 points to free inode 1310848, would
junk entry
corrupt dinode 786561, (btree extents).  This is a bug.
Please report it to xfs@oss.sgi.com.
corrupt dinode 786561, (btree extents).  This is a bug.
Please report it to xfs@oss.sgi.com.
corrupt dinode 786561, (btree extents).  This is a bug.
Please report it to xfs@oss.sgi.com.
Segmentation fault

-- 
Germán Poó Caamaño
http://www.gnome.org/~gpoo/
