Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED039C388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 10:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805932225E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 10:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZT/cvSb1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgKBKCP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:02:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728387AbgKBKCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 05:02:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604311332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=+T4RvRg3R79f8P/LtsARUV8+MUAJ5GUoNlLz08CsF7M=;
        b=ZT/cvSb12nRYcLcIlIEeYNRK7YhSS2Ypqi3urbIVeHtjN2IQsATpsLAU0ksJwRC+Nucs/l
        v1wyUCrbjREWr919Wt4t3i88hPevyJMlRa4/SwgZFKb8pu8+8Z/lWA160h900io7h7e8t1
        g4JgQ2zQm2qVBjhqaHEGK5oUQKtGQEs=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-6HYRP3PfMm-VEHzohkHdrg-1; Mon, 02 Nov 2020 05:02:10 -0500
X-MC-Unique: 6HYRP3PfMm-VEHzohkHdrg-1
Received: by mail-pf1-f198.google.com with SMTP id u24so9600463pfh.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 02:02:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+T4RvRg3R79f8P/LtsARUV8+MUAJ5GUoNlLz08CsF7M=;
        b=hk1kRynznc7BSEclTWmV7RtZIAR1ejT2kSBXBDhkoXRfNe2puqiPr8YGwqkZu6mwJ2
         L9WShinkBpRsnp78iIA88Mv0+nXgSzLXZCURHr3aSmpX0c7+6Gth34eLJxF+vjCx2LWh
         a+IkJkrq/TtqJjvUuG2vq3jEGb0Cq1TIkv7VqqfdYz6DpwcMXYGlSm5EpCz2XM2WLl+9
         lo+XiDqe2pZHnB/GEQphTLAOFMKDRR3KgB43ei4fJsGIUxFMR/pbfCibBWzBZ8UfB5jk
         0u7EDeZjLl7jCzyjZmz8aQdwVV8oPNZ607VXPjiN/PFQbn0lSnsFyPKrXgolX39oI6D8
         OCoA==
X-Gm-Message-State: AOAM530oU+0xaKInX0XFgqs/kWuonveuolD89utTjJUG9OLdSE8D/q5N
        1GIkuvkGfdG2/Xk2/E+9yP1j/2SC1aIosv7Jd2k49/YgPd6OBCfr0TBoud68I7zN1dGPZLBHYkb
        s57lI0hPX1/EuQJymZag/
X-Received: by 2002:a17:90a:ba8d:: with SMTP id t13mr16504255pjr.38.1604311328834;
        Mon, 02 Nov 2020 02:02:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrFidsbtQVH3AwKI6+7WYodugf6LxHcQJiu7FRdBLAfjinow6YGoTjATAhxe05Vw33WOwiCA==
X-Received: by 2002:a17:90a:ba8d:: with SMTP id t13mr16504234pjr.38.1604311328543;
        Mon, 02 Nov 2020 02:02:08 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gw10sm4128138pjb.24.2020.11.02.02.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:02:08 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [RFC PATCH] xfsdump: fix handling bind mount targets
Date:   Mon,  2 Nov 2020 18:01:20 +0800
Message-Id: <20201102100120.660443-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sometimes, it's not true that the root directory is always
the first result from calling bulkstat with lastino == 0
assumed by xfsdump.

Recently XFS_BULK_IREQ_SPECIAL_ROOT was introduced last year,
yet that doesn't exist in old kernels.

Alternatively, we can also use bulkstat to walk through
all dirs and find the exact dir whose ino # of ".." is
itself by getdents, and that should be considered as the
root dir.

Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
preliminary test with the original testcase is done...

 dump/content.c | 168 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 140 insertions(+), 28 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 30232d4..653d4eb 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -511,6 +511,132 @@ static bool_t create_inv_session(
 		ix_t subtreecnt,
 		size_t strmix);
 
