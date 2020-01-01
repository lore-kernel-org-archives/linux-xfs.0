Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67164C2D0DD
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 379D62064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bvm526HX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAABJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51816 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xrI089124
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=W95HXQC3Zhd2Ck+Y/rf9ifrpZdWS6YR391roJH/WHDw=;
 b=Bvm526HXH50cdseUAgwGd/LbCjJWZozO+W6Ij0uLCn3uaAgl90pSm+faby6JhxA0tIE8
 o/flKRt0eKsTuGDYVhlmvO5cHWZxXpes6Aq/3cQzHjGAH10P+fNBfUavxVupJexEPSi2
 6L/ymdrUSvKkeesBWAuehPA7HbsKUA3EGGQ+XP4aeo5gXwEw3rKvG3H2G45hksM7JVfp
 vYamdhLHw/HFi/IdHlQHdA3nO8v6PFVnSBcr9v1GW+gAss8o3t6/Z5IcFQ39Ppvefkys
 9B5W+SZ9F7kE2eV9Pva8a2EarLUsHOGU6EMjinsdCa1qPISBKLO6FXRyzmkxVITa/y00 xA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wWr172190
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj915f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00118gDN031286
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:43 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:08:42 -0800
Subject: [PATCH v2 00/10] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:08:40 -0800
Message-ID: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series implements deferred inode inactivation.  Inactivation
is the process of updating all on-disk metadata when a file is deleted
-- freeing the data/attr/COW fork extent allocations, removing the inode
from the unlinked hash, marking the inode record itself free, and
updating the inode btrees so that they show the inode as not being in
use.

Currently, all this inactivation is performed during in-core inode
reclaim, which creates two big headaches: first, this makes direct
memory reclamation /really/ slow, and second, it prohibits us from
partially freezing the filesystem for online fsck activity because scrub
can hit direct memory reclaim.  It's ok for scrub to fail with ENOMEM,
but it's not ok for scrub to deadlock memory reclaim. :)

The implementation will be familiar to those who have studied how XFS
scans for reclaimable in-core inodes -- we create a couple more inode
state flags to mark an inode as needing inactivation and being in the
middle of inactivation.  When inodes need inactivation, we set iflags,
set the RECLAIM radix tree tag, update a count of how many resources
will be freed by the pending inactivations, and schedule a deferred work
item.  The deferred work item scans the inode radix tree for inodes to
inactivate, and does all the on-disk metadata updates.  Once the inode
has been inactivated, it is left in the reclaim state and the background
reclaim worker (or direct reclaim) will get to it eventually.

Patch 1-2 refactor some of the inactivation predicates.

Patches 3-4 implement the count of blocks/quota that can be freed by
running inactivation; this is necessary to preserve the behavior where
you rm a file and the fs counters update immediately.

Patches 5-6 refactor more inode reclaim code so that we can reuse some
of it for inactivation.

Patch 8 delivers the core of the inactivation changes by altering the
inode lifetime state machine to include the new inode flags and
background workers.

Patches 9-10 makes it so that if an allocation attempt hits ENOSPC it
will force inactivation to free resources and try again.

Patch 11 converts the per-fs inactivation scanner to be tracked on a
per-AG basis so that we can be more targeted in our inactivation.

Patches 12-14 teach the per-AG sick status to remember if we inactivate
inodes that themselves had unfixed sick flags set, and for scrub to
clear all those flags if it finds that the filesystem is clean.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation
