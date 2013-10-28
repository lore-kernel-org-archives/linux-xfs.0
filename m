Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A5B727F51
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 17:00:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87AC3304053
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 15:00:21 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id wI4vWCNnSaB0PRvz for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 15:00:19 -0700 (PDT)
Message-Id: <20131028204715.921910478@sled1.home.jeffreymahoney.com>
Date: Mon, 28 Oct 2013 16:47:15 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 0/3] xfstests: for btrfs publishing/export patchset (v3)
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
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com

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

-Jeff

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
