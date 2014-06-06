Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1C387F47
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F3B48F8035
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p2YDWzYW0yaAJUBR for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:37 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDZkD025357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:36 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZn6009698
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/6] xfs sysfs support
Date: Fri,  6 Jun 2014 09:13:28 -0400
Message-Id: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here's a first version of sysfs support for XFS. This is based on and
incorporates feedback from the rfc, available here:

	http://oss.sgi.com/archives/xfs/2014-05/msg00425.html

The idea of using debugfs instead was brought up, but not much
discussion around it, so I've left things as is with respect to using
sysfs.

This series creates new xfs_sysfs.[c,h] source files to contain the
general infrastructure for sysfs attribute files in XFS, creates a
global kset for the module (represented as /sys/fs/xfs) and embeds a
couple kobjects to start creating an attribute heirarchy.

Patch 1 fixes what looks like a couple minor error handling errors in
xfs_mountfs(). Patches 2-5 add the sysfs infrastructure, objects and
attributes. Patch 6 adds documentation for the newly defined attributes.

Thoughts, reviews, flames appreciated.

Brian

v1:
- Move sysfs infrastructure code to new source file, add helpers for
  object initialization, etc.
- Created an xfs_mount->xlog object heirarchy for attributes associated
  with the log.
- Renamed the reserve/write grant head attributes to
  '[reserve,write]_grant_head.'
- Use the 'cycle:block' or 'cycle:bytes' decimal format for attributes
  (rather than export encoded values).
- Included generic mountfs fix and doc.

Brian Foster (6):
  xfs: fix a couple error sequence jumps in xfs_mountfs()
  xfs: add a sysfs kset
  xfs: add xfs_mount sysfs kobject
  xfs: add xlog sysfs kobject and attribute handlers
  xfs: add log attributes for log lsn and grant head data
  xfs: document log sysfs attributes in testing ABI

 Documentation/ABI/testing/sysfs-fs-xfs |  39 ++++++++
 fs/xfs/Makefile                        |   1 +
 fs/xfs/xfs_log.c                       |   9 ++
 fs/xfs/xfs_log_priv.h                  |   3 +
 fs/xfs/xfs_mount.c                     |  19 +++-
 fs/xfs/xfs_mount.h                     |   2 +
 fs/xfs/xfs_super.c                     |  12 ++-
 fs/xfs/xfs_sysfs.c                     | 175 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h                     |  47 +++++++++
 9 files changed, 303 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-xfs
 create mode 100644 fs/xfs/xfs_sysfs.c
 create mode 100644 fs/xfs/xfs_sysfs.h

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
