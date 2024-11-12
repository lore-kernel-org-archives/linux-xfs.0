Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2EA21733B
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434197; cv=none; b=SxsASnrV6MDF2yjXavPX5Cq4LjQHPayg3ZR0aNiDIZQug4J+aFcs1L6TF0Xs9dPdZsLjVPmVRXhlNE6FAEZh3s2wjaFCIPbFuyjDTooG5S7pe0E0gDfjuHcZTS4STjT5Hv5ZHgePxUqMq4WqyXDQRtN/ugihPYo+9zTTws5iOrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434197; c=relaxed/simple;
	bh=u0ZPC8RBKGOY//W0g1jPdakQ+vbKZNphZ2gNuJs6b/U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoOqGyt1zWcnOkwv9mm7wnXMT+Ux2gm1sp97hnj7815OiR6tcuV9ia/v35oNMKntHZ283GXTOQpvFqZhH2F7oXlzjUxDoSIn8730uRldHhK7Dqk/GutvGpIWFFpNEMyyoY62n2HAikiWpFJL5KvSaeHkxJYTtZ9lLXuhI0+P094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=XMoQOzrv; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XMoQOzrv"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e30d821c3e0so5665583276.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434194; x=1732038994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c28yJdRjKgJn+HaLKJzmXzT/1RpIgNKOoAPY3XeErlk=;
        b=XMoQOzrvEsYiOUnEsMfaTLSM58Yq9sb6Q8ID0Fj0l4cr1ivMfFEH0c+/Sg5bbWo+3W
         uPK0vKSfZQM5YEOoD9mdZkdcQbDnigWN0dr7qUSmwFDwOhBqhrL0+K0K5cdDoG2Dve87
         Nf1bBla/bLmsgx7JERwMIt3LMda4dXfViF43WZ3tR0P0bxptUdjKv8TIMkhUXwVgKIKZ
         TkE02kc0y+hJlobk9S6CHZA32GoK83hZJRm7XIkJK5Bd34l/IjAofhVjSfp+9rgrhsNE
         sY1NVPhqhipn8nU3s6Nj89aADj6zW1MCZOPR+wia7OAj8rF5wo29+8bWKE6GWJkT1rQO
         2NIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434194; x=1732038994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c28yJdRjKgJn+HaLKJzmXzT/1RpIgNKOoAPY3XeErlk=;
        b=KB8lPlE9fuxl38dfejcxhqWV1C31xMZNSsG/3hf55xB87GKf5uXUsZvG8t0HXOow1q
         84qlMdiTZn6BgtGgbpBChNVpv2LRtksAyfPF09d873vL3quaOhtPiQyZaoRR1hT42UNp
         AnP9NKTOClhLP69Pxu84XPzBFbHrLK8Bt8AMniyEsGR6hLR+9yHrnCBD+/lqWEF+4yn1
         GZsF05JijdUe8xtxabzkfGogDeDobU/OxI26yTRQblOxKRbujWzS5q8JbwiW7Q0dAg5g
         MYSFrYAAquvtWv7GtYVSgM0BtHSKbvcB1iNg22XvcwABNokd3ume2b/rFjnQjEwfLFgy
         pPag==
X-Forwarded-Encrypted: i=1; AJvYcCUNTVAW9UcivGFv955nwoIQBYB6yQ+zRnW/dphpR/ebG5cnRHN97DXRGHMmwoTQ+U+Rci5WnY3QtpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMQygxnNSJn243hGsNCUlIb7oFnZEv/LAZWHpeI2zO93tgmPif
	Pxt8pqBfUqANtWBnpGRwvxIn04sxeKVdm7+87pj8X66E69edxft1YiuzsS32Dz4U38czEf44obZ
	t
X-Google-Smtp-Source: AGHT+IGHOswKyJpRxtAUdSHm9RVyiLr7O2lKHvfik/aOxq8+Vnb458JxpogP2HSmvoOplu22cOYVQg==
X-Received: by 2002:a05:6902:728:b0:e2b:dce5:9c93 with SMTP id 3f1490d57ef6-e337f844799mr17781398276.7.1731434194365;
        Tue, 12 Nov 2024 09:56:34 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336ef48465sm2752627276.31.2024.11.12.09.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:33 -0800 (PST)
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
Subject: [PATCH v7 04/18] fanotify: reserve event bit of deprecated FAN_DIR_MODIFY
Date: Tue, 12 Nov 2024 12:55:19 -0500
Message-ID: <22d02743468d137aeb73dfbc7bef44efd361785d.1731433903.git.josef@toxicpanda.com>
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

From: Amir Goldstein <amir73il@gmail.com>

Avoid reusing it, because we would like to reserve it for future
FAN_PATH_MODIFY pre-content event.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fsnotify_backend.h | 1 +
 include/uapi/linux/fanotify.h    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3ecf7768e577..53d5d0e02943 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -55,6 +55,7 @@
 #define FS_OPEN_PERM		0x00010000	/* open event in an permission hook */
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 #define FS_OPEN_EXEC_PERM	0x00040000	/* open/exec event in a permission hook */
+/* #define FS_DIR_MODIFY	0x00080000 */	/* Deprecated (reserved) */
 
 /*
  * Set on inode mark that cares about things that happen to its children.
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 34f221d3a1b9..79072b6894f2 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -25,6 +25,7 @@
 #define FAN_OPEN_PERM		0x00010000	/* File open in perm check */
 #define FAN_ACCESS_PERM		0x00020000	/* File accessed in perm check */
 #define FAN_OPEN_EXEC_PERM	0x00040000	/* File open/exec in perm check */
+/* #define FAN_DIR_MODIFY	0x00080000 */	/* Deprecated (reserved) */
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* Interested in child events */
 
-- 
2.43.0

