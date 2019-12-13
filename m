Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91ACCC4D2C5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C63FB2469F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 20:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLMU6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 15:58:14 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:60083 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfLMU6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 15:58:14 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M89bP-1iacoR0uTj-005GHx; Fri, 13 Dec 2019 21:58:04 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 21/24] xfs: quota: move to time64_t interfaces
Date:   Fri, 13 Dec 2019 21:53:49 +0100
Message-Id: <20191213205417.3871055-12-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:U4OoSyJcMxWrLz56NTLy5TvcMiZnlFrF1R3kAshvAlEbSRCOzeC
 MU+a+kgOurK/EF2WxWRPMR623nA1fdKR5uRZ5zKbNPf7Q2ifioCKn5m71y7W41kzptK+bmW
 9TOOEK3FNdMOUOQoRUe5MnmmUq4cS3xgQeGYFPjj5jUUq3spY9G9co13nAzhAlTt8J/ZDfO
 +dqdMz7x2VQcU+LqrJVNQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4lyDylcgSX0=:F5ZQkV9kT770JxgnJn/cL8
 evBqGVlSOOHU9YaF40rxkzMeuVOWdyUbeluOGJJoi27Gtec8k8wXepwcwF2X+kQ/bGHRH+J8j
 PjjDXCcTk2Hty4XzJOPpv7Fv0xgqAP+4gQfP8IdGfq2OuJ/OyARMKjaCfYMhmYLIP3wrg6ccW
 gtiugyTF6LhkR33EtG6hVSDPgEXi/exbCoyrKa6ShVgnIi/JlRRJBYPgj16sjAMO/OXbkvY6u
 Xps2P8/JfVrKNZbEiZlLVALGFNqcrUdGKMOUOT571zbbP7E62dCsyD02WJMx8t0JydYxsC/Ou
 VtgaSRolPluzw+f7YnHCpjtW4QxfSH60A9mLCFjtEg0SQiDmUxREbHg3t7FVMBSGkktjffPAz
 LFgTgjqOoYjMEHC5hNqhHp1HmEJvIuXDpcLpPu5VD8VnYLDl7YSM71H6pZm4oL7VrAFpgcD0s
 l9qvZ/Jx0kmcY97rs/JGUZQXE6C5exrGmn2EZLLXyBZ+AKj83tgyN8NZY7olersMN9gPyeafi
 n1EpZh7UBE+d/XXv5ZvG7rqLqCAE9Sk2q6rik8uvPQ6DqP6aEvyQ50sA6CgFKwP2p3pdJelUO
 5rFSAbi9xXwOqG0ZwWf++sNzNgbH3uiPbJ0poN26J4mz3BZmaKNVv3nY9UFqUCH5J8y37HHrC
 RFD0VmbxowJHo/BR9zbH3SBtYyP0ODVTvILY5ibLHYZMMkktaI+DZXL0LHXVbczPyIs3cUCx5
 dgU73Z+qHw36dXcT3e6TEf9S9ASK7H4SEglU5STCth0eRVfRvGBiyf6GteFPF2suKIchlxBo9
 5bBLjgE/fCM3JhJUtx7QoCvNKcxyA7urx4LcaHNsEjy7ZKwk5V21PMatuptaWTElQOF7utsKd
 sdIkxulCikM8Z1R+3ZYg==
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As a preparation for removing the 32-bit time_t type and
all associated interfaces, change xfs to use time64_t and
ktime_get_real_seconds() for the quota housekeeping.

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

