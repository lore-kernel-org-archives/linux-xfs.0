Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B3C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBCCE222C3
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WHReBQ4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCKArR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKArR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0eIle137833
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=aE/TSXqyVdFWsSU/KnLdJ9HpEImg2wTQoa6L5R57f7U=;
 b=WHReBQ4pMLIEbTuGWE5iKT9isG1qBUE3M5S1u3nSGELurRcjrc6I0jrJtBlMB+G70FYe
 HcXBYrBALmDdIUOyCo0Ov4PnXT5DujJCvNG6BTgB9yRqWamtL8CiWB4ywWHI1lgqj9BG
 XvUpxJBBjCJOOQt2l6AZg2fRcV+0mC0vBO3VDzv1zgeJ6FgE/tdIaFz7JlEF+0ls9St4
 AkS4i5ZAcjmdz9nxoApZjXiWVwDcXy7sp4mrJALJ97X2ZU77+08YVAAvhsPRb53jpZCO
 Ns7+lRwNRmXQTmHJci+9R4If3nZKJROyaPT09dbN+9aSmNx1vCXo0Ijt3my8GDuMVe0H zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yp7hm52j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0c9nk087745
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yp8pv5bg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0lEWu019862
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:13 -0700
Subject: [PATCH v2 0/7] xfs: fix errors in various verifiers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:13 -0700
Message-ID: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

During a code audit of the effectiveness of the new online directory
repair code, it was discovered that XFS does not check the owner fields
of the dir3 free, data, and block format metadata blocks.  It was
further discovered that when the dir3 free block verifier rejects a
block, it does not leave the incore buffer in the correct state.
Correct these problems.

For v2, we actually stale the buffer so that it won't hang around on the
LRU, and fix a UAF bug I introduced into the attr inactivation bailout
code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=verifier-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=verifier-fixes
