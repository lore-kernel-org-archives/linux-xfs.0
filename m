Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B431BC9F4
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356354; cv=none; b=AlMQuozhJ+4cuZT4+rnqtWPMQ7noDnmUcVrpa4pTJ7OKcndrWzxNR4E8QCRMppZSR7u49RHz8G96SvBpa+KSgyyTzzRxHwRiwgEwfnfn4aiEv9UwOhbNSfc7F4vLUqkAMq1nex3KwDQbihlpnLaHjoTyFEZ1ri/UAiovXmqFIzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356354; c=relaxed/simple;
	bh=u0ZPC8RBKGOY//W0g1jPdakQ+vbKZNphZ2gNuJs6b/U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4Kt89qi5J0KaI7QIs5qrtzTtenAMEVScZs8k+Nx+tUQTd21kBNwKsJXc0TMCoa1pr4KdZLJnTmRiZ9r8oQGKmtEyjnwyFapAc0M1E0hnZUrzsAXE6e5j7aini3OnrSrPc5QNgYYUxJbCvgJEH5Z94vFAQw9RFYcmAkE/MjZGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=uMBxQLaQ; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="uMBxQLaQ"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-460af1a1154so33125271cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356352; x=1731961152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c28yJdRjKgJn+HaLKJzmXzT/1RpIgNKOoAPY3XeErlk=;
        b=uMBxQLaQdBTOkogBm81DGliBM20P6mhlC40/Usb1CUb5B86iwNU51MU+HxprOxDz9U
         yIoBkFy49ZDZqQE28wzwXn25ItTuJZACsCK+rx5Y/PLhtVPHO/A2Nx5lAobzJaSgqvC6
         6FFBrz7RfEDMdaeTLP65qrNn4X01xPP5XG/f1hXvofBDzFdmRs5ukFR24JLQ5xUmJcB2
         j49GfoP0zMir8eAsUtn4lcmP0LwUVkZWSfFTw1VcJFWu6TZOC3AvrhKTyfzLcg0oXfAt
         5CNAgeh5llTo82f2OBja2AiB3ir933Ufd3DFqOPWkua7ph112xYzdcvsgvQ9jHA/tlr4
         Scww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356352; x=1731961152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c28yJdRjKgJn+HaLKJzmXzT/1RpIgNKOoAPY3XeErlk=;
        b=vkcSBJDsuNyFeQwl+lu85oPtFA61WaJ46MQPNvayT/dFc/El+o2IQkBF4F2A66Z7o0
         6ND7dAxHaS5ztC/77YLBMov5Kd6GJoWg4c+52qYfk43Mm2mYQk48fZhGvP6hvHpVsnwA
         lwqFF8mAmbAPK1SrlbSNsa+LJ5yAS2bzdJEBvBE2zv+ADn3WtE5WHozaWs59NV21wvNd
         JcuQ0juxemcabdMDl/D43aVXYGsOI1SmpBCtkAlh95ISJjrI/t0sKESywP3/fb0hPD7l
         4UiNH+392/7z4DBwNN329zHPtZ2Bv4RESNd3umIPpteZn4+ZADFbwzNG/K3/VSST4LUc
         PAhw==
X-Forwarded-Encrypted: i=1; AJvYcCVcaD0592uX76Cu5YQQxZQuVY+mBIg+oR0LJefl3/riVAcVo1BPYHmq2LvRW1xkuAidtQFN/5owRrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YybEEIO02JNf014NqEmv1stP8Lfk6LaG3xELVONEZLEQySXtVMj
	JgozeB7xvtkqvLCq7uiA4BcAdXZfXJQ7q/6UEF8VPUBbZvCxRy6RgvcYiduWez8=
X-Google-Smtp-Source: AGHT+IGJ1y9f+W3Xzh+MP+v/BdPhaguxeBsLZfL0+LeTficfSUhpJzafSU29+3SIM79iI497xnnP7Q==
X-Received: by 2002:a05:622a:189d:b0:461:123:d168 with SMTP id d75a77b69052e-46309415f15mr198172601cf.50.1731356352177;
        Mon, 11 Nov 2024 12:19:12 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ff41b63fsm66638381cf.23.2024.11.11.12.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:11 -0800 (PST)
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
Subject: [PATCH v6 03/17] fanotify: reserve event bit of deprecated FAN_DIR_MODIFY
Date: Mon, 11 Nov 2024 15:17:52 -0500
Message-ID: <0ac31d4ce175116ee220bc3e1deb0f437ac03ea4.1731355931.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
References: <cover.1731355931.git.josef@toxicpanda.com>
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

