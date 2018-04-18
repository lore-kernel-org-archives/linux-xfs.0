Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51006 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:44:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2fQk5170886
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:25 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:24 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2iNXC022595
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:24 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2iNrM028161
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:44:23 GMT
Subject: [PATCH 0/9] xfs-4.18: strengthen corruption reporting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:22 -0700
Message-ID: <152401946245.12719.18338955003321437040.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series is the result of me combing through the fuzz xfstests
looking for places where either we fail to report corruption to
userspace, or use fatal ASSERTs for on-disk metadata checks.
In other words, here are nine patches that convert ASSERTs into
-EFSCORRUPTED returns.  On systems with non-fatal asserts (or debugging
disabled) this prevents a number of memory corruptions and crashes
resulting from bad metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees.  The kernel patches[1] should apply against
4.17-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
places.  The git trees contain all four series' worth of changes.

Comments and questions are, as always, welcome.

--D

[1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
[2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
[3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
