Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38BF27FA4
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:11:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 285468F8059
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:11:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	g5S5G0mUyiuqWgpG for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:11:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFyx-0000Kx-10
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFyw-0005Aj-T1
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/22] xfs: metadata CRCs, fourth version
Date: Wed,  3 Apr 2013 16:11:10 +1100
Message-Id: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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

Hi Folks,

New CRC patchset. Previous versions:

http://oss.sgi.com/archives/xfs/2013-01/msg00328.html
http://oss.sgi.com/archives/xfs/2013-02/msg00451.html
http://oss.sgi.com/archives/xfs/2013-03/msg00291.html

This version is based on 3.9-rc4 + TOT xfsdev. 3.9-rc5 has loopback
bugs that make it useless for testing, so I've just kept my tree on
-rc4.

New in this patch set:

        - numerous bug fixes
	- cleanups to addresse Bens review comments
	- logs entire inode allocation buffers
	- reworks the buffer type tracking for log recovery
	- fixes the endian issues reported by sparse
	- splits out the symlink code rearrangement
	- adds support for v5 superblock feature masks
        - add mount warnings about CRC support being experimental

Still to do:

        - Documentation (half written, not in series)
        - DT_* type fields in the directory entries. This can be
	  done with a feature bit if not done in time.
        - storage of attributes larger than 256 bytes in shortform
          attribute forks. Same comment about a feature bit.

The addition of the feature mask support to the superblock added a
new field to the superblock - a log compatibility feature mask. This
is to allow new transactions and recovery features to be added and
prevent kernels that don't understand those features from performing
log recovery. The idea is that clean logs can be mounted by kernels
that don't support the new feature if everything else is compatible,
but if they require log recovery the mount will be aborted. This
means pure log changes don't require a compat/incompat/rocompat
feature bit to be set.

The result of adding this is that all the old CRC enabled
filesystems will not work with this kernel - the CRC field location
changed, and that makes the mount fail hard. So a new userspace will
be needed to test the CRC side of this patchset. (Coming soon!)

Comments, testing welcome...

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
