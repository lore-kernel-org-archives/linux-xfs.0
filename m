Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfDKBpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Apr 2019 21:45:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hP8A044912
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:30 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rpkht66um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B1hlLg009760
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2rpytchsd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3B1jSsO017593
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 01:45:28 GMT
Subject: [PATCH v2 0/8] xfs: online health tracking support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 10 Apr 2019 18:45:24 -0700
Message-ID: <155494712442.1090518.2784809287026447547.stgit@magnolia>
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

Reporting to userspace is handled by three ioctl modifications:
enhancements of the existing fs geometry ioctl to include sickness
information; enhancement of the existing bulkstat ioctl to report
sickness information, and a totally new ioctl to report allocation group
geometry and sickness data.

On the userspace side of things, xfs_scrub will be adapted to give a
clean bill of health to the kernel when it is warranted, and
xfs_spaceman will be able to report the health status of a filesystem.

The first three patches add the internals of the health reporting
infrastructure and convert the "bad summary" code to use it instead of
a mount state flag.

The five patches after that implement the ioctls to report health status
to userspace by enlarging the fs geometry ioctl, creating a new ag
geometry ioctl, and then adding fields to all three so that the kernel
can report what it has checked and what it knows to be good or bad.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-tracking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-tracking
