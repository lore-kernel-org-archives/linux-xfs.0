Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37746 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdF3IdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 04:33:04 -0400
Received: by mail-it0-f43.google.com with SMTP id m84so20806202ita.0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Jun 2017 01:33:04 -0700 (PDT)
MIME-Version: 1.0
From: Alphazo <alphazo@gmail.com>
Date: Fri, 30 Jun 2017 10:33:03 +0200
Message-ID: <CAHJqNbyngon0T1wnYpM6f+cWYzCrZjM9a6mp54QHgayeS9Bq5A@mail.gmail.com>
Subject: Any tips for moving to reflink?
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

xfs never stops impressing me. Most if not all of my storage has been
converted to it, including a 30TB+ unRaid server. I have been
contemplating snapshot and dedup enabled filesystems like btrfs and
ZFS but couldn't justify the jump. The new xfs reflink feature seems a
good addition and compromise to a stable and proven filesystem.
I'm strongly considering using the experimental reflink feature for my
new photo drive. This will be done in a controlled environment with
multiple backups.
Are there any general rules of conduct when working with a dedup
filesystem, like never go above 80% disk usage or never trust df/dh
results?
Also is there any risk of trying to mount a reflink enabled xfs
filesystem on an older kernel that doesn't know about it?

I don't think I need it for the moment but would enabling rmapbt as
well add any risk to the data integrity or impact performance? Can
rmapbt be enabled later on an existing filesystem if required? Will
rmpabt be only used to enhance filesystem recovery?

I'm planning to use this reflink feature for instant local snapshots
and then use my backup software of choice, borg, to keep a long time
history of my work on a remote server. Since borg stores data in a
dedup fashion I can also backup the reflink snapshots and they won't
take additional space. The only drawback is that today borg need to
hash all the files found in a reflink directory in order to find out
about dedup blocks. I asked a question on the borg mailing list
https://github.com/borgbackup/borg/issues/2743 and apparently it won't
be an issue to add a feature to support XFS in order to identify the
physical extents. Is rmapbt required for that?

Alphazo
