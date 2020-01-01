Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D7CC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7195206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Af73OLr4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgAABCp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:02:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgAABCp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:02:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7BN103972
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TcZNm05CQG69Rphy0Ckv2xKIULN5hswkGZmB3/saQsY=;
 b=Af73OLr4TGMefmy4y1qqoPJpOn4PYVvYTLPDiMYkNdpERZ9aOvEo3E/xCe8FGHf12idg
 5t6l3sXGaMMNz+nm62zSmpxuj+jG8FAXlRW8GLoiJCjgRGhrvmzmqfXcJkdRf9A4cXZr
 ecfCkc1V/xj1vGY7/1rdq7HnJd1wp23yF/aWlIEDtw6e6lWIDRzk5yZXqpZejR3X4ryB
 2HqbQ25ms43NVK0LFatzaze+INXC03tvYa7OfINILO1jj0f8aN9m7ryVMDKw8h90g3YX
 GYO207LjK5bl7Olwun/n2epRlWN03c+Xr+xe+v5jaTJ144TW0JzEHwxEillQTUcYCvKw WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk26e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wwRi190653
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guedmhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:02:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00112gji003269
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:02:42 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:02:41 -0800
Subject: [PATCH v22 0/5] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:02:38 -0800
Message-ID: <157784055814.1358685.7277201980352188138.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the twenty-second revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for this version is a rebase against 5.5-rc4, bulk loading of
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
