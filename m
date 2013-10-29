Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 931FC7F53
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 14:30:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D2ACAC088
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 12:30:50 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EPaeGpk7W5svnGYb for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 12:30:48 -0700 (PDT)
Message-Id: <20131029192653.194827430@suse.com>
Date: Tue, 29 Oct 2013 15:26:53 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 0/3] xfstests: for btrfs publishing/export patchset (v4)
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
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>

These are the tests that Josef requested accompany the submission of
the btrfs publishing/export patchset[1].

021: Test new global metadata reservation ioctl
022: Test new sysfs exporting of allocation and device membership
023: Test new sysfs exporting of feature bits
024: Test setting/clearing feature bits via ioctl
025: Test setting/clearing feature bits via sysfs

As part of the ioctl testing, I added a helper that can be extended
easily to export simple information via ioctl. This means that the
tests can be independent of btrfsprogs version or its output formatting.

V2:
- Used next numbers in sequence
- Better commit messages
- Fixed handling of the missing feature cases
- Fixed issues raised in Josef's review

V3:
- Fixed missing output in btrfs/023 when the ioctls arent't supported
- Fixed missing umount introduced in V2

V4:
- I was running the tests directly, not through check and didn't catch these:
 - Fixed incorrect output from 022 while running under check
 - Added tests to group file

-Jeff

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
