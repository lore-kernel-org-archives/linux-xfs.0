Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39896 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbeJICqX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 22:46:23 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported devices
Date: Mon,  8 Oct 2018 14:32:46 -0500
Message-Id: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org

In response to an earlier xfs patch to change how xfs reacts to
dax incompatibilities, Dave said:

> I suspect we need to be more harsh are rejecting mounts with -o dax
> on devices DAX isn't supported on. This mount option is going into
> production systems - it's not just for "testing" as the comments all
> claim. i Things will break in production systems if DAX isn't
> enabled and they are expecting it to be enabled.

and I tend to agree, so proposing this change to hard-fail a dax mount if
the device doesn't support it, instead of silently disabling the
functionality.  Proposing for ext2, ext4, and xfs to keep behavior in
sync.

Thanks,
-Eric
