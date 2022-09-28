Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15D1C04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 19:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiI1TLO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 15:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbiI1TLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 15:11:13 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3823477E99
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 12:11:12 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id ay9so8601081qtb.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 12:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=q9b7hjgGEJFY63qigv5HHVdcWisSc2jQTeyJhEQn3Kg=;
        b=dQCLxajmW/LfXVNpqqjjphv5Gh++w44rdHek19l6QiWRIhj6bPy7RPCQZfF6b691AZ
         SiZ9P4Y0uodOlLJ0+1m2E8fqQx9bORyl0XG531Lg95sKE7Iz5dbqwmjYayYfDn5ict2L
         JlglF07ffgRO5cAD9vEyoOI9imNg3pQME01kFNI4NpeHJ8ZoMo8Vuv+U0VhrFWUu+zBf
         swssft3DYOb4uhn/raomn8/v7H6QR1z0xwP+F9mOz8U5Et+GSZFEelIIRY6yLJl1Q/oP
         D6zJ/tfbDrIdgxpCIm2Jmfk0zjCX13gaXB6JKhdSwqprBI9xS/+NfqzKIgYbOHHHMYUw
         lSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=q9b7hjgGEJFY63qigv5HHVdcWisSc2jQTeyJhEQn3Kg=;
        b=IcutDu5WHkMHkLMgaVmDLwKnCNYjv5euChwnnueUtLYa1SaYcYYYwfLrQ6u8oLSh77
         s4WOXn0oFeiF1/HD7gUBiM3weXWgkohlmRb2w6qKouR/Kk2HXvwSv7aMK6Aod3NCYZ4G
         DbE12gG+/pUyCwmC5lM9mqgkzQLxXy9FzeeFkfBwDSKPJ8ZM2uxU7NZ+Z5itLVWhxMxQ
         OngIiVbkWwdWnrB8ojsTidmpqxrRWnVXujRTmKtOhpkAZIaUUZpE/64invSevATUzJTK
         HLNQvX3qmbQTiu5d9ggIj19hBcjQ2lzJxJviDS6WptcdCmc4qByNAee+0brzDSgaMYam
         Ro3Q==
X-Gm-Message-State: ACrzQf2rP9q3dq4d6Ktj2sToZ41TWf7zbPQqL1CInyiZLxq8f+eJwtAN
        G/z0QaDnjgbLy1pIvQbP3r80hZ/6w7onL5NY
X-Google-Smtp-Source: AMsMyM78noic8mXt6zd4aYVXmFRNNGLgiF2bC+BrkRreoWgNGsikpYr9i0LP2pIj4/K4fQMguDOhaw==
X-Received: by 2002:a05:622a:492:b0:35d:518d:2b58 with SMTP id p18-20020a05622a049200b0035d518d2b58mr7079585qtx.78.1664392271190;
        Wed, 28 Sep 2022 12:11:11 -0700 (PDT)
Received: from shiina-laptop.redhat.com ([2601:18f:801:e210:abfc:537a:d62c:c353])
        by smtp.gmail.com with ESMTPSA id b134-20020ae9eb8c000000b006ce76811a07sm3467091qkg.75.2022.09.28.12.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 12:11:10 -0700 (PDT)
From:   Hironori Shiina <shiina.hironori@gmail.com>
X-Google-Original-From: Hironori Shiina <shiina.hironori@fujitsu.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>,
        Donald Douwsma <ddouwsma@redhat.com>,
        Hironori Shiina <shiina.hironori@fujitsu.com>
Subject: [RFC PATCH V3] xfsrestore: fix rootdir due to xfsdump bulkstat misuse
Date:   Wed, 28 Sep 2022 15:10:52 -0400
Message-Id: <20220928191052.410437-1-shiina.hironori@fujitsu.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20201116080723.1486270-1-hsiangkao@redhat.com>
References: <20201116080723.1486270-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

If rootino is wrong and misspecified to a subdir inode #,
the following assertion could be triggered:
  assert(ino != persp->p_rootino || hardh == persp->p_rooth);

This patch adds a '-x' option (another awkward thing is that
the codebase doesn't support long options) to address
problamatic images by searching for the real dir, the reason
that I don't enable it by default is that I'm not very confident
with the xfsrestore codebase and xfsdump bulkstat issue will
also be fixed immediately as well, so this function might be
optional and only useful for pre-exist corrupted dumps.

In details, my understanding of the original logic is
 1) xfsrestore will create a rootdir node_t (p_rooth);
 2) it will build the tree hierarchy from inomap and adopt
    the parent if needed (so inodes whose parent ino hasn't
    detected will be in the orphan dir, p_orphh);
 3) during this period, if ino == rootino and
    hardh != persp->p_rooth (IOWs, another node_t with
    the same ino # is created), that'd be definitely wrong.

So the proposal fix is that
 - considering the xfsdump root ino # is a subdir inode, it'll
   trigger ino == rootino && hardh != persp->p_rooth condition;
 - so we log this node_t as persp->p_rooth rather than the
   initial rootdir node_t created in 1);
 - we also know that this node is actually a subdir, and after
   the whole inomap is scanned (IOWs, the tree is built),
   the real root dir will have the orphan dir parent p_orphh;
 - therefore, we walk up by the parent until some node_t has
   the p_orphh, so that's it.

