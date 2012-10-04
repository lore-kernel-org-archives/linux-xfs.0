Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94FjOoN164770 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 10:45:24 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id xM9gQjIZnLEpAC66 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 08:46:49 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.5/8.14.4/SuSE Linux 0.8) with ESMTP id
	q94FkkUC019711 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 08:46:48 -0700
Message-ID: <506DAF66.2030507@tlinx.org>
Date: Thu, 04 Oct 2012 08:46:46 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: how to replay log of a fs that has no log? or is this supposed to
	work?
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

Looking at xfs_freeze it claims it is suppose to:
        When this is selected, all ongoing transactions in the
        filesystem are allowed to complete, new write system calls are  halted,
        other calls which modify the filesystem are halted, and all dirty data,
        metadata, and  log  information  are  written  to  disk.
--
Important in the above is the part about all the log information being
written to disk.

That ***should*** imply that xfs_ncheck shouldn't complain about outstanding
logfile changes that need to be replayed, no?  Er, um, having just tried that,
and noting that it DOES still indicated the log file is still outstanding,
does that mean xfs_freeze doesn't work in regards to writing out the logfile
or ?? what?

I assume I'm missing something? Seems like lunches aren't available even
after paying for them...let alone hoping for free ones...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
