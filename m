Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ECBC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2652120658
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgLaWrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:47:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56918 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgLaWrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:47:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkxZA155774
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fz6Ihzk+2fQh7yYFzkVu0+phgwO+lJoRC11jmjk4zxk=;
 b=JJIjxbGwGSyOhG8XY8hhFo61CQ2rtDoVUWD0FXOYWxEl5vctMjvh38ahQEbWWfHhl+2u
 9HroVBPBVBSj1ZrDEEP1Qv6UOWlXqZUKgM2FVbvDFIbG/B01yTmCrFtntmVq4j75aYbO
 ufL403X9/KYmQMchO5JfGYUATZ73ORHfy6Ucbocjv+0Gha8t3Zp4kzen3eCr67TMYGgU
 a5+qTWjK/z5Rk1WylMKEZLnEWyS6PokFX6bw7hfBBVx/on1BK0NlcI5IsI//ksobJm29
 FfDrnE9vswP4f8f9RZd8eIuzHVbhf4OPSdmCcB4VhvTjnvv826Nk2tN+8dyjZr1iuxKd Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35rk3bv3qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:46:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe6sR143933
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35pexuktsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:58 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMivn3008703
        for <linux-xfs@vger.kernel.org>; Thu, 31 Dec 2020 22:44:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:57 -0800
Subject: [PATCHSET v22 0/4] xfs: online repair of directories
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:55 -0800
Message-ID: <160945469505.2831193.8736922141107333054.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series employs atomic extent swapping to enable safe reconstruction
of directory data.  Directory repair consists of five main parts:

First, we walk the existing directory to salvage as many entries as we
can, by adding them as new directory entries to the repair temp dir.

Second, we validate the parent pointer found in the directory.  If one
was not found, we scan the entire filesystem looking for a potential
parent.

Third, we prepare the temp file by changing the inode owner field in
the directory block headers.

Fourth, we use atomic extent swaps to exchange the entire data fork
between the two directories.

Finally, we add the ability to inactivate directories by directly
freeing all the data fork blocks.  This does not change anything with
normal directories, since they must still unlink and shrink one entry at
a time.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-dirs
---
 fs/xfs/Makefile              |    2 
 fs/xfs/scrub/common.c        |    4 
 fs/xfs/scrub/dir.c           |   49 ++
 fs/xfs/scrub/dir_repair.c    | 1176 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c        |   39 +
 fs/xfs/scrub/parent.h        |   11 
 fs/xfs/scrub/parent_repair.c |  439 ++++++++++++++++
 fs/xfs/scrub/repair.c        |  166 ++++++
 fs/xfs/scrub/repair.h        |    6 
 fs/xfs/scrub/scrub.c         |   10 
 fs/xfs/scrub/scrub.h         |    4 
 fs/xfs/scrub/trace.h         |  123 ++++
 fs/xfs/xfs_inode.c           |   55 ++
 fs/xfs/xfs_inode.h           |    1 
 14 files changed, 2077 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c
 create mode 100644 fs/xfs/scrub/parent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c

