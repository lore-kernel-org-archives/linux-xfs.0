Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B57FC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 462FF2063A
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 16:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MpizPKUJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgEIQ3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 12:29:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbgEIQ3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:29:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GPIPB065534;
        Sat, 9 May 2020 16:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=43s8mr6AAHMDPoi64JCX5ywtifFieMdUiCTzR5ScWqg=;
 b=MpizPKUJ+nZ2BPqZL8iXJm1j0xrDkrkIVczvc5Mwqg29O/AcwySdG6V7jz3ppUT51C+B
 DBoRFNLug7VXjfANtUK1B2hU3GgPYt4c38HoJS8HLMTYcrUrHRYwfJjx3HLIdWYWtaqw
 uQgSpIh/gHOn6OSLrMgW6t22KvnBkIQNBUahCfcm+l8TeO77GOY2X+PESCNfSzUs9PIr
 bniBUvtjyui9J+hTeIvs6wzfKdbw8SPttLmFYZtHqf7eEJrtMwAeHO93g2NXJzYtuJX7
 GThSiEEfvVdmRkYzRnjzk9fA1JXadZBUxh5w5fa52S+lk2epxO40028kUciEX2aVn6Oz mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30wx8n86ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GOEEQ100489;
        Sat, 9 May 2020 16:29:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30wwwpnhen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:29:52 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GTq1R020272;
        Sat, 9 May 2020 16:29:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:29:52 -0700
Subject: [PATCH 00/16] xfs_repair: catch things that xfs_check misses
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sat, 09 May 2020 09:29:52 -0700
Message-ID: <158904179213.982941.9666913277909349291.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A long-time goal of mine is to get rid of xfs_check from fstests,
because it is deprecated, adds quite a bit of runtime to the test suite,
and consumes memory like crazy.  We've not been able to do that for lack
of even a basic field-by-field corruption detection comparison between
check and repair, so I temporarily modified the dangerous_repair tests
to warn when check finds something but repair says clean.

The patches below teach xfs_repair to complain about things that it
previously did not catch but xfs_check did.  The one remaining gap is
the lack of quota counter checking, which will be sent in a separate
series once I've worked out all the bugs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=check-vs-repair
