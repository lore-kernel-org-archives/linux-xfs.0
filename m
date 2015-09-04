Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B35C57FB7
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 15:54:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 854468F8049
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 13:54:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jqSKP1W0qO8WB1Yj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2015 13:54:23 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 8F38E341AF6
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2015 20:54:23 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-56-195.rdu2.redhat.com
	[10.10.56.195])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t84KsLOB004979
	for <xfs@oss.sgi.com>; Fri, 4 Sep 2015 16:54:23 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 3/3] xfs: remove unused procfs code
Date: Fri,  4 Sep 2015 15:54:10 -0500
Message-Id: <1441400050-8455-4-git-send-email-billodo@redhat.com>
In-Reply-To: <1441400050-8455-1-git-send-email-billodo@redhat.com>
References: <1441400050-8455-1-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

As a part of the work to move xfs global stats from procfs to sysfs,
this patch removes the now unused procfs code that was xfs stat specific.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_stats.c | 74 ------------------------------------------------------
 1 file changed, 74 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index a9f05de..05d5227 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -112,80 +112,6 @@ void xfs_stats_clearall(void)
 	}
 }
 
-static int xfs_stat_proc_show(struct seq_file *m, void *v)
-{
-	int		i, j;
-	__uint64_t	xs_xstrat_bytes = 0;
-	__uint64_t	xs_write_bytes = 0;
-	__uint64_t	xs_read_bytes = 0;
-
-	static const struct xstats_entry {
-		char	*desc;
-		int	endpoint;
-	} xstats[] = {
-		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
-		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
-		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
-		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
-		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
-		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
-		{ "ig",			XFSSTAT_END_INODE_OPS		},
-		{ "log",		XFSSTAT_END_LOG_OPS		},
-		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
-		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
-		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
-		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
-		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
-		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
-		{ "buf",		XFSSTAT_END_BUF			},
-		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
-		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
-		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
-		{ "ibt2",		XFSSTAT_END_IBT_V2		},
-		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
-		/* we print both series of quota information together */
-		{ "qm",			XFSSTAT_END_QM			},
-	};
-
-	/* Loop over all stats groups */
-	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		seq_printf(m, "%s", xstats[i].desc);
-		/* inner loop does each group */
-		for (; j < xstats[i].endpoint; j++)
-			seq_printf(m, " %u", counter_val(j));
-		seq_putc(m, '\n');
-	}
-	/* extra precision counters */
-	for_each_possible_cpu(i) {
-		xs_xstrat_bytes += per_cpu(xfsstats, i).xs_xstrat_bytes;
-		xs_write_bytes += per_cpu(xfsstats, i).xs_write_bytes;
-		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
-	}
-
-	seq_printf(m, "xpc %Lu %Lu %Lu\n",
-			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	seq_printf(m, "debug %u\n",
-#if defined(DEBUG)
-		1);
-#else
-		0);
-#endif
-	return 0;
-}
-
-static int xfs_stat_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xfs_stat_proc_show, NULL);
-}
-
-static const struct file_operations xfs_stat_proc_fops = {
-	.owner		= THIS_MODULE,
-	.open		= xfs_stat_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
 /* legacy quota interfaces */
 #ifdef CONFIG_XFS_QUOTA
 static int xqm_proc_show(struct seq_file *m, void *v)
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
