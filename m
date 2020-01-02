Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED45FC2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD52221835
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 20:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgABUlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 15:41:35 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:48131 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgABUlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 15:41:35 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MvKTJ-1jeFvm46W9-00rDm7; Thu, 02 Jan 2020 21:41:16 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>, y2038@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH v3 2/2] xfs: quota: move to time64_t interfaces
Date:   Thu,  2 Jan 2020 21:40:46 +0100
Message-Id: <20200102204058.2005468-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20200102204058.2005468-1-arnd@arndb.de>
References: <20200102204058.2005468-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:onU+uB1esbQ3dsXBT7fEhIdBt0hzU21s3R+y0vIg8afhzsq7nRk
 ya/iySXsCZKeAjNroJnGdLoAWsx5vrmlb0OPxeJ6nMm/2LFcAwJ+Wx5uGD1iaf/X/M2pBy6
 TJq7uK+/hP6k7fYa1cdYx+Wmx/9JO5rw8CSRnl6L8//m+NKDW3iMn2g6+i3ewAqyrbyDgq2
 cNhHNES1SFpJQgfZl4iog==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1oUVC3DCrLs=:Lf4LJmEhdt2ALfh+Izfopx
 5DIpp2n2VVAyKd+lc9r0Xiran6T67mX4v8kVtm0YEGrvJ4ZVlzymGynIj/omOPs5r2DyeIe5R
 BvUAhadsP8vMdqc3MnMtFEe427cweoQukMs936LK6JYwMmvv+LzdhVATgvIrWXgSGab6HmXyo
 CURHIi5s9W8tfXcB0UB81ie6+tvx3GwG3PTz1a7i+cvumQn/NTeb28dTF55RFLZ9hXfyYlVI7
 TNwdiDnE2aIVzOIvTQ5jlrzUX14jzkRa5J9xwxR/XBw3yZNoVL0JpZ1IeSsSiPmvscncNThH+
 DTmwCZGkI8L9C4jGp4wN+sWi9G6/mQ8cUx+d9mpOAU3gdsJJ97XioyBuSGgnMyaC1Moac+LyJ
 mU8+wwT01a7xzVIRm5x71P1Bi6h52EbH7zwM3JTz71TML875tN8/8Fh2Fw7JUEIHGGhkXMmen
 gaLR8i+3YlztUPZqjU+aP4+hI9xHloR3YR0HHmRLjJ8w1d0qso3/2Hd6aHQvrKKQrWBkCUG9V
 PHb/wlVQGlBSXu3lDFwI1BrTHTlSr4jHG9lvWoMnuRN5oYLURjqeJ3ueXYzZ1UFY6LeBQz1FD
 inSNzU/xO0ku5gsvcPZWgZm6nqp1sjlWW+m5hpbb6hthrWkyP1TEAKlJyW6yDBAxbxImi0+7U
 /VKYBRB8QHDcN7iS3VUxhihygV8ty/2zpAqZ1wlmU7VyMYj8DyMe9UEoWeQMZv5d2wKEs15K3
 gcNIra9s2fgrKpILp9nw4BhgHQhLIQn2k8WzqrBTY7mc6Mmr/P8jXt3J+7R5q+1fKliRkZYyo
 MWs9KY6qHwyYKusfN0kTLnP8skDG3YiEnS0N03sXefaQOJ13Yqh/biO/xkeunOXwXethzFDK/
 c0lekH57mzdgmFpFTeBA==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As a preparation for removing the 32-bit time_t type and
all associated interfaces, change xfs to use time64_t and
ktime_get_real_seconds() for the quota housekeeping.

This avoids one difference between 32-bit and 64-bit kernels,
raising the theoretical limit for the quota grace period
to year 2106 on 32-bit instead of year 2038.

Note that common user space tools using the XFS quotactl
interface instead of the generic one still use the y2038
dates.

To fix quotas properly, both the on-disk format and user
space still need to be changed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This has a small conflict against the series at
https://www.spinics.net/lists/linux-xfs/msg35409.html
("xfs: widen timestamps to deal with y2038") which needs
to be rebased on top of this.

