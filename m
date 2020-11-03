Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAB7C2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DCB20735
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQh1E1Cw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgKCPeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:34:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728083AbgKCPeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:34:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604417659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=9Vrz+r+b2nBHfGqaG92bM+3K696V072pt6VQTxnGYwo=;
        b=cQh1E1CwglGKKsustE/mAoGFG18gL1UiyqIaTCbYEM4vPZVB235OLXWEKssEtjDq8aKwI8
        cehsIjKAefRtQhAZLhgw5aA7kgIg7abfmwLjxw/iZSmfcWWboJUmdfoTiAhrMmOOd0h3ey
        iqiuqKnoiJ4Nw+5XUdLXxZR4tDjZjqM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-LjBismIDM9mn68uGMtsm_A-1; Tue, 03 Nov 2020 10:34:17 -0500
X-MC-Unique: LjBismIDM9mn68uGMtsm_A-1
Received: by mail-pl1-f197.google.com with SMTP id m8so7428984plt.7
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:34:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9Vrz+r+b2nBHfGqaG92bM+3K696V072pt6VQTxnGYwo=;
        b=qoALBXGW/tMqvpN9EsQqPxV/nzFjLLG7MqwFx0oL5gyELuqtBxD/UYsJzeghihzsbE
         h2i8IQGESmy4GrlLi3gFydJDHZrHGypf/1Hw80gdbWeJ57n26C6PaAT+D7QwQkhnrHZg
         Ub/+oppgcu42EHeVRXpyK8mwd/k7Ih3HN4DKX29idVlkRXGmpQEG4MqCJ2ueKMUJXAfu
         UZisiZdHRvk12enZwK2+38B52ViExLxeQbp8loOV+aBiVl4z18LzNePMVYy6jDQvZCxu
         BWCFd9FyWCWXfydXAQHgPj/wmoSFugmej8aS0PbeJ6ozc+kBfpyTCB0mCGp/KdbdPhb/
         K/jw==
X-Gm-Message-State: AOAM531etiYLPr1SKymQqdHi0qI1kYZIclR3KoP0YoXRD/luyvbZvdEE
        /ny8CVREa2aC1rUZh2sj7AVEkkFXsrcZiNPHMV7vho9YaV0pL3jy1AccMGYmIv438vOvk74LeCD
        QlUNq1t0aOKjOyUQQe5pD
X-Received: by 2002:a63:7f47:: with SMTP id p7mr16999508pgn.394.1604417656064;
        Tue, 03 Nov 2020 07:34:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZRko5QUxHKjIi97s9mlERGfQO9MMt9Gi2Kwvea58jVhqWHCWO1uj6GloWOBXud9uEjjVI/g==
X-Received: by 2002:a63:7f47:: with SMTP id p7mr16999479pgn.394.1604417655693;
        Tue, 03 Nov 2020 07:34:15 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w10sm3646165pjy.57.2020.11.03.07.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:34:15 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v3 2/2] xfsdump: intercept bind mount targets
Date:   Tue,  3 Nov 2020 23:33:28 +0800
Message-Id: <20201103153328.889676-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201103023315.786103-2-hsiangkao@redhat.com>
References: <20201103023315.786103-2-hsiangkao@redhat.com>
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
changes since v2 (Eric):
 - error out the case where the directory cannot be read;
 - In any case, stop as soon as we have found "..";
 - update the mountpoint error message and use i18n instead;

 dump/content.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/dump/content.c b/dump/content.c
index c11d9b4..c248e74 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -511,6 +511,55 @@ static bool_t create_inv_session(
 		ix_t subtreecnt,
 		size_t strmix);
 
+static bool_t
+check_rootdir(int fd,
+	      xfs_ino_t ino)
+{
+	struct dirent	*gdp;
+	size_t		gdsz;
+	bool_t		found = BOOL_FALSE;
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
+			break;
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
+			if (!strcmp(p->d_name, "..")) {
+				if (p->d_ino == ino)
+					found = BOOL_TRUE;
+				break;
+			}
+		}
+	}
+	free(gdp);
+	return found;
+}
+
 bool_t
 content_init(int argc,
 	      char *argv[],
@@ -1393,6 +1442,14 @@ baseuuidbypass:
 			      mntpnt);
 			return BOOL_FALSE;
 		}
+
+		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
+			mlog(MLOG_ERROR,
+_("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
+			     mntpnt);
+			return BOOL_FALSE;
+		}
+
 		sc_rootxfsstatp =
 			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
 		assert(sc_rootxfsstatp);
-- 
2.18.1

