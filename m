Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DKGjUQ047513 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 15:16:55 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B56814AE816
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 13:17:26 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id 1Tc95c10IsMEihSK for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 13:17:26 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 3076E204116
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:17:23 +0000 (UTC)
Message-ID: <4A8474D2.7050508@jquigley.com>
Date: Thu, 13 Aug 2009 15:17:22 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: XFS corruption with failover
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Development <xfs@oss.sgi.com>

Folks:

We're deploying XFS in a configuration where the file system is being exported with NFS.  XFS is being mounted on Linux, with default options; an iSCSI volume is the formatted media.  We're working out a failover solution for this deployment utilizing Linux HA.  Things appear to work correctly in the general case, but in continuous testing we're getting XFS superblock corruption on a very reproducible basis.  

The sequence of events in our test scenario:

1. NFS server #1 online
2. Run IO to NFS server #1 from NFS client
3. NFS server #1 offline, (via passing 'b' to /proc/sysrq-trigger)
4. NFS server #2 online
5. XFS mounted as part of failover mechanism, mount fails

The mount fails with the following:

<snip>
kernel: XFS mounting filesystem sde
kernel: Starting XFS recovery on filesystem: sde (logdev: internal)
kernel: XFS: xlog_recover_process_data: bad clientid
kernel: XFS: log mount/recovery failed: error 5
kernel: XFS: log mount failed
</snip>

When running xfs_repair:

<snip>
[root@machine ~]# xfs_repair /dev/sde 
xfs_repair: warning - cannot set blocksize on block device /dev/sde: Invalid argument
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs ...
</snip>

Any advice or insight into what we're doing wrong would be very much appreciated.  My apologies in advance for the somewhat off-topic question.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
