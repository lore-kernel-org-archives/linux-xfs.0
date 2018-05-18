Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56682 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750763AbeERV5o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 May 2018 17:57:44 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v2 0/2] vfs: better dedupe permission check
Date: Fri, 18 May 2018 14:57:25 -0700
Message-Id: <20180518215727.26418-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Adam Borowski <kilobyte@angband.pl>

Hi,

The following patches fix a couple of issues with the permission
check we do in vfs_dedupe_file_range().

The first patch expands our check to allow dedupe of a file if the
user owns it or otherwise would be allowed to write to it.

Current behavior is that we'll allow dedupe only if:

- the user is an admin (root)
- the user has the file open for write

This makes it impossible for a user to dedupe their own file set
unless they do it as root, or ensure that all files have write
permission. There's a couple of duperemove bugs open for this:

https://github.com/markfasheh/duperemove/issues/129
https://github.com/markfasheh/duperemove/issues/86

The other problem we have is also related to forcing the user to open
target files for write - A process trying to exec a file currently
being deduped gets ETXTBUSY. The answer (as above) is to allow them to
open the targets ro - root can already do this. There was a patch from
Adam Borowski to fix this back in 2016:

https://lkml.org/lkml/2016/7/17/130

which I have incorporated into my changes.


The 2nd patch fixes our return code for permission denied to be
EPERM. For some reason we're returning EINVAL - I think that's
probably my fault. At any rate, we need to be returning something
descriptive of the actual problem, otherwise callers see EINVAL and
can't really make a valid determination of what's gone wrong.

This has also popped up in duperemove, mostly in the form of cryptic
error messages. Because this is a code returned to userspace, I did
check the other users of extent-same that I could find. Both 'bees'
and 'rust-btrfs' do the same as duperemove and simply report the error
(as they should).

The patches are also available in git:

git pull https://github.com/markfasheh/linux dedupe-perms

Thanks,
  --Mark


Changes from V1 to V2:
- Add inode_permission check as suggested by Adam Borowski
- V1 discussion: https://marc.info/?l=linux-xfs&m=152606684017965&w=2
