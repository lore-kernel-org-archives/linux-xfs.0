Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kCbCPhuM"
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F391B118
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 09:05:36 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BE9wrrs009144
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=xwWp/MPqnOEHD0iRkaamWsYZjf5ITDsySX36CO2BFfc=;
 b=kCbCPhuMhkvKszsqg7gp7xP4BSGqQwAjd4XgNPpRmbnB1QddR1kNCPX0UKZH1uVgPRl3
 X1mAyTHY4b81Jj9zgYP7BUAjDrHd9RM5ZSyThxmoYr2Ve3L+JtQI+RHlIzIM157MU8p+
 9naf+06ADSjoBlHZ8vCg4MxGmr0HDQqKpWHKVSa1lVh9j4sWEt1NTlwxGbfuSX680qBA
 /k59NZt8kUfQx3/bQMTZYvbETrFCvonL/9TYtugmJm29x7au39/IfryTlUq1M3VA80cB
 v4EHVCbKgYktI+vJXMHg0zN8MGKSSsosHyqVoLwrNDebWyxTg9IF2GHmgQCdX/cabes2 gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3sh4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEGDPZm012793
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepahcw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEH0mnn036808
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:05:34 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-65-131-193.vpn.oracle.com [10.65.131.193])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3uvepahcsv-6;
	Thu, 14 Dec 2023 17:05:34 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 5/9] xfs: defrag: process some cases in xfs_defrag_process
Date: Thu, 14 Dec 2023 09:05:26 -0800
Message-Id: <20231214170530.8664-6-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20231214170530.8664-1-wen.gang.wang@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_11,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312140121
X-Proofpoint-ORIG-GUID: QZYDfOeQDKrTvaWE3hcxXXjEPmlLl00E
X-Proofpoint-GUID: QZYDfOeQDKrTvaWE3hcxXXjEPmlLl00E

In the main process xfs_defrag_process(), deal with following cases:

1. sleep until next defragmentation time come
2. sleep if no defragmetation job exist
3. defragmentation job is stopped by user
4. defragmentation job failed (stay a while for user to pick up error)
5. defragmentation job is suspended
6. defragmentation job is done successfully

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_defrag.c | 146 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_defrag.c b/fs/xfs/xfs_defrag.c
index fec617ac5945..aee4cfd3f86e 100644
--- a/fs/xfs/xfs_defrag.c
+++ b/fs/xfs/xfs_defrag.c
@@ -190,6 +190,14 @@ static void __xfs_drop_defrag(struct xfs_defrag_info *di, struct xfs_mount *mp)
 	kfree(di);
 }
 
+/* cleanup when a defragmentation is done, failed, or cancelled. */
+static void xfs_drop_defrag(struct xfs_defrag_info *di, struct xfs_mount *mp)
+{
+	down(&mp->m_defrag_lock);
+	__xfs_drop_defrag(di, mp);
+	up(&mp->m_defrag_lock);
+}
+
 /* clean up all defragmentation jobs in this XFS */
 void clean_up_defrags(struct xfs_mount *mp)
 {
@@ -203,15 +211,149 @@ void clean_up_defrags(struct xfs_mount *mp)
 	up(&mp->m_defrag_lock);
 }
 
