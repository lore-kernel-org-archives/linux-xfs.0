Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5S5fhYT183074 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 00:41:43 -0500
Received: from e37.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9D6A14F8795
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:41:42 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id VTbZk7ngExYmuB7R for
	<xfs@oss.sgi.com>; Mon, 27 Jun 2011 22:41:42 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5S5caqp018570
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:38:36 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5S5fE7d169228 for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 23:41:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5RNTuxB021646
	for <xfs@oss.sgi.com>; Mon, 27 Jun 2011 17:29:57 -0600
From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v6] XFS TESTS: Add ENOSPC Punch Hole Test
Date: Mon, 27 Jun 2011 22:32:41 -0700
Message-Id: <1309239163-3975-1-git-send-email-achender@linux.vnet.ibm.com>
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

This is another set I sent out a while ago, but I didnt see it show up on the lists, 
so I am resending this one too. The work in this patch is a continuation from a 
previous patch set that has been partially accepted, so I thought I 
should retain the v6.

This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
This test will verify that a hole can be punched even when the disk is full.
Reserved blocks should be used to complete the operation when there is not blocks
to further fragment the file.

Because punching a hole does not always require extra blocks, there needs to 
be serveal iterations of punching holes, and then filling the file system to 100% 
usage before it is forced to grow the tree in order to handle the fragmentation. 
The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.

I could use some opinions on this patch set becuase I am not sure if other filesystems 
handle their punch holes in the same way.  Although xfs appears to pass the test, 
should this test be an ext4 only test? Thx!

Allison Henderson (2):
  XFS TESTS: Move su routines in 123 to common.rc
  XFS TESTS: Add ENOSPC Hole Punch Test

 123       |   24 ------------------------
 common.rc |   20 ++++++++++++++++++++
 group     |    1 +
 3 files changed, 21 insertions(+), 24 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
