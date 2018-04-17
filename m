Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:8271 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750831AbeDQGjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 02:39:25 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: detect corrupt inobt records better
Date: Tue, 17 Apr 2018 16:39:14 +1000
Message-Id: <20180417063916.13069-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk

Hi Folks,

Despite what the subject line says, this isn't a patch set that
looks at inobt records. What it does is catch bad allocations that
occur due to corrupt inobt records that cannot be detected until we
access the inode that has been selected for allocation.

The first patch fixes a dentry cache corruption vector, where we
overwrite an in-use inode via allocation. After scratching my head
about the whacky pathwalk oops, KASAN use-after-free traces and
deadlocks trying to lock inodes in xfs_iget(), Al Viro confirmed
that it smelt like an inode overwrite problem, so that's where I
looked next.

I just recently fixed a very similar inobt record corruption problem
that triggered inode list corruption. That one was on the "read from
disk" side of xfs_iget() - see commit ee457001ed6c ("xfs: catch
inode allocation state mismatch corruption") for details. The dentry
cache corruption was the same problem, just on the "cached in
memory" side of xfs_iget().  The same fix applies here and so I
factored those checks and applied them to both the cache hit and
miss cases.

To avoid the allocation deadlock problems, we have to ensure that
the directory we are allocating in isn't the inode that is selected
for allocation.  We already hold the directory inode locked, so the
attempt to lock it again in xfs_iget() can trigger a deadlock. Hence
we have to detect this before we try to retreive the inode from the
cache. This is the second patch, and it also catches attempts to
allocate special inodes we know are allocated (root inode, rt
inodes, quota inodes) just because it's easy and obviously wrong
to be allocating a known in-use inode.

-----

That's it for the patches, but there's a deeper problem here,
especially on v4 filesystems: we have no reliable way of detecting
inobt record corruption at runtime.

What I've put in place is basic cross checks that catch the result
of a bad allocation, but we still don't really know if the inobt
record was totally ok or not even if the inode on disk is free. It
just prevents us reallocating an inode that is already in use.

e.g. the inobt record could contain a stale inode chunk that has
been stamped with empty inode templates but is now considered free
space due to a crash and log recovery problem. We know the v4 format
has unfixable log recovery issues around inode chunk allocation
(fixed in the v5 format), so there's multiple layers of problems we
could trip over here.  i.e. our cross-check object can also be
corrupt or stale.

IOWs, once we stop trusting that internal filesystem indexes are
correct, we're in a world of pain because we cannot tell what is
valid and what has been corrupted or manipulated. Malicious damage
is a threat model most filesystem structures were never designed to
detect, let alone be robust against, and the v4 format has no
protections at all.

The problem is much more nuanced for v5 filesystems. For v5, we
don't read newly allocated inodes from disk - we implicitly trust
that the inobt record is valid. This is a fair assumption because
CRC and other on-disk validation structures reduce the chance of
undetected corruption substantially compared to v4 filesystems.
However, it means we can't detect inobt corruptions when they do
happen because we have no cross reference that can catch otherwise
undetected corruptions.

That said, with current mkfs defaults - v5 + finobt - we have
redundant metadata that will catch a inobt or finobt corruption
during allocation. Hence we're pretty safe from a single corruption
event going undetected, and the likelyhood that a concurrent
multiple sector corruption corrupts both the finobt and the inobt
records in exactly the same way is highly improbable. Hence v5 +
finobt is quite robust against inobt record corruption without
needing to read and trust the inode on disk to detect corruption.

However, v5 is still not safe against is malicious corruption, where
a bad actor intentionally modifies the on-disk structures to mark
inodes free in both the inobt and the finobt and then recalculates
the CRCs and other metadata. We could check the rmapbt if it's
configured, but an attacker can also manipulate that structure to
say that region does contain inodes. They can also manipulate the
free space btrees to say it's used space and so once we've chased
everything we can cross-check down we still can't reliably detect
malicious corruption attacks on the v5 filesystem structure.

IOWs, even with all the extra on-disk verification the v5 format
has, the only thing we can do to protect against propagation of
malicious corruption is the same thing as for v4: check the inode is
free on disk before allowing the allocation to proceed.

I have not done this, because I think malicious corruption is not
something we can defend against. Hence it makes no sense to add
checks that reduce performance but don't provide any extra
benefit to device-based corruption detection or propagation
prevention. IOWs, I don't think we should try to mitigate
malicious corruption attack scenarios.

I think we need to keep improving our bounds checking and structure
corruption detection, but we should not worry about things that take
multiple, highly improbably structure corruptions that are hihgly
expensive to detect and/or mitigate. i.e.  unprivileged mounts of
untrusted XFS filesystem images should never, ever be allowed.

What does everyone else think about this? Darrick, I'm sure you've
got some thoughts on this :)

Cheers,

Dave.
