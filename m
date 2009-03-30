Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UM1uTE216841 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 17:02:06 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4FF21D6CAC
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 15:01:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id DBZUMY0ame2zfAqr for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2009 15:01:11 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n2UM1Af1007243
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 18:01:11 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2UM1B82014759
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 18:01:11 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n2UM16Ld005723
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 18:01:10 -0400
Message-ID: <49D14120.8040804@sandeen.net>
Date: Mon, 30 Mar 2009 17:01:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Mystery solved?  files not written for days...
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
To: xfs mailing list <xfs@oss.sgi.com>

On LKML:

[PATCH] writeback: guard against jiffies wraparound on
inode->dirtied_when checks

When a file is continually dirtied, the check in sync_sb_inodes:

        /* Was this inode dirtied after sync_sb_inodes was called? */
        if (time_after(inode->dirtied_when, start))
                break;

may have large windows where this trips on the first
(continually-dirtied) inode on the list when the time_after check has
wrapped, causing the nothing to be written out for that superblock,
potentially for days.

Could this be the reason for those various "hey, my file disappeared
after a crash and I hadn't written to it for *days*" reports we got now
and then, leaving us all scratching our heads?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
