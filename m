Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70055C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D4023A24
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgLQVMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 16:12:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54650 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgLQVMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Dec 2020 16:12:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHL4N1Z038939;
        Thu, 17 Dec 2020 21:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ToE7bbmEY4WgMSl/lmZybuCco2OfMxwUm7ASfH+HwFk=;
 b=wNlUAo4OIrK9QDxtj9TTWxoiB3V9s4HHjoyc8cIUkEOJFBu5pW3H/jhMGiTir27a/uwY
 q3CSifFzS+1LAprH8ueBT4wmMubIWs3vbVsJdblpV5b1i4O/F954fC2yk/2oprR2fopl
 HMVZ3Wmx4UUthurHwUFdnLNXG7orxmVdAtb60VD339mBvLWpGEv5GvlhXltOI0lx4sVi
 JwtNXiZYzVLQt3qrFk6VKju+TsRYXIKTDKdcemyy3nlPmmiVmWPRAawa++/ORXKGzzJj
 r1BOJu2upMKS421BjYLIv10NmOR+ZzVKYsSUozVe+jrKhClWHtYkV5ZraDUomzPfY6XL Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35cn9rqj4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 21:11:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHL5GKx093983;
        Thu, 17 Dec 2020 21:11:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6etvste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 21:11:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BHLBJ6a023378;
        Thu, 17 Dec 2020 21:11:19 GMT
Received: from localhost (/10.159.157.202)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 13:11:18 -0800
Date:   Thu, 17 Dec 2020 13:11:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     wenli xie <wlxie7296@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [Bug report] overlayfs over xfs whiteout operation may cause
 deadlock
Message-ID: <20201217211117.GF38809@magnolia>
References: <CABRboy006NP8JrxuBgEJbfCcGGUY2Kucwfov+HJf2xW34D5Ocg@mail.gmail.com>
 <20201211234233.GK106271@magnolia>
 <CABRboy35_tyxA3gHN7_=xp0_RVugQjvFOHCRsH4Y4rrivE7HmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABRboy35_tyxA3gHN7_=xp0_RVugQjvFOHCRsH4Y4rrivE7HmQ@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170140
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 15, 2020 at 08:44:27PM +0800, wenli xie wrote:
> I tried upstream kernel 5.10 to do the test, and this issue still  can be
> reproduced.

Thanks for the report, I've condensed this down to the following:

#!/bin/bash

SCRATCH_MNT=/mnt
LOAD_FACTOR=1
TIME_FACTOR=1

mkfs.xfs -f /dev/sda
mount /dev/sda $SCRATCH_MNT

mkdir $SCRATCH_MNT/lowerdir
mkdir $SCRATCH_MNT/lowerdir1
mkdir $SCRATCH_MNT/lowerdir/etc
mkdir $SCRATCH_MNT/workers
echo salts > $SCRATCH_MNT/lowerdir/etc/access.conf
touch $SCRATCH_MNT/running

stop_workers() {
	test -e $SCRATCH_MNT/running || return
	rm -f $SCRATCH_MNT/running

	while [ "$(ls $SCRATCH_MNT/workers/ | wc -l)" -gt 0 ]; do
		wait
	done
}

worker() {
	local tag="$1"
	local mergedir="$SCRATCH_MNT/merged$tag"
	local l="lowerdir=$SCRATCH_MNT/lowerdir:$SCRATCH_MNT/lowerdir1"
	local u="upperdir=$SCRATCH_MNT/upperdir$tag"
	local w="workdir=$SCRATCH_MNT/workdir$tag"
	local i="index=off"

	touch $SCRATCH_MNT/workers/$tag
	while test -e $SCRATCH_MNT/running; do
		rm -rf $SCRATCH_MNT/merged$tag
		rm -rf $SCRATCH_MNT/upperdir$tag
		rm -rf $SCRATCH_MNT/workdir$tag
		mkdir $SCRATCH_MNT/merged$tag
		mkdir $SCRATCH_MNT/workdir$tag
		mkdir $SCRATCH_MNT/upperdir$tag

		mount -t overlay overlay -o "$l,$u,$w,$i" $mergedir
		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
		touch $mergedir/etc/access.conf
		mv $mergedir/etc/access.conf $mergedir/etc/access.conf.bak
		touch $mergedir/etc/access.conf
		umount $mergedir
	done
	rm -f $SCRATCH_MNT/workers/$tag
}

for i in $(seq 0 $((4 + LOAD_FACTOR)) ); do
	worker $i &
done

sleep $((30 * TIME_FACTOR))
stop_workers

...and I think this is enough to diagnose the deadlock.

This is an ABBA deadlock caused by locking the AGI buffers in the wrong
order.  Specifically, we seem to be calling xfs_dir_rename with a
non-null @wip and a non-null @target_ip.  In the deadlock scenario, @wip
is an inode in AG 2, and @target_ip is an inode in AG 0 with nlink==1.

First we call xfs_iunlink_remove to remove @wip from the unlinked list,
which causes us to lock AGI 2.  Next we replace the directory entry.
Finally, we need to droplink @target_ip.  Since @target_ip has nlink==1,
xfs_droplink will need to put it on AGI 0's unlinked list.

Unfortunately, the locking rules say that you can only lock AGIs in
increasing order.  This means that we cannot lock AGI 0 after locking
AGI 2 without risking deadlock.

Does the attached patch fix the deadlock for you?

--D

From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix an ABBA deadlock in xfs_rename

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in the correct order.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b7352bc4c815..dd419a1bc6ba 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3000,6 +3000,48 @@ xfs_rename_alloc_whiteout(
 	return 0;
 }
 
+/*
+ * For the general case of renaming files, lock all the AGI buffers we need to
+ * handle bumping the nlink of the whiteout inode off the unlinked list and to
+ * handle dropping the nlink of the target inode.  We have to do this in
+ * increasing AG order to avoid deadlocks.
+ */
+static int
+xfs_rename_lock_agis(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*wip,
+	struct xfs_inode	*target_ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*bp;
+	xfs_agnumber_t		agi_locks[2] = { NULLAGNUMBER, NULLAGNUMBER };
+	int			error;
+
+	if (wip)
+		agi_locks[0] = XFS_INO_TO_AGNO(mp, wip->i_ino);
+
+	if (target_ip && VFS_I(target_ip)->i_nlink == 1)
+		agi_locks[1] = XFS_INO_TO_AGNO(mp, target_ip->i_ino);
+
+	if (agi_locks[0] != NULLAGNUMBER && agi_locks[1] != NULLAGNUMBER &&
+	    agi_locks[0] > agi_locks[1])
+		swap(agi_locks[0], agi_locks[1]);
+
+	if (agi_locks[0] != NULLAGNUMBER) {
+		error = xfs_read_agi(mp, tp, agi_locks[0], &bp);
+		if (error)
+			return error;
+	}
+
+	if (agi_locks[1] != NULLAGNUMBER) {
+		error = xfs_read_agi(mp, tp, agi_locks[1], &bp);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /*
  * xfs_rename
  */
@@ -3130,6 +3172,10 @@ xfs_rename(
 		}
 	}
 
+	error = xfs_rename_lock_agis(tp, wip, target_ip);
+	if (error)
+		return error;
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
