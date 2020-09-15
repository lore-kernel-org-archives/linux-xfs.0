Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6677FC433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4BE21973
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 01:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fmEmMpau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOBnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 21:43:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgIOBm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 21:42:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1eDRO130215;
        Tue, 15 Sep 2020 01:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=z1se613xpkVWIZe7F27AVwF755VcurHiWhrBRIs/T+k=;
 b=fmEmMpaurdZ5yQY8exmPsATE4LiXMN3to7Vuyg+mg6IODo9vhVBR7nkTMqJwAkGk5S3y
 H/xmZvCNPfUGfxQZpKlmM5uvZ4455p5+UxM1dZfMnv6HvjghMpDEWGIWEPkrw+Ett88N
 +15R090tSNuHPQLuXY6jMdgcDuPxBypmD+oZI9KXlY6kRH+hY0ZhIkYuy1Se6wVQvIpD
 4wTQZlq7u0x9CmsQNxDWvQKMRc2cORhjh74SysLavR+eZYUMM6H0FY++GL2Ne+7dqk/J
 Ah9CflWxrEY13ZONxQ3Iyw0ouUe+PGmXLTVNPgb4PtUhT2aZUpUE8vPKX8rTYXos8W+G fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrqsxru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 01:42:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08F1fV8f109659;
        Tue, 15 Sep 2020 01:42:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h8837wj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 01:42:56 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08F1gtaL003886;
        Tue, 15 Sep 2020 01:42:55 GMT
Received: from localhost (/10.159.147.241)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 01:42:55 +0000
Subject: [PATCH 00/24] fstests: tons of random fixes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 14 Sep 2020 18:42:54 -0700
Message-ID: <160013417420.2923511.6825722200699287884.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=950
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

So now that I have a cloud account, I suddenly have much more resources
to find out if things like external log devices and realtime volumes
actually work.  This means that I've found a couple dozen minor issues
all over fstests; most of the front patches in this series try to
address them.

At the end, there is also a new test to try unloading and reloading the
filesystem module between tests, to detect problems with resource
allocations not being freed.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-stuff
---
 README            |    3 +++
 check             |    9 +++++++++
 common/rc         |   20 ++++++++++++++++----
 common/xfs        |   28 +++++++++++++++++++++++++++-
 tests/generic/204 |    9 +++++++--
 tests/generic/600 |    4 +++-
 tests/generic/601 |    4 +++-
 tests/generic/607 |    5 +++++
 tests/overlay/020 |    6 ++++++
 tests/overlay/069 |    2 +-
 tests/overlay/071 |    2 +-
 tests/xfs/003     |   14 +++++++-------
 tests/xfs/016     |    4 ++--
 tests/xfs/019     |    5 +++++
 tests/xfs/031     |    5 +++++
 tests/xfs/032     |    4 +---
 tests/xfs/045     |    2 +-
 tests/xfs/070     |    4 +++-
 tests/xfs/073     |    5 +----
 tests/xfs/077     |    3 +--
 tests/xfs/098     |    8 +++++++-
 tests/xfs/111     |    2 +-
 tests/xfs/135     |    2 +-
 tests/xfs/137     |    4 ++--
 tests/xfs/141     |    4 +++-
 tests/xfs/171     |    1 +
 tests/xfs/172     |    1 +
 tests/xfs/173     |    1 +
 tests/xfs/174     |    1 +
 tests/xfs/194     |    3 +++
 tests/xfs/205     |    1 +
 tests/xfs/284     |    3 +--
 tests/xfs/291     |    6 ++++--
 tests/xfs/306     |    1 +
 tests/xfs/318     |    1 +
 tests/xfs/331     |    1 +
 tests/xfs/424     |    8 +++++++-
 tests/xfs/444     |    1 +
 tests/xfs/449     |    4 +++-
 tests/xfs/503     |    1 +
 40 files changed, 149 insertions(+), 43 deletions(-)

