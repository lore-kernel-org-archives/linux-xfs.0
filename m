Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93CnQX8241659 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 07:49:26 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 6/6] xfsprogs: libxcmd: ignore errors when initializing
	fs_table
Date: Mon,  3 Oct 2011 07:49:20 -0500
Message-Id: <95b49eebacd595be5d527a7c780f62cee7aa329f.1317646036.git.aelder@sgi.com>
In-Reply-To: <1317646160-5437-1-git-send-email-aelder@sgi.com>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
In-Reply-To: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>

When initializing fs_table, the full set of mounted filesystems and
the full set of defined projects are (or may be) examined.  If an
error ever occurs looking at one of these entries, the processing
loop just quits, skipping all remaining mounts or projects.

One mount or project being problematic is no reason to give
up entirely.  It may be that it is completely unrelated to
the mount point or project that the user wants to operate on.

So instead of quitting when an error occurs while adding
something to fs_table, proceed until all entries are added.

Meanwhile, the two affected functions are used for either
installing one entry in the table or for initializing the
table based on the full set of mounts or projects.  In
the former case, once the entry matching that was requested
has been found there is no need to continue searching for
other entries, so break out of the loop immediately in
that case.

It so happens that these two changes affect the exact
same portion of the code...

SGI PV 1017024

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index a6adc51..2afd9bb 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -287,16 +287,17 @@ fs_table_initialise_mounts(
 		    ((strcmp(path, mnt->mnt_dir) != 0) &&
 		     (strcmp(path, mnt->mnt_fsname) != 0)))
 			continue;
-		found = 1;
 		if (fs_extract_mount_options(mnt, &fslog, &fsrt))
 			continue;
-		error = fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
+		(void) fs_table_insert(mnt->mnt_dir, 0, FS_MOUNT_POINT,
 					mnt->mnt_fsname, fslog, fsrt);
-		if (error)
+		if (path) {
+			found = 1;
 			break;
+		}
 	}
 	endmntent(mtp);
-	if (!error && path && !found)
+	if (path && !found)
 		error = ENXIO;
 
 	return error;
@@ -326,15 +327,16 @@ fs_table_initialise_mounts(
 		    ((strcmp(path, stats[i].f_mntonname) != 0) &&
 		     (strcmp(path, stats[i].f_mntfromname) != 0)))
 			continue;
-		found = 1;
 		/* TODO: external log and realtime device? */
-		error = fs_table_insert(stats[i].f_mntonname, 0,
+		(void) fs_table_insert(stats[i].f_mntonname, 0,
 					FS_MOUNT_POINT, stats[i].f_mntfromname,
 					NULL, NULL);
-		if (error)
+		if (path) {
+			found = 1;
 			break;
+		}
 	}
-	if (!error && path && !found)
+	if (path && !found)
 		error = ENXIO;
 
 	return error;
@@ -399,16 +401,17 @@ fs_table_initialise_projects(
 					progname, path->pp_pathname, strerror(errno));
 			continue;
 		}
-		found = 1;
-		error = fs_table_insert(path->pp_pathname, path->pp_prid,
+		(void) fs_table_insert(path->pp_pathname, path->pp_prid,
 					FS_PROJECT_PATH, fs->fs_name,
 					NULL, NULL);
-		if (error)
+		if (project) {
+			found = 1;
 			break;
+		}
 	}
 	endprpathent();
 
-	if (!error && project && !found)
+	if (project && !found)
 		error = ENOENT;
 
 	return error;
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
