Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E238FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EE792077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CygQMJgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbfKGDB4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:01:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:01:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7300dS024437;
        Thu, 7 Nov 2019 03:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=S8HbIFZfP/xtg/Tg5nogbO+6PEto/W6xmQqlcQ6JzVQ=;
 b=CygQMJgQmohSPD5dGqNaty1EWP2W9JC8zqS0GBASZiGanhQuh8FkElen23KLIq4jfgmp
 fEf0un38aqmJboWlbVYPNL5FpjtWNlRhUN5VpVc3WAWfoMk7w8LjpXyna0Uoce5iU2ef
 HNltILiqeSPb1ghc1BkHtKelZLu6kUcaknWQ/CRDmYxew3rAZ6hOTvNYDZUqMNOlai1s
 ykr/jZr3mlVuKTI/fWfxyiBsjaQU6qs6RzcjNmAKZBylyerrrxjHkg43aAz56BYB71UL
 c25xBNbE2e+39+gZTNwcRWLP3LUfhf/pIoPMery5pVnqmPDTG+vPBAxfvhbx2POW8K41 yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w0u0fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wlpw106922;
        Thu, 7 Nov 2019 03:01:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wg120t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 03:01:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA731nVv028449;
        Thu, 7 Nov 2019 03:01:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:01:49 -0800
Subject: [PATCH 0/4] xfs: refactor corruption checking and reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Wed, 06 Nov 2019 19:01:48 -0800
Message-ID: <157309570855.45542.14663613458519550414.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=923
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this second series, we refactor the code that XFS uses to determine
that it is dealing with corrupt metadata and report that to userspace.

The first patch replaces the XFS_WANT_CORRUPT* macros with open-coded
versions because it's a little strange that a thing that looks like a
simple function call actually has series effects on code flow.

The second patch cleans up all the "if (bad) { XFS_ERROR_REPORT..." code
by combining that into a single XFS_IS_CORRUPT macro that does all that
logging.  This cleans up the error handling code blocks some more.

Patch three converts other metadata corruption checks to use the new
XFS_IS_CORRUPT macro.

Patch four converts some EIO-on-corruption returns that were missed in
an earlier cleanup patch.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-corruption-checks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-corruption-checks
