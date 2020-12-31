Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E6DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BF220678
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgLaWpc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:45:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgLaWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:45:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMinM8147486;
        Thu, 31 Dec 2020 22:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KfZ5WGwXl/33K1Ykxe/yV4bwhPwP+AkrUCcSnSCmXg0=;
 b=IlIF/8FQ9i6g3djy99vQdDVZj7wT1cpk8Fjaj8mmhaPOaS3yviU9zZkrZ0NJZND0CrFG
 99lfYIJTK0NKXhLdWjTeFaoZIEVV955d8LMHxWc3xciLJuUVBihjbmR5MoGBdQ2ADjxr
 SXGK5P6ffNkO0lEi806zpkP9kUY6aBQCNBsMBCccbP6XRosRmXodtgtnang3X1fZ/wYs
 ts1pwKawYmfpavdGxRx3qho3S+ttQgJu8DOGNzOWlFHMy85IqfKXh9zcg2Yn9ieopuNj
 b2bDXfCU30+FJ/1C1ORHEbi8ouYXf6H5w/xrMkNaMbkcCjE1BEm7rilfzN5MdVF2reYO 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35phm1jt30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:44:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMe8eo015233;
        Thu, 31 Dec 2020 22:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35perpnde3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:44:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMimYN024972;
        Thu, 31 Dec 2020 22:44:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:44:48 -0800
Subject: [PATCHSET v22 0/3] xfs: online repair of extended attributes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:44:47 -0800
Message-ID: <160945468736.2831121.10472980419151770878.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012310134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series employs atomic extent swapping to enable safe reconstruction
of extended attribute data.  Extended attribute repair consists of four
main parts:

First, we walk the existing attributes to salvage as many of them as we
can, by adding them as new attributes attached to the repair tempfile.

Second, we prepare the temp file by changing the inode owner field in
the attr block headers.

Third, we use atomic extent swaps to exchange the entire attribute fork
between the two files.

Finally, we tear down the old attr data (which is now in the temporary
file) as carefully as we can.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-xattrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-xattrs
---
 fs/xfs/Makefile            |    2 
 fs/xfs/libxfs/xfs_attr.c   |    2 
 fs/xfs/libxfs/xfs_attr.h   |    1 
 fs/xfs/scrub/array.c       |   24 +
 fs/xfs/scrub/array.h       |    2 
 fs/xfs/scrub/attr.c        |    9 
 fs/xfs/scrub/attr.h        |   10 
 fs/xfs/scrub/attr_repair.c | 1393 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.c      |   22 +
 fs/xfs/scrub/bitmap.h      |    1 
 fs/xfs/scrub/blob.c        |  167 +++++
 fs/xfs/scrub/blob.h        |   26 +
 fs/xfs/scrub/dabtree.c     |   16 +
 fs/xfs/scrub/dabtree.h     |    1 
 fs/xfs/scrub/repair.c      |  136 ++++
 fs/xfs/scrub/repair.h      |    9 
 fs/xfs/scrub/scrub.c       |    2 
 fs/xfs/scrub/scrub.h       |    3 
 fs/xfs/scrub/trace.c       |    1 
 fs/xfs/scrub/trace.h       |   86 +++
 fs/xfs/xfs_buf.c           |    9 
 fs/xfs/xfs_buf.h           |    9 
 22 files changed, 1927 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/scrub/attr_repair.c
 create mode 100644 fs/xfs/scrub/blob.c
 create mode 100644 fs/xfs/scrub/blob.h

