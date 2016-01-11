Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35BFD7F3F
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 21:26:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B18A304039
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2016 19:26:02 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wfImvGEvLydWBwwY for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2016 19:25:56 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aIT6H-0001Zt-F9
	for xfs@oss.sgi.com; Mon, 11 Jan 2016 14:24:57 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aIT6H-00079N-E8
	for xfs@oss.sgi.com; Mon, 11 Jan 2016 14:24:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2 v3] xfs: handle dquot buffer readahead in log recovery
	correctly
Date: Mon, 11 Jan 2016 14:24:52 +1100
Message-Id: <1452482694-27314-1-git-send-email-david@fromorbit.com>
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

Version 3 of this patchset. Version 2 of the patchset added a fix
for the inode readahead error setting in log recovery, which turned
out to be problematic.

I've split that change out into it's own patch which includes the
fix it requires to prevent a race condition in log recovery to do
with inode buffer creation recovery. This is a generic fix to
xfs_buf_get_map(), in that if we are returning an initialised buffer
for the caller to use, it shouldn't have an error set on it from the
previous operation. If we don't clear the error before returning the
buffer, it causes unexpected failures further down the line. This
caused log recovery failures in generic/073 on slow disks (i.e.
needed sufficient readahead IO latency to open the race window) and
a couple of other tests as well.

The second patch is essentially the original patch with just the
inode buffer changes removed. There are no other changes to that
patch.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
