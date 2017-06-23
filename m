Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28378 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdFWQfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2017 12:35:11 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5NGZAYE030480
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2017 16:35:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v5NGZAnS004504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2017 16:35:10 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5NGZAbT028692
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2017 16:35:10 GMT
Subject: [PATCH v2 0/4] xfs: more configurable error injection
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 23 Jun 2017 09:35:09 -0700
Message-ID: <149823570899.31786.10730517727349185585.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is a small patch set that exposes all the error injection tags
under /sys/fs/xfs/$dev/errortag/.  Each tag gets its own sysfs
attribute; you can enable a tag via:

# echo $num > /sys/fs/xfs/$dev/errortag/$tagname

The tag names are the same ones as xfs_io's inject command, and the
number units are the denominator of the occurrence frequency, which is
to say that they're the same units as XFS_RANDOM_*.  1 = all the time,
2 = half the time, 100 = 1% of the time, "default" = whatever the
ioctl would do, etc.

The purpose of this patch series is twofold -- first, the old ioctl
interface doesn't allow us to control how often errors actually get
injected.  The extra flexibility enables us to write regression tests
where we set up the next operation to fail, as well as tests that set a
low frequency of trouble and try to run longer tests.  Second, with
error injection knobs appearing in sysfs we might as well move them all
to the same place.  Third, now we can individually /disable/ error
injectors, whereas the ioctl interface can only turn all of them off at
once.

Note that the old ioctls are not going away; their behavior is
unchanged.

Comments and questions are, as always, welcome.

--D
