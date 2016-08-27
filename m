Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E2DC7CA0
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 20:45:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E45F430404E
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 18:45:51 -0700 (PDT)
Received: from sabe.cs.wisc.edu (sabe.cs.wisc.edu [128.105.6.20]) by
	cuda.sgi.com with ESMTP id VRKsRiACmpQvMDMU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 26 Aug 2016 18:45:49 -0700 (PDT)
Received: from Juns-MacBook-Pro.local (eagleheights-118-111.resnet.wisc.edu
	[146.151.118.111]) (authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.7/8.14.1) with ESMTP id u7R1jf3U027529
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>; Fri, 26 Aug 2016 20:45:49 -0500
Date: Fri, 26 Aug 2016 20:45:37 -0500
From: Jun He <jhe@cs.wisc.edu>
Subject: XFS discards more data than it writes
Message-ID: <20160827014537.GA4119@Juns-MacBook-Pro.local>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi all,

I find that, with '-o discard', XFS sometimes discards more data than it
writes. This may slow down XFS more on slow-discard SSDs. Also, could
problematic discard implementation lead to data loss?

Setup to reproduce: 
- Linux 4.5.4
- Workload: LevelDB

$ mkfs.xfs  -K -f -s size=4096 -b size=4096 /dev/sdc1
$ mount -o discard /dev/sdc1 /mnt/fsonloop
$ leveldb/db_bench --benchmarks=overwrite --num=3000000 --db=/mnt/fsonloop/leveldb_data0 --threads=1 --use_existing_db=0

I found that XFS discarded ~2.4GB while only wrote ~1.4GB,
by blktrace. (This is not due to the mkfs discarding the
whole disk.)

Some visual https://github.com/junhe/xfs-bug-report/blob/master/xfs-double-discard.png 
Some spaces are discarded twice in this case.

Is it a bug?

Thanks,
Jun


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
