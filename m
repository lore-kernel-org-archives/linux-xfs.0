Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53JFghc029701 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 14:15:42 -0500
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 143E06FDF2B
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 12:15:41 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id v2REVW8mTINIZFzU for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2011 12:15:41 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p53J48Qs011478
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 15:04:08 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p53JFd8s075356 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 15:15:39 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p53DFSWj000521
	for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 07:15:28 -0600
Message-ID: <4DE932D0.9040808@linux.vnet.ibm.com>
Date: Fri, 03 Jun 2011 12:15:28 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Fwd: XFS TESTS: Add Fallocate Punch Hole Test v4 Changes
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
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>



-------- Original Message --------
Subject: XFS TESTS: Add Fallocate Punch Hole Test v4 Changes
Date: Wed, 25 May 2011 19:40:20 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
