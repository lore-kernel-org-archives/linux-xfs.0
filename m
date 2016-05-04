Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4829A7CA6
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 10:43:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0921AC003
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 08:43:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h9aHSekKpiIBpqVe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 08:43:27 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id CD77D2027D
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 15:43:26 +0000 (UTC)
Received: from zion.usersys.redhat.com (unused [10.10.50.11] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u44FhPoE012561
	for <xfs@oss.sgi.com>; Wed, 4 May 2016 11:43:25 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/7] Configurable error behavior [V3]
Date: Wed,  4 May 2016 17:43:13 +0200
Message-Id: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
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

This is the new revision of this patchset, according to last comments.

This patchset is aimed to implement a configurable error behavior in XFS, and
most of the design has been done by Dave, so, that's why I kept his signed-off
in the patches.

This new revision has the detailed changelog written on each patch, but the
major changes are:

	- Detailed changelog by-patch and description fixed to become
	  (hopefuly) more clear
	- kept fail_at_unmount as a sysfs attribute


Regarding fail_at_unmount, I left it almost exactly as Dave's design, giving his
comments on the last revision, although, I still think there is no need to keep
it as a per-error granularity, so, I was wondering if a single, global option in
/sys/fs/xfs/<dev>/error/fail_at_unmount wouldn't suffice, but, this will require
a new place to store the value inside kernel, instead of keeping it inside
struct xfs_error_cfg, or maybe use the same structure but use it outside of the
m_error_cfg array?

First 6 patches are ready, the fail_at_unmount one, need to be re-worked if we
want it in a less granular way, but until now I don't think we reached any
decision about how it should be implemented.

 fs/xfs/xfs_buf.h      |  22 ++++
 fs/xfs/xfs_buf_item.c | 126 ++++++++++++++--------
 fs/xfs/xfs_mount.c    |  19 +++-
 fs/xfs/xfs_mount.h    |  32 ++++++
 fs/xfs/xfs_sysfs.c    | 283 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h    |   3 +
 6 files changed, 437 insertions(+), 48 deletions(-)

-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
