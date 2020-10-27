Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A704AC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0F121D42
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 19:06:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AKfrOsxi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503718AbgJ0TGD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 15:06:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503794AbgJ0TGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:06:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIt6wd108088;
        Tue, 27 Oct 2020 19:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=F1eqUbYboSqXHRNYVDWUvPtnDvXpczmOTMrRhEMoYLQ=;
 b=AKfrOsxi4u501n6X3Xuyolj0pJeHgYUhTPK7i+rPTKIq1RfGj+rS4oDPUODrNTWN3NXl
 U6jYlvOZ78hNjP5x+eWBezkpu1VuRpswrPDaTm7qt9nelfeiivyFfpCSYSbYDH9ENblr
 G7QbwIUY0QNd8IOhu6dgFUbS5E2fN+r3xhlbcdhtRdAqDlt3aVV0F10gl8pxtswHU8Je
 u2ep5zNmf7AV89V6Wtve0firQWUq0bQaJUxGOcjqBBk2jYLyytvaDyzaIHL7FM1g6TIX
 KdOut1Z4l7Dm/L4Wrv6iLn1Rwt/4MvTmj6eQnzKVOVqCYjVDL9OL2BKoHKfeb05rKFdF kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7kuv7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:06:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RItK9e019886;
        Tue, 27 Oct 2020 19:04:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34cx6wbnwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:04:00 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RJ3x09028369;
        Tue, 27 Oct 2020 19:03:59 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:03:55 -0700
Subject: [PATCH RFC v6 0/4] xfstests: widen timestamps to deal with y2038+
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:03:54 -0700
Message-ID: <160382543472.1203848.8335854864075548402.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
to the non-root dquot timer fields to boost their effective size to 34
bits.  These two changes enable correct time handling on XFS through the
year 2486.

On a current V5 filesystem, inodes timestamps are a signed 32-bit
seconds counter, with 0 being the Unix epoch.  Quota timers are an
unsigned 32-bit seconds counter, with 0 also being the Unix epoch.

This means that inode timestamps can range from:
-(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).

And quota timers can range from:
0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).

With the bigtime encoding turned on, inode timestamps are an unsigned
64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
are a 34-bit unsigned second counter right shifted two bits, with 0
being the Unix epoch, and capped at the maximum inode timestamp value.

This means that inode timestamps can range from:
0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)

Quota timers could theoretically range from:
0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).

But with the capping in place, the quota timers maximum is:
max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).

v2: rebase to 5.9, having landed the quota refactoring
v3: various suggestions by Amir and Dave
v4: drop the timestamp unions, add "is bigtime?" predicates everywhere
v5: reintroduce timestamp unions as *legacy* timestamp unions
v6: minor stylistic changes

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
 common/rc             |    2 -
 common/xfs            |   30 ++++++++++
 tests/generic/721     |  117 +++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    1 
 tests/generic/722     |  120 ++++++++++++++++++++++++++++++++++++++
 tests/generic/722.out |    1 
 tests/generic/group   |    2 +
 tests/xfs/122         |    1 
 tests/xfs/122.out     |    1 
 tests/xfs/908         |   87 ++++++++++++++++++++++++++++
 tests/xfs/908.out     |   10 +++
 tests/xfs/909         |  153 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out     |    4 +
 tests/xfs/911         |   44 ++++++++++++++
 tests/xfs/911.out     |   15 +++++
 tests/xfs/group       |    3 +
 16 files changed, 590 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out
 create mode 100755 tests/generic/722
 create mode 100644 tests/generic/722.out
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out

