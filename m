Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AA9219E58
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434218; cv=none; b=IW2+1VoqoAQ04hd6YqUBzA4gPrICpy0x06NyCLBS4mwwPBjxpb28Bwz3CHggjiJVGX0mLWsmpo4nbVKFUgauXCpN7Xx0BGiNRJWIYI2A5uWZOrWWNJ6mxaVZCO/uUmQLh90gv7CQ3ZCwo5Q6VrScHB1wR74xShwyWm8uNtFS3a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434218; c=relaxed/simple;
	bh=6I0DlDU7r6h299w7wCYMACFg3R+68ox0OBCaPPO6OWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMy9KFyuANd52lm7wjY0Kd6CSHJXPE8p4ZexnwyD4IqoIMc563cIhmnV98ImDQPxpAGArOxM7+spZSuy8d4cF9x06Sa/J13unL/1zscM3tViX//cT0xgv9N8vOHx6qe/j7vP4t2wVRTtAyw+T1YwqHyGU6v5v3+ttH4m8kc+r0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=j18VGQM3; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="j18VGQM3"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6ea15a72087so46657347b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434215; x=1732039015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SVlCssk7TvFYg+mPz0+epJww2XrJywW98H8fNg6oZ9s=;
        b=j18VGQM3VALd1FPSDSra8F/bETEhAgljXkXreIriBZwHMoZHqvsHqXh+DL/yfnASy2
         tazeYr4+Rt+6PDTeAQgPJDHSlyiWYiHAM3WTgDP07GCIRCeUr8sONmYt+apS1ZPZ0oGi
         3IKMK/QA8W32klu0VROVgGnI7jxko1c9dDY4fAGU+7TyiJQ8BNDJfcUGl4/WWqHSiM6b
         IDmrMZSC9vJ/1ye5B4f6RwoRUh4x8p1QqDxZIzOHuGFqmVytD4Qd7HqDG3aqbH5JQ/y1
         ag1CGDx1Ax2gxVHAYVR9iasn4GUpjuHUIH+FzApo9ydNwMmqNUYo6jyxKd5iZVisBRMz
         lXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434215; x=1732039015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVlCssk7TvFYg+mPz0+epJww2XrJywW98H8fNg6oZ9s=;
        b=VeUvYShsku/5kTPqeAJcSwkDDICbOF50vRah62Z5vTciqVSvabonyEaojfxCLMobDx
         TRnMHUIL4yLyadVnA/1fz53KTz1UW8NXNmS0brU+6WhDCkbut4HRSnY0oWPywZSZirfc
         rqJ9OkrE4uYgHAxfsZVXiR60EvbaEW73YeKfg5dmtSlWJ7cgK5GP43iYnPVkbGSb0lvx
         CfGVNuE7eDkxC8ajzNYPbhmaa6Vl8szRWep7pjCMW7rlmE/JvhwgwjrEsT8UFgxGdR6P
         n5vIyn8EgeSBnyKQmKj1EWyP5BswuTAZeStFkzrotBAR7sDidu36O4HpI2CiXo1RXqbh
         oWTw==
X-Forwarded-Encrypted: i=1; AJvYcCWIt+R4qPEcNjDrywacvcHAe/l3Dtjm1hjJRM2KZZ0dRUwlNIKI7m9RycDw/is80gSSosJCj0gL46A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBD7x1WuwlE7gQzAkOX+RQ69x4glZShDjHNPQIWPX4zM7MoJpT
	Uyg+6z91YefMeR7MjOUP4rJE3z5KNNzB0gwiVt1H3GlDZvp/yzzMB+ZlWoG9Ul8=
X-Google-Smtp-Source: AGHT+IHRWQQqMmmNmJOTp/8rWDSoFWHv3EcV7+6jsx99WLy4Go67YPaRFk01hHzbJnpPfWcpjoX+9Q==
X-Received: by 2002:a05:690c:7448:b0:6dd:e837:3596 with SMTP id 00721157ae682-6eaddd9703amr170632707b3.14.1731434215357;
        Tue, 12 Nov 2024 09:56:55 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6eace8f0c5dsm26584767b3.41.2024.11.12.09.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:54 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v7 17/18] btrfs: disable defrag on pre-content watched files
Date: Tue, 12 Nov 2024 12:55:32 -0500
Message-ID: <6d9ff819edb6df5583844c26169dc6ddd471316d.1731433903.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731433903.git.josef@toxicpanda.com>
References: <cover.1731433903.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We queue up inodes to be defrag'ed asynchronously, which means we do not
have their original file for readahead.  This means that the code to
skip readahead on pre-content watched files will not run, and we could
potentially read in empty pages.

Handle this corner case by disabling defrag on files that are currently
being watched for pre-content events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c9302d193187..1e5913f276be 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2635,6 +2635,15 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 
+		/*
+		 * Don't allow defrag on pre-content watched files, as it could
+		 * populate the page cache with 0's via readahead.
+		 */
+		if (fsnotify_file_has_pre_content_watches(file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		if (argp) {
 			if (copy_from_user(&range, argp, sizeof(range))) {
 				ret = -EFAULT;
-- 
2.43.0

