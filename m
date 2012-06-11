Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5B3LdQK037802 for <xfs@oss.sgi.com>; Sun, 10 Jun 2012 22:21:40 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id nlLhlHbWSnRjdIPe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 10 Jun 2012 20:21:38 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q5B3LZD9010492 for <xfs@oss.sgi.com>; Sun, 10 Jun 2012 20:21:37 -0700
Message-ID: <4FD5643F.5070801@tlinx.org>
Date: Sun, 10 Jun 2012 20:21:35 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: block sizes > 4K ??  possible w/large page support?
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
To: xfs-oss <xfs@oss.sgi.com>

Is this something being thought about??

More than one of my hard disks:

/boot:                 130 files in     103112 4K blocks:    793.6 blks/file
/tmp:                 1401 files in     746715 4K blocks:    533.4 blks/file
/var/cache:           1438 files in      87858 4K blocks:     61.5 blks/file
/backups:              713 files in 2523985177 4K blocks: 3539951.6 blks/file
/var:                 9038 files in     746715 4K blocks:     83.1 blks/file
/var/cache/squid:      570 files in      90031 4K blocks:    158.4 blks/file
/Media:              51893 files in 1691400956 4K blocks:  32594.5 blks/file
/:                   37312 files in     506778 4K blocks:     14.0 blks/file
/usr/share:         320805 files in  195425485 4K blocks:    609.6 blks/file
/backups/Media:      50544 files in 1642550112 4K blocks:  32497.9 blks/file
/usr:               116650 files in    1389380 4K blocks:     12.4 blks/file
/Share:            1617995 files in  305269701 4K blocks:    189.1 blks/file
/home:             5822174 files in  195412389 4K blocks:     34.0 blks/file

All but 2 could benefit from a 16K block size, and 3 of them could benefit
from a 128K block size.  Wouldn't that benefit in  in freeing up some space
both on disk and in memory?  Just a thought.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
