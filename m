Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2528BC2BB85
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:10:17 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66932064A
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JLP7Wv3w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D66932064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-xfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgDMBKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 21:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgDMBKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Apr 2020 21:10:15 -0400
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F768C0A3BE0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2020 18:10:15 -0700 (PDT)
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D19NnM022146
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=8J3DD3cTZtP3lhkR6EqbhMM4xzXTNHlgT4y5ow3sSB8=;
 b=JLP7Wv3wVpQi/++LEBtSioOcAWTOy3jgZbef0v7jZ9kq/o+AXoTTk/c9s7H3DQUfENng
 8EBei/CrQuzuatF9zQ5a4NoIv7CqV5FQQQL2dEWQGvzFESwEB1lsO6L5qEJNZ2AjNXDN
 Bo5XieMEaNBhcZV0B5BdLk2ewDgJFSK/ht49GaKJhzM0GRSq3WCkIMRi4WSYIqoH/xwi
 6MG9ap2eh3F8bD25LanYJYCFbO0IgLcB4rMTMcPwk1SllfHygfZgfczxst0d5YyqiQER
 obRjsg5Skn0bJYcT4+qGOQHD1PVgLNrXNxhLXTQbv5w4SCToYwpoDfQS5SRSV95/eFnm TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30b6hpbxqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D17jpM149574
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30bqccep14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03D1ACEP005043
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 12 Apr 2020 18:10:12 -0700
Subject: [PATCH 0/2] xfs: random fixes for 5.7
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 12 Apr 2020 18:10:11 -0700
Message-ID: <158674021112.3253017.16592621806726469169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=907
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=965 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of a couple of bug fixes for 5.7.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-5.7-fixes
