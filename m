Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 555467FA4
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 07:07:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A3AA304064
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 05:07:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CU3shJFafJ222j7N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 05:07:03 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5RC72Wc019748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s5RC71Db017580
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 08:07:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/6] xfs sysfs support
Date: Fri, 27 Jun 2014 08:06:55 -0400
Message-Id: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of sysfs support for XFS. The previous version is available
here:

	http://oss.sgi.com/archives/xfs/2014-06/msg00141.html

This version is rebased onto the latest for-next and further cleans up
the code to use some abstractions for sysfs object maintenance and
associated helpers. As noted in the v1 thread, I think the current doc
patch already indicates that the sysfs attrs are not considered stable.
Unless there is further feedback on that front, I'll leave that patch as
is.

Brian

v2:
- Rebased to latest for-next (error negation, libxfs).
- Introduce xfs_kobj container for kobject and completion.
- Genericize kobject release function.
- Move snprintf() outside of iclog lock in log_head_lsn_show(). Clean up
  xlog handlers.
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
 fs/xfs/xfs_linux.h                     |  11 +++
 fs/xfs/xfs_log.c                       |   9 ++
 fs/xfs/xfs_log_priv.h                  |   2 +
 fs/xfs/xfs_mount.c                     |  18 +++-
 fs/xfs/xfs_mount.h                     |   1 +
 fs/xfs/xfs_super.c                     |  12 ++-
 fs/xfs/xfs_sysfs.c                     | 165 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h                     |  59 ++++++++++++
 10 files changed, 313 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-xfs
 create mode 100644 fs/xfs/xfs_sysfs.c
 create mode 100644 fs/xfs/xfs_sysfs.h

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
