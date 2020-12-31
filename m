Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9E3C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BC12076E
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Dec 2020 22:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgLaWul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Dec 2020 17:50:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgLaWuk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Dec 2020 17:50:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMjcUm018959;
        Thu, 31 Dec 2020 22:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kvy2P7MlcO3ftz0PFk9G1SPmByl3h4BPWQpFtiV+uPc=;
 b=A2+HrO+rK+c1Yk7HBSS9N2kctFlqvMJm+VSJAYnyrl+PW0WSHYkRfkIlpCotf4uzps0W
 cNNkFBYcpao5Xl4FT/H+nWSp0ANIihTyIcyTt3TQLu4a42jbPC1MylHKsbR80ULybhsI
 Q4V3KWS+aACEsyyx7xWnQd+wC4SvAYMJ/E4FjBcskPWBHECAHPTz6eZwqTC9R+OLnDla
 V75KUbIY4tCOzPzX50qR00DyIE6bSy1O3sQQfKxDt6WBbHN5R9X6R2aQxZGwDc31JI0a
 HZS216G4r4GT0O2zTdUbpzw5/kIe0W0LTf11ECA0n8vOcif8Q13PBIuFwq3mLXHxW+m9 Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35nvkquwcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 31 Dec 2020 22:49:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BVMkUWA093284;
        Thu, 31 Dec 2020 22:47:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35pf307n2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Dec 2020 22:47:58 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BVMlu6c009870;
        Thu, 31 Dec 2020 22:47:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Dec 2020 14:47:56 -0800
Subject: [PATCHSET 00/12] xfs_scrub: track data dependencies for repairs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 31 Dec 2020 14:47:55 -0800
Message-ID: <160945487569.2835592.11413873278889731756.stgit@magnolia>
In-Reply-To: <20201231223847.GI6918@magnolia>
References: <20201231223847.GI6918@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9851 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012310135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Certain kinds of XFS metadata depend on the correctness of lower level
metadata.  For example, directory indexes depends on the directory data
fork, which in turn depend on the directoyr inode to be correct.  The
current scrub code does not strictly preserve these dependencies if it
has to defer a repair until phase 4, because phase 4 prioritizes repairs
by type (corruption, then cross referencing, and then preening) and
loses the ordering inherent in the previous phases.

To solve this problem, reorganize the repair ticket to track all the
repairs pending for a princpal object (inode, AG, etc.).  This reduces
memory requirements if an object requires more than one type of repair
and makes it very easy to boost the priority of repairs so that they are
attempted only after dependent data structures are fixed.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-data-deps
---
 scrub/phase1.c |    9 -
 scrub/phase2.c |   53 +++----
 scrub/phase3.c |   49 ++----
 scrub/phase4.c |   10 -
 scrub/phase7.c |    9 -
 scrub/repair.c |  456 +++++++++++++++++++++++++++++++++++++-------------------
 scrub/repair.h |   23 ++-
 scrub/scrub.c  |  288 +++++++++++------------------------
 scrub/scrub.h  |  135 ++++++++++++-----
 9 files changed, 564 insertions(+), 468 deletions(-)

