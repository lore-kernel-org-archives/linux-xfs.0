Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17271 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbcKEARQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:17:16 -0400
Subject: [PATCH v2 0/9] xfstests: online scrub/repair support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:17:10 -0700
Message-ID: <147830503054.1919.4998804611100937975.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Hi all,

This is the second revision of a patchset that adds to XFS userland
tools support for online metadata scrubbing and repair.

The new patches in this series do three things: first, they expand the
filesystem populate commands inside xfstests to be able to create all
types of XFS metadata.  Second, they create a bunch of xfs_db wrapper
functions to iterate all fields present in a given metadata object and
fuzz them in various ways.  Finally, for each metadata object type there
is a separate test that iteratively fuzzes all fields of that object
and runs it through the mount/scrub/repair loop to see what happens.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
The kernel patches in the git trees should apply to 4.9-rc3; xfsprogs
patches to for-next; and xfstest to master.

The patches have survived all auto group xfstests both with scrub-only
mode and also a special debugging mode to xfs_scrub that forces it to
rebuild the metadata structures even if they're not damaged.  Note that
I haven't thoroughly run the new tests in [3] that try to fuzz every
field in every data structure on disk.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
