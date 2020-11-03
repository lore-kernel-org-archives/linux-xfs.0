Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5104EC388F2
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 02:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CB122265
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 02:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UXjnXnLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgKCCeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 21:34:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbgKCCeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 21:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604370850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=uC2t3wztcLYU//GjBY6JydOXVvD7q4rUOIvlzDo0EZI=;
        b=UXjnXnLwUwqvA90/KWZQmn2r3m7T8FABcxm45xbDDX1y7YZ14fj3XHZbqbYGSitYb6tyyr
        Z2QrXA8s6/B2eoVrvUw4pQypVdy9U+p0GiI7GYtznFs2MjWd/NAWtfAlWfmvLWtujQkFyz
        OpPBeSAOVzAiDR7QagLtzcLqsvjjiq8=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-ktZgKHJQPUKBQv9SAnzXcg-1; Mon, 02 Nov 2020 21:34:08 -0500
X-MC-Unique: ktZgKHJQPUKBQv9SAnzXcg-1
Received: by mail-pf1-f198.google.com with SMTP id 64so11350020pfg.9
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 18:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uC2t3wztcLYU//GjBY6JydOXVvD7q4rUOIvlzDo0EZI=;
        b=Pm/7db0eg0X5rRL/OYQfto5AEGC5GNa6kO4FIc8emu+GqqJe7qLk1tQRb8RO3J0pdC
         tNZkgStlZIexWM5C6MAH7+AxykZdHZTOBk3j2xmxm+LCuJw4qhi9ECbxaD4xJKDobpXW
         7s5nWrNrnTO1uP6KuiK0zn2GXVRof7z1ELcimuXrIAu03xtmlbKk0URvJVfrKFZaFCdh
         /oKECNbatu4Y8k7wA/bHi2i39kHUIyFnvr1KdUH0t18tM0m6rtUFqBCZFdIYaDnDQBgR
         9kxOtOYVOv4OFyH3WgRGewocL+G0tAnhVhoMpd8pyxIzG1s1xzzd7SZms1bNUPn4G40b
         zRAg==
X-Gm-Message-State: AOAM533XTsO7E6xlOvwKCJ1SX5GU+XkKIoygaZkock/y/I5y3HSIUcEk
        CCL1eMcjw94z35IA57000VwEtk0QAJibl81Np2gvsyRXn/GL/Z+DS9DSOF1JLph1B01lRCT3jNC
        WtkRKD3U/vTax6bWzsZBr
X-Received: by 2002:a63:b245:: with SMTP id t5mr15290729pgo.328.1604370847291;
        Mon, 02 Nov 2020 18:34:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyIWK+/fM8DXxDXvFoxhZ6MH0Jbjt4dCLtBTK4yhn1V5kDxoo4RjZsyla2FpV2PmqVMANwDog==
X-Received: by 2002:a63:b245:: with SMTP id t5mr15290718pgo.328.1604370847092;
        Mon, 02 Nov 2020 18:34:07 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u11sm14251253pfk.164.2020.11.02.18.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 18:34:06 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v2 2/2] xfsdump: intercept bind mount targets
Date:   Tue,  3 Nov 2020 10:33:15 +0800
Message-Id: <20201103023315.786103-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201103023315.786103-1-hsiangkao@redhat.com>
References: <20201103023315.786103-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

It's a bit strange pointing at some non-root bind mount target and
then actually dumping from the actual root dir instead.

Therefore, instead of searching for the root dir of the filesystem,
just intercept all bind mount targets by checking whose ino # of
".." is itself with getdents.

Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v1:
 just intercept bind mount targets suggested by Eric on IRC instead,
 and no need to use XFS_BULK_IREQ_SPECIAL_ROOT since the xfs header
 files and the kernel on my laptop don't support it, plus
 xfsdump/xfsrestore are not part of xfsprogs, so a bit hard to
 sync and make full use of that elegantly.

 dump/content.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/dump/content.c b/dump/content.c
index c11d9b4..7a55b92 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -511,6 +511,61 @@ static bool_t create_inv_session(
 		ix_t subtreecnt,
 		size_t strmix);
 
+static bool_t
+check_rootdir(int fd,
+	      xfs_ino_t ino)
+{
+	struct dirent	*gdp;
+	size_t		gdsz;
+
+	gdsz = sizeof(struct dirent) + NAME_MAX + 1;
+	if (gdsz < GETDENTSBUF_SZ_MIN)
+		gdsz = GETDENTSBUF_SZ_MIN;
+	gdp = (struct dirent *)calloc(1, gdsz);
+	assert(gdp);
+
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
+				mlog(MLOG_DEBUG, "FOUND: name %s d_ino %llu\n",
+				     p->d_name, ino);
+				free(gdp);
+				return BOOL_TRUE;
+			}
+		}
+	}
+	free(gdp);
+	return BOOL_FALSE;
+}
+
 bool_t
 content_init(int argc,
 	      char *argv[],
@@ -1393,6 +1448,13 @@ baseuuidbypass:
 			      mntpnt);
 			return BOOL_FALSE;
 		}
+
+		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
+			mlog(MLOG_ERROR,
+"oops, seems to be a bind mount, please use the actual mountpoint instead\n");
+			return BOOL_FALSE;
+		}
+
 		sc_rootxfsstatp =
 			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
-- 
2.18.1

