Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436DCC4167B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4BE3224B1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 01:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgLDBMY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 20:12:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLDBMY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 20:12:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B419RDW014436;
        Fri, 4 Dec 2020 01:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=NwkX59nIaAIzFX8DkTKzIru3ZAeR4EuuxaoEUtq7ABE=;
 b=GTGjXklt5n7mncrvSmrUMisDkjallIpsgp8krE7KaAUTm15nFajb2Mu9kZzHrBByeCbV
 5GytXau23BckwlNRYVKPs/i0AAhqLlHW7xQeF9/XdpRCkb78V8FxOw46kcNgABwgjkh1
 tyzloBTG2miSUN8wTybGwvGgwhI9YU2M0inVjXJm8gqutpLHIPK+jRr5BT81op/KYlM9
 hqSMrANW6IREHAuddhPERZoNNzKyoBxfgHLzfJE2dm6NYBXYI4j/qWBTDGmhymBf2tex
 EvABmUtf4lG0IxFYO5opV13ZtVabmbqW0gEgSuE+FFDRcdB/eEfIdjDuKntNtSLOowYT Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm0yj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 01:11:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B41AO87099202;
        Fri, 4 Dec 2020 01:11:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540ax530t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 01:11:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B41BZxK014848;
        Fri, 4 Dec 2020 01:11:35 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 17:11:34 -0800
Subject: [PATCH v2 00/10] xfs: strengthen log intent validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 03 Dec 2020 17:11:34 -0800
Message-ID: <160704429410.734470.15640089119078502938.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset hoists the code that checks log intent record validation
into separate functions, and reworks them to use the standard field
validation predicates instead of open-coding them.  This strengthens log
recovery against (some) fuzzed log items.

v2: rearrange some of the checks per hch; report intent item corruption

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovered-log-intent-validation-5.11
---
 fs/xfs/xfs_bmap_item.c     |   77 +++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_extfree_item.c  |   30 +++++++++++++----
 fs/xfs/xfs_log_recover.c   |    5 ++-
 fs/xfs/xfs_refcount_item.c |   59 ++++++++++++++++++++++------------
 fs/xfs/xfs_rmap_item.c     |   74 ++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trace.h         |   19 +++++++++++
 6 files changed, 182 insertions(+), 82 deletions(-)

