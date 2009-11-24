Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOJ56X5158700 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 13:05:06 -0600
Received: from BLADE3.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34AD012D1ABE
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 11:05:30 -0800 (PST)
Received: from BLADE3.ISTI.CNR.IT (blade3.isti.cnr.it [194.119.192.19]) by
	cuda.sgi.com with ESMTP id m0rm6B7K35tX5hoG for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 11:05:30 -0800 (PST)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.4 #31773)
	id <01NGHEFVMM8G9OGIF0@mx.isti.cnr.it> for xfs@oss.sgi.com; Tue,
	24 Nov 2009 20:04:27 +0100
Received: from [155.253.41.89] by mx.isti.cnr.it (PMDF V6.4 #31704)
	with ESMTPSA id <01NGHEFSNHLA9PM8QJ@mx.isti.cnr.it> for xfs@oss.sgi.com;
	Tue, 24 Nov 2009 20:04:23 +0100
Date: Tue, 24 Nov 2009 20:04:38 +0100
From: Asdo <asdo@shiftmail.org>
Subject: Any on-disk format changes recently?
Message-id: <4B0C2E46.1040509@shiftmail.org>
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

Dear XFS people
I am tracking a nasty bug for which I would need to regress the kernel 
version from 2.6.31 down to 2.6.28 or maybe even 2.6.24.
I have to do this on an important fileserver full of important data on 
XFS filesystems which were created on 2.6.31.
I also need to *write* to the XFS filesystems after regressing the kernel.
Do you see any problems with this? Have there been on-disk format 
changes for XFS since 2.6.24 that could trigger data loss? (or with much 
minor concern, fail the mount?)

Thank you
Asdo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
