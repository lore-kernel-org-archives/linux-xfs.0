Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EB13B19D9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403187; cv=none; b=YhrOKggz1DUfx1SHmuQmSSwcNLIajjOQN1jlMhmxVArY2KpuEh7n49XM+s3UiWE77hS59BZhT4ESi2MpzhslVHWHcaC8nSLzhxMdJjpwhW3M65W8EroohTsdp6iNqySzEG9rfDzAts6D5hdj8Wspp7JMIzHiGLVjBFXJeLxNtKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403187; c=relaxed/simple;
	bh=dvPmh2MX3lGbIaGJA+vnikpJaoUwi8NxpixIT/Mz2A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6qaahLNLvJtcGVRBzo+wpJFlVOPGouvuutrlu9pdHxXR/sqwhp8X9SznPgK9NfiEkldFrLie35cbHK8RdJn4PRaF3N42X4G4DzkxM4p9qfIlBzeKrXOmb9cy8CRGoB0ig40Ag+juUrmAfPg07fvX48jFbgYyTgPaHgEd/JKqlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=OLrrpWNr; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="OLrrpWNr"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-972f2ea069eso83288241.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403182; x=1787007982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XY2LsFCEmCQ1uxuh8820Be3psuNjCA8kqH0DVMr4tgE=;
        b=OLrrpWNrC+r9lTFPzuFN16KekeETeiBjuvzl6xpfZN2YOv+pJ74mwufH3IJWAE9QzQ
         rFTTFxr4JhWQTKt2tH6gkBoTWs2V86D7MtQK75rAhp4mM9sXv8dApHmthYr8fLCF7uG8
         4Mt2mXMw7GhavtL/ozOfURaDXTQofzKgjHrCLXZ1uJojbynDvRidjJtONU1aWQAEDvYT
         m/+3vyczcz8qX5Qxw1rrwnW2WgGz5sMt9DdBKcAt3dNKRF5Qgw+3YfL4lxc2ojp8avYn
         zRo/4ts3KumGVoNcPUZQ+IUPAEprWW9AmhBRItgbhFJuLDrHkAnVnRajUNXX+oiPRFq/
         fRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403182; x=1787007982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XY2LsFCEmCQ1uxuh8820Be3psuNjCA8kqH0DVMr4tgE=;
        b=RT4zV5yt5UZJFBh2GtJ6VQpRVx/TjdQxcS3KZHeLtkOOV6jJtF3O8ChxXwKqHVNtV9
         gKkAbA9MMtGqjD+UVDrrN4/RbazESQapAzRxaEhZ8O7SOAgO50gln10bkDEqqY2HnEGS
         +sq00QPRptFh9fNoOqryav4UxCJ/C/f1p4huxMhi3VaKLS1QYkIM7JLCqPaKVGu2ua+i
         HOjVGKyt/fHYE1eQAnbODBmdU0gVHY5Qz8J57mpKLpSV+hFuhfQxmi8sfBUZw+NiBMc7
         0DeanLNBCv2DKiZo52h8RnyBRGEwSHs10mNXZtGUCl7k+QexydTeQ1zTW2HpRIlyblcS
         d+fg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3GUBjibpGv7PCHzLnRO96N/K6f4bMw9sG/j8HzTgHh4CuQuE2RaqpppCb6Qt61T9QQDppJKDNxZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrcdkgrKRzDXDdpWV1UO9rlEoU/2HlBKRRl9L6aLe0xOHLbbu1
	Ikfi6cxpLea0XT83E84NO2ChSZRSAl2F+PHRJjudJ7ClVZqM68UYzoW/xvIeVW51Mpw=
X-Gm-Gg: AR+sD125T9rNRcQsOTtllDVKGAjHnbOHGgZQGkU4uiy85pBJV0vwvBUf45A9+fCuogH
	Cw+0awbNaJ1Sp1OkddLKN3tV2R0R1XuNWqmQo6MN7gGfz8uaVXDUwhvqdvvkKi7Q73NyqBs6VoT
	+QX4g4I4sklp0bdnCdOxF7djRg0ZAoa1PE2Gm8xNgKifNo6kxHGfmuGiKcdghVQWGzM4i8ekjVT
	zVTWZWu5XJ9QmwDQDjhWYLNFVtwx6OwkpySQNQf06Sz9pv0y3HwSdmEBSlIwjC6BQ9XCoNE2CzZ
	LCvt6sMYC8OhbTmSDPa7ua76/5zrEndRj/QtUeh70CcMfDH+idaPz5NR8LytAP/kwZ/jHJViHbJ
	3h1zbRoCoMnRA/w8xANKCNCKoHYRKSg4rCE4snqal7snRiwb61kIsZlnIiosubA5bqOn0VLNnqO
	4MnssmGXlmZeX9nV2cnqOVsWEBC+hyKVHAZbE+Z1kkwTTFffAAJ39ivuUQPCxefhFK
