Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SJsgi9172597 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 14:54:52 -0500
Date: Fri, 28 Aug 2009 23:55:00 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] xfs: switch to seq_file
Message-ID: <20090828195500.GC15123@x200.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-masters@oss.sgi.com
Cc: hch@infradead.org, xfs@oss.sgi.com

create_proc_read_entry() is getting deprecated.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/xfs/linux-2.6/xfs_stats.c |   51 ++++++++++++----------------
 fs/xfs/quota/xfs_qm_stats.c  |   78 +++++++++++++++++--------------------------
 2 files changed, 55 insertions(+), 74 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_stats.c
+++ b/fs/xfs/linux-2.6/xfs_stats.c
@@ -20,16 +20,9 @@
 
 DEFINE_PER_CPU(struct xfsstats, xfsstats);
 
-STATIC int
-xfs_read_xfsstats(
-	char		*buffer,
-	char		**start,
-	off_t		offset,
-	int		count,
-	int		*eof,
-	void		*data)
+static int xfs_stat_proc_show(struct seq_file *m, void *v)
 {
-	int		c, i, j, len, val;
+	int		c, i, j, val;
 	__uint64_t	xs_xstrat_bytes = 0;
 	__uint64_t	xs_write_bytes = 0;
 	__uint64_t	xs_read_bytes = 0;
@@ -60,18 +53,18 @@ xfs_read_xfsstats(
 	};
 
 	/* Loop over all stats groups */
-	for (i=j=len = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += sprintf(buffer + len, "%s", xstats[i].desc);
+	for (i=j = 0; i < ARRAY_SIZE(xstats); i++) {
+		seq_printf(m, "%s", xstats[i].desc);
 		/* inner loop does each group */
 		while (j < xstats[i].endpoint) {
 			val = 0;
 			/* sum over all cpus */
 			for_each_possible_cpu(c)
 				val += *(((__u32*)&per_cpu(xfsstats, c) + j));
-			len += sprintf(buffer + len, " %u", val);
+			seq_printf(m, " %u", val);
 			j++;
 		}
-		buffer[len++] = '\n';
+		seq_putc(m, '\n');
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -80,36 +73,38 @@ xfs_read_xfsstats(
 		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
 	}
 
-	len += sprintf(buffer + len, "xpc %Lu %Lu %Lu\n",
+	seq_printf(m, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += sprintf(buffer + len, "debug %u\n",
+	seq_printf(m, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else
 		0);
 #endif
+	return 0;
+}
 
-	if (offset >= len) {
-		*start = buffer;
-		*eof = 1;
-		return 0;
-	}
-	*start = buffer + offset;
-	if ((len -= offset) > count)
-		return count;
-	*eof = 1;
-
-	return len;
+static int xfs_stat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, xfs_stat_proc_show, NULL);
 }
 
+static const struct file_operations xfs_stat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xfs_stat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 int
 xfs_init_procfs(void)
 {
 	if (!proc_mkdir("fs/xfs", NULL))
 		goto out;
 
-	if (!create_proc_read_entry("fs/xfs/stat", 0, NULL,
-			xfs_read_xfsstats, NULL))
+	if (!proc_create("fs/xfs/stat", 0, NULL,
+			 &xfs_stat_proc_fops))
 		goto out_remove_entry;
 	return 0;
 
--- a/fs/xfs/quota/xfs_qm_stats.c
+++ b/fs/xfs/quota/xfs_qm_stats.c
@@ -48,50 +48,34 @@
 
 struct xqmstats xqmstats;
 
-STATIC int
-xfs_qm_read_xfsquota(
-	char		*buffer,
-	char		**start,
-	off_t		offset,
-	int		count,
-	int		*eof,
-	void		*data)
+static int xqm_proc_show(struct seq_file *m, void *v)
 {
-	int		len;
-
 	/* maximum; incore; ratio free to inuse; freelist */
-	len = sprintf(buffer, "%d\t%d\t%d\t%u\n",
+	seq_printf(m, "%d\t%d\t%d\t%u\n",
 			ndquot,
 			xfs_Gqm? atomic_read(&xfs_Gqm->qm_totaldquots) : 0,
 			xfs_Gqm? xfs_Gqm->qm_dqfree_ratio : 0,
 			xfs_Gqm? xfs_Gqm->qm_dqfreelist.qh_nelems : 0);
-
-	if (offset >= len) {
-		*start = buffer;
-		*eof = 1;
-		return 0;
-	}
-	*start = buffer + offset;
-	if ((len -= offset) > count)
-		return count;
-	*eof = 1;
-
-	return len;
+	return 0;
 }
 
-STATIC int
-xfs_qm_read_stats(
-	char		*buffer,
-	char		**start,
-	off_t		offset,
-	int		count,
-	int		*eof,
-	void		*data)
+static int xqm_proc_open(struct inode *inode, struct file *file)
 {
-	int		len;
+	return single_open(file, xqm_proc_show, NULL);
+}
+
+static const struct file_operations xqm_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xqm_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
+static int xqmstat_proc_show(struct seq_file *m, void *v)
+{
 	/* quota performance statistics */
-	len = sprintf(buffer, "qm %u %u %u %u %u %u %u %u\n",
+	seq_printf(m, "qm %u %u %u %u %u %u %u %u\n",
 			xqmstats.xs_qm_dqreclaims,
 			xqmstats.xs_qm_dqreclaim_misses,
 			xqmstats.xs_qm_dquot_dups,
@@ -100,25 +84,27 @@ xfs_qm_read_stats(
 			xqmstats.xs_qm_dqwants,
 			xqmstats.xs_qm_dqshake_reclaims,
 			xqmstats.xs_qm_dqinact_reclaims);
+	return 0;
+}
 
-	if (offset >= len) {
-		*start = buffer;
-		*eof = 1;
-		return 0;
-	}
-	*start = buffer + offset;
-	if ((len -= offset) > count)
-		return count;
-	*eof = 1;
-
-	return len;
+static int xqmstat_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, xqmstat_proc_show, NULL);
 }
 
+static const struct file_operations xqmstat_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= xqmstat_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 void
 xfs_qm_init_procfs(void)
 {
-	create_proc_read_entry("fs/xfs/xqmstat", 0, NULL, xfs_qm_read_stats, NULL);
-	create_proc_read_entry("fs/xfs/xqm", 0, NULL, xfs_qm_read_xfsquota, NULL);
+	proc_create("fs/xfs/xqmstat", 0, NULL, &xqmstat_proc_fops);
+	proc_create("fs/xfs/xqm", 0, NULL, &xqm_proc_fops);
 }
 
 void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
