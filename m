Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D4147F76B;
	Tue,  1 Sep 2026 12:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265020; cv=none; b=dDk72a6Y7uFDUU9n3MmfOM1OGsPViE9A9zP8APXpeHavnzGUip1XYmE0BVw+eI94aUTZJ28ugyh97aPs6vSjQV+tyMfa0PDOkWFX6/FRs3U7Bp+UIQ+ZApJwJOKYeYgWlzWK3ovpbU9ptoukRT7sFX9WTKA5R8ZRM+XUaq2ImzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265020; c=relaxed/simple;
	bh=F/j2NqH+w7TNV8U4wBjPBjnprw3X0ltqzP2LkSeZfIQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fZdW2N26sQEJ1X8CHqNe72h6FubetyyWmjqf2nOwpOMo1kOYiJzGabMz9KdyFT+v8eZwSuv3D4UJeRF0pp/35KOhNY2E5wQwEgo/cWM8+PDT1VkbKMsdR/vlG3qPPk0TDcmwDAMhIJ/W9MrLUWVHg9dNj4GMLpLbRqxrWCdAXKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+9iSSna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+9iSSna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7B91F00A3E;
	Tue,  1 Sep 2026 12:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788265019;
	bh=BcC4YMfM11/fGljBqSTApr2iuzA2VgR75nVP6J1Ns+U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O+9iSSnaLb98YWV2BOQGyoaOGowmVxpgGMBak8Z6FXI8QAR7yfBQ5hTcd+G6LrlP/
	 2N3uSTb1RL6fK7rW1NtU3wJK5l6FTSj9oBbVOwMx7aXnUUQPjLMMe08l/XbxFMd1VD
	 f3rwyXmzRQJ3l7F3WqTv5BlGcht151R7uj3RafMzmCarjjYPXasUe7GjmJhAkOfT0m
	 MEv390o/4NJj05ivjF2QtHeqWE3XtLSIjeg3bWH8iqN9jr1gVQwnDGIt+K0MnnLYeZ
	 Iz2uszihWkWFAaYqCp7I9mCCcvSp1xY4YZXkgTwQ6g35QIUgSG5GW9CSDbzMeWn5Fw
	 ybQULS0u+cKZA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 01 Sep 2026 14:14:52 +0200
Subject: [PATCH 27/27] fs: make nop_mnt_idmap and invalid_mnt_idmap const
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-work-idmap-const-v1-27-54ccd48e100b@kernel.org>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1731; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F/j2NqH+w7TNV8U4wBjPBjnprw3X0ltqzP2LkSeZfIQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7juuASHSvjdD2vZN/1wK1Q8PP2K8SIPF4Nds+KrQ
 tZn6yupdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkwDGGP1yn3TyV2B+5WR/7
 OGsWf21se1dQxD6NlxOZboaqhcUFA1Xwv3b+1lLjefzIN8fv0XP3d2wuslt8guU/o9nzRLPE4j2
 MAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Make both static maps const so they end up in rodata. Any attempt to
modify them now faults instead of silently corrupting the initial
idmapping.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/mnt_idmapping.c            | 4 ++--
 include/linux/mnt_idmapping.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/mnt_idmapping.c b/fs/mnt_idmapping.c
index 26704eeb7318..bed57094cef0 100644
--- a/fs/mnt_idmapping.c
+++ b/fs/mnt_idmapping.c
@@ -28,7 +28,7 @@ struct mnt_idmap {
  * mapping. This means that {g,u}id 0 is mapped to {g,u}id 0, {g,u}id 1 is
  * mapped to {g,u}id 1, [...], {g,u}id 1000 to {g,u}id 1000, [...].
  */
-struct mnt_idmap nop_mnt_idmap = {
+const struct mnt_idmap nop_mnt_idmap = {
 	.count	= REFCOUNT_INIT(1),
 };
 EXPORT_SYMBOL_GPL(nop_mnt_idmap);
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(nop_mnt_idmap);
  * Carries the invalid idmapping of a full 0-4294967295 {g,u}id range.
  * This means that all {g,u}ids are mapped to INVALID_VFS{G,U}ID.
  */
-struct mnt_idmap invalid_mnt_idmap = {
+const struct mnt_idmap invalid_mnt_idmap = {
 	.count	= REFCOUNT_INIT(1),
 };
 EXPORT_SYMBOL_GPL(invalid_mnt_idmap);
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
index b445c7660040..78eeef4c2996 100644
--- a/include/linux/mnt_idmapping.h
+++ b/include/linux/mnt_idmapping.h
@@ -8,8 +8,8 @@
 struct mnt_idmap;
 struct user_namespace;
 
-extern struct mnt_idmap nop_mnt_idmap;
-extern struct mnt_idmap invalid_mnt_idmap;
+extern const struct mnt_idmap nop_mnt_idmap;
+extern const struct mnt_idmap invalid_mnt_idmap;
 extern struct user_namespace init_user_ns;
 
 typedef struct {

-- 
2.53.0

