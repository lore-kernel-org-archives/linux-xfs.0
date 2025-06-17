Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F39F28D85F;
	Tue, 17 Jun 2025 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750166101; cv=none; b=TlCOHeTLPrMx+h5dVvOEpxvymIAFal8XS1uI3+4AXotqvfcbEQ+kvGK8+xoiVXFua3xhoF5sOVhuzgc5t1epAYTnNszG1JYC9paJNiRxoqLuP4DKrgwqbmuQ7OAOCsjnd1WHRz+8NpDm/8beStFTSjKRj7esKxZC+zl8mRYjfhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750166101; c=relaxed/simple;
	bh=p7DOfF+FVsKwThiS6DtW1TTjKjyRC+p9KTOjsE2PN9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WMRmr3I6xtJt0czo69+ZXSiwyHAgaDlEfVl2nCbFI4hVVhHTiONNCaiKkHOxcXg2zS7cEbmk7bboCxOEc2EMiQgQhn6QtROukIaOCwhaA4XAxWoKGWDPh20M46030shFsccYEio4yXMXnxhCw5SMmE7l+v5Hxh5xF8SXbytgEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKALhbX6; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKALhbX6"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-748d982e97cso373271b3a.1;
        Tue, 17 Jun 2025 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750166099; x=1750770899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qdj6PEXQSBqXoHF+okOiKXmDKN7rBK1h3xMiJzkSQlg=;
        b=JKALhbX6WfgsFdT6K2e1I4RWaepzUEQkkDnu/i0oonawi7u+FvqDDJndYe107Si6h9
         wNHG3QmVnTRYv8Lvo0bQBCtvMy6Nn6ZgEKB019qBdKPJ+Ctgs58kAcVuEcXqvy3meTIh
         XM48bZ/flYy0OkR67w6go9944Mv7Z4x9m2IM/Q5fjSGQU+Xna7Zf86Wl8+13cWNZjGFm
         dGetDGedjS1x4ZSIr5IjRK66emInZ8+7FNzO/iLdz0LOhe/KQUdljm6XjtNBRquc3Cq4
         PH4ng0+Qa39EPHalw36n9qltFruwDRQnAupgYTVb7Td2YLKKo9yVB95yM81K/uGLFSqR
         0UXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750166099; x=1750770899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qdj6PEXQSBqXoHF+okOiKXmDKN7rBK1h3xMiJzkSQlg=;
        b=RXhnvwboYlv3uWcXl2F+OcURzHbLXaGdnOV18vZaDmntJLfGs7729P93jm28QC++TB
         ktFH/lt7Nk1c6vJkMaTXnDx4jVX2VhDAQELQCAPVG4Q0kEepZXZLZsNmwENUXM2O9Jf5
         FufNFtEx6UCxxNmqKrzPchW5CaQ7lopWubaAuPYsZFu16zYUGOTNY3p3sYWOhNk+eDvC
         csD6eMkyG4ZH+4eOLcfLXlho1rgeY6YgVJVAZ0DKp9QQe5dw9v3fp2phQRx+r6qnQnI+
         rBdgwL51/AKtKxAbADgaJ5BVwjlrbK3iw0sTBQNNEaLBAcbs+pLrjssceDf2kLkLpxE9
         kkHw==
X-Forwarded-Encrypted: i=1; AJvYcCWGi2U4GXggaw1/sQtR51jc6atAsc7Ldmw0qD2ruBJHYw0T9Q2m71Om6tZfnCisa/PwdMQVluvFzwrBzNk=@vger.kernel.org, AJvYcCXvRgKrghYL9AQXu3nmL1sFIijdXjQDQ23BWfAjuFv46q8iT8n3/tMRpm9Q/X23WS3TIuBLzQ12ui6Q@vger.kernel.org
X-Gm-Message-State: AOJu0YwQgSYE5wzfec7bWtgkGg6uyeNClcQKFl4Xcnt7qBu3Drqw+KuV
	ZJgMf1Mf/9nyXmxWk5jWuoMH8Ghv3p6QOmBG7oUFu3NzyC+mOHdhFH5ndof8n6TJ
X-Gm-Gg: ASbGncvRq3LTiqurBOAz4VfsNTpLafwoFkC+1+DBI69ph6j5n5hD6r/p+ucADks3BL3
	JL/IbYm0LvkFhuYPFWUrcEU3MFd279iPWIQHy3x3J4bXrEUNqzK5zJA/h0ws0GjM2netrb/pqq+
	4HaCsof901SKHaH8hwd+J49WpUxO5FoP+fIwnvsA2aXsbn3G2OUnYahhi4ZTkwiUS3ta3LcYbve
	omxbb6lsB1aWxJwbSn3ewaTm+wHkDw6SxZrbEpdWjQgkev98RoAEyPyMMfvQlA95BwFgWIM08oe
	6PMfr2WV4XGPhMKeJQdi2VAd5JqTQY8FFFkGnGBAn+GQdl5AqYsU/+aB4gY4gC4nJ14o758Y21q
	UxJMyl6s=
X-Google-Smtp-Source: AGHT+IEj47XzIhTDcSayzRQ0CFz7ib3XQdJW80v1f1Wk6QFx4GpfqPmgDq8HhOc7YT3tqSGvz5AKdw==
X-Received: by 2002:a05:6a00:13a9:b0:740:9c57:3907 with SMTP id d2e1a72fcca58-7489d175260mr18366198b3a.19.1750166099185;
        Tue, 17 Jun 2025 06:14:59 -0700 (PDT)
Received: from manjaro.domain.name ([2401:4900:1c68:884c:5800:7324:c411:408d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900cec7dsm8775059b3a.153.2025.06.17.06.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 06:14:58 -0700 (PDT)
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
To: cem@kernel.org
Cc: skhan@linuxfoundation.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Pranav Tyagi <pranav.tyagi03@gmail.com>
Subject: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Date: Tue, 17 Jun 2025 18:44:46 +0530
Message-ID: <20250617131446.25551-1-pranav.tyagi03@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
The length is known and a null byte is added manually.

No functional change intended.

Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
---
 fs/xfs/xfs_xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0f641a9091ec..ac5cecec9aa1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
 	offset = context->buffer + context->count;
 	memcpy(offset, prefix, prefix_len);
 	offset += prefix_len;
-	strncpy(offset, (char *)name, namelen);			/* real name */
+	memcpy(offset, (char *)name, namelen);			/* real name */
 	offset += namelen;
 	*offset = '\0';
 
-- 
2.49.0

