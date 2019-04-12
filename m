Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50402 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfDLG2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 02:28:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C68lap193623
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:05 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rphmevt8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C6S5BB112922
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rtd84cv2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:04 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C6S3SD022523
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 06:28:04 GMT
Subject: [PATCH v3 0/8] xfs: online health tracking support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Apr 2019 23:28:01 -0700
Message-ID: <155505048097.1279757.13952335054480511366.stgit@magnolia>
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

Proposed manpages for the three ioctls capable of reporting health
status:

https://djwong.org/docs/man/ioctl_xfs_ag_geometry.2.html
https://djwong.org/docs/man/ioctl_xfs_fsbulkstat.2.html
https://djwong.org/docs/man/ioctl_xfs_fsop_geometry.2.html

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-tracking

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-tracking
