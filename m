Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45676 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbfDARKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 13:10:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x31H9px0134674
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2rhwyd0ggv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 17:10:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x31HABcC003580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:11 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x31HAArQ016587
        for <linux-xfs@vger.kernel.org>; Mon, 1 Apr 2019 17:10:11 GMT
Subject: [PATCH 00/10] xfs: online health tracking support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Apr 2019 10:10:09 -0700
Message-ID: <155413860964.4966.6087725033542837255.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series adds online health tracking capabilities to XFS, which
enables userspace to discover if any metadata corruptions have been
found (and not fixed) within a given class of metadata.

The reporting of metadata health problems is triggered only by the
online scrub code, though in principle a metadata read encountering
corruption could also set a sick flag.

Online repair will clear the appropriate sick flags when metadata passes
its inspection after a repair attempt.

Reporting to userspace is handled by three ioctl modifications:
enhancements of the existing fs geometry ioctl to include a health
field; enhancement of the existing bulkstat ioctl to report health, and
a totally new ioctl to report allocation group geometry and status.

On the userspace side of things, xfs_scrub is adapted to give a clean
bill of health to the kernel when it is warranted, and xfs_spaceman can
now perform live health reporting.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-tracking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-tracking
