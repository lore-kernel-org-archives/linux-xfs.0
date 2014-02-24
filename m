Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D37627F53
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 00:29:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 625F9AC004
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 22:29:37 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wJCTkuzelMVV4XdT for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 22:29:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHp2h-0004rh-RK
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:31 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHp2h-0001L5-QV
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/10, v2] repair: scalability and prefetch fixes
Date: Mon, 24 Feb 2014 17:29:19 +1100
Message-Id: <1393223369-4696-1-git-send-email-david@fromorbit.com>
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

This is a followup to the patchset posted here:

http://oss.sgi.com/archives/xfs/2013-12/msg00495.html

I've made various changes to address the review comments, and
droped the parallelisation of phase 6 after I realised that is was
causing occasional problem in pahse 6 (i.e. the simple patch didn't
make it entirely threadsafe).

There are various other prefetching fixes added to the series as
well that help with scalability - mainly to do with reworking the
way prefetching runs ahead of the processing threads. This allowed
unbound prefetching when the number of inode chunks was less than
the queue depth (typically 16384 inode chunks or 65536 inode cluster
buffers on 512 byte inode filesystems). This was causing the
prefetching to blow out the caches and result in all metadata being
read twice - once for the readhead, then again when it was actually
necessary.

The prefetching was changed to only readahead the AG following the
current one being processed, hence preventing thrashing and an awful
lot of unnecessary IO and buffer cache churn.

I'm not seeing any problems with this series, and performance on CRC
filesystems is now on a par with non-CRC filesystems so there are no
more known xfs_repair performance issues to be addressed with CRC
enabled filesytems after this patch set is applied.

Comments, review, flames and testing welcome!

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
