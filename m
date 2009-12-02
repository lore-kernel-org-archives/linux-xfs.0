Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2A1hCR241444 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 04:01:44 -0600
Received: from kms.syseleven.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0BB312DBD8F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 02:02:11 -0800 (PST)
Received: from kms.syseleven.de (kms.syseleven.de [193.164.134.106]) by
	cuda.sgi.com with ESMTP id BkmtyHg0DLFqWgv6 for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 02:02:11 -0800 (PST)
Received: from miniMac.local ([93.219.181.233])
	(authenticated user j.rosenboom@syseleven.de) by kms.syseleven.de
	for xfs@oss.sgi.com; Wed, 2 Dec 2009 11:02:09 +0100
Message-ID: <4B163B20.6030808@syseleven.de>
Date: Wed, 02 Dec 2009 11:02:08 +0100
From: Jens Rosenboom <j.rosenboom@syseleven.de>
MIME-Version: 1.0
Subject: Performance problem with multiple parallel rm -rf's
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
To: xfs@oss.sgi.com

On a large 13TB XFS volume that is being used for backups, I am seeing 
bad performance if multiple "rm -rf" processes are running in parallel. 
The backups are being done with rsnapshot and the first operation it 
does is removing the oldest snapshot. A single rsnapshot does this in 
reasonable time, but if four jobs are started at the same time, all 
their rm processes run for hours without making much progress.

This seems to be related to the planned optimizations in

http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead

Are there any other tuning options I might try? I'm already using 
"noatime,nodiratime,nobarrier,logbufs=8,logbsize=256k" as mount options 
and did enable lazy_counters for the fs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
