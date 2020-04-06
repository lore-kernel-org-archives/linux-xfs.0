Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79346C2BA17
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE4622C9E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 16:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LwvphoME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgDFQy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 12:54:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44780 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgDFQy7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 12:54:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Gnkow012100
        for <linux-xfs@vger.kernel.org>; Mon, 6 Apr 2020 16:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Kjycbfx2HRwJ1gQrXIEgRlgeEYYYXw1053uWFE/Mjv0=;
 b=LwvphoMEx792qXstXFEXlfA+8Lb6EBFuWvyVlFgZZLG8qPx137A4rDCsV/yry5XLec+v
 mn69wpKnDBCQqIPF7PGuz3XOSmqaD67HMGQvjvpbuFGsAc8VuxzZvdCBjhUo8kifVWmy
 R8hifNOWgayQhW/RR7DS9uaIGMRuwix42dYibV7cI86k5txjuKPWMIDmW8Qh2KGnhpcS
 a2byubCDwZr0nYyDJOsAoZpOy403VnjeTRF0QetnDfVbThoRSRvosNEKaGdbfv9FYj2D
 1UAUwwi4fsMAac1oHz/KEaBS9Mva+McYIYJyQbCCuRwmwDBkirxl5fTiu55Mk+AO2AXe Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 306hnr04w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2020 16:54:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036GlRM4081145
        for <linux-xfs@vger.kernel.org>; Mon, 6 Apr 2020 16:54:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30741b3dvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2020 16:54:56 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036Gst2e004335
        for <linux-xfs@vger.kernel.org>; Mon, 6 Apr 2020 16:54:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 09:54:55 -0700
Date:   Mon, 6 Apr 2020 09:54:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 5833112df7e9
Message-ID: <20200406165454.GC6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.  Don't mind me shovelling in another bug fix.

The new head of the for-next branch is commit:

5833112df7e9 xfs: reflink should force the log out if mounted with wsync

New Commits:

Brian Foster (3):
      [8d3d7e2b35ea] xfs: trylock underlying buffer on dquot flush
      [d4bc4c5fd177] xfs: return locked status of inode buffer on xfsaild push
      [d9fdd0adf932] xfs: fix inode number overflow in ifree cluster helper

Christoph Hellwig (3):
      [8b41e3f98e6c] xfs: split xlog_ticket_done
      [54fbdd1035e3] xfs: factor out a new xfs_log_force_inode helper
      [5833112df7e9] xfs: reflink should force the log out if mounted with wsync

Darrick J. Wong (3):
      [f8e566c0f5e1] xfs: validate the realtime geometry in xfs_validate_sb_common
      [5cc3c006eb45] xfs: don't write a corrupt unmount record to force summary counter recalc
      [c6425702f21e] xfs: ratelimit inode flush on buffered write ENOSPC

Dave Chinner (15):
      [7ec949212dba] xfs: don't try to write a start record into every iclog
      [9590e9c68449] xfs: re-order initial space accounting checks in xlog_write
      [dd401770b0ff] xfs: refactor and split xfs_log_done()
      [70e42f2d4797] xfs: kill XLOG_TIC_INITED
      [f10e925def9a] xfs: merge xlog_commit_record with xlog_write_done
      [3c702f95909a] xfs: refactor unmount record writing
      [b843299ba5f9] xfs: remove some stale comments from the log code
      [108a42358a05] xfs: Lower CIL flush limit for large logs
      [0e7ab7efe774] xfs: Throttle commits on delayed background CIL push
      [2def2845cc33] xfs: don't allow log IO to be throttled
      [12eba65b28b0] xfs: Improve metadata buffer reclaim accountability
      [d59eadaea2b9] xfs: correctly acount for reclaimable slabs
      [4165994ac967] xfs: factor common AIL item deletion code
      [8eb807bd8399] xfs: tail updates only need to occur when LSN changes
      [5806165a6663] xfs: factor inode lookup from xfs_ifree_cluster

Kaixu Xia (2):
      [63337b63e7da] xfs: remove unnecessary ternary from xfs_create
      [d8fcb6f1346c] xfs: remove redundant variable assignment in xfs_symlink()


Code Diffstat:

 fs/xfs/libxfs/xfs_sb.c  |  32 +++++
 fs/xfs/xfs_buf.c        |  11 +-
 fs/xfs/xfs_dquot.c      |   6 +-
 fs/xfs/xfs_dquot_item.c |   3 +-
 fs/xfs/xfs_export.c     |  14 +-
 fs/xfs/xfs_file.c       |  16 +--
 fs/xfs/xfs_inode.c      | 174 +++++++++++++---------
 fs/xfs/xfs_inode.h      |   1 +
 fs/xfs/xfs_inode_item.c |  31 ++--
 fs/xfs/xfs_log.c        | 372 +++++++++++++++++-------------------------------
 fs/xfs/xfs_log.h        |   4 -
 fs/xfs/xfs_log_cil.c    |  55 +++++--
 fs/xfs/xfs_log_priv.h   |  75 +++++++---
 fs/xfs/xfs_mount.h      |   1 +
 fs/xfs/xfs_qm.c         |  14 +-
 fs/xfs/xfs_super.c      |  17 ++-
 fs/xfs/xfs_symlink.c    |   1 -
 fs/xfs/xfs_trace.h      |  15 +-
 fs/xfs/xfs_trans.c      |  27 ++--
 fs/xfs/xfs_trans_ail.c  |  88 +++++++-----
 fs/xfs/xfs_trans_priv.h |   6 +-
 21 files changed, 512 insertions(+), 451 deletions(-)
