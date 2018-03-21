Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32798 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbeCUDjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:39:45 -0400
Subject: [PATCH 00/14] xfsprogs: online scrub fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:39:40 -0700
Message-ID: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch of fixes for the xfs_scrub program that was introduced in
xfsprogs 4.15.

The first nine patches replace the weak name collision scanner of the
original xfs_scrub with a much more powerful one based on a well known
collision finding strategy.  The name scanner still checks all entries
in a directory and all extended attribute keys in a file for names
containing control characters and names with utf8 sequences that
normalize into the same unicode points, which are common methods that
spoofers use to create malicious names.  However, we add in more
powerful scanning capabilities -- first, we can now look for names that
are identical except for zero-width spaces; second, we look for names
with bidirectional overrides; and third, we can warn about long names
that contain well known confusable characters in the same place in both
names (think 'f0' vs 'fO').  As a result of this rewrite, a few buffer
underruns that caused truncated comparisons have been fixed.

The last five patches fix various minor bugs in the xfs_scrub_all
wrapper and service.

If you're going to start using this mess, you probably ought to just
pull from my git tree for xfsprogs[1].

Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
