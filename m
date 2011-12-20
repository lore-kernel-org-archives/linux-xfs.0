Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBK9smCf127951
	for <linux-xfs@oss.sgi.com>; Tue, 20 Dec 2011 03:54:48 -0600
Received: from ppsw-51.csi.cam.ac.uk (ppsw-51.csi.cam.ac.uk [131.111.8.151])
	by cuda.sgi.com with ESMTP id WbPFkOn2Iw1dlzYv for
	<linux-xfs@oss.sgi.com>; Tue, 20 Dec 2011 01:54:46 -0800 (PST)
Message-ID: <4EF05B62.7020903@jeremysanders.net>
Date: Tue, 20 Dec 2011 09:54:42 +0000
From: Jeremy Sanders <jeremy@jeremysanders.net>
MIME-Version: 1.0
Subject: Re: bug in fs/xfs/xfs_aops.c:959! (kernel 3.1.5)
References: <jcn0ip$hsk$1@dough.gmane.org> <20111219221137.GR23662@dastard>
In-Reply-To: <20111219221137.GR23662@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com


Dave Chinner wrote:

 > There was a line above this about an assert failure? What was it?

Unfortunately there's are no other messages above this in 
/var/log/messages. I checked carefully for any asserts.

 > If it tripped the assert I think it did, it looks like the system
 > was trying to do write IO into a hole in the file. What workload
 > were you running, and what are the details of your machine + storage
 > config?

It's xfs (nobarrier opts) running from a Linux MD software raid device 
(no LVM). It uses raid6 on 11 1TB discs, using a chunk size of 32 kB. 
The filesystem is 88% full. The discs are on a 3ware 9650SE controller.

The array has a set of backup "snapshots" with hard links created using 
the rsync --link-dest feature. We also used --sparse when doing the 
rsyncs. We have snapshots for a set of user directories, one for each day.

The message occured while rsync was writing to the array (creating the 
snapshots) and it was being read by rsync or a tar to tar pipe to a 
second btrfs array.

Jeremy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