+struct fixrootino_context {
+	xfs_ino_t	rootino;
+	struct dirent	*gdp;
+	size_t		gdsz;
+};
+
+static bool_t
+scan_rootinode(int fd,
+	       xfs_ino_t ino,
+	       struct dirent *gdp,
+	       size_t gdsz)
+{
+	while (1) {
+		struct dirent *p;
+		int nread;
+
+		nread = getdents_wrap(fd, (char *)gdp, gdsz);
+		/*
+		 * negative count indicates something very bad happened;
+		 * try to gracefully end this dir.
+		 */
+		if (nread < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
+_("unable to read dirents for directory ino %llu: %s\n"),
+			      ino, strerror(errno));
+			/* !!! curtis looked at this, and pointed out that
+			 * we could take some recovery action here. if the
+			 * errno is appropriate, lseek64 to the value of
+			 * doff field of the last dirent successfully
+			 * obtained, and contiue the loop.
+			 */
+			nread = 0; /* pretend we are done */
+		}
+
+		/* no more directory entries: break; */
+		if (!nread)
+			break;
+
+		for (p = gdp; nread > 0;
+		     nread -= (int)p->d_reclen,
+		     assert(nread >= 0),
+		     p = (struct dirent *)((char *)p + p->d_reclen)) {
+			if (!strcmp(p->d_name, "..") && p->d_ino == ino) {
+				mlog(MLOG_NITTY, "FOUND: name %s d_ino %llu\n",
+				     p->d_name, ino);
+				return BOOL_TRUE;
+			}
+		}
+	}
+	return BOOL_FALSE;
+}
+
+/* ARGSUSED */
+static int
+cb_find_root_inode(void *arg1,
+	jdm_fshandle_t *fshandlep,
+	int fsfd,
+	struct xfs_bstat *statp)
+{
+	int fd;
+	struct fixrootino_context *ctx = arg1;
+
+	/* open the directory named by statp*/
+	fd = jdm_open(fshandlep, statp, O_RDONLY);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
+		      "unable to open directory: ino %llu: %s\n"),
+		      statp->bs_ino, strerror(errno));
+		return RV_OK; /* continue anyway */
+	}
+
+	if (scan_rootinode(fd, statp->bs_ino, ctx->gdp, ctx->gdsz)) {
+		ctx->rootino = statp->bs_ino;
+		return RV_NOMORE;
+	}
+	return RV_OK;
+}
+
+static bool_t
+fix_root_inode(
+	stat64_t *rootstat,
+	struct xfs_bstat *sc_rootxfsstatp)
+{
+	struct xfs_bstat *bstatbufp;
+	int rval;
+	struct fixrootino_context ctx;
+	rv_t rv = RV_OK;
+
+	ctx.gdsz = sizeof(struct dirent) + NAME_MAX + 1;
+	if (ctx.gdsz < GETDENTSBUF_SZ_MIN)
+		ctx.gdsz = GETDENTSBUF_SZ_MIN;
+
+	ctx.gdp = (struct dirent *)calloc(1, ctx.gdsz);
+	assert(ctx.gdp);
+
+	/* already a root dir */
+	if (scan_rootinode(sc_fsfd, rootstat->st_ino, ctx.gdp, ctx.gdsz))
+		goto out;
+
+	/* allocate a buffer for use by bigstat_iter */
+	bstatbufp = (struct xfs_bstat *)calloc(BSTATBUFLEN,
+					       sizeof(struct xfs_bstat));
+	assert(bstatbufp);
+
+	rval = bigstat_iter(sc_fshandlep, sc_fsfd, BIGSTAT_ITER_DIR,
+			    (xfs_ino_t)0, cb_find_root_inode,
+			    &ctx, NULL, NULL, (int *)&rv, preemptchk,
+			    bstatbufp, BSTATBUFLEN);
+	if (rval)
+		return BOOL_FALSE;
+
+	if (rv != RV_NOMORE && rv != RV_OK)
+		return BOOL_FALSE;
+
+	mlog(MLOG_NORMAL | MLOG_NOTE,
+	     "fix up rootino %lld, bind mount?\n", ctx.rootino);
+	rootstat->st_ino = ctx.rootino;
+out:
+	if (bigstat_one(sc_fsfd, rootstat->st_ino, sc_rootxfsstatp) < 0) {
+		mlog( MLOG_ERROR,
+		      _("failed to get bulkstat information for root inode\n"));
+		return BOOL_FALSE;
+	}
+	return BOOL_TRUE;
+}
+
 bool_t
 content_init(int argc,
 	      char *argv[],
@@ -1381,6 +1507,18 @@ baseuuidbypass:
 		return BOOL_FALSE;
 	}
 
+	/* alloc a file system handle, to be used with the jdm_open()
+	 * functions.
+	 */
+	sc_fshandlep = jdm_getfshandle(mntpnt);
+	if (!sc_fshandlep) {
+		mlog(MLOG_NORMAL, _(
+		      "unable to construct a file system handle for %s: %s\n"),
+		      mntpnt,
+		      strerror(errno));
+		return BOOL_FALSE;
+	}
+
 	/* figure out the ino for the root directory of the fs
 	 * and get its struct xfs_bstat for inomap_build().  This could
 	 * be a bind mount; don't ask for the mount point inode,
@@ -1388,9 +1526,6 @@ baseuuidbypass:
 	 */
 	{
 		stat64_t rootstat;
-		xfs_ino_t lastino = 0;
-		int ocount = 0;
-		struct xfs_fsop_bulkreq bulkreq;
 
 		/* Get the inode of the mount point */
 		rval = fstat64(sc_fsfd, &rootstat);
@@ -1404,33 +1539,10 @@ baseuuidbypass:
 			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
 
-		/* Get the first valid (i.e. root) inode in this fs */
-		bulkreq.lastip = (__u64 *)&lastino;
-		bulkreq.icount = 1;
-		bulkreq.ubuffer = sc_rootxfsstatp;
-		bulkreq.ocount = &ocount;
-		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
-			mlog(MLOG_ERROR,
-			      _("failed to get bulkstat information for root inode\n"));
+		if (!fix_root_inode(&rootstat, sc_rootxfsstatp)) {
+			mlog(MLOG_ERROR, _("failed to fix root inode\n"));
 			return BOOL_FALSE;
 		}
-
-		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
-			mlog (MLOG_NORMAL | MLOG_NOTE,
-			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
-			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
-	}
-
-	/* alloc a file system handle, to be used with the jdm_open()
-	 * functions.
-	 */
-	sc_fshandlep = jdm_getfshandle(mntpnt);
-	if (!sc_fshandlep) {
-		mlog(MLOG_NORMAL, _(
-		      "unable to construct a file system handle for %s: %s\n"),
-		      mntpnt,
-		      strerror(errno));
-		return BOOL_FALSE;
 	}
 
 	if (preemptchk(PREEMPT_FULL)) {
-- 
2.18.1

