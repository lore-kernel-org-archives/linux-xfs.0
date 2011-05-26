Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4Q2eO5V177466 for <xfs@oss.sgi.com>; Wed, 25 May 2011 21:40:24 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBBA346EA34
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 19:40:23 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id 5mAmkHovKGZBFuRN for
	<xfs@oss.sgi.com>; Wed, 25 May 2011 19:40:23 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4Q2KLk1028209
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 22:20:21 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4Q2eNnO113100 for <xfs@oss.sgi.com>; Wed, 25 May 2011 22:40:23 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p4PMeBoI006443 for <xfs@oss.sgi.com>; Wed, 25 May 2011 19:40:11 -0300
Received: from [9.65.10.114] (sig-9-65-10-114.mts.ibm.com [9.65.10.114])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p4PMeAIq006382 for <xfs@oss.sgi.com>; Wed, 25 May 2011 19:40:11 -0300
Message-ID: <4DDDBD94.4060901@linux.vnet.ibm.com>
Date: Wed, 25 May 2011 19:40:20 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: XFS TESTS: Add Fallocate Punch Hole Test v4 Changes
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

Hi All,

Here is v4 of the punch hole tests.  I've merged in the non over-lapping 
tests from v3 into 252, and I've separated the code paths for punch hole 
and fallocate in the fsx patch.  I've also included the ENOSPC test that 
we used in the ext4 punch hole tests.  Feedback appreciated!  Thx All!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
