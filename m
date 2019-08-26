Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A814BC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 765DF21883
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GVRmdk/o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfHZVWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:22:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHZVWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLFLDA162263;
        Mon, 26 Aug 2019 21:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=i7wCFrHdlOHPAizNBU3LM4FvVRtPyh5WvHje8MDztBk=;
 b=GVRmdk/oCwtDEPxmL+qJ6ILj2zk2ApeGrKs9cj5CDnNWXafI4IHEcJPWOy9qlY8/eKSQ
 bExv6XUefwWizHQSfJMj5x3UMaRAamSlhr/CKk0L7NLekkvHzGM1fWBknz3qmZidFoWB
 SZIYf71oWu6Duzxjnrj5R2w7kyoecupnlil/U1BcW2hO804T9Q/Khz7J3I/49ImSz7ck
 P/Cy8+hPV4R4Iz+dkIB3cb/8277OvUNIY5V20zSpztEYZ00vGfMrPE1vFETwxpeaVfip
 RgZskwSOo86aELIfzsqcxaxWa4x4uTRrypZAL0bFrBqP6tS0f8iCP6ICQX/CQoenf5iV hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t811j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLINhP170054;
        Mon, 26 Aug 2019 21:22:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2umj277ub9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLMCOd030797;
        Mon, 26 Aug 2019 21:22:12 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:22:12 -0700
Subject: [PATCH 0/5] xfsprogs: port utilities to bulkstat v5
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:22:11 -0700
Message-ID: <156685453125.2840332.15645173323964762232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=698
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=775 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Port the libfrog bulkstat/inumbers wrapper functions to use the new v5
interfaces and to enable falling back to the v1 interfaces if need be.
This series ports only the more lightweight users of these interfaces.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5-porting
