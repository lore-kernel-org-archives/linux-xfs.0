Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B24C2D0D2
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 840802146E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 16:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfLRQos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:44:48 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:35725 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfLRQos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 11:44:48 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MGgRW-1iTsus1Nac-00Dsp6; Wed, 18 Dec 2019 17:44:20 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] xfs: quota: move to time64_t interfaces
Date:   Wed, 18 Dec 2019 17:44:05 +0100
Message-Id: <20191218164418.463467-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191218163954.296726-1-arnd@arndb.de>
References: <20191218163954.296726-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FUskByiXnCTH70Q8n4XCuCHT4CPOpZnVwrXf6WYJO0e75Nr0PkI
 /3qYAc9i1Gb0z3DV7SD6P0CowGHqfFUAgc1InUWAjgphQascqxFczuBbwL/GN7Z76TUNqnK
 yv7bOtCBDc+pBvCXVUXOZ3Ig3NsqRZn6fRK7lkW3QFrj4Wuf8Xf2gp1UrycHD7XJ5MQsQ8C
 StzNKoNY4xo73FADLxmUA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CJHPKKZvaj8=:951edUD5nPzOwVPTUhUzTo
 Na8wsKech0H1SPSyDKfyESXK+qPEGA6OnlRj0aHs5dOX3SoOLrUqx8HzJQ6aglzju7+HIncJT
 yBRJgnGP7JRUgHk2tksC0ucChGYjSUJqsPkbFrDlXo18m5COvHH9u6mVbSBVCGpgjLHGZyyDE
 rLcVEiz+OWpFFSFXQdTlNYAm4gFYn2Mj0fvk/s/82K7He1tfA+JlL4WJNq4Vpnzy+ZcYDZpCv
 9eSZ+gmFRGhWXeTc+6RUVeJ5cDSk0K2DPSb8KSnCW5GvqSucWZWSz6CDKEOPtsVI89k8AW8h1
 Hy2WhVUpuaKGbWcqUs3OAmBtHqNnSOP5BMsE9u4E553ADYtzFgzRnQM4MCWcR/L+R59lgStGg
 JI0F0C29gdeTnrGRKWpaj7Gv9tW5LeQPGRSlqOovqnJbSOSRV6ZwAs/cQSmn4E9r/78ZYOrff
 Yu7ooH71Xb18C0F9KF/kJrZPVeapR4OnXCVRzZgdDoFeynb62+5TpICCNl+ISo/A6S5so2vs7
 WKXoR7fWfHUlPqNryVYikAVwLrIRNDKZ44vVwuAjDCfIpZZye+rw+0wjMrnI93MpAOmoy2P+/
 V0dH7JFrIWu6rVPhdMDLrKV/UasnYN7sLDmdw+Vexi7CTbS5s9gRZpeazWHLC6RlYcrmdiv0o
 1zAHJrJqaVlGfqldsCksKwh0i6OnEaoBfWSnZeP1OCljlz3gbm2Cce2PIsXD1uSFkeq3beX7R
 /zx/jI4DDP1d4MUr/kiojBi0h4qOzEE+psQzHOLYVBypfxwAkD+pVLiqehJ/gvmM44bhzkObA
 QcyKcWjd71X3+kXy7nZYqn2DsoSfhSD93OWyCbRmau7YIpcm4+8h7VKgty1JAxfMFAa1778bp
 1gxy1cBGfoEw15O0qs9w==
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

