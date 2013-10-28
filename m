Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 263BB7F50
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 14:54:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2B21AC044
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 12:54:48 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uemTQxpkTy9IZE5H for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 12:54:43 -0700 (PDT)
Message-Id: <20131028195204.611287480@sled1.home.jeffreymahoney.com>
Date: Mon, 28 Oct 2013 15:52:04 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/3] xfstests: for btrfs publishing/export patchset (v2)
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

-Jeff

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
