Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Mar 2008 08:09:54 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m26G9ZAB025720
	for <xfs@oss.sgi.com>; Thu, 6 Mar 2008 08:09:36 -0800
Received: from mail.pawisda.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91918F2A75F
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2008 08:10:04 -0800 (PST)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156]) by cuda.sgi.com with ESMTP id nRVxdO3g7rsyeaRU for <xfs@oss.sgi.com>; Thu, 06 Mar 2008 08:10:04 -0800 (PST)
Subject: Re: REVIEW: xfs_reno #2
From: Ruben Porras <ruben.porras@linworks.de>
In-Reply-To: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 17:10:35 +0100
Message-Id: <1204819835.4002.36.camel@tecra.thekeening.homeunix.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am Donnerstag, den 04.10.2007, 14:25 +1000 schrieb Barry Naujok:
> A couple changes from the first xfs_reno:
> 
>   - Major one is that symlinks are now supported, but only
>     owner, group and extended attributes are copied for them
>     (not times or inode attributes).
> 
>   - Man page!
> 
> 
> To make this better, ideally we need some form of
> "swap inodes" function in the kernel, where the entire
> contents of the inode themselves are swapped. This form
> can handle any inode and without any of the dir/file/attr/etc
> copy/swap mechanisms we have in xfs_reno.
> 
> Barry.

+static int
+process_slink(
+	bignode_t	*node)
+{
+	int		i = 0;
+	int		rval = 0;
+	struct stat64	st;
+	char		*srcname = NULL;
+	char		*pname = NULL;
+	char		target[PATH_MAX] = "";
+	char		linkbuf[PATH_MAX];
+
+	SET_PHASE(SLINK_PHASE);
+
+	dump_node("symlink", node);
+
+	cur_node = node;
+	srcname = node->paths[0];
+
+	if (lstat64(srcname, &st) < 0) {
+		if (errno != ENOENT) {
+			err_stat(srcname);
+			global_rval |= 2;
+		}
+		goto quit;
+	}


+	if (st.st_ino <= XFS_MAXINUMBER_32 && !force_all)
+		/* this file has changed, and no longer needs processing */
+		goto quit;

This check need to go out, the same in functions process_dir and
process_file.

+	rval = 1;
+
+	i = readlink(srcname, linkbuf, sizeof(linkbuf) - 1);
+	if (i < 0) {
+		err_message(_("unable to read symlink: %s"), srcname);
+		goto quit;
+	}
+	linkbuf[i] = '\0';
+
+	if (realuid != 0 && realuid != st.st_uid) {
+		errno = EACCES;
+		err_open(srcname);
+		goto quit;
+	}
+
+	/* create target */
+	pname = strdup(srcname);
+	if (pname == NULL) {
+		err_nomem();
+		goto quit;
+	}
+	dirname(pname);
+
+	sprintf(target, "%s/%sXXXXXX", pname, cmd_prefix);
+	if (mktemp(target) == NULL) {
+		err_message(_("unable to create temp symlink name"));
+		goto quit;
+	}

do not create the file, it is done later with symlink, if the file
exists, symlink is going to fail.

+	cur_target = strdup(target);
+	if (cur_target == NULL) {
+		err_nomem();
+		goto quit;
+	}

cur_target is not needed.

+
+	if (symlink(linkbuf, target) != 0) {
+		err_message(_("unable to create symlink: %s"), target);
+		goto quit;
+	}

[...]

+	free(cur_target);
+
+	cur_target = NULL;


again, both are unnecesary.

+	numslinksdone++;
+	return rval;
+}
