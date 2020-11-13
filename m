Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D923DC6369E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2BC206D9
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bykB0LWY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgKMMwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgKMMwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 07:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605271937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=XgL7zI/5MSmwSP2d//GGOj//IZej1qaYOsLhbH56krY=;
        b=bykB0LWYd8gERGyqvWzTN4MDL3JTHi0Df1J+S7WvSvYU0o9QtsgmjsHbiYoBWprseR1Jpy
        5fXhsyZEMBDufSQwRRxwIrgkSJxCIjcbCeAZr1G2LwZchN3RktvpmuVNGfk11R/dCLnYZ5
        /nOLGVbhNmS1zWn4SMZrQ3xhDC9g55I=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489--Dn_LrgCMuGlh4lyQH6y3Q-1; Fri, 13 Nov 2020 07:52:15 -0500
X-MC-Unique: -Dn_LrgCMuGlh4lyQH6y3Q-1
Received: by mail-pf1-f199.google.com with SMTP id u3so5262483pfm.22
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 04:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XgL7zI/5MSmwSP2d//GGOj//IZej1qaYOsLhbH56krY=;
        b=q2Hf1FcWcz6a2v9aSKVoQjUeRRG5YxBNQPQmhyXDQeBLkL95sX0RxANS4wuvtKUtiy
         AVa85Rc7DS6mTa5O/JPcmkH9EP+PojrzwHgnz+foSO0F+HRy58AX2zlLoamJaPHQOnaP
         xxr9FdXVbxjrgjrYn7bvr/KVv2cx86NI/fb/gevwQxvvnsRG8hgtZKQNnWpzdp3C7Rzu
         6sY7tqzQEta2M6+/KThmeZrO3EMHI3ulPM7MeKzimeMxHl+gC8LWrSVlYK7DvVGjsltL
         7ucycH7ssaF9s3c7wss/AQKeklDRfBihXmDzub0aIGv6GsWougZeGKrHTzuFyze8z1gn
         u58w==
X-Gm-Message-State: AOAM530kKMWSXr3VNbhMpYfv9ILFRXjm4YQHm0OBgYSKpbBoDnC9U1MX
        RpxloMscGwJq6IhNFsz1M91PFlSEYm/cV6nmpwCvAGt9uqK7ilNuYZBEOzOmOCg1VRpcYUVuJ3i
        xvtBMQeKVcM6kqcYIvo+ygHNzB8q2HQUE7RSqOYcOtBu0+lyF3TXtmoaoOox3DaaEbKrC0tYkYQ
        ==
X-Received: by 2002:a17:90a:af81:: with SMTP id w1mr2928710pjq.180.1605271934533;
        Fri, 13 Nov 2020 04:52:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyc36V6tRE6pQuMv/BONt2Li1XFl44Ab8DP3dIx6aPrgY255UWS7Ok7SUYY86Obq4vXK46gAw==
X-Received: by 2002:a17:90a:af81:: with SMTP id w1mr2928670pjq.180.1605271934060;
        Fri, 13 Nov 2020 04:52:14 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e8sm9816268pfn.175.2020.11.13.04.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 04:52:13 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH] xfsrestore: fix rootdir due to xfsdump bulkstat misuse
Date:   Fri, 13 Nov 2020 20:51:27 +0800
Message-Id: <20201113125127.966243-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
    been detected will be in the orphan dir, p_orphh);
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

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 restore/content.c |  7 +++++++
 restore/getopt.h  |  4 ++--
 restore/tree.c    | 44 +++++++++++++++++++++++++++++++++++++++++++-
 restore/tree.h    |  2 ++
 4 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 6b22965..e807a83 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -865,6 +865,7 @@ static int quotafilecheck(char *type, char *dstdir, char *quotafile);
 
 bool_t content_media_change_needed;
 bool_t restore_rootdir_permissions;
+bool_t need_fixrootdir;
 char *media_change_alert_program = NULL;
 size_t perssz;
 
@@ -964,6 +965,7 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	stsz = 0;
 	interpr = BOOL_FALSE;
 	restore_rootdir_permissions = BOOL_FALSE;
+	need_fixrootdir = BOOL_FALSE;
 	optind = 1;
 	opterr = 0;
 	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
@@ -1189,6 +1191,9 @@ content_init(int argc, char *argv[], size64_t vmsz)
 		case GETOPT_FMT2COMPAT:
 			tranp->t_truncategenpr = BOOL_TRUE;
 			break;
+		case GETOPT_FIXROOTDIR:
+			need_fixrootdir = BOOL_TRUE;
+			break;
 		}
 	}
 
@@ -3140,6 +3145,8 @@ applydirdump(drive_t *drivep,
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
index 0670318..c1e0461 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -265,6 +265,7 @@ extern void usage(void);
 extern size_t pgsz;
 extern size_t pgmask;
 extern bool_t restore_rootdir_permissions;
+extern bool_t need_fixrootdir;
 
 /* forward declarations of locally defined static functions ******************/
 
@@ -335,6 +336,36 @@ static xfs_ino_t orphino = ORPH_INO;
 
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
+		/* since all new node (including non-parent) would be adopted into orphh */
+		    parh == persp->p_orphh ||
+		    parh == NH_NULL)
+			break;
+		rooth = parh;
+	}
+
+	if (rooth != persp->p_rooth) {
+		persp->p_rooth = rooth;
+		persp->p_rootino = rootino;
+
+		mlog(MLOG_NORMAL, "fix root # to %llu (bind mount?)\n", rootino);
+	}
+}
+
 /* ARGSUSED */
 bool_t
 tree_init(char *hkdir,
@@ -753,8 +784,13 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 
 	/* lookup head of hardlink list
 	 */
+	/* do not use the old fake root node to prevent potential loop */
+	if (need_fixrootdir == BOOL_TRUE && ino == persp->p_rootino && !gen)
+		gen = -1;
+
 	hardh = link_hardh(ino, gen);
-	assert(ino != persp->p_rootino || hardh == persp->p_rooth);
+	if (need_fixrootdir == BOOL_FALSE)
+		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
 
 	/* already present
 	 */
@@ -824,6 +860,12 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
 		*dahp = dah;
 	}
 
+	/* found the fake rootino from subdir, need fix p_rooth. */
+	if (need_fixrootdir == BOOL_TRUE &&
+	    persp->p_rootino == ino && hardh != persp->p_rooth) {
+		mlog(MLOG_NORMAL, "found fake rootino #%llu, will fix.\n", ino);
+		persp->p_rooth = hardh;
+	}
 	return hardh;
 }
 
diff --git a/restore/tree.h b/restore/tree.h
index 4f9ffe8..5d0c346 100644
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
2.18.4

