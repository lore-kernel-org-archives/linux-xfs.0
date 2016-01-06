Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F47B7F50
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 22:57:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7068D8F804B
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 20:57:00 -0800 (PST)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	XBqFOFbl22KUKZ3g for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 20:56:58 -0800 (PST)
Subject: [PATCH v2 3/4] xfs: unmap dax at shutdown (force_failure)
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Jan 2016 20:56:32 -0800
Message-ID: <20160106045632.38788.84927.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160106045616.38788.61076.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org

When an exceptional event triggers xfs_force_shutdown() tear down dax
mappings.  Quoting Dave,

    "The simple fact is that a /filesystem/ shutdown needs to do DAX
    mapping invalidation regardless of whether the block device has
    been unplugged or not. This is not a case of "this only happens
    when we unplug the device", this is a user data protection
    mechanism that we use to prevent corruption propagation once it
    has been detected. A device unplug is just one type of
    "corruption" that can occur."

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_fsops.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ee3aaa0a5317..0c6a52809dcc 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -828,6 +828,15 @@ xfs_do_force_shutdown(
 	if (xfs_log_force_umount(mp, logerror))
 		return;
 
+	/*
+	 * If DAX is in use, we have to unmap all direct access virtual
+	 * mappings to ensure nothing more gets written directly from
+	 * userspace. This will force them to refault and that will
+	 * result in them detecting the shutdown condition and hence
+	 * will fail appropriately.
+	 */
+	unmap_dax_inodes(mp->m_super);
+
 	if (flags & SHUTDOWN_CORRUPT_INCORE) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
     "Corruption of in-memory data detected.  Shutting down filesystem");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
