Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1DEC7F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 13:12:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D477304070
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ltrUV8U7wt8pfNF3 for
	<xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:48 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4GICm1h004879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:48 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4GIClZm024473
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 0/2] xfs: sysfs attribute support
Date: Fri, 16 May 2014 14:12:44 -0400
Message-Id: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
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

This is an rfc to get some discussion rolling on sysfs support for XFS.
The motivation for this work is here:

http://oss.sgi.com/archives/xfs/2014-05/msg00381.html

... and also illustrated by an xfstests test I'll send in conjunction
that demonstrates use of the values exported here. This functionality
creates a /sys/fs/xfs directory at module initialization time and a
per-mount subdirectory for each mounted device.

The basic sysfs support code is pretty much borrowed from ext4. I've
dumped it in xfs_mount.c for lack of a better place. While the currently
exported values are more associated with the log, I'm starting with a
flat directory structure here that seemingly aligns with struct
xfs_mount. That said, I could drop the code into xfs_stats.c or create
an entirely new file if that is preferred.

I'm also interested in thoughts about what else might be exported here,
if anything.  I'm pretty sure we don't want to go and add all kinds of
tunables and knobs just for fun. ;) I suppose things like the current
AIL target or CIL push sequence could be relevant. There's also
opportunity for per-AG data, though that would probably warrant a new
subdirectory for AGs and require another child kobject, perhaps embedded
in xfs_perag.

Dave, I believe you had some ideas along the lines of not just dumping
perag data, but having some element of control over an allocation
group. Care to elaborate a bit more on that?

Thoughts/flames on any or all of this appreciated.

Brian

P.S., From the looks of it, the attributes we end up creating need to be
documented under /Documentation/ABI/testing/, so it's worth thinking
about the desired directory structure a bit up front as well.

Brian Foster (2):
  xfs: add basic per-mount sysfs attribute support
  xfs: sysfs attributes for the current log state

 fs/xfs/xfs_mount.c | 133 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |   2 +
 fs/xfs/xfs_super.c |  12 ++++-
 3 files changed, 146 insertions(+), 1 deletion(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
