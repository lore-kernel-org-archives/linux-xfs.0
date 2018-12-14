Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbeLNMex (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 07:34:53 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E841790B12
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:52 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0917261A6
        for <linux-xfs@vger.kernel.org>; Fri, 14 Dec 2018 12:34:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/5] XFS near block allocation algorithm prototype
Date: Fri, 14 Dec 2018 07:34:47 -0500
Message-Id: <20181214123452.20974-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a prototype of a rework for the NEAR type block allocation
algorithm in XFS. As a bit of background, this came up recently in a
thread[1] from a user report of terrible allocation performance on a
filesystem with at least one AG with highly fragmented free space. The
cause of the performance degradation is the reliance on the brute force
bnobt search as a fallback in the current algorithm.

A couple ideas materialized through this discussion. The first was to
take advantage of the fact that a cntbt extent lookup already supports
the ability to use the agbno as a secondary key. This allows us to find
an extent with ideal locality of a particular size and could help
optimize the NEAR algorithm. The second was a high level observation
that each of the current near, size and exact allocation types have a
unique implementation for allocation algorithms that ultimately aren't
all that much different from eachother. While playing around with this
further, I also pondered the idea of storing maximum record length data
in non-leaf bnobt keys in support of an optimized seek mechanism (i.e.,
find the next closest extent of a minimum size without having to process
each record), but that's a thought experiment and separate discussion
atm.

The purpose of this prototype is to try and rework the NEAR allocation
algorithm into something that is a bit more efficient with an eye
towards longer term reuse for the other higher level allocation types.
At the moment, this prototype only covers the common case of
>=args.maxlen extents. It is very lightly tested and only performance
tested enough to determine that it prospectively improves allocation
performance on a metadump associated with [1] without any obvious
regression from a very simple fs_mark test. I see a factor of 10
increase in small file allocation performance (files/sec) on the
associated fs_mark test. I'm sending an RFC at this point because this
is the minimal implementation that includes potential high level
algorithm changes. I would obviously like to solicit any thoughts,
feedback or ideas on the core allocation algorithm before getting too
far into refining this further.

On the details of the algorithm update, the original thought was to
replace the bnobt scan with a basic cntbt lookup (that incorporated
agbno). I ended up using an approach to perform iterative cntbt lookups
in combination with a bnobt scan for several reasons. First, the bnobt
lookup is actually more efficient for smaller allocations. If we
consider that NEAR lookups are used not just for user data, but for
inodes, inode btree blocks, bmap btree blocks, etc., it's pretty clear
that many of these are generally smaller (even single block) allocations
that are trivially completed with a bnobt lookup. Second, I didn't have
a great means otherwise to determine when to cap cntbt lookups outside
of going to the end of the tree. Third, a one time agbno+len cntbt
lookup is essentially a crapshoot with regard to locality, so I don't
think that is an appropriate solution.

The idea of using both trees in this manner is to essentially balance
eachother out. Smaller allocations are likely to be more efficient
through the bnobt while larger allocations are likely to be more
efficient through the cntbt. Admittedly, I do still need to figure a way
to try and measure "allocation locality effectiveness" so I can at least
compare with the current algorithm.

Beyond the obvious need for design review and more thorough regression
and performance testing, etc., there are still plenty of changes
required to make this production worthy. I expect to add minlen support
for the case where there are no maxlen extents available as well as to
fold in the small allocation case and eventually replace (i.e. remove)
the existing NEAR alloc code. The prototype implementation is simply
bolted on in a manner to facilitate experimentation.

In the longer term, I think the implementation can fairly easily support
the existing EXACT and SIZE allocation modes with some minor
enhancements to consider allocation type at the appropriate points. For
example, a SIZE allocation could simply elide bnobt cursor allocation at
setup time and stop the search as soon as the first usable extent is
found. In other words, it's a NEAR search without any locality
requirement. I think we could do something similar for the EXACT case by
allocating a single bnobt cursor and stopping the allocation sequence as
soon as we process the first extent, regardless of whether it satisfies
the exact allocation requirement.

Finally, note that the first four patches are refactors/cleanups of the
existing code but aren't technically required for patch 5. I started out
on this by refactoring the existing code in anticipation of shifting
bits around and whatnot (and because it made it easier to reason about)
and instead ended up bolting on additional code for the time being. I'm
including the refactoring patches simply because they are the base in my
tree for patch 5, but for the purposes of the RFC they can probably be
ignored.

Thoughts, reviews, flames appreciated.

Brian

[1] https://marc.info/?l=linux-xfs&m=154028142608367&w=2

Brian Foster (5):
  xfs: factor out bnobt based near allocation algorithm
  xfs: factor out cntbt based near allocation algorithm
  xfs: refactor near alloc small case
  xfs: clean up variable names in xfs_alloc_ag_vextent_near()
  xfs: new cntbt based near allocation algorithm

 fs/xfs/libxfs/xfs_alloc.c | 956 +++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trace.h        |   1 +
 2 files changed, 726 insertions(+), 231 deletions(-)

-- 
2.17.2
