Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270C3C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE44F206C2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 16:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dPGHhz8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJHQaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:30:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHQaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 12:30:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98GNVDY150246
        for <linux-xfs@vger.kernel.org>; Tue, 8 Oct 2019 16:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=0F0wQj0WY/zAN4aKfezGoIg0LyHPxZqiYFZDqWFIyhQ=;
 b=dPGHhz8Yi7Jz3nkyeXNrPE+EbulKENSfTq4rym4wm1PX6nT8Z9LapQWt6JtIsb39e+yZ
 7zu8QbTqdVVnNWM2djqI+cKgoIkXM2KWYBmtWuMNu6TXogy1OfPjujzr054DS7wCwaH0
 KzFagxI5W+K2FO6IdHifkprFA41E7zULCbsJbZcBd9wd+7wmm3ZKBlTOVB+JMOT8abNi
 j2wE+/J7dXJpwmysZzYeudoOgqxWWEne5zJnaF21lDyTLRI0YmoRXpcKJevuWVQuQnPt
 7gEgFR/0T9RvKbppBQHZ+0H798L/pLAw8RIvW0ElE+cSQe8lXnD930QX7GcMrC9hYsgu 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qee7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2019 16:30:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x98GDeLs184007
        for <linux-xfs@vger.kernel.org>; Tue, 8 Oct 2019 16:30:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vgefawj56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 Oct 2019 16:30:11 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x98GUArl032644
        for <linux-xfs@vger.kernel.org>; Tue, 8 Oct 2019 16:30:10 GMT
Received: from localhost (/10.159.229.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Oct 2019 09:30:10 -0700
Date:   Tue, 8 Oct 2019 09:30:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 6350744c66a4
Message-ID: <20191008163009.GO1473994@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9404 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

*** NOTE *** These are XFS fixes for 5.4-rc3.  There's a bug in fs
writeback that caused fstests to crash ("writeback: fix use-after-free
in finish_writeback_work"); regrettably it did not make it upstream
until after -rc2.

I hope to have an iomap working branch for 5.5 around the end of the
week.

The new head of the for-next branch is commit:

6350744c66a4 xfs: move local to extent inode logging into bmap helper

New Commits:

Aliasgar Surti (1):
      [d5cc14d9f928] xfs: removed unused error variable from xchk_refcountbt_rec

Bill O'Donnell (1):
      [b4d5a0a3dc26] xfs: assure zeroed memory buffers for certain kmem allocations

Brian Foster (3):
      [7cb8e1afa5db] xfs: log the inode on directory sf to block format change
      [464327354d98] xfs: remove broken error handling on failed attr sf to leaf change
      [6350744c66a4] xfs: move local to extent inode logging into bmap helper

Eric Sandeen (1):
      [6374ca03975a] xfs: remove unused flags arg from xfs_get_aghdr_buf()

Max Reitz (1):
      [e093c4be760e] xfs: Fix tail rounding in xfs_alloc_file_space()


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c         |  5 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 21 +++------------------
 fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
 fs/xfs/libxfs/xfs_bmap.h       |  3 ++-
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/scrub/refcount.c        |  3 +--
 fs/xfs/xfs_bmap_util.c         |  4 +++-
 fs/xfs/xfs_buf.c               | 12 +++++++++++-
 fs/xfs/xfs_log.c               |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 10 files changed, 29 insertions(+), 31 deletions(-)
