Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f41.google.com ([209.85.161.41]:35671 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfAYO2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jan 2019 09:28:04 -0500
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 25 Jan 2019 16:27:52 +0200
Message-ID: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
Subject: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>

Hi,

I would like to discuss the concept of lazy file reflink.
The use case is backup of a very large read-mostly file.
Backup application would like to read consistent content from the
file, "atomic read" sort of speak.

With filesystem that supports reflink, that can be done by:
- Create O_TMPFILE
- Reflink origin to temp file
- Backup from temp file

However, since the origin file is very likely not to be modified,
the reflink step, that may incur lots of metadata updates, is a waste.
Instead, if filesystem could be notified that atomic content was
requested (O_ATOMIC|O_RDONLY or O_CLONE|O_RDONLY),
filesystem could defer reflink to an O_TMPFILE until origin file is
open for write or actually modified.

What I just described above is actually already implemented with
Overlayfs snapshots [1], but for many applications overlayfs snapshots
it is not a practical solution.

I have based my assumption that reflink of a large file may incur
lots of metadata updates on my limited knowledge of xfs reflink
implementation, but perhaps it is not the case for other filesystems?
(btrfs?) and perhaps the current metadata overhead on reflink of a large
file is an implementation detail that could be optimized in the future?

The point of the matter is that there is no API to make an explicit
request for a "volatile reflink" that does not need to survive power
failure and that limits the ability of filesytems to optimize this case.

I realize the "atomic read" requirement is somewhat adjacent to
the "atomic write" [2] requirement, if not only by name, but I am
not sure how much they really share in common?

A somewhat different approach for the problem is for the application
to use fanotify to register for pre-modify callback and implement the
lazy reflink by itself. This could work but will require to extend the
semantics of fanotify and application currently needs to have
CAP_SYS_ADMIN, because it can block access to file indefinitely.

Would love to get some feedback about the concept from filesystem
developers.

Thanks,
Amir.

[1] https://lwn.net/Articles/719772/
[2] https://lwn.net/Articles/715918/
