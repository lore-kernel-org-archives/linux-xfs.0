Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 05:48:32 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DCmSbm031307
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 05:48:29 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DCmUfT018385
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 08:48:30 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DCmUwn205836
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 06:48:30 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DCmUS4025803
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 06:48:30 -0600
Date: Fri, 13 Jul 2007 18:18:47 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713124847.GC22961@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713123816.GA18000@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

From: David P. Quigley <dpquigl@tycho.nsa.gov>

Revalidate the write permissions for fallocate(2), in case security policy has
changed since the files were opened.

Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>

---
 fs/open.c |    3 +++
 1 files changed, 3 insertions(+)

Index: linux-2.6.22/fs/open.c
===================================================================
--- linux-2.6.22.orig/fs/open.c
+++ linux-2.6.22/fs/open.c
@@ -407,6 +407,9 @@ asmlinkage long sys_fallocate(int fd, in
 		goto out;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out_fput;
+	ret = security_file_permission(file, MAY_WRITE);
+	if (ret)
+		goto out_fput;
 
 	inode = file->f_path.dentry->d_inode;
 
