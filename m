Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3967DC55ABD
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5077206A1
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IUi2D/Xp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgKISRP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:15 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKISRO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9I9o1M120432;
        Mon, 9 Nov 2020 18:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=5k1abBe4/SJLb+qrmfj+YZ60ypkdAOtriU6iIlFejC4=;
 b=IUi2D/Xps9eWNYm9uo+khNa7+TsVO6ggi4Y+Mi86A4ha6HSQ9N+N0utyvM7KnmV8nQ4U
 f5PEZLPmTtjh/MO2IFz4RRh6vulDL9dOtwW0updPeqEQgAKu7nPKBmG7UkqU9pzt4uUV
 d0IRVmUFLcRI1CP26kmwxs9zU9ndzhoym3fY60tYeSnsubT4wnXHxRvnUZ6AUpjeABn5
 Yt3YR1xxPrlpUFJ70sg2Zy4Szx95Re331rGbU/L67qLhVzZogZ6/dvxjenw8sV54yA1b
 vBDEtfz14qwA1kIRX4gCTlf5nzBR0TRBBSA5vOktHdeSM+6u2i2rY76yZPVfdz9V+oCF 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34nh3aqn7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IAoqo157400;
        Mon, 9 Nov 2020 18:17:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34p5fy1h2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IHAnH010055;
        Mon, 9 Nov 2020 18:17:10 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:10 -0800
Subject: [PATCH 0/3] xfs: fix serious bugs in rmap key comparison
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:09 -0800
Message-ID: <160494582942.772693.12774142799511044233.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Last week I found some time to spend auditing the effectiveness of the
online repair prototype code, and discovered a serious bug in the rmap
code.  Each btree type provides four comparison predicates: one for
comparing a key against the current record; one for comparing two
arbitrary record keys, and one each for checking if a btree block's
records or keys are in the correct order.

Unfortunately, I encoded a major thinko into those last three functions.
The XFS_RMAP_OFF macro masks off the three namespace bits before we
perform a comparison, which means that key comparisons do not notice
differences between the unwritten, bmbt, or attr fork status.  On a
consistent filesystem this is not an issue because there can only ever
be overlapping rmap records for written inode data fork extents, which
is why we've not yet seen any problems in the field.

Fortunately, the last two functions are used by debugging asserts and
online scrub to check the contents of a btree block, so the severity of
the flaw there is not high.

Unfortunately, the flaw in _diff_two_keys is more severe, because it is
used for query_range requests.  Ranged queries are used by the regular
rmap handling code when reflink is enabled; and it is used in the rmap
btree validation routines of both xfs_scrub and xfs_repair.  As I
mentioned above, the flaw should not manifest on a *consistent*
filesystem, but for fuzzed (or corrupt) filesystems, this seriously
impacts our ability to detect problems.

The first two patches in this series fix two places where we pass the
wrong flags arguments to the rmap query functions (which didn't
previously cause lookup failures due to the broken code) and the third
patch fixes the comparison functions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-fixes-5.10
---
 fs/xfs/libxfs/xfs_rmap.c       |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c |   16 ++++++++--------
 fs/xfs/scrub/bmap.c            |    2 ++
 3 files changed, 11 insertions(+), 9 deletions(-)

