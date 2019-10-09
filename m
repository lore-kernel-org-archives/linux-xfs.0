Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1A6ECE596
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2196721848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QnRhzls9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfJIQuO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:50:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60264 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIQuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:50:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjcFQ039767
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=MrFoDgPsvrIjUmf1uA5fpigLOxG6+NA2/h6v6qx/H54=;
 b=QnRhzls9n5E5kTXNY3kogFXdhIpECr4BDLzmvJahRp4QFD6jC9bs9s6JVEfmompapec/
 1Hlyiat8i18TE9kJUogTJf4DytO7s/TAEbmKBt7NAq9LZIl44bGmrvctr575r4j6d2vT
 PIInzApIS43DkOTS9/bl9gAP2TzXuzdgCRfYKYAtxQtVe7vijs4/CeLYSqFJRk/+SlkV
 0twllC1nBPVKrjqxzn97YTN9cIUyD06HlzTIWWXlI9yjKKKAwKK/54w3SQSJAECYhsU1
 m4DZImwVhNTFfc8ds9Dll5sNTBYXfzTYOWRLAf6DOj3YqLbswno7OEyMeSCcpbaMBfqx Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vejkup155-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZRn174362
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vhhsmx2k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:50:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GoAOq028103
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:50:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:50:10 -0700
Subject: [PATCH v20 0/4] xfs: online repair of AG btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:50:08 -0700
Message-ID: <157063980873.2915883.8510302923584220865.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the first part of the twentieth revision of a patchset that
adds to XFS kernel support for online metadata scrubbing and repair.
There aren't any on-disk format changes.

New for this version is a rebase against 5.3-rc6, bulk loading of
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
