Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A08C4320E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 844CC60EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbhHFVYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56920 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240338AbhHFVYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TV7Qj9Cd4raX9KM6H4jz/MP/F7OzpXjw6bNGnLkt9j0=;
        b=RzG+DfTseWvdnNQ73X1apak71ncgt3w7mkRAdDvl3+bAo4k0cmlYRBn17ValPylYMMZnxt
        zQ5qTwh98Vxs8NPHXx6RDkK8fH10jAEYRqyhirm9fLuro9vbjn1U8WKdfqciVzs5fHdBC3
        ZC6rMJ/WxR642IBPEM+0bLHO13m0bBQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-WlYzO3h8OH6tzwluvTuycA-1; Fri, 06 Aug 2021 17:23:57 -0400
X-MC-Unique: WlYzO3h8OH6tzwluvTuycA-1
Received: by mail-ej1-f70.google.com with SMTP id k22-20020a1709061596b02905a370b2f477so3523756ejd.17
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TV7Qj9Cd4raX9KM6H4jz/MP/F7OzpXjw6bNGnLkt9j0=;
        b=KXc2XEDSsBbGwqQkjewiOS06PPcnyGEojK7gM3wC/OddmEdp0r0TtLOEq8w4WQe67E
         sQi75CV9AzzsSLhNJG/f1snum63zrgRSCLqI2pH0UKnRAu/Zjjc44b6SkwLAJLarYR5g
         YyJNIfi7G+Rvf6urowdNmYcCCBnEqHSlgBrS3myKo6PmbTPnYtCxeCe09d16LafLPRcA
         h1WR1VhallSrPzBWf+4e4KF8aO1+q8kkP7f4CXRvK4r/JbSJydnmq3/nfCGdNrPSEUog
         c8UFbgbNywtKd4WlcyJGLBoYaDB3NS0StusXYsq4OExijhyIt3A0w1t00dq+R8xFvQ0L
         jIVg==
X-Gm-Message-State: AOAM5310I16vju26IX1XvKMZPZLOWX6yqdhwcXVP8PbNqErlx1yabLNa
        vOOXiPLyNj1oryzswc4fZidasgqrRTxVyeb1vw4XhL8KUJxvvgxU21DWIGVlqICjaM3n556m5fF
        tAZyNmBQ+ZBG7MBqf9GqOEvdoZvsd0GNAqgArY9WzsR3d4+EDnWGDxG3Jek3HBvP5b5GQEgs=
X-Received: by 2002:a17:906:158f:: with SMTP id k15mr11509703ejd.241.1628285035706;
        Fri, 06 Aug 2021 14:23:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxO3wjJkVCY4BuHvOYq59RFb3tlRtqoMO0BeSs0yHK1UePwI6/H5mCFBFfKJkP6YaWGooB+mw==
X-Received: by 2002:a17:906:158f:: with SMTP id k15mr11509690ejd.241.1628285035497;
        Fri, 06 Aug 2021 14:23:55 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.54
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:54 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 24/29] xfsprogs: Stop using platform_set_blocksize()
Date:   Fri,  6 Aug 2021 23:23:13 +0200
Message-Id: <20210806212318.440144-25-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c    | 8 +++++++-
 libfrog/platform.h | 1 +
 libxfs/init.c      | 4 ++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 4e75247e..796fb890 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -145,7 +145,7 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
 }
 
 int
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
 {
 	int error = 0;
 
@@ -160,6 +160,12 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
 	return error;
 }
 
+int
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+{
+	return set_blocksize(fd, path, device, blocksize, fatal);
+}
+
 /*
  * Flush dirty pagecache and disk write cache to stable media.  Returns 0 for
  * success or -1 (with errno set) for failure.
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 69f432f7..06519a0c 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -14,6 +14,7 @@ int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 int check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
+int set_blocksize(int fd, char *path, dev_t device, int bsz, int fatal);
 int platform_flush_device(int fd, dev_t device);
 int flush_device(int fd, dev_t device);
 char *platform_findrawpath(char *path);
diff --git a/libxfs/init.c b/libxfs/init.c
index 9fb4f9d8..46e6e225 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -123,10 +123,10 @@ retry:
 	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
 		if (setblksize == 1)
 			/* use the default blocksize */
-			(void)platform_set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
+			(void)set_blocksize(fd, path, statb.st_rdev, XFS_MIN_SECTORSIZE, 0);
 		else {
 			/* given an explicit blocksize to use */
-			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
+			if (set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
 			    exit(1);
 		}
 	}
-- 
2.31.1

