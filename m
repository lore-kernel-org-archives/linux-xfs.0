Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D9CD28D
	for <linux-xfs@vger.kernel.org>; Mon,  1 Apr 2024 23:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712012500; cv=none; b=U5exMo4q+d6QDx+sbxvxS7S0VyS1i7xHntvaAnItDm9LSpaAkg5Q4MP0AiTC5SfH+Drg8JMu1F/L+BWKKqSqWw7Vz+0OryYyeSQM9pDx9bx5JW9PUSw1j4Dk/b/HC2AVZyJ2Ux/YsAASicqVdIvS8VOQEl7T9HxqnFpOYx8tJ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712012500; c=relaxed/simple;
	bh=Sw17VZ2rI5t1U7w6lSBn7Tgm6w53GtT34jTTgkY57jY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GvUgH4zdJE6vbF2Hl8se61cmDUesIzishEuwDcd/5pkcXQgYiD+LoSNoGYU3DNpfmfkUhjjabOGNLIv3jYBMit1n1zokdb99QWBZu1Eeq1L4M3RJWo/8Bf+FGej02RPNNh5+E212ZBUVGptUC5OGNy2uB8JpDiOSwSeN/C2P+M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZ59IzDo; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZ59IzDo"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7cc012893acso489410739f.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2024 16:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712012498; x=1712617298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4UCTUqrCfJ+dpmdPP9hi+yGQv3LbBnFi/puoG4yXu+A=;
        b=UZ59IzDo+aVZhpLdXkaFdWKK6akcV6wBQsTeuS7s1T6vOJpeIFm24kKSMEUt/XNqFV
         LckB/5FOUU1VrAROUZ3Ec4Rc7Dwt/IoiX552eMZhXr/hlf8RytRoc5qAm7fePh60MwhK
         i+nHMTtFtyZjWQO9tM95SS0E3mYrw2Sha2RFNwSJmmNQ6QytgMZs7E5GR8opaMAOQmEg
         Hl+4K+aagSid0gPJawo3GvntPWHBnigdJfIK+aRivaF/d96c3ayhMha/yBiPjx63n0zj
         Y4SXbyPYTt2ZogvOde3r5SUYbWdHWVb6JgPxikeFv4FuywDzzlhLRuyRJ6JBKhJPbY2+
         mJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712012498; x=1712617298;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4UCTUqrCfJ+dpmdPP9hi+yGQv3LbBnFi/puoG4yXu+A=;
        b=awg/UmIU6FIqPNq07mGNVcvzNBvOgzmLh40iBxDk8wmXXXthxDOhUWWQ5nPSkpjNI5
         sp20wHYcDUiR73YJRq6R0GwFn8Y7M/QtCPaXQ7JD8zX5QCXbU+CLj4Rs5TkJ4VnGRdOn
         eMNXk00HOn7K0EO7j5DfTvrxqBmx5V+iQxhl9bNKsXCxi9TPusUQvgDI72Nc/O4X+lnW
         nYSX4C25uGV97MvB1E2G5jCKcXexpVtwveWLixE14Ge1ejUHT3iwt0/kpzteMnGw3OvK
         XIKqAhPuBqOa/LE1c3RL+dGferCuDegi3el9Bf+8vWLmG8OwX7zx2+GM1lyWg6hlHwKW
         wVUg==
X-Gm-Message-State: AOJu0Yz8iLXZZBuS2BaRO1CbqqltDH0akg2ADYVT5wFWvmgiRxtq5Zvw
	iWO4fsFDr6HisxzsmRE8pPFs+eKQkHySFzWZBcjWw8x9ezBfUP6VC4jIDtkrgiZjdID1RiU2IBP
	rJujSw0naJXI9n5hj4HMEtA==
X-Google-Smtp-Source: AGHT+IFxVfAigFgMJYj0MK1XEtlxuguR9QWg4M5wW3cmX+ehlPJHICAdqbQsd1MUKQyprqYyiz7tRJ0CYxKiBQl4pg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6602:6b84:b0:7cc:39c:143d with
 SMTP id ii4-20020a0566026b8400b007cc039c143dmr390494iob.0.1712012498421; Mon,
 01 Apr 2024 16:01:38 -0700 (PDT)
Date: Mon, 01 Apr 2024 23:01:38 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIANE8C2YC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDEwND3eKSorzkgkrdtGLdCgiOz8xPLsnRTda1SEwzT7SwNE1KSzNQAhp QUJSallkBNjw6trYWANLq9zZsAAAA
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1712012497; l=2623;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=Sw17VZ2rI5t1U7w6lSBn7Tgm6w53GtT34jTTgkY57jY=; b=Je+3bNOSl7VFFOi8HXFh39huAOtiEkqd6rPxUqiwOM0mvuBTBLcnq2KhywdxKIOo4cLT9pfWn
 V/SkR0/wmEZCC2e2cJMcsHJHf83GS2EdKd0Xp+fXHoZtq8eOB+5DclX
X-Mailer: b4 0.12.3
Message-ID: <20240401-strncpy-fs-xfs-xfs_ioctl-c-v1-1-02b9feb1989b@google.com>
Subject: [PATCH] xfs: cleanup deprecated uses of strncpy
From: Justin Stitt <justinstitt@google.com>
To: Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

In xfs_ioctl.c:
The current code has taken care NUL-termination by memset()'ing @label.
This is followed by a strncpy() to perform the string copy.

Use strscpy_pad() to get both 1) NUL-termination and 2) NUL-padding
which may be needed as this is copied out to userspace.

Note that this patch uses the new 2-argument version of strscpy_pad
introduced in Commit e6584c3964f2f ("string: Allow 2-argument
strscpy()").

In xfs_xattr.c:
There's a lot of manual memory management to get a prefix and name into
a string. Let's use an easier to understand and more robust interface in
scnprintf() to accomplish the same task.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Note: build-tested only.

Found with: $ rg "strncpy\("
---
 fs/xfs/xfs_ioctl.c | 4 +---
 fs/xfs/xfs_xattr.c | 6 +-----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d0e2cec6210d..abef9707a433 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1755,10 +1755,8 @@ xfs_ioc_getlabel(
 	/* Paranoia */
 	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
 
-	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
-	memset(label, 0, sizeof(label));
 	spin_lock(&mp->m_sb_lock);
-	strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
+	strscpy_pad(label, sbp->sb_fname);
 	spin_unlock(&mp->m_sb_lock);
 
 	if (copy_to_user(user_label, label, sizeof(label)))
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38a..b9256988830f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -220,11 +220,7 @@ __xfs_xattr_put_listent(
 		return;
 	}
 	offset = context->buffer + context->count;
-	memcpy(offset, prefix, prefix_len);
-	offset += prefix_len;
-	strncpy(offset, (char *)name, namelen);			/* real name */
-	offset += namelen;
-	*offset = '\0';
+	scnprintf(offset, prefix_len + namelen + 1, "%s%s", prefix, name);
 
 compute_size:
 	context->count += prefix_len + namelen + 1;

---
base-commit: 928a87efa42302a23bb9554be081a28058495f22
change-id: 20240401-strncpy-fs-xfs-xfs_ioctl-c-8af7a895bff0

Best regards,
--
Justin Stitt <justinstitt@google.com>

