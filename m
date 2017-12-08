Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752572AbdLHD7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 22:59:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB83vIOW114506
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 03:59:30 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2eqk3s00re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Dec 2017 03:59:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB83t0pH021518
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 03:55:00 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB83sxvE008211
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 03:55:00 GMT
Date: Thu, 7 Dec 2017 19:54:57 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFCRAP DONOTMERGE PATCH 0/2] xfs: parent pointers
Message-ID: <20171208035457.GD19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Hi all,

So I've been working in my spare time (ha ha) to build a prototype
parent pointer ioctl backend so that I can play around with the
userspace side of things -- namely (cough) having xfs_scrub be able to
resolve an (ino, gen) tuple back to a user-friendly file path.

The first ugly patch attacks the dentry cache to use d_parent to provide
one of the parents of some file.  Obviously, this is totally deficient
as we can only report one parent and the file has to have been opened
via path at some previous point in time, and I bet the locking is
totally wrong.  It's too ugly to live but it /does/ function as a stub.

The second patch implements two iterators atop the parent pointer ioctl
we've been tossing around on the mailing list -- one to return parents
of an open file/file handle, and a second one to return all the paths of
an open file/file handle, and plunges it into (part of) xfs_scrub and
the xfs_io parent command.  Note that I'm expecting xfs_scrub/xfs_repair
to take over parent pointer checking and fixing, so I removed the
checker function from xfs_io.

This is _not_ a substitute for Allison's parent pointer patches, as
they provide the meat of the real feature... but seeing how much
bikeshedding ioctls invite, we might as well start the reconciliation
process now.

--D
