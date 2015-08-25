Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1FEE7F37
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 00:06:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21A38F804B
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 22:06:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	YGvC1rC7aA1ZU48N for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 22:06:09 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZU6Ql-0001qs-HC
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 15:05:55 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZU6Ql-0000lG-GA
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 15:05:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4 v2] xfs: get rid of xfs_cluster_write()
Date: Tue, 25 Aug 2015 15:05:49 +1000
Message-Id: <1440479153-1584-1-git-send-email-david@fromorbit.com>
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

This is the second version of the patchset that removes
xfs_cluster_write() in preference to using state in
generic_writepages to enable clustering of pages. The full
description from the v1 patchset is here:

http://oss.sgi.com/archives/xfs/2015-08/msg00224.html

The end result is effectively unchanged from version 1, just the
breakdown of the patches is different to the original posting, as
requested by Christoph.

-Dave.

Version 2:
- promote removal of non-blocking behaviour to be an initial cleanup
  patch
- collapse staged introduction of struct xfs_writepage_context into
  a single patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
