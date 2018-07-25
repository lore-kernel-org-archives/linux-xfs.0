Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56070 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388457AbeGYCXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 22:23:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6P18wB9173966
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2kbtbcugy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6P1EdxL008471
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:39 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6P1EdE3028239
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jul 2018 01:14:39 GMT
Subject: [PATCH 0/2] xfs-4.19: inode cleanups
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 24 Jul 2018 18:14:46 -0700
Message-ID: <153248128617.28208.11803349732053454018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This series cleans up XFS inode handling.  The first patch removes the
unused IHOLD macro; the second patch replaces the IRELE macro with a
proper function that can be typechecked.  Having done that, the scrub
code can use the new function, which allows me to trace iget/iput calls
in the scrub code.

Comments and questions are, as always, welcome.

--D
