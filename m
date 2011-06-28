Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S4P9B6177355 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:25:10 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51C8F310DE
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 21:25:08 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id tCj4DKEQHqFJv7q6 for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 21:25:08 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S44P7C030497
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:04:25 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S4P7Bp1241100
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:25:07 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5S4P762014747 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:25:07 -0400
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/3 v2] XFS TESTS: Fix 252 failure
Date: Mon, 27 Jun 2011 21:27:24 -0700
Message-Id: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Allison Henderson <achender@linux.vnet.ibm.com>

Hi All,

Sorry for the delay on this set.  I meant to send it a while back,
but it looks like the email did not get through, so I am resending it. 

This patch corrects a 252 test failure when run on ext4.  Becuase ext4
and xfs do not handle splitting extents in the same way, it was decided
that the fiemap filter should not display an extent type. Only the
location of the hole.  An md5 check sum has also been added to make 
sure the file contents are correct.

Also, another patch was sumbitted that modifes the same code in 242.out.
Assumeing that patch will go through, this set was modifed to be applied on 
top of Christoph's "[PATCH] xfstests: update test 042 golden output" (06/20/2011). 

Allison Henderson (3):
  XFS TESTS: Fix 252 Failure: Relax fiemap filter
  XFS TESTS: Fix 252 Failure: Update 252 Golden Output
  XFS TESTS: Fix 252 Failure: Update 242 Golden Output

 242.out      |   17 ++++
 252          |    8 +-
 252.out      |  272 ++++++++++++++++++++++++++++++++++++----------------------
 common.punch |   38 ++++++++-
 4 files changed, 227 insertions(+), 108 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
