Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50072 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:09:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7BFYOIu094120
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:34:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2ksnacrvm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:34:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFYw2r013944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:34:58 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFYwc4029426
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:34:58 GMT
Subject: [PATCH v2 0/6] xfs-4.19: various fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:34:57 -0700
Message-ID: <153400169747.27471.4044680761841034489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here are some late fixes for 4.19.

The first patch teaches xfs to trigger a sb counter recalculation if the
icount is bad; when I added the icount check to the write verifier, I
forgot to add the corresponding check to the read side.

The second patch fixes the online repair "find AG btree root" function
to ignore btree blocks that have siblings and to ignore a btree level if
multiple sibling-less blocks are found.

The third patch fixes a problem when allocating a transaction for online
repairs where if the AGF block or AGI inode counts are totally garbage
we can end up ENOSPC'ing out of online repair after an attempt to
reserve a ridiculous number of blocks.  This is unfortunate,
particularly if we were setting up for an AGF/AGI counter repair.

The fourth patch fixes some buffer state management bugs so that we
don't accidentally clobber b_ops on buffers that were already in-core
when we try to find an AG header's btree root blocks.

The fifth patch fixes an uninitialized variable usage in the iomap code.

The sixth patch avoids a crash in the VFS readlink routines if we have
an inline symlink that's corrupted such that if_data is NULL.

Comments and questions are, as always, welcome.

--D
