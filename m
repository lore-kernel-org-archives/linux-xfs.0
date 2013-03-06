Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AC8F7FD0
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 09:09:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB83DAC001
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 07:09:02 -0800 (PST)
Received: from mail-bk0-f66.google.com (mail-bk0-f66.google.com
	[209.85.214.66]) by cuda.sgi.com with ESMTP id LwSFQzSf0IFSgk5J
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 07:09:01 -0800 (PST)
Received: by mail-bk0-f66.google.com with SMTP id jk7so170490bkc.1
	for <xfs@oss.sgi.com>; Wed, 06 Mar 2013 07:08:59 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 6 Mar 2013 16:08:59 +0100
Message-ID: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
Subject: XFS filesystem corruption
From: Julien FERRERO <jferrero06@gmail.com>
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
To: xfs@oss.sgi.com

Hi,

I am migrating a video streaming server from Linux kernel 2.6.18 (8
years old kernel...) to 2.6.35 (2 years old...). Unfortunately, I
don't have the choice of the kernel version since some proprietary
external modules require this specific kernel version.

We use XFS for filesystem and the layout is the following:
H/W RAID 5 (/dev/sda) > mdadm Linear RAID (/dev/md0) > XFS filesystem
(/mountpoint).
The allocated size of the fs is 1.5 TB.

Since we have migrated to 2.6.35, we start to experience some very
rare and random filesystem corruption. Some file or directory suddenly
become no longer accessible. For instance, the /bin/ls command
returns:
??????????  ? ?      ?        ?            ?
4988d60d-2ee5-4ee6-9a16-6f7f5f28f412.xml
and I cannot open the file (No such file or directory).

I had a look to the FAQ and I did try to remount the fs with the
option "inode64" but it did not change anything. I have the exact same
result.

If I run "xfs_repair" on my system I have the following output:
--------------8<--------------8<--------------
# xfs_repair -n /dev/md0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
agi unlinked bucket 62 is 190 in ag 1 (inode=134217918)
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
b52feb70: Badness in key lookup (length)
bp=(bno 60387336, len 16384 bytes) key=(bno 60387336, len 8192 bytes)
        - agno = 1
imap claims a free inode 134217858 is in use, would correct imap and clear inode
imap claims a free inode 134217859 is in use, would correct imap and clear inode
imap claims a free inode 134217860 is in use, would correct imap and clear inode
imap claims a free inode 134217863 is in use, would correct imap and clear inode
imap claims a free inode 134217864 is in use, would correct imap and clear inode
imap claims a free inode 134217866 is in use, would correct imap and clear inode
imap claims a free inode 134217867 is in use, would correct imap and clear inode
imap claims a free inode 134217869 is in use, would correct imap and clear inode
imap claims a free inode 134217915 is in use, would correct imap and clear inode
imap claims a free inode 134217916 is in use, would correct imap and clear inode
imap claims a free inode 140493888 is in use, would correct imap and clear inode
imap claims a free inode 140493894 is in use, would correct imap and clear inode
imap claims a free inode 140493896 is in use, would correct imap and clear inode
imap claims a free inode 140493897 is in use, would correct imap and clear inode
imap claims a free inode 140493898 is in use, would correct imap and clear inode
imap claims a free inode 140493899 is in use, would correct imap and clear inode
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "10fdb8cd-b48a-4d2a-8ff4-19516e6a3b06.xml" at block 0 offset 544
in directory inode 134217856 references free inode 140493896
would clear inode number in entry at offset 544...
entry "9e6727ff-9fd6-466a-aa30-c7aabdd67646.xml" at block 0 offset 600
in directory inode 134217856 references free inode 140493898
entry "tmp" at block 0 offset 112 in directory inode 128 references
free inode 140493888
would clear inode number in entry at offset 600...
would clear inode number in entry at offset 112...
entry "5ff59379-e982-4d4e-b87a-cb194ea6cfd8.xml" at block 0 offset 632
in directory inode 134217856 references free inode 140493899
entry "tmp" at block 0 offset 3984 in directory inode 128 references
free inode 135
would clear inode number in entry at offset 632...
would clear inode number in entry at offset 3984...
entry "b8078379-d8ee-4af0-9ed4-2c94479a7a51.xml" in shortform
directory 131 references free inode 135
would have junked entry "b8078379-d8ee-4af0-9ed4-2c94479a7a51.xml" in
directory inode 131
entry "4988d60d-2ee5-4ee6-9a16-6f7f5f28f412.xml" in shortform
directory 131 references free inode 135
would have junked entry "4988d60d-2ee5-4ee6-9a16-6f7f5f28f412.xml" in
directory inode 131
        - agno = 2
entry "87280c00-3b60-46ec-9d65-937db364a7b9" at block 2 offset 16 in
directory inode 268435584 references free inode 135
would clear inode number in entry at offset 16...
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
entry "up2" in shortform directory 4026531968 references free inode 135
would have junked entry "up2" in directory inode 4026531968
        - agno = 31
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "tmp" in directory inode 128 points to free inode 140493888,
would junk entry
entry "tmp" in directory inode 128 points to free inode 135, would junk entry
bad hash table for directory inode 128 (no data entry): would rebuild
entry "56b3f51e-4912-4e43-99ed-2204aa8a68f2.xml" in shortform
directory inode 131 points to free inode 135would junk entry
entry "4988d60d-2ee5-4ee6-9a16-6f7f5f28f412.xml" in shortform
directory inode 131 points to free inode 135would junk entry
entry "ca073ec3-5d59-4306-a8a6-67c2e0d79c81.xml" in directory inode
134217856 points to free inode 140493896, would junk entry
entry "ea5dd270-06a0-4e25-8cbf-0a37b2dad755.xml" in directory inode
134217856 points to free inode 140493898, would junk entry
entry "dd745300-48fa-46e5-b5c7-a4ba5e820353.xml" in directory inode
134217856 points to free inode 140493899, would junk entry
entry "3a092246-f8ea-4cb6-9758-f0d73253f368.xml" in dir 134217856
points to an already connected directory inode 140493909
would clear entry "3a092246-f8ea-4cb6-9758-f0d73253f368.xml"
bad hash table for directory inode 134217856 (no data entry): would rebuild
entry "87280c00-3b60-46ec-9d65-937db364a7b9" in directory inode
268435584 points to free inode 135, would junk entry
bad hash table for directory inode 268435584 (no data entry): would rebuild
entry "up2" in shortform directory inode 4026531968 points to free
inode 135would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 134217861, would move to lost+found
disconnected inode 134217865, would move to lost+found
disconnected inode 134217868, would move to lost+found
disconnected inode 134217918, would move to lost+found
disconnected inode 134217919, would move to lost+found
disconnected inode 140493900, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 128 nlinks from 12 to 8
would have reset inode 134217918 nlinks from -1 to 1
would have reset inode 268435584 nlinks from 192 to 191
would have reset inode 4026531968 nlinks from 4 to 3
No modify flag set, skipping filesystem flush and exiting.
--------------8<--------------8<--------------

The filesystem was originally created with the command:
# mkfs.xfs -f -l size=32m /dev/md0
and the mount option in fstab are "defaults" (rw,relatime,attr2,noquota).

We know the problem is not related to the RAID H/W. We also have an
unit with corrupted fs on a single drive (the RAID Linear is still
there though).

I am totally stuck and I really don't know how to duplicate the
corruption. I only know that units are used to be power cycle by
operator while the fs is still mounted (no proper shutdown / reboot).
My guess is the fs journal shall handle this case and avoid such
corruption.

Any help would be appreciated.

Thank you.

-- Julian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
