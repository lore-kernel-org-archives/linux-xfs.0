Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbeEKT1G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 15:27:06 -0400
From: Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/2] vfs: better dedupe permission check
Date: Fri, 11 May 2018 12:26:49 -0700
Message-Id: <20180511192651.21324-1-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Hi,

The following patches fix a couple of issues with the permission
check we do in vfs_dedupe_file_range().

The first patch expands our check to allow dedupe of a readonly file
if the user owns it. Existing behavior is that we'll allow dedupe only
if:

- the user is an admin (root)
- the user has the file open for write

This makes it impossible for a user to dedupe their own file set
unless they do it as root, or ensure that all files have write
permission. There's a couple of duperemove bugs open for this:

https://github.com/markfasheh/duperemove/issues/129
https://github.com/markfasheh/duperemove/issues/86

The solution is simple - we allow dedupe of the target if the user
owns it. With that patch, a user can dedupe all of their files.

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
