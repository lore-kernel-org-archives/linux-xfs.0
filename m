Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56360 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/7] xfsprogs: libxfs spring cleaning take 3
Date: Mon, 20 May 2019 22:47:00 -0500
Message-Id: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Ok, i'll be damned if I have a nice handle on libxfs namespace still,
so just drop the 2 patches that touched it in any way, shape, or form.
Also drop the libxfs_getsb() arg patches, since Darrick would like me
to merge that from kernelspace later.

So this series just does some cosmetic fixups, mostly with an eye
towards sharing xfs_trans_inode.c with the kernel, which does finally
happen in patch 7.

ALl the previous RVBs are intact, only changes are libxfs namespace
swizzling, but I'll leave time for a NAK if anyone wants to.

Thanks,
-Eric
