Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EFfqTk089080 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 10:41:53 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FCF011DC10C
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 08:41:51 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id XS5dfGOx68HL8kIH for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 08:41:51 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EFZnDw024274
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 09:35:49 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5EFfYEL148956 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 09:41:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5E9f3ro011828
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 03:41:03 -0600
Message-ID: <4DF78127.40505@linux.vnet.ibm.com>
Date: Tue, 14 Jun 2011 08:41:27 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: xfstests 252 failure
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
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi all,

I just wanted to get some ideas moving on this question before too much 
time goes by.  Ext4 is currently failing xfstest 252, test number 12. 
Currently test 12 is:

	$XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
		-c "$alloc_cmd 0 20k" \	
		-c "pwrite 8k 4k" -c "fsync" \		
		-c "$zero_cmd 4k 12k" \
		-c "$map_cmd -v" $testfile | $filter_cmd
	[ $? -ne 0 ]&&  die_now

and the output is:

         12. unwritten -> data -> unwritten
0: [0..7]: unwritten
1: [8..31]: hole
2: [32..39]: unwritten

Ext4 gets data extents here instead of unwritten extents.  I did some 
investigating and it looks like the fsync command causes the extents to 
be written out before the punch hole operation starts.  It looks like 
what happens is that when an unwritten extent gets written to, it doesnt 
always split the extent.  If the extent is small enough, then it just 
zeros out the portions that are not written to, and the whole extent 
becomes a written extent.  Im not sure if that is incorrect or if we 
need to change the test to not compare the extent types.

It looks to me that the code in ext4 that does this is supposed to be an 
optimization to help reduce fragmentation.  We could change the filters 
to print just "extent" instead of "unwritten" or "data", but I realize 
that probably makes the test a lot less effective for xfs.  If anyone 
can think of some more elegant fixes, please let me know.  Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