All other changes to remove time_t and get_seconds()
are now in linux-next, this is one of the last patches
needed to remove their definitions for v5.6.

If the widened timestamps make it into v5.6, this patch
can be dropped.
---
 fs/xfs/xfs_dquot.c       | 6 +++---
 fs/xfs/xfs_qm.h          | 6 +++---
 fs/xfs/xfs_quotaops.c    | 6 +++---
 fs/xfs/xfs_trans_dquot.c | 8 +++++---
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2bff21ca9d78..9cfd3209f52b 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -137,7 +137,7 @@ xfs_qm_adjust_dqtimers(
 		    (d->d_blk_hardlimit &&
 		     (be64_to_cpu(d->d_bcount) >
 		      be64_to_cpu(d->d_blk_hardlimit)))) {
-			d->d_btimer = cpu_to_be32(get_seconds() +
+			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
@@ -160,7 +160,7 @@ xfs_qm_adjust_dqtimers(
 		    (d->d_ino_hardlimit &&
 		     (be64_to_cpu(d->d_icount) >
 		      be64_to_cpu(d->d_ino_hardlimit)))) {
-			d->d_itimer = cpu_to_be32(get_seconds() +
+			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
@@ -183,7 +183,7 @@ xfs_qm_adjust_dqtimers(
 		    (d->d_rtb_hardlimit &&
 		     (be64_to_cpu(d->d_rtbcount) >
 		      be64_to_cpu(d->d_rtb_hardlimit)))) {
-			d->d_rtbtimer = cpu_to_be32(get_seconds() +
+			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
 					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 7823af39008b..4e57edca8bce 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -64,9 +64,9 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
 	struct list_lru	 qi_lru;
 	int		 qi_dquots;
-	time_t		 qi_btimelimit;	 /* limit for blks timer */
-	time_t		 qi_itimelimit;	 /* limit for inodes timer */
-	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
+	time64_t	 qi_btimelimit;	 /* limit for blks timer */
+	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
+	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
 	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
 	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
 	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index c7de17deeae6..38669e827206 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -37,9 +37,9 @@ xfs_qm_fill_state(
 	tstate->flags |= QCI_SYSFILE;
 	tstate->blocks = ip->i_d.di_nblocks;
 	tstate->nextents = ip->i_d.di_nextents;
-	tstate->spc_timelimit = q->qi_btimelimit;
-	tstate->ino_timelimit = q->qi_itimelimit;
-	tstate->rt_spc_timelimit = q->qi_rtbtimelimit;
+	tstate->spc_timelimit = (u32)q->qi_btimelimit;
+	tstate->ino_timelimit = (u32)q->qi_itimelimit;
+	tstate->rt_spc_timelimit = (u32)q->qi_rtbtimelimit;
 	tstate->spc_warnlimit = q->qi_bwarnlimit;
 	tstate->ino_warnlimit = q->qi_iwarnlimit;
 	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index a6fe2d8dc40f..d1b9869bc5fa 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -580,7 +580,7 @@ xfs_trans_dqresv(
 {
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
-	time_t			timer;
+	time64_t		timer;
 	xfs_qwarncnt_t		warns;
 	xfs_qwarncnt_t		warnlimit;
 	xfs_qcnt_t		total_count;
@@ -635,7 +635,8 @@ xfs_trans_dqresv(
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
-				if ((timer != 0 && get_seconds() > timer) ||
+				if ((timer != 0 &&
+				     ktime_get_real_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
 						       QUOTA_NL_BSOFTLONGWARN);
@@ -662,7 +663,8 @@ xfs_trans_dqresv(
 				goto error_return;
 			}
 			if (softlimit && total_count > softlimit) {
-				if  ((timer != 0 && get_seconds() > timer) ||
+				if  ((timer != 0 &&
+				      ktime_get_real_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
 						       QUOTA_NL_ISOFTLONGWARN);
-- 
2.20.0

