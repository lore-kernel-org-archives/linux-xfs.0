Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D86C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0501F204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J9NzNPWU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgHQXBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgHQXA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:00:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwAlF164162;
        Mon, 17 Aug 2020 23:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=AjBqS3OPDp2Mr1wdlcoKRAVgNybwh/lp+S0lAfi090o=;
 b=J9NzNPWUg3h+HTUqdunchTButN3nZiZwg3ivdRnpkph31pPfrGbPUa0IxOXLTpW8I2Yh
 5ck7+gG7WbkkHArVqw2Ct82+qKWCFEGQK6KRzkdkSa6hUSIQwr2rhiqfPCpMqUhYOa49
 eUXuq5BU90RufTO5rbvp3xSreWM98WCvwoxZGGNZEo/1k+HrzEDpa830k41XDOYm3VD8
 qePSBQlDJlVEcdRntyw6kbq7X5DCm7kZZ4pWk7IvTD7gZtvKwxd+PNgj851HHnbZnJLe
 p5BX9pv/Zeb60jBJ1aXeiyVY7IbQ0zPWKT2OqGksopGH4n40/e96bIe/HL5JuijAGHeR SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r1myf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:00:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9Qn084679;
        Mon, 17 Aug 2020 23:00:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsfr5bg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:00:56 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN0td4018694;
        Mon, 17 Aug 2020 23:00:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:00:54 -0700
Subject: [PATCH RFC 0/4] xfstests: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:00:54 -0700
Message-ID: <159770525400.3960575.11977829712550002800.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=983
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it refactors the quota
grace period expiration timer code a bit before implementing bit
shifting to widen the effective counter size to 34 bits.  This enables
correct time handling on XFS through the year 2486.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
---
 common/rc         |    2 +
 common/xfs        |   46 ++++++++++++++++++++++++++++++++
 tests/xfs/010     |    3 +-
 tests/xfs/030     |    2 +
 tests/xfs/122.out |    2 +
 tests/xfs/908     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/908.out |    3 ++
 tests/xfs/909     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out |   12 ++++++++
 tests/xfs/910     |   60 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |    3 ++
 tests/xfs/911     |   45 +++++++++++++++++++++++++++++++
 tests/xfs/911.out |   15 ++++++++++
 tests/xfs/group   |    4 +++
 14 files changed, 345 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out

