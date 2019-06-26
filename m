Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfFZUqh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKiGkW012429
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:36 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtcmxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjSGv069245
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tat7d1h0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKkZDl007908
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:35 GMT
Subject: [PATCH v2 0/6] xfs: scrub-related fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 26 Jun 2019 13:46:33 -0700
Message-ID: <156158199378.495944.4088787757066517679.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

I discovered by sampling xfs_scrub stack trace swith a flame graph that
the attr scrub code has a sizeable oversight -- the xattr scrub code
always allocates a zeroed 65K temporary buffer before locking the inode,
even if it then turns out that the inode does not have extended
attributes.

In addition to the pointless memory allocation, the scrub code itself is
careful to initialize whatever part of the memory buffer it's going to
use before reading the contents, which means that the memory clearing is
not only painful (it's 5% of the sample traces!) but totally pointless.

The first patch does more whack-a-mole cleanup of places where corrupt
ondisk directory metadata causes ASSERTs instead of -EFSCORRUPTED
returns.

The rest of the series first cleans up the open-coded pointer
calculations where the buffer is concerned, and then restructures the
code so to allocate the smallest size buffer needed and only just before
it's actually needed.  The final patch disables buffer zeroing for
better performance.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-scrub-fixes