Cc: Donald Douwsma <ddouwsma@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Hironori Shiina <shiina.hironori@fujitsu.com>
---

changes since RFC v2:
 - re-adopt the orphanage dir to the fixed root for creating a
   correct path of the orphanage dir.

 - add description of the new '-x' option to the man page.

changes since RFC v1:
 - fix non-dir fake rootino cases since tree_begindir()
   won't be triggered for these non-dir, and we could do
   that in tree_addent() instead (fault injection verified);

 - fix fake rootino case with gen = 0 as well, for more
   details, see the inlined comment in link_hardh()
   (fault injection verified as well).

 common/main.c         |  1 +
 man/man8/xfsrestore.8 | 14 +++++++++
 restore/content.c     |  7 +++++
 restore/getopt.h      |  4 +--
 restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++---
 restore/tree.h        |  2 ++
 6 files changed, 94 insertions(+), 6 deletions(-)

diff --git a/common/main.c b/common/main.c
index 1db07d4..6141ffb 100644
--- a/common/main.c
+++ b/common/main.c
@@ -988,6 +988,7 @@ usage(void)
 	ULO(_("(contents only)"),			GETOPT_TOC);
 	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
 	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
+	ULO(_("(try to fix rootdir due to xfsdump issue)"),GETOPT_FIXROOTDIR);
 	ULO(_("(don't restore extended file attributes)"), GETOPT_NOEXTATTR);
 	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
 	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM);
diff --git a/man/man8/xfsrestore.8 b/man/man8/xfsrestore.8
index 60e4309..df7dde0 100644
--- a/man/man8/xfsrestore.8
+++ b/man/man8/xfsrestore.8
@@ -240,6 +240,20 @@ but does not create or modify any files or directories.
 It may be desirable to set the verbosity level to \f3silent\f1
 when using this option.
 .TP 5
+.B \-x
+This option may be useful to fix an issue which the files are restored
+to orphanage directory because of xfsdump (v3.1.7 - v3.1.9) problem.
+A normal dump cannot be restored with this option. This option works
+only for a corrupted dump.
+If a dump is created by problematic xfsdump (v3.1.7 - v3.1.9), you
+should see the contents of the dump with \f3\-t\f1 option before
+restoring. Then, if a file is placed to the orphanage directory, you need to
+use this \f3\-x\f1 option to restore the dump. Otherwise, you can restore
+the dump without this option.
+
+In the cumulative mode, this option is required only for a base (level 0)
+dump. You no longer need this option for level 1+ dumps.
+.TP 5
 \f3\-v\f1 \f2verbosity\f1
 .\" set inter-paragraph distance to 0
 .PD 0
diff --git a/restore/content.c b/restore/content.c
index b19bb90..fdf26dd 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -861,6 +861,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
 
 bool_t content_media_change_needed;
 bool_t restore_rootdir_permissions;
+bool_t need_fixrootdir;
 char *media_change_alert_program = NULL;
 size_t perssz;
 
@@ -958,6 +959,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	stsz = 0;
 	interpr = BOOL_FALSE;
 	restore_rootdir_permissions = BOOL_FALSE;
+	need_fixrootdir = BOOL_FALSE;
 	optind = 1;
 	opterr = 0;
 	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
@@ -1186,6 +1188,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		case GETOPT_FMT2COMPAT:
 			tranp->t_truncategenpr = BOOL_TRUE;
 			break;
+		case GETOPT_FIXROOTDIR:
+			need_fixrootdir = BOOL_TRUE;
+			break;
 		}
 	}
 
@@ -3129,6 +3134,8 @@ applydirdump(drive_t *drivep,
 			return rv;
 		}
 
+		if (need_fixrootdir)
+			tree_fixroot();
 		persp->s.dirdonepr = BOOL_TRUE;
 	}
 
diff --git a/restore/getopt.h b/restore/getopt.h
index b5bc004..b0c0c7d 100644
--- a/restore/getopt.h
+++ b/restore/getopt.h
@@ -26,7 +26,7 @@
  * purpose is to contain that command string.
  */
 
-#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
+#define GETOPT_CMDSTRING	"a:b:c:def:himn:op:qrs:tv:wxABCDEFG:H:I:JKL:M:NO:PQRS:TUVWX:Y:"
 
 #define GETOPT_WORKSPACE	'a'	/* workspace dir (content.c) */
 #define GETOPT_BLOCKSIZE        'b'     /* blocksize for rmt */
@@ -51,7 +51,7 @@
 /*				'u' */
 #define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
