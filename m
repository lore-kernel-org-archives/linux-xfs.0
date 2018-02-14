Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161731AbeBNSPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 13:15:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1EI7Evl061921
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 18:15:13 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2g4t3fg2xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 18:15:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1EIC1Qg000906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 18:12:01 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1EIC1JH018928
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 18:12:01 GMT
Subject: [PATCH v2 0/4] xfs: fix v5 AGFL wrapping
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Feb 2018 10:12:00 -0800
Message-ID: <151863191996.12012.10898223924122487735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch of patches fixing the AGFL padding problem once and for
all.  When the v5 disk format was rolled out, the AGFL header definition
had a different padding size on 32-bit vs 64-bit systems, with the
result that XFS_AGFL_SIZE reports different maximum lengths depending on
the compiler.  In Linux 4.5 we fixed the structure definition, but this
has lead to sporadic corruption reports on filesystems that were
unmounted with a pre-4.5 kernel and a wrapped AGFL and then remounted on
a 4.5+ kernel.

To deal with these corruption problems, we introduce a new ROCOMPAT
feature bit to indicate that the AGFL has been scanned and guaranteed
not to wrap.  We then amend the mounting code to find broken wrapping,
fix the wrapping, and if we had to fix anything, set the new ROCOMPAT
flag.  The ROCOMPAT flag prevents re-mounting on unpatched kernels, so
this series will likely have to be backported.

--D
