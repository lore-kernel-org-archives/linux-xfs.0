Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdCITls (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 14:41:48 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A44CA85547
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2017 19:40:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v29JegBR010582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 9 Mar 2017 14:40:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: readonly handling changes
Message-ID: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
Date: Thu, 9 Mar 2017 13:40:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

A couple of changes to how xfs behaves w.r.t. readonly
mounts.

1) remove readonly checks from xfs_release and xfs_inactive paths
2) write unmount record even for RO mounts (which may have done recovery)

Both of these stem from the fact that a readonly mount (as opposed to a
ro,norecovery mount) is /not/ guaranteed to do no writes to the block
device; in fact we do that straightaway when we replay the log.  Other
"OMG don't write!" leftovers linger, and cause issues as described
in the following 2 patches.

Dave suggested grand plans for coalescing more of this into common
paths ala remount handling, i.e. a RO mount gets mounted RW and then
just goes through the same transition to RO at the end, but I haven't
put all that together yet, and these patches address a couple bugs in
a more targeted fashion until that can happen.

-Eric
