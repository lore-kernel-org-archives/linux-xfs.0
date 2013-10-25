Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE07B7F51
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 15:56:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA743304059
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 13:56:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9j8B7TUi9YJa3p4X for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 13:56:44 -0700 (PDT)
Message-Id: <20131025205246.269327744@suse.com>
Date: Fri, 25 Oct 2013 16:52:46 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 0/3] xfstests: tests for btrfs publishing/export patchset
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

100: Test new global metadata reservation ioctl
101: Test new sysfs exporting of allocation and device membership
102: Test new sysfs exporting of feature bits
103: Test setting/clearing feature bits via ioctl
104: Test setting/clearing feature bits via sysfs

As part of the ioctl testing, I added a helper that can be extended
easily to export simple information via ioctl. This means that the
tests can be independent of btrfsprogs version or its output formatting.

-Jeff

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/29307


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
