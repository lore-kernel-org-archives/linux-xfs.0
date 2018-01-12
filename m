Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965370AbeALWES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jan 2018 17:04:18 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0CLvM7p044711
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:17 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ff5c0820f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM41m8009797
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:01 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0CM41Gq025740
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 22:04:01 GMT
Subject: [PATCH 0/5] xfs: kasan/ubsan fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 12 Jan 2018 14:03:59 -0800
Message-ID: <151579463950.8694.320025813242574491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Following are five patches that fix KASAN/UBSAN warnings that I
encountered when running the xfs_repair fuzz tests.  The first, fourth,
and fifth patches strengthen the verifiers against bad values.  The
second patch fixes a coding flaw in the scrub code, and the third patch
teaches the directory scrubber to walk through a directory entry block
to find the entries rather than assuming that the hash tree addresses
are at all correct.

--D
