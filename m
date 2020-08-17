Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF28AC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B960F2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 22:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uy0dGjTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgHQW65 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 18:58:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbgHQW64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:58:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMwto9062630;
        Mon, 17 Aug 2020 22:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9N+xTlhZ8sLU2pYgIJY2NiPKFf95wkfl3a8VdsWoonM=;
 b=Uy0dGjTUSfD2KgKecjZKmY6QirSY1QEA8pppmQ2/Br6ySLZIUoRfOEGXslfJiXvASs3E
 ieygeZ1Q+YohUHwcM8v0kPRn4huf2TOE4zgfLPXZ9h6F9HAJkkPt9e1azFH9cqPiRtZO
 1Uo6sUgDFep7hsiqg55gvZp4jzqCXv4K661uj8CKbFFJblVRkU2h7jJs12JjcG5BvYKy
 +d4Fb4l9clFvPYB48RUkliZrv15+Y29gaZv4aadUW/QRQK0bLr5kqAluCUo32DsIROym
 ywk6JU4X7+Z1xBhqbnY84IdY4TKLmyZ6qjQf5Ex0dRGDseWyjlh361CViNm069Dyr01v hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:58:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw7HX138964;
        Mon, 17 Aug 2020 22:58:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9m9ypj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:58:55 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HMwsAv025254;
        Mon, 17 Aug 2020 22:58:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:58:54 -0700
Subject: [PATCH 00/18] xfsprogs: widen timestamps to deal with y2038
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 15:58:51 -0700
Message-ID: <159770513155.3958786.16108819726679724438.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
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
 db/Makefile                |    2 -
 db/command.c               |    1 
 db/command.h               |    1 
 db/dquot.c                 |   31 ++++++++-
 db/field.c                 |    8 ++
 db/field.h                 |    3 +
 db/fprint.c                |  120 +++++++++++++++++++++++++++++++++++
 db/fprint.h                |    6 ++
 db/inode.c                 |   30 ++++++++-
 db/sb.c                    |   15 ++++
 db/timelimit.c             |  152 ++++++++++++++++++++++++++++++++++++++++++++
 include/libxfs.h           |    1 
 include/platform_defs.h.in |    3 +
 include/xfs_inode.h        |   22 +++---
 include/xfs_mount.h        |    5 +
 libfrog/fsgeom.c           |    6 +-
 libxfs/libxfs_api_defs.h   |   14 ++++
 libxfs/libxfs_priv.h       |    2 -
 libxfs/util.c              |   10 ++-
 libxfs/xfs_dquot_buf.c     |   60 +++++++++++++++++
 libxfs/xfs_format.h        |  139 +++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_fs.h            |    1 
 libxfs/xfs_inode_buf.c     |  132 +++++++++++++++++++-------------------
 libxfs/xfs_inode_buf.h     |    7 +-
 libxfs/xfs_log_format.h    |   21 ++++--
 libxfs/xfs_quota_defs.h    |    9 ++-
 libxfs/xfs_sb.c            |    2 +
 man/man8/mkfs.xfs.8        |   16 +++++
 man/man8/xfs_admin.8       |    5 +
 man/man8/xfs_db.8          |   23 +++++++
 mkfs/xfs_mkfs.c            |   24 +++++++
 repair/dinode.c            |   25 ++++++-
 scrub/common.c             |    2 -
 scrub/progress.c           |    1 
 34 files changed, 772 insertions(+), 127 deletions(-)
 create mode 100644 db/timelimit.c

