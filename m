Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeECSF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 14:05:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w43I10pY087029
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:05:55 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2hmgxg30kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 03 May 2018 18:05:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w43I5tGb002944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:05:55 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w43I5s4j002602
        for <linux-xfs@vger.kernel.org>; Thu, 3 May 2018 18:05:54 GMT
Subject: [PATCH v4 00/12] xfs-4.18: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 May 2018 11:05:53 -0700
Message-ID: <152537075334.16676.10600900179473864298.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a revised series cleaning up some problems and bugs found by
stressing the online scrub code.  Most of the problems fixed here were
uncovered through more thorough testing of the online repair series,
which was posted previously.

The first patch replaces a panic() call in the bmap debugging verifiers
with logging code that doesn't take the whole system down.  This helps
us to avoid panic reboots while running generic/388.  The second patch
fixes an uncaught error return in the rmap code.

Then, we amend scrub to skip cross-referencing once the first error is
found; this patch hasn't changed since its posting during the 4.17 cycle.
Second is a patch adding more "finish scrub as soon as we've decided
CORRUPT" checks.

The next two patches refactor the quota scrub to drop all the weird code
that attaches to the quota ip in favor of using the well known mechanism
that we use for all other inodes.  This enables us to call the data fork
scrubber on the quota inodes; and the dquot iterator that we created
earlier.  We also adapt the rtbitmap/rtsum scrubbers to check the data
forks with the same helper.

The next two patches fix some broken interaction between scrub and the
rest of xfs.

Following that are three fixes to the scrubbers themselves -- the first
checks that a btree block never contains fewer than minrecs records
unless it's the top block in a tree.  The second refactors the
transaction allocation helper; and the last one fixes a potential ABBA
deadlock in the parent scrubber.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc3.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

This is an extraordinary way to eat your data.  Enjoy!
Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
