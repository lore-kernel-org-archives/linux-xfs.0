Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQIBN3B007306 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:11:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 074174AC92
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:11:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 8GIIL5w0wDBYURfb for
	<xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:11:22 -0800 (PST)
Date: Fri, 26 Dec 2008 12:45:52 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfs_db 2.9.8: coredump
In-Reply-To: <49551073.5090704@redhat.com>
Message-ID: <alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
	<49551073.5090704@redhat.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com



On Fri, 26 Dec 2008, Eric Sandeen wrote:

> Justin Piszcz wrote:
>> # xfs_db -V
>> xfs_db version 2.9.8
>>
>> p34:~# xfs_db -c frag -f /dev/sda1
>> Segmentation fault (core dumped)
>> p34:~# xfs_db -c frag -r /dev/sda1
>> Segmentation fault (core dumped)
>>
>> (It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).
>>
>> Now it can no longer check it?
>>
>
> Or, get an xfs_metadump of the fs and see if db segfaults on that too.
>
> I'd be curious  to know if xfs_repair -n flaggs any problems, as well.
>
> -Eric
>

# xfs_metadump -g /dev/sda1  /root/sda1.metadump
Copied 300096 of 426176 inodes (0 of 12 AGs)
Copying log
#

p34:~# xfs_db -c frag -f sda1.metadump
xfs_db: unexpected XFS SB magic number 0x5846534d
xfs_db: read failed: Invalid argument
xfs_db: data size check failed
cache_node_purge: refcount was 1, not zero (node=0x1ce4b80)
xfs_db: cannot read root inode (22)
cache_node_purge: refcount was 1, not zero (node=0x1ce4cd0)
xfs_db: cannot read realtime bitmap inode (22)
Segmentation fault (core dumped)
p34:~#

p34:~# xfs_repair -n /dev/sda1
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
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0
         - agno = 2
         - agno = 1
         - agno = 3
         - agno = 4
         - agno = 5
         - agno = 6
         - agno = 7
         - agno = 8
         - agno = 9
         - agno = 10
         - agno = 11
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
         - traversing filesystem ...
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.
p34:~#

Again, unmount / remount, no issues.

p34:~# umount /r1
p34:~# mount -a ; dmesg | tail -n 2
[264025.739788] XFS mounting filesystem sda1
[264025.836900] Ending clean XFS mount for filesystem: sda1
p34:~#

But xfs_db dies, on the metadump file as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
