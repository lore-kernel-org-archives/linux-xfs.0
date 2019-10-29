Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25F7CA9EC3
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72FD20679
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RnmQXqVw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfJ2Xbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:31:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2Xbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:31:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNTGE5017508
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TZCF9tteX6dCGc27uQm9lkeFeuyszG56OvwN8fAmhrs=;
 b=RnmQXqVwYpKoa2476k8T5CIWBHuSIjudfkZSIxzjsEXGu6ibucn3d2NdjX5a5OBgsJvG
 YxH0Pqpq3z8VxPcTQQl0gCVwX7hmBaJX1ZI9upmJSmSJBo/LLOZh4RtLzh0eBmccPrSq
 QFOaKZI/AVOrg8SedEHUwvZbHzrUWbrd7qoh8diY+/tEedlbLTaR2Od3rp0r3P191BNM
 hORSXywivpK4H6Uzt/janu/bHxDhlafZu0RgO0YqQTViNuL0qmmNAY9G0/X46DAZqGIW
 9RZDF1F5jXXYUEefWO2/1LFxbtM7LVV4Ze1gX2N/WNarL8A9vxpkoNknrOCMQsIB25Ht 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vxwhf8b43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRkLA069154
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vxwhuvg6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:47 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNVloT007240
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:31:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 23:31:47 +0000
Subject: [PATCH v21 0/5] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:31:46 -0700
Message-ID: <157239190609.1267304.9008396217521176875.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the twenty-first revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for this version is a rebase against 5.4-rc5, bulk loading of
btrees, integration with the health reporting subsystem, and the
explicit revalidation of all metadata structures that were rebuilt.

First, create a new data structure that provides an abstraction of a big
memory array by using linked lists.  This is where we store records for
btree reconstruction.  This first implementation is memory inefficient
and consumes a /lot/ of kernel memory, but lays the groundwork for a
later patch in the set to convert the implementation to use a (memfd)
swap file, which enables us to use pageable memory without pounding the
slab cache.

The three patches after that implement reconstruction of the free space
btrees, inode btrees, and reference count btree.  The reverse mapping
btree requires considerably more thought and will be covered later.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-ag-btrees

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-ag-btrees
