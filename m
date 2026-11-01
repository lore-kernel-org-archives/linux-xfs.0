Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793550491;
	b=hYM8RQS++AOERhh7xXKYaOKmz/yIWheTfSvx7iBpisSSJbtNkBFc9n5qF8Bmd8fSwHG2
	 7u+8i/A1RSEtHjSHRTIGltdMhzCRLfjkH/6bBlz0tRwbv7CS0RlcyhbsmeEDwScVS2AUF
	 raVvd+jNW/sgfJB0+gQguVGEoL4esJSE3caVap4yTSJBc02cF02EQ7Tzx2g/iekk7h2gy
	 Gh7Tove7xgQNGQk1MGXXyXyR5Zb//0856BdE+Soqq8vp0E0EYGhCWa1G6ayHriAtaRYsP
	 vJRC8BJvgEz6s/KwbvSPgq2n2vWqUb1rr++uMI1qV+aPiCqIqCfC1Z2pv9pl53AafUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793550491;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FX/wG/qZI2yQ+/NVqbtc3QLtED3oH3+ZnbVKgbyotgA=;
	b=ROktoGur//dBlMPvbSF5VVE7hTDPIG4T0MeTSQCQSZuckRZC0PBtUI094fFUerau2jPO
	 gFRZKZRxFiQnYLq7Ajw/WwI+46h1LvdbJ0Rk/AYcO5qgdvPJxDpZpSa2lKH65YuT4JkKa
	 wvwlBGeZHuWsuxXIUVS0pQU3wtCnXWaawjUwdhamWv2UqHMsKGKsdauggVg5W/6KdI2fD
	 p+hEzaPuBZvxALcYKXuDHl34fFgRuXgwYGLYTfCTOCgKASVdGorSfi/rCLz7H0VJ+8KtW
	 sVHU5cB1wIY9ZOL2Ss70AS7x/5lMnfhLH1Ulmcg80h/UDMsTkyi4+lYXLjzkOx0gF1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j5TvWi3n;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C164606A32E
	for <linux-xfs@vger.kernel.org>; Sun,  1 Nov 2026 16:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C164606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j5TvWi3n
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4afe2d546f9so5680115e9.3
        for <linux-xfs@vger.kernel.org>; Sun, 01 Nov 2026 08:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793550490; x=1794155290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FX/wG/qZI2yQ+/NVqbtc3QLtED3oH3+ZnbVKgbyotgA=;
        b=j5TvWi3nMWFlaI7jA8vIX8x3HB7KeKVInFUBducMd4Yy8ZvoNsLE3lIfus/EciPZ6f
         m8Aeth4J8RxI/CQJJJHRIwXy17ExpzOfTLI6ljslF0Hk96PNaAxS/dz2pK4jB1ymnwij
         6eQ0oTUhZDDrP9QmYq5NlAUoq90+2BGjFvh0tJZ+mLU+6iV9zWDYzhu8eGFJBOIVSuN+
         c/dvTix+OFGcsD0eFIYR+O3shKWG36XH+EDnYUtH6XbKUBu0Ummgq4W2wLUn3CgOPZjw
         4I50GkEPR00peCIlTcCN1uquS5g3gTcz4/TZXpY81Y0DChqVLY5iaVTmI5gqCUTWFWTH
         gNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793550490; x=1794155290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FX/wG/qZI2yQ+/NVqbtc3QLtED3oH3+ZnbVKgbyotgA=;
        b=t1hApQb0HHmI9V/txZQDfm1xSaJZGySOQNvF+8dZOteEegs7x7vON7ZRZj0VIJ4qQF
         MFrjD4MpC05IQNaMQ6tauzJpggR08g2zXNCO6TktvnD7RyDekFfNezg9e17bYPBb2A36
         Vhttn8zIbVPWYx3fiEF0AKPvmhNpFnUwj/X53ClpvioRFQK1T0FW2iqmdqHBzvL+c0hU
         99WzZrpDG86+NoLsq4PcWeQaJspOIGrSIYPeT+zsvLbi1hxyQFYQWsx1jhhuQtMeiTHz
         S6MniKGfkv1L0wkn4pKmYyuVGx+QQdg4YiCPDXFLp9W8D55/haTWgOssRoiPYDsACsdA
         oZiw==
X-Gm-Message-State: AFq9FYLh7iMgPl4vGUZkP+4zxaD/ncHYzBSWSZ+CxIUOLNAwok+Vi4jn
	48bnoqmyEb+XwOGni8kbMrloQN0X69IRCHocwlm0vfyQezXCA+cJS37y1u6V
