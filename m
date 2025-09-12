Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FF621A421
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690887; cv=none; b=I2lOH19VDHZkaY6h4Vmy98JNUa8BkhSqRW4eS1hV1rHSvs1owX7QJbZCA+SZ2uH9O7nnkQBZa6vVM6H8ndNy7E7UOF7SnheOCjN3pAwm3eupAga8qxnnexYt7H9Q29p710N5XVsvXiU0f6ygWbW3wqFd4Iwf8xLERvCpns/s9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690887; c=relaxed/simple;
	bh=GhbGsRZIFWwACCchhCI1wpT+Z6yk4SfcgM3GpwKm+3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+vxwy/saElPR8+KUmHJjaNVGPsbaZiAkMXEBol3EEo5+abc5tXuPyOr+umzkstlrKBWoc/13Cmg/f2N0SYErRrVnH3yqHyGWlOhb52m4a17lw/pa+Doln/6d+p8aSHOsEsMlCZ+51uxLD/51sdtHSLXw7j1vrzOlRSKsF2Thi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U9g06hcM; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U9g06hcM"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-772843b6057so1890290b3a.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 08:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690885; x=1758295685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epfohba7lLb94CzZQeNzguTuJKCwE90c2JR8b9B+3/Q=;
        b=U9g06hcMQS1SmAvit1EorYFhcCwBB3xIfBrHCGEfem88UATljbTNLdYoW6DOsBucMO
         1bClKhf9q2dfK7sQOUI9IKhq8BniuG1QuIh9uOumJw4CbR1C3t5mk7yRHaXmuUlTU+jh
         Lqr0QZ5TnjRAS6XgxE1JDl9CT+4AA3aYTX4fCC++vbq4VBuHdTJBh9NdCSDuAKCDEdYQ
         Yt54WcfDVkb9EkphV7gd8VmL4Xl0JN6IhPzlfT3EUEvfqnULG3svwYdAox6nj8xh1XkY
         ZjOInDctYBZ9JsdwD6daO83prFf3XLsmBG3VtTkvs51x1V1/KI1hkPRFvHo56Jk6qpO3
         WKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690885; x=1758295685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epfohba7lLb94CzZQeNzguTuJKCwE90c2JR8b9B+3/Q=;
        b=if7NSDguCbQlLbxwvm5KYoPkqj+3MXslQDTPI6pc8tXWvX7D019q55FZo1MPwyJrcX
         J5xBYkABZaTfbX1D6MLYSlkEUmjBsqGG9qUqn2Q/OoxjI/fzKdQNJXRz/qKeZ3ZgVOAu
         X7xQRolXIaC58xn75ZVPPS3S8N6Mim22d5EdB88wXpXUfe2fdFSG7s7jECyovaxXg1ei
         N3c+aksa5ryfhlgaMHyaHJIOMD5QIQi0h7JO3gR46Vn+TGYE7rYZQmtsI23UKi9ZtY7q
         tHQVuiTOssALJRSf6MtvYI8nRXD7hg4zbWIuax1JcB8frgwrmeBPsk/dJmaHPJqU5imv
         fPyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ6JYrRrrnuj7RKMyDgy5t4fD0zgQfSbBhYQAKWemXeG8bwSZX24YNXEQ1W5oYFB4EOedKGRz2OK0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3ZdwH8i9n2sNl7FStwOG5zgYQlvmSEZsFj1rB3W/2GwnV+TqL
	qeLSptOZFo42o/ldGCl0Ho1CoxEBNa9rmAx32RMyL3DeCUrq4/0/CuWC
X-Gm-Gg: ASbGncsG7kR1hasnfo4HqmHa3uPggyUIkkIY9yMzLl1Y92pwxRHtq24p2a+Ti+EEXEv
	7JThKfWEngY8yj2ocr8aYNEmlz8f5eJxWP5hJ6Lu0MwdHNplQn1zip4+RlBEw6dSu7QmLMp7nNR
	lkGEYwa8885ToYjO4xc6L1jIpiPicrHZWcuklDWMkZQdf1Sz/EFtbjYT0UXaeEhfCDLuPwld6BP
	gulHKiA+ayKkOe64c/ow7I1j0tRRGUAe2OXl9tGOoQH6t2F9HVHLEnsssrzVpQRvGdUidt4P1Jd
	D4yZxqiACn+UfD4+Ela5W6C1jIzHiJh4ulZHs/qTlhfCNi3Gdjr/qluJI9wIyngFOkHa7rzQLw9
	YO6VMS1e0QlQ61iidSv0amtT1aVO9AbST9gPf
X-Google-Smtp-Source: AGHT+IGNpJNOsvFiulBAn14rvV+gNw6x7YaxgnaL0p3o0QovIgtsHJ2X+893Wi/o+WL5lAWsrHnGBQ==
X-Received: by 2002:a05:6a21:6d85:b0:245:4181:e1fb with SMTP id adf61e73a8af0-2602aa83d47mr4372165637.27.1757690884773;
        Fri, 12 Sep 2025 08:28:04 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:28:04 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 08/10] io_uring: add __io_open_prep() helper
Date: Fri, 12 Sep 2025 09:28:53 -0600
Message-ID: <20250912152855.689917-9-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a helper, __io_open_prep(), which does the part of preparing
for an open that is shared between openat*() and open_by_handle_at().

It excludes reading in the user path or file handle--this will be done
by functions specific to the kind of open().

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 io_uring/openclose.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 884a66e56643..4da2afdb9773 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -58,11 +58,10 @@ static bool io_openat_force_async(struct io_open *open)
 	return open->how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE);
 }
 
-static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+/* Prep for open that is common to both openat*() and open_by_handle_at() */
+static int __io_open_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
-	const char __user *fname;
-	int ret;
 
 	if (unlikely(sqe->buf_index))
 		return -EINVAL;
@@ -74,6 +73,29 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		open->how.flags |= O_LARGEFILE;
 
 	open->dfd = READ_ONCE(sqe->fd);
+
+	open->file_slot = READ_ONCE(sqe->file_index);
+	if (open->file_slot && (open->how.flags & O_CLOEXEC))
+		return -EINVAL;
+
+	open->nofile = rlimit(RLIMIT_NOFILE);
+
+	if (io_openat_force_async(open))
+		req->flags |= REQ_F_FORCE_ASYNC;
+
+	return 0;
+}
+
+static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	const char __user *fname;
+	int ret;
+
+	ret = __io_open_prep(req, sqe);
+	if (ret)
+		return ret;
+
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	open->filename = getname(fname);
 	if (IS_ERR(open->filename)) {
@@ -82,14 +104,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 
-	open->file_slot = READ_ONCE(sqe->file_index);
-	if (open->file_slot && (open->how.flags & O_CLOEXEC))
-		return -EINVAL;
-
-	open->nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
-	if (io_openat_force_async(open))
-		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
-- 
2.51.0

