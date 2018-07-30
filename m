Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbeG3HD0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:03:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6U5TSnO191671
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:11 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2kgfwstvxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:11 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6U5UA7v007922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:10 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6U5UAUK025920
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jul 2018 05:30:10 GMT
Subject: [PATCH 0/3] xfs-4.19: superblock verifier cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Jul 2018 22:30:08 -0700
Message-ID: <153292860880.19274.14533449137039985963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series refactors the superblock verification routines into three
predicates: one to handle checks that are only done at read time,
another for write time checks, and a third for checks common to both.
We then add some sanity checks for the summary counters to the write
verifier (a reworked version of Bill O'Donnell's earlier patch), and end
by addding a verifier for inode counts and adding that into the
superblock write checks.

Comments and questions are, as always, welcome.

--D
