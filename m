Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:48:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lddt4053572
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:48:55 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0qfjrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:48:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lmjux171886
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:48:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngkkhnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:48:54 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LmrcO011229
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:48:54 GMT
Subject: [PATCH v2 0/4] xfs: refactor inode geometry
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:48:52 -0700
Message-ID: <155968493259.1657505.18397791996876650910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series starts by moving the in-core inode geometry calculations
into a separate structure.  It then combines several of the inode
geometry calculation functions into a single setup function.

Next we fix some longstanding bugs in the inode cluster size usage so
that inode flushing and log recovery on 64k-block filesystems works the
way it's supposed to.  Finally, we replace various open-coded geometry
calculations with accesses into this structure so that we calculate
positions and offsets of inodes and inode clusters correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-geometry

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-geometry
