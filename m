Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751748AbdGUPK7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jul 2017 11:10:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86592C0B2A46
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 15:10:59 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EB04900A8
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 15:10:59 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2 resend] xfs: readonly handling changes
Message-ID: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
Date: Fri, 21 Jul 2017 10:10:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

A couple of changes to how xfs behaves w.r.t. readonly
mounts.

1) write unmount record even for RO mounts (which may have done recovery)
2) remove readonly checks from xfs_release and xfs_inactive paths

Both of these stem from the fact that a readonly mount (as opposed to a
ro,norecovery mount) is /not/ guaranteed to do no writes to the block
device; in fact we write straightaway when we replay the log on an ro
mount.  Other "OMG don't write!" leftovers linger, and cause issues as
described in the following 2 patches.

Dave suggested grand plans for coalescing more of this into common
paths ala remount handling, i.e. a RO mount gets mounted RW and then
just goes through the same transition to RO at the end, but I haven't
put all that together yet, and these patches address a couple bugs in
a more targeted fashion until that can happen.

Dave also objected earlier to my 2nd patch which allows orphan recovery
to proceed on an ro mount.  There may be filesystems out there with
fairly long orphan inode lists which have never been recovered due to
this bug, and I guess the concern was that $SOMEHOW, processing them now
would cause $PROBLEMS.  I'm at a loss for how to address these concerns;
I tried to come up with a way to craft such a filesystem for a regression
test, but failed.  Once the flaw has been fixed in the kernel, I don't
know how to recreate the situation at will for testing.

Christoph was concerned about the xfstest which demonstrates this flaw
still failing, so resending these patches to see if we can make some
progress.

Thanks,
-Eric
