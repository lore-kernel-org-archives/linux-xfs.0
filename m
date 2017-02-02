Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:34664 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdBBQqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 11:46:10 -0500
Received: by mail-ot0-f175.google.com with SMTP id f9so16131600otd.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Feb 2017 08:46:10 -0800 (PST)
MIME-Version: 1.0
From: fuser ct1 <fuserct1@gmail.com>
Date: Thu, 2 Feb 2017 16:46:09 +0000
Message-ID: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com>
Subject: Safe XFS limits (100TB+)
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello list.

Despite searching I couldn't find guidance, or many use cases, regarding
XFS beyond 100TB.

Of course the filesystem limits are way beyond this, but I was looking for
real world experiences...

Specifically I'm wondering about the sanity of using XFS with a couple of
144TB block devices (my system will have two 22x8TB R60 in a 44 bay JBOD).
My storage is used for video editing/post production.

* Has anybody here tried?
* What is the likelihood of xfs_repair/check finishing if I ever needed to
run it?
* Am I nuts?

I know that beyond a certain point I should be looking at a scale out
option, but the level of complexity and cost goes up considerably.

More info:
=======

Previously I had an 80TB usable (96TB raw) with an LSI MegaRAID 9361
controller. This worked very nicely and was FAST. I was careful to choose
the inode64 fstab mount option. The OS was Debian Jessie, which has
XFSPROGS version 3.2.1.

Thanks in advance and sorry if this is not the right list.
