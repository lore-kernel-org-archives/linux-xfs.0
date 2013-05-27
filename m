Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 972B329DF8
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 06:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 769278F8037
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 04:39:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TR2L4Ot1IbSEZQ2Y for <xfs@oss.sgi.com>;
	Mon, 27 May 2013 04:39:40 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Ugvm5-0000OB-Fg
	for xfs@oss.sgi.com; Mon, 27 May 2013 21:39:37 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Ugvm5-0006sd-A3
	for xfs@oss.sgi.com; Mon, 27 May 2013 21:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: changes for 3.11
Date: Mon, 27 May 2013 21:39:30 +1000
Message-Id: <1369654773-26391-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

three patches for the 3.11 cycle. The first two i've posted
previously to reduce buffer cache lookups for inode creation and
inode unlink.

The third is a new patch that modifies speculative preallocation to
be nicer in small file workloads. It solves anissue where a specific
workload triggers freespace fragmentation problems due to writeback
being triggered with the speculative preallocation beyond EOF
still attached to the file and then never being used.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
