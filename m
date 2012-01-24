Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OMwgNJ097598 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 16:58:43 -0600
Received: from mailrelay.mcs.anl.gov (newman-1.mcs.anl.gov [140.221.6.6]) by
	cuda.sgi.com with ESMTP id oZQf0E2BzBKvcSEk for
	<xfs@oss.sgi.com>; Tue, 24 Jan 2012 14:58:41 -0800 (PST)
Date: Tue, 24 Jan 2012 16:58:40 -0600
From: John Valdes <valdes@anl.gov>
Subject: Re: log recovery fails at mount
Message-ID: <20120124225840.GA20222@starfish.mcs.anl.gov>
References: <20120124024340.GA6689@starfish.mcs.anl.gov>
	<4F1E3C71.1020303@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1E3C71.1020303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:06:57PM -0600, Eric Sandeen wrote:
> try:
> 
> # xfs_metadump /dev/md4 md4.metadump
> # xfs_mdrestore md4.metadump md4.img
> # xfs_repair -L md4.img
> 
> that'll repair a metadata image and you can see how much it runs into.

Good suggestion.  Here's the result; looks innocuous:

  prompt# xfs_repair -v -L md4.img
  Phase 1 - find and verify superblock...
          - block cache size set to 1242264 entries
  Phase 2 - using internal log
          - zero log...
  zero_log: head block 123697 tail block 123687
  ALERT: The filesystem has valuable metadata changes in a log which is being
  destroyed because the -L option was used.
          - scan filesystem freespace and inode maps...
          - found root inode chunk
  Phase 3 - for each AG...
          - scan and clear agi unlinked lists...
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
          - agno = 2
          - agno = 3
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
          - agno = 26
          - agno = 27
          - agno = 28
          - agno = 29
          - agno = 30
          - agno = 31
          - agno = 25
          - agno = 4
  Phase 5 - rebuild AG headers and trees...
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
          - reset superblock...
  Phase 6 - check inode connectivity...
          - resetting contents of realtime bitmap and summary inodes
          - traversing filesystem ...
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
          - traversal finished ...
          - moving disconnected inodes to lost+found ...
  Phase 7 - verify and correct link counts...

          XFS_REPAIR Summary    Tue Jan 24 13:49:49 2012

  Phase           Start           End             Duration
  Phase 1:        01/24 13:49:12  01/24 13:49:13  1 second
  Phase 2:        01/24 13:49:13  01/24 13:49:18  5 seconds
  Phase 3:        01/24 13:49:18  01/24 13:49:24  6 seconds
  Phase 4:        01/24 :        01/24 13:49:49  01/24 13:49:49

  Total run time: 37 seconds
  done

However, if I loopback mount the img file, the file/directory names in
the mounted fs are mostly corrupted; that may be expected though since
it's just a metadata dump/restore?

  prompt# mount -r -t xfs -o loop md4.img /mnt
  prompt# ls /mnt
  ??5?z+o??%F_4(?R?.wrhE*]  data  K?ckw?  T?o??n2o?,?0-|K#\o Z?w?9=ol\?7j??1T

Any other suggestions or comments before I let loose xfs_repair -L on
the real filesystem?

John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
