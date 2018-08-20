Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38458 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbeHTIDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:06 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006Rw-2M
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7a-0000Q5-VS
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] xfs: feature flag rework
Date: Mon, 20 Aug 2018 14:48:41 +1000
Message-Id: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

This series reworks how the kernel code handles feature bits. It
seemed to me to be a bit crazy to repeatedly have to check multiple
values in the superblock to check whether a feature is supported.
e.g. to check if reflink is available, we first mask the version
number to extract it from the superblock field, then we check it
against the v5 value, then we load and check the feature bit from
the superblock.

This could all just be a single flag check - a flag that is set at
mount time after doing all of the above, and so it's just a single
operation to check.

I'm also tired of typing "xfs_sb_version_hasfoo" everytime a check
needs to be done. Not to mention having a different mechanism to
check mount option based features.

And then there's the conflation of mount option feature flags and
runtime state in the one set of flags. The flags field is not
updated atomically, so there no guarantee that a change of a state
flag does race with anything else and we lose it.

So this patch set moves all the feature flags into a new m_features
field in the struct xfs_mount. It doesn't matter if they are mount
options or superblock feature bits - they all end up in the one
place whether they are [almost entirely] read only. These are now
checked by "xfs_has_foo(mp)" functions (following the ext4 feature
check syntax), and for the very few features that can be dynamically
added or removed there are also xfs_feat_add/remove_foo(mp) helpers.
IOWs, both superblock and mount option features are checked the same
way.

The state flags (clean mount, unmounting, shutdown, etc) are all
moved to a new m_state field, which is manipulated entirely by
atomic bitops to avoid update races. THere are a couple of wrappers
for the common checks - xfs_is_read_only(mp) and
xfs_is_shut_down(mp). The latter replaces the XFS_FORCED_SHUTDOWN()
macro.

There's a bit of extra work around the attr2 feature bit - we've got
the superblock bit, and then "attr2" and "noattr2" mount options and
somewhat convoluted interactions. This patchset changes the
behaviour of all these now - the attr2 bit on disk and mount option
now mean the same thing, and noattr2 will turn off the superblock
bit if it is set and prevent attr2 inodes from being created. This
simplifies the mount time checking and clearing of these features.

Also, it gives us a clean separation of "inode32 mount option" and
"inode32 allocation is active". The former is a feature bit (i.e.
SMALL_INUMS), and the latter is a state bit (32BITINODES) that is
set if the filesystem size requires the allocator to limit
allocation to 32 bit inode space.

This also allows us to get rid of all the xfs_sb_version_hasfoo()
inline functions. THere is a single function to populate m_features
from the superblock bits, and the low level checks that are purely
superblock based (i.e. on disk conversion and verifiers) directly
check the superblock fields rather than use wrappers.

Overall, this doesn't change the amount of code. If does reduce the
built binary size by about 3.2kB, mainly through replacing the
xfs_sb_version...() checks with a single m_features flag check. It
makes the code a bit simpler, easier to read, and less shouty and
separates runtime state from filesystem features.

-Dave.
