Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMJFL4H094665 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 13:15:22 -0600
Received: from mx2.isti.cnr.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C87E13E0891
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 11:16:57 -0800 (PST)
Received: from mx2.isti.cnr.it (mx2.isti.cnr.it [194.119.192.4]) by
	cuda.sgi.com with ESMTP id 8W6VGoCHOAAnCz9D for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 11:16:57 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NUKIN0XTTSLGY6N8@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Mon, 22 Nov 2010 20:16:22 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NUKIN0KKA8LGY6LD@mx.isti.cnr.it> for xfs@oss.sgi.com; Mon,
	22 Nov 2010 20:16:21 +0100 (MET)
Received: from [192.168.7.52] (firewall.itb.cnr.it [155.253.6.254])
	by mx.isti.cnr.it (PMDF V6.5 #31826)
	with ESMTPSA id <01NUKIN0G7MILI95RA@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Mon, 22 Nov 2010 20:16:21 +0100 (MET)
Date: Mon, 22 Nov 2010 20:18:27 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Is xfs defrag *reliably* aligned to stripes?
Message-id: <4CEAC203.9040800@shiftmail.org>
MIME-version: 1.0
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

Hello xfs people,

does the xfs defrag (xfs_fsr, I think) reliably aligns files to stripes?

There is one scenario which requires this: if you make raw disk images 
for virtual machines, you want such files to be reliably aligned to 
stripes.

Even if a complete defrag for one file is not possible because there is 
no contiguous free space (you remain e.g. with 2 trunks for one of such 
files you still need to ensure that every trunk begins exactly at the 
beginning of a stripe and ends exactly at the end of a stripe.

This is the only way to be able to align the guest filesystems to the 
RAID, inside the virtual machine.
(obviously this also requires some work by the system administrator 
because he needs to ensure that partitions inside the guest also are 
offsetted by multiples of the stripe size, ok, but it's still anyway 
needed that xfs_fsr guarantees total alignment to the stripes like I 
described)

Does it do that? Will it do that in the future?

Thank you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
