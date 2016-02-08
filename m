Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC5DB7CA6
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 23:44:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E407AC001
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 21:44:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Fp7GqDLGemTQXuaI for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 21:44:23 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSecX-0007Aq-Pn
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSecX-00021P-P8
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5 v3] xfs: get rid of xfs_cluster_write()
Date: Mon,  8 Feb 2016 16:44:13 +1100
Message-Id: <1454910258-7578-1-git-send-email-david@fromorbit.com>
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

Still clearing out my pending patches. This one was last posted
almost 6 months ago:

http://oss.sgi.com/archives/xfs/2015-08/msg00523.html

The main issue at the time was the fact that the ioends were added
to the writepage context and only submitted once
write_cached_pages() was done, resulting in building up a large
number of writeback pages and allocated ioends before IO submission
was done. hence we could potentially prevent writeback progress from
being made due to mempool starvation as we weren't following the
required rules for the ioend mempool.

This is addressed in the new patch 5. instead of chaining ioends
onto the writepage context, we submit completed ioends the moment we
are done processing the page that triggered allocation of a new
ioend. Hence we issue ioends as they are built, rather than as a
batch once page processing is done. This ensures that writeback
follows the rules required for mempools to work effectively and we
won't deadlock due to mempool starvation during low memory
writeback.

This modified patch set has been sitting in my queue now for almost
4 months, so it's time to get it moved onwards...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