X-Gm-Gg: AYBFou0D2Rfv6cXcNCoVvzqRC/QonosCW+Dr/Qlvso/H5lR+e4FISbE/OEkhndg/jYz
	epYTGG7JNA4GPcBDVX4VXF4JS8xIFXxGz/tUdnFpOD0Sm8OXd8BzeSXje5ZcS7XChxvZ1svpiKT
	9F2aH5JuMvbBiDM78If6+xKLaZFk3CgEeFW6yzFNn7Gl7l9s33WCnN5lWisw1CInGV5lm1k6U23
	DlyRS2kjQBGgITjx0YjJk5u3IioujC/WVoNWh0kN3YNhD6ZpYV/h1r36bAXHwZrgLhxA7LWtGN8
	z2RE9ubBNSr+wBtsaxF9bqlpXp1koWXBBF9HkPk1E6Q7owMxB9ymC+AAegWr9UCFx1g8zbPLzhF
	K0OI3ggBhea6bUzyP53F/XQhAOYZiUJnJk1X/VsU2sN1CKrq1Jqz4cAKxC7XX7WbfIUe0u6UpP6
	1jdiEW3MJeXuDKQPR43sjP/uuv5TWiJs4CWm4dd1EobLWwmysy5VjkvfeG+p4FcbdEfPezIv+pn
	SUv9BeshvwjPQFfoo+AmI7VrOF6DrkbEpsSmtA0FQIZXrvhD36ny7Rysd9T8nWsXiU8yqUthnco
	yujAzO30k6VYSeBSvvQ/52NwOuhPp2tr
X-Received: by 2002:a05:600c:a0b:b0:4a1:a6e0:4ce4 with SMTP id 5b1f17b1804b1-4ac183d2043mr177192165e9.33.1793550489823;
        Sun, 01 Nov 2026 08:28:09 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf0b36853sm192023245e9.0.2026.11.01.08.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 08:28:09 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org,
	djwong@kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH xfsprogs 5/5] logprint: bounds-check continued log record copies
Date: Sun,  1 Nov 2026 16:28:03 +0000
Message-ID: <20261101162804.1444159-6-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101162804.1444159-1-tristan@talencesecurity.com>
References: <20261101162804.1444159-1-tristan@talencesecurity.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Five log redo format copy functions (xfs_efi_copy_format,
xfs_rui_copy_format, xfs_cui_copy_format, xfs_bui_copy_format,
xfs_xmi_copy_format) bypass the record length validation when the
XLOG_WAS_CONT_TRANS flag is set.  In that case, memcpy copies the
full source length into a destination buffer sized by the nextents
field, without verifying that the source length fits.  A crafted
log image can trigger a heap buffer overflow via an oversized
continued record.

Fix all five functions to check that the source length does not
exceed the destination buffer size even for continued records.

Found by code audit.

Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 logprint/log_redo.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 38caf5a2..df24b77f 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -24,9 +24,13 @@ xfs_efi_copy_format(
 	uint len32 = xfs_efi_log_format32_sizeof(nextents);
 	uint len64 = xfs_efi_log_format64_sizeof(nextents);

-	if (len == dst_len || continued) {
+	if (len == dst_len || (continued && len <= dst_len)) {
 		memcpy((char *)dst_efi_fmt, buf, len);
 		return 0;
+	} else if (continued) {
+		fprintf(stderr, _("%s: continued efi record too large: %u; max %u\n"),
+			progname, len, dst_len);
+		return 1;
 	} else if (len == len32) {
 		struct xfs_efi_log_format_32 *src_efi_fmt_32 =
 			(struct xfs_efi_log_format_32 *)buf;
@@ -264,7 +268,7 @@ xfs_rui_copy_format(
 	uint nextents = ((struct xfs_rui_log_format *)buf)->rui_nextents;
 	uint dst_len = xfs_rui_log_format_sizeof(nextents);

-	if (len == dst_len || continued) {
+	if (len == dst_len || (continued && len <= dst_len)) {
 		memcpy((char *)dst_fmt, buf, len);
 		return 0;
 	}
@@ -430,7 +434,7 @@ xfs_cui_copy_format(
 	nextents = cui->cui_nextents;
 	dst_len = xfs_cui_log_format_sizeof(nextents);

-	if (len == dst_len || continued) {
+	if (len == dst_len || (continued && len <= dst_len)) {
 		memcpy(dst_fmt, cui, len);
 		return 0;
 	}
@@ -587,7 +591,7 @@ xfs_bui_copy_format(
 	nextents = bui->bui_nextents;
 	dst_len = xfs_bui_log_format_sizeof(nextents);

-	if (len == dst_len || continued) {
+	if (len == dst_len || (continued && len <= dst_len)) {
 		memcpy(dst_fmt, bui, len);
 		return 0;
 	}
@@ -1086,7 +1090,8 @@ xfs_xmi_copy_format(
 	struct xfs_xmi_log_format *dst_fmt,
 	int			  continued)
 {
-	if (len == sizeof(struct xfs_xmi_log_format) || continued) {
+	if (len == sizeof(struct xfs_xmi_log_format) ||
+	    (continued && len <= sizeof(struct xfs_xmi_log_format))) {
 		memcpy(dst_fmt, xmi, len);
 		return 0;
 	}
--
2.53.0