-/*				'x' */
+#define GETOPT_FIXROOTDIR	'x'	/* try to fix rootdir due to bulkstat misuse */
 /*				'y' */
 /*				'z' */
 #define	GETOPT_NOEXTATTR	'A'	/* do not restore ext. file attr. */
diff --git a/restore/tree.c b/restore/tree.c
index 5429b74..bfa07fe 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -15,7 +15,6 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
@@ -262,6 +261,7 @@ extern void usage(void);
 extern size_t pgsz;
 extern size_t pgmask;
 extern bool_t restore_rootdir_permissions;
+extern bool_t need_fixrootdir;
 
 /* forward declarations of locally defined static functions ******************/
 
@@ -328,10 +328,47 @@ static tran_t *tranp = 0;
 static char *persname = PERS_NAME;
 static char *orphname = ORPH_NAME;
 static xfs_ino_t orphino = ORPH_INO;
+static nh_t orig_rooth = NH_NULL;
 
 
 /* definition of locally defined global functions ****************************/
 
+void
+tree_fixroot(void)
+{
+	nh_t		rooth = persp->p_rooth;
+	xfs_ino_t 	rootino;
+
+	while (1) {
+		nh_t	parh;
+		node_t *rootp = Node_map(rooth);
+
+		rootino = rootp->n_ino;
+		parh = rootp->n_parh;
+		Node_unmap(rooth, &rootp);
+
+		if (parh == rooth ||
+		/*
+		 * since all new node (including non-parent)
+		 * would be adopted into orphh
+		 */
+		    parh == persp->p_orphh ||
+		    parh == NH_NULL)
+			break;
+		rooth = parh;
+	}
+
+	if (rooth != persp->p_rooth) {
+		persp->p_rooth = rooth;
+		persp->p_rootino = rootino;
+		disown(rooth);
+		adopt(persp->p_rooth, persp->p_orphh, NH_NULL);
+
+		mlog(MLOG_NORMAL, _("fix root # to %llu (bind mount?)\n"),
+		     rootino);
+	}
+}
+
 /* ARGSUSED */
 bool_t
 tree_init(char *hkdir,
@@ -746,7 +783,8 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 	/* lookup head of hardlink list
 	 */
 	hardh = link_hardh(ino, gen);
-	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
+	if (need_fixrootdir == BOOL_FALSE)
+		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
 
 	/* already present
 	 */
@@ -815,7 +853,6 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 		adopt(persp->p_orphh, hardh, NRH_NULL);
 		*dahp = dah;
 	}
-
 	return hardh;
 }
 
@@ -960,6 +997,7 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 				}
 			} else {
 				assert(hardp->n_nrh != NRH_NULL);
+
 				namebuflen
 				=
 				namreg_get(hardp->n_nrh,
@@ -1110,6 +1148,13 @@ tree_addent(nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen)
 		      ino,
 		      gen);
 	}
+	/* found the fake rootino from subdir, need fix p_rooth. */
+	if (need_fixrootdir == BOOL_TRUE &&
+	    persp->p_rootino == ino && hardh != persp->p_rooth) {
+		mlog(MLOG_NORMAL,
+		     _("found fake rootino #%llu, will fix.\n"), ino);
+		persp->p_rooth = hardh;
+	}
 	return RV_OK;
 }
 
@@ -3808,7 +3853,26 @@ selsubtree_recurse_down(nh_t nh, bool_t sensepr)
 static nh_t
 link_hardh(xfs_ino_t ino, gen_t gen)
 {
-	return hash_find(ino, gen);
+	nh_t tmp = hash_find(ino, gen);
+
+	/*
+	 * XXX (another workaround): the simply way is that don't reuse node_t
+	 * with gen = 0 created in tree_init(). Otherwise, it could cause
+	 * xfsrestore: tree.c:1003: tree_addent: Assertion
+	 * `hardp->n_nrh != NRH_NULL' failed.
+	 * and that node_t is a dir node but the fake rootino could be a non-dir
+	 * plus reusing it could cause potential loop in tree hierarchy.
+	 */
+	if (need_fixrootdir == BOOL_TRUE &&
+	    ino == persp->p_rootino && gen == 0 &&
+	    orig_rooth == NH_NULL) {
+		mlog(MLOG_NORMAL,
+_("link out fake rootino %llu with gen=0 created in tree_init()\n"), ino);
+		link_out(tmp);
+		orig_rooth = tmp;
+		return NH_NULL;
+	}
+	return tmp;
 }
 
 /* returns following node in hard link list
diff --git a/restore/tree.h b/restore/tree.h
index bf66e3d..f5bd4ff 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -18,6 +18,8 @@
 #ifndef TREE_H
 #define TREE_H
 
+void tree_fixroot(void);
+
 /* tree_init - creates a new tree abstraction.
  */
 extern bool_t tree_init(char *hkdir,
-- 
2.37.3

