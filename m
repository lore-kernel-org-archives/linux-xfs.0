Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 461307CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 10:20:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7709AC004
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Q1NAuCMZcrEaA5y0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:12 -0700 (PDT)
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/3] xfsprogs: xfs_quota foreign fs path handling modifications
Date: Wed, 14 Sep 2016 10:19:38 -0500
Message-Id: <1473866381-28975-1-git-send-email-billodo@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com


Hello-

This is a new series that supercedes:
http://www.spinics.net/lists/xfs/msg42220.html -
(xfs_quota foreign fs path handling changes).

The following commits modified xfs_quota for use on foreign
filesystems:
b20b6c2 xfs_quota: certain commands must always be available
29647c8 xfs_quota: add capabilities for use on non-XFS filesystems

Included in those commits were modifications to
fs_initialise_mounts (paths.c), resulting in a reverse
compatibility issue. In particular, xfstest xfs/261 failed,
due to foreign fs paths being picked up from the fs table,
and the xfs_quota print command complaining about not being
able to print the foreign paths.

This series fixes the foreign path print problem, via
modifications to the xfs_quota paths and print operations.

patch 1: populate the fs table with xfs entries first,
maintaining mtab order, followed by foreign fs entries.

patch 2: adjust print and path formatting of xfs and
foreign fs entries, maintaining reverse compatibility.

patch 3: add the case for foreign fs in init_check_command
to cover both states of the -f (foreign_allowed) flag.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
