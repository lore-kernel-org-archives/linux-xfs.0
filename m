Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46364 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbfDQBkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:40:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1cPnh086741
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:02 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2ru59d809r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3H1c6kW015498
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2rwe7a41b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:02 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3H1e1PM001174
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2019 01:40:01 GMT
Subject: [PATCH 0/3] xfs: scrub filesystem summary counters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 16 Apr 2019 18:40:00 -0700
Message-ID: <155546519998.176278.8300210828717055034.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This patch series introduces a totally new filesystem summary counter
online scrub feature.  Whereas previous iterations froze the filesystem
to count inodes and free blocks, this one drastically reduces overhead
by loosening its precision somewhat.  Instead of freezing the fs, we
race the expected summary counter calculation with normal fs operations
and use thresholding to check that the counters are in the ballpark,
where ballpark means "off by less than 6% or so".

The first patch implements a per-cpu counter of the number of blocks
being held in delayed allocation reservations.  This should represent
the difference between the incore fdblocks counter and the one that
would be recorded on disk if one were to iterate all the committed
metadata structures.

Patch #2 enables the scrub code to pause the posteof and cowblocks
background reclamation workers temporarily to reduce perturbations in
the summary counters while the scrubber runs.  This isn't totally
foolproof since they can be re-armed, but we only need ballpark
correctness.

Finally, patch #3 implements the actual fs summary counter scrubber
code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-summary-counters

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-summary-counters