+/*
+ * if mp->m_defrag_list is not empty, return the first one in the list.
+ * returns NULL otherwise.
+ */
+static struct xfs_defrag_info *get_first_defrag(struct xfs_mount *mp)
+{
+	struct xfs_defrag_info *first;
+
+	down(&mp->m_defrag_lock);
+	if (list_empty(&mp->m_defrag_list))
+		first = NULL;
+	else
+		first = container_of(mp->m_defrag_list.next,
+				struct xfs_defrag_info, di_list);
+	up(&mp->m_defrag_lock);
+	return first;
+}
+
+/*
+ * if mp->m_defrag_list is not empty, return the last one in the list.
+ * returns NULL otherwise.
+ */
+static struct xfs_defrag_info *get_last_defrag(struct xfs_mount *mp)
+{
+	struct xfs_defrag_info *last;
+
+	down(&mp->m_defrag_lock);
+	if (list_empty(&mp->m_defrag_list))
+		last = NULL;
+	else
+		last = container_of(mp->m_defrag_list.prev,
+				struct xfs_defrag_info, di_list);
+	up(&mp->m_defrag_lock);
+	return last;
+}
+
+static inline bool xfs_defrag_failed(struct xfs_defrag_info *di)
+{
+	return di->di_defrag.df_status != 0;
+}
+
+/* so far do nothing */
+static bool xfs_defrag_file(struct xfs_defrag_info *di)
+{
+	return true;
+}
+
+static inline bool xfs_defrag_suspended(struct xfs_defrag_info *di)
+{
+	return di->di_defrag.df_suspended;
+}
+
 /* run as a separated process.
  * defragment files in mp->m_defrag_list
  */
 int xfs_defrag_process(void *data)
 {
+	unsigned long		smallest_wait = ULONG_MAX;
 	struct xfs_mount	*mp = data;
+	struct xfs_defrag_info	*di, *last;
+
+	while (!kthread_should_stop()) {
+		bool	defrag_any = false;
 
-	while (!kthread_should_stop())
-		xfs_defrag_idle(1000);
+		if (smallest_wait != ULONG_MAX) {
+			smallest_wait = max_t(unsigned long, smallest_wait, 10);
+			xfs_defrag_idle(smallest_wait);
+			smallest_wait = ULONG_MAX;
+		}
+
+		last = get_last_defrag(mp);
+		if (!last) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			continue; /* while loop */
+		}
+
+		do {
+			unsigned long	next_defrag_time;
+			unsigned long	save_jiffies;
+
+			if (kthread_should_stop())
+				break; /* do */
+
+			di = get_first_defrag(mp);
+			/* done this round */
+			if (!di)
+				break; /* do */
+
+			/* stopped by user, clean up right now */
+			if (di->di_user_stopped) {
+				xfs_drop_defrag(di, mp);
+				continue; /* do */
+			}
+
+			/*
+			 * Defrag failed on this file, give some grace time, say 30s
+			 * for user space to capture the error
+			 */
+			if (xfs_defrag_failed(di)) {
+				unsigned long drop_time = di->di_last_process
+					+ msecs_to_jiffies(XFS_DERFAG_GRACE_PERIOD);
+				save_jiffies = jiffies;
+				/* not the time to drop this failed file yet */
+				if (time_before(save_jiffies, drop_time)) {
+					/* wait a while before dropping this file */
+					if (smallest_wait > drop_time - save_jiffies)
+						smallest_wait = drop_time - save_jiffies;
+				} else {
+					xfs_drop_defrag(di, mp);
+				}
+				continue; /* do */
+			}
+
+			if (xfs_defrag_suspended(di))
+				continue; /* do */
+
+			next_defrag_time = di->di_last_process
+					+ msecs_to_jiffies(di->di_defrag.df_idle_time);
+
+			save_jiffies = jiffies;
+			if (time_before(save_jiffies, next_defrag_time)) {
+				if (smallest_wait > next_defrag_time - save_jiffies)
+					smallest_wait = next_defrag_time - save_jiffies;
+				continue; /* do */
+			}
+
+			defrag_any = true;
+			/* whole file defrag done successfully */
+			if (xfs_defrag_file(di))
+				xfs_drop_defrag(di, mp);
+
+			/* avoid tight CPU usage */
+			xfs_defrag_idle(2);
+		} while (di != last);
+
+		/* all the left defragmentations are suspended */
+		if (defrag_any == false && smallest_wait == ULONG_MAX) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+		}
+
+	}
 
 	clean_up_defrags(mp);
 	return 0;
-- 
2.39.3 (Apple Git-145)

