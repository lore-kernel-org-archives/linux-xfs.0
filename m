Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B59F7F4E
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:43:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCE85AC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:43:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	HENJiXTJBRiiYyhq for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:43:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yNe-0005HR-0A
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yNd-0001u3-UR
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] libxfs: code rearrangement
Date: Thu,  8 Jan 2015 08:42:59 +1100
Message-Id: <1420666983-7275-1-git-send-email-david@fromorbit.com>
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

Here's a few small patches that reflect changes to the libxfs layout
as I've been working on the userspace update. The header files are
common to both user and kernel space, so shoul dbe in libxfs, and
there's a couple of bmap related structures and function prototypes
that can be moved back to libxfs now that the kernel stack split
code have moved into the btree code.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
