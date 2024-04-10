Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEAF181B88
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712780067; cv=none; b=pq89R1iSmrqf33MmOStX1SQjZ1H0/Z4EsAWHE4+6JRCSeFFuwm2uZHq3iq3gGRIv9d1BttRg6DcZVJbC5tylRXT5PHboL09hzy6IXUg+WSubs/6K4gT6HxMmCNOlKEVqmTl5gVXddZ8pgY/XYmkyKsu4Fl2ELeUTatcXPnjTgQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712780067; c=relaxed/simple;
	bh=1WH+WjNKIPoW9LpNzdvZ48+fexOkK0Angcb6mkMyhY8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZyAaVTskaCn/oAeeJ62ScmAhOyxuda3n8rruT5awdbsdUuDmj3t/S80dxluvhsQWu1wm44z3krmBwyQveU63887GYPuUkr+j9Lp8+wWFuS4A6Dgk0JjyDCq56xErHa6M4/u//TZyOu44LsmZD0AmlpgAM/YQhDbJK/gvrFZDICc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EDJ5AWgD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EDJ5AWgD"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc4563611cso10640485276.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 13:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712780064; x=1713384864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VObyo2wyvz3H1owllIXU/4cuDgtcb197tJY3OggHujs=;
        b=EDJ5AWgD1aZ/49AHlPUuaiyIcy+IGZUSmEqLffp0/YYukvcK5zZIUcIu0CILOuTe+f
         EmaYP5hfpAQJZruHxx0+A1FzO7KZdAPkiJLAnLwvawbXAg8lSWu8aDu7y2NPnHncCpmT
         RFU6Dq6KSyytx+xwxHgjR2nDsOyGxHZb3hrejPtm7DA/7OY4mwGsmZ7P+EzEry/fZuvH
         PYANxbe45Q3flJR2dw9NH+NvCHUR1mzb8crMqPBKHfzVmNKsbLauKsVxCUBRK+SSAn5r
         54oIO+K27tW+5ONi6/+q7XBeOm9Sv+55Ujq7GO87htTZSR35Q+n8SrkCTwQ7WlUDt5Ah
         0eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712780064; x=1713384864;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VObyo2wyvz3H1owllIXU/4cuDgtcb197tJY3OggHujs=;
        b=iQ5S8hVLHYIzkl4m/hphOxHaBDt4L+8DqM6jGKYqpyQRm01bkHoiWo4nDEuhxMmV31
         hF6HVH3vVIC55YcMjrrD+G671Dv+7d7wM7EvSuK1P9sLS8fIfbjLgtc5eiOfAXnNLdMi
         RrCA+w5jfp4hc786pT7XX0vDesWjDhvyyH1qZGa0YqS0Q98BD0uVt74FllkuId6JIk+o
         slOv5X9mikO8RLg9Mxprvim/sppT9duRK9KvjPy/uM8r+hG+FY9dHvYPVkcSHwk3SjRM
         GTTovP/8mky+yerbo0rVIUOF1hqi27+c755g//DryKrfpvuRotgOY+Ilqh05yDxfXTP7
         /CSg==
X-Gm-Message-State: AOJu0YygLTyJvxPOZLiEWf5pEpoIlR1DrLIaxGXeo3fXUUFTlczZ7mWh
	MxZE7LHy2FxLVMzqtkJinvdpLUvC7x2Onxzm347peyNbpobPriuvWmTlUN9jA1Q7bR6MpxP2y8R
	Q1Bm2cTzl2KtTXfuUOLL4CQ==
X-Google-Smtp-Source: AGHT+IHa45ZNDiclIsv5Sga0Hjq5bIte66tVL8HHIr9d2dNOeh9g96p0pD1RhZHeJDymW9OZnE7gm7oheZV8TTMcyQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:2b12:b0:dda:c57c:b69b with
 SMTP id fi18-20020a0569022b1200b00ddac57cb69bmr1133895ybb.0.1712780064614;
 Wed, 10 Apr 2024 13:14:24 -0700 (PDT)
Date: Wed, 10 Apr 2024 20:14:12 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABPzFmYC/4WNTQ6DIBCFr2Jm3WkGtL+r3qNxQSngJBYMEKIx3
 r3UC3T5vbz3vRWSiWwS3JsVoimcOPgK8tCAHpR3BvldGSTJjjo6YcrR62nBWeUcMU0jZ4mkWmU
 t6bOSBHU6RWN53rXPvvLAKYe47C9F/NI/wiJQ4I3US1xlW4uXhwvBjeaowwf6bdu+YhMt37kAA AA=
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1712780063; l=2553;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=1WH+WjNKIPoW9LpNzdvZ48+fexOkK0Angcb6mkMyhY8=; b=3iIZtw/QRxaTt6QPXeP2E9uQENXAhZX40wZW58IkOJgGmBYfzOVD5l3bUeBuJS5NdjDHhCjWW
 XDjbGw120zZC4Yb/cDVW/a18g6TEjYIZBObC2bY0IzsXrphsOxMl2Cy
X-Mailer: b4 0.12.3
Message-ID: <20240410-strncpy-xattr-split2-v2-1-e6e03ebaeb65@google.com>
Subject: [PATCH v2] xfs: xattr: replace strncpy and check for truncation
From: Justin Stitt <justinstitt@google.com>
To: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy is deprecated and as such we should prefer less ambiguous and
more robust string interfaces [1].

There's a lot of manual memory management to get a prefix and name into
a string. Let's use an easier to understand and more robust interface in
scnprintf() to accomplish the same task while enabling us to check for
possible truncation, resulting in a soft warning.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Changes in v2:
- use "%.*s" format specifier
- use != instead of < to check for truncation (Christoph H.)
- Link to v1: https://lore.kernel.org/r/20240405-strncpy-xattr-split2-v1-1-90ab18232407@google.com
---
Tested with https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
but using scripts + image from: https://github.com/tytso/xfstests-bld

test results: https://pastebin.com/44bjhpCp (no failures)

Split from https://lore.kernel.org/all/20240401-strncpy-fs-xfs-xfs_ioctl-c-v1-1-02b9feb1989b@google.com/
with feedback from Christoph H.
---
 fs/xfs/xfs_xattr.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38a..54e7e7d24ce9 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -206,6 +206,7 @@ __xfs_xattr_put_listent(
 {
 	char *offset;
 	int arraytop;
+	size_t combined_len, actual_len;
 
 	if (context->count < 0 || context->seen_enough)
 		return;
@@ -220,11 +221,16 @@ __xfs_xattr_put_listent(
 		return;
 	}
 	offset = context->buffer + context->count;
-	memcpy(offset, prefix, prefix_len);
-	offset += prefix_len;
-	strncpy(offset, (char *)name, namelen);			/* real name */
-	offset += namelen;
-	*offset = '\0';
+
+	combined_len = prefix_len + namelen;
+
+	/* plus one byte for \0 */
+	actual_len = scnprintf(offset, combined_len + 1, "%.*s%.*s",
+			       prefix_len, prefix, namelen, name);
+
+	if (actual_len != combined_len)
+		xfs_warn(context->dp->i_mount,
+	"cannot completely copy context buffer resulting in truncation");
 
 compute_size:
 	context->count += prefix_len + namelen + 1;

---
base-commit: c85af715cac0a951eea97393378e84bb49384734
change-id: 20240405-strncpy-xattr-split2-0a3aff0c6a20

Best regards,
--
Justin Stitt <justinstitt@google.com>

