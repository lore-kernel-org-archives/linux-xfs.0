Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C48AB7CA2
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 22:24:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B44D2304048
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 20:24:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ABEtLlvCEhdnpDBy for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 20:24:26 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSdN9-00072H-MS
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSdN9-0000lk-LF
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 15:24:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3 0/9] xfs: gut the struct xfs_icdinode
Date: Mon,  8 Feb 2016 15:24:12 +1100
Message-Id: <1454905461-2773-1-git-send-email-david@fromorbit.com>
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

This is the thrid version of this patchset, the second version is
here:

http://oss.sgi.com/archives/xfs/2016-01/msg00459.html

There is no change to the space savings the series gives us; it is
an update to address Brian's review comments. Testing over the past
couple of weeks indicates no new regressions, so hopefully this is
the final review posting. :)

Version 3
- fix typos/comments and use sb_meta_uuid (patch 3)
- introduce new patch for reclaimable inode core reinitialisation
  infrastructure (patch 5)
- remove typedefs (patch 6)
- added field reinitialisation to function introduced in patch 5
  (patches 6-9)
- removed stray debug hunk (patch 9)
- added reviewed-by tags to patches that have been reviewed already.

Version 2
- timestamps are signed, so need casting to int before being stored
  in a 64 bit variable when read from disk. Fixes generic/258
  failure (patch 2).
- nlink wasn't being accounted correctly for O_TMPFILE files and
  rename whiteouts. Fixes generic/078 and others. (patch 5)
- VFS does not initialise i_mode, ever, so we need to initialise it
  directly after slab allocation to ensure that we correctly detect
  new file creates and hence don't add the inode the sb list twice,
  corrupting it. (busy inodes after unmount, self destruct in 5
  seconds, have a nice day!) (patch 8)
- when reallocating a reclaimable inode, we need to save the
  variables that hold on-disk values across the inode_init_always()
  call, otherwise we lose them. This results in corruption of these
  fields. (patch 8)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