X-Received: by 2002:a05:6102:2c16:b0:74d:ce65:3e8b with SMTP id ada2fe7eead31-760e9045be4mr6961995137.2.1786403182482;
        Mon, 10 Aug 2026 16:06:22 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-763feadcdf4sm5513334137.4.2026.08.10.16.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:21 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/6] xfs: report the error that made deferred work shut down the fs
Date: Mon, 10 Aug 2026 17:06:15 -0600
Message-ID: <20260810230611.2859909-11-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2392; i=floss@jetm.me; h=from:subject; bh=dvPmh2MX3lGbIaGJA+vnikpJaoUwi8NxpixIT/Mz2A0=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljS1kfyPgZ2EcwoP6u3bIWL9e5ICDwP/7uA KbgYNfEH0qJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 H6kVDACM50ty0CdE4rXcPkIWvOe0rLriJDAU8v3i7ycm9G2Al2Yuv8NTzI1FlsCQkW6yOV3iuG8 elwybvxarjhiBrhesER3oglmO6TZ4MKLa+EtdLDA27aSVx3PTaz5L+Q59uMMo8NLU2MZnM55Hel WADaeQqfPDoQTF0BT5GKSGxWtp4/QzEApyDv6GHRvQLPfo5ULBDXNoPCjjxXRExDa6drEd4mw0Z a/Aa4Z4kcq2gSFJC/kGOy+LwzXg1ot7kh8g2POBwZgOH6nkwSb3Zt+Qht5TDaPobStbbCKeSu+9 QnJ9LZgw8V0SJcgHFqaZdhH3G8jBzn4XSfGaa95hDnVIoQHSCo/jAD8mBgVn6z8oSA3ZpO4xB0r EMuRQJ2RBjd7MdPSbFfrwyMYpue3dL2T/L/x47H/tF1QXEWvvCv5h50XeTXehnCDRltRSI0OhkI BW8+uLBX5gFRmVQaTSIHlDcZ7bQukY6Zytg7/4lG8LnQrMcwegssNA7tTcALO4XguarnM=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

When a deferred operation fails and shuts the filesystem down,
xfs_defer_finish_noroll() reports neither the errno nor which operation
originated it, so the log cannot tell a transient -ENOSPC from real
corruption.  Report the operation type, errno and remaining reservation.

trace_xfs_defer_finish_error() runs after xfs_force_shutdown(), which
BUGs under fs.xfs.panic_mask and so never fires for the first failure;
move it ahead of the shutdown and mirror it to xfs_alert() for systems
without tracing armed.  Capture the op name while the item is live (dfp
is freed once its work list drains) and suppress the alert once the fs is
already down.

Signed-off-by: Javier Tia <floss@jetm.me>
---
 fs/xfs/libxfs/xfs_defer.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 75f0d37914d5..3152acdc335d 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -656,6 +656,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp = NULL;
+	const char			*what = "chain";
 	int				error = 0;
 	LIST_HEAD(dop_pending);
 	LIST_HEAD(dop_paused);
@@ -705,9 +706,17 @@ xfs_defer_finish_noroll(
 				struct xfs_defer_pending, dfp_list);
 		if (!dfp)
 			break;
+		what = dfp->dfp_ops->name;
 		error = xfs_defer_finish_one(*tp, dfp);
 		if (error && error != -EAGAIN)
 			goto out_shutdown;
+		/*
+		 * A finished item is no longer a candidate for a later
+		 * failure.  An -EAGAIN one is not finished, so it keeps the
+		 * attribution across the roll that completes it.
+		 */
+		if (!error)
+			what = "chain";
 	}
 
 	/* Requeue the paused items in the outgoing transaction. */
@@ -719,8 +728,12 @@ xfs_defer_finish_noroll(
 out_shutdown:
 	list_splice_tail_init(&dop_paused, &dop_pending);
 	xfs_defer_trans_abort(*tp, &dop_pending);
-	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	trace_xfs_defer_finish_error(*tp, error);
+	if (!xfs_is_shutdown((*tp)->t_mountp))
+		xfs_alert((*tp)->t_mountp,
+			  "deferred %s work failed, error %d, %u blocks reserved",
+			  what, error, (*tp)->t_blk_res);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
 	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
 	xfs_defer_cancel(*tp);
 	return error;
-- 
Javier Tia

