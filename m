Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD93377AB9;
	Thu, 17 Sep 2026 09:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636207; cv=none; b=a8xDfzzojgjS7K25W7Ep7hYjHKlDm5gFdgeMhnrBMbcipS0kHkEiB9HCAK3e9YVNBOGY5qR2ojIEIbE1CG0mhZRueJzREv4BNNOjae+16UJdq3anEQ/7WWhhYhECU4AcvXvPHkH4UvuyMBEFoaFqsxhaXIcvmQvSTrIupmH6UdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636207; c=relaxed/simple;
	bh=gePQjgNJP3rZLgjxZMbNcyCVB0rhSfWKtw7rWIMHsCU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HoVV4ABPkNQIVIjDUbECBSJlB+YCy4ltEKaJaxN8a/SH1XIFBa2votgLRjUF4hc8VmU93F0LrSS8zLxu66QesX/LTQaoSFOtBCMIo/0OpYb8tKaETZzYDoxji4xcnQqIDiwjQeSu4NgXUC3ciURgbzveH6odWPj3Ydf847Igcy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gB/wFH2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gB/wFH2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D271F00893;
	Thu, 17 Sep 2026 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636205;
	bh=6dWahTpadJ8SVAXJFFy0YTTM47N8xZaWr7TRB490RZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gB/wFH2CZNIyTyzKz6rMZb09+PgNTjUmU9H+6Eu6QBXgv+KymxIPpgYbmkzflAQrU
	 333+7mJ3A2kMGLT23ZySfOlzw7hqX2G8T9dO6f/Qu32WgqkH066+pbE6q3csCBOJhn
	 hVwJvSqenhZsWVto4JK5LUDNWiDFgSRr4SPiFoiBdYSNOulqmHCvK17qzpVrUB9knh
	 DwxjmfSuTDS9Rvyi1IKr+fRBTuThlHhHi2c3yTEEnl8wU779+BxDljLnOBC063luH/
	 Qeu0whojY0FqyPpX+sBJ7x4WXtUCJ8RhJj4+xD+LK3aPYwpIvuZYf2EKHwPsuXaN/1
	 6baEMzbhlX7jA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:09:44 +0200
Subject: [PATCH 3/4] cleanup: remove CLASS_INIT()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-file-fd_prepare-v1-3-b87534ca49f3@kernel.org>
References: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
In-Reply-To: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1527; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gePQjgNJP3rZLgjxZMbNcyCVB0rhSfWKtw7rWIMHsCU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhcptiHRLFxir8hFQ7cX4T8XKIlF/9FhyhR+65ynl
 qu6Wcqno5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJzVzD8lWq5Gco9c839ZU7p
 jdrmawS83i4NPfWqOvxHVrbIx6usagz/LFur6m/9XDa34GfizllL3I9kJfeIcS3yyg6IPH70c+Z
 CfgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

CLASS_INIT() was added for FD_PREPARE() in commit 011703a9acd7 ("file:
add FD_{ADD,PREPARE}()") and never got another user. FD_PREPARE() now
declares its variable with __cleanup() directly. Remove CLASS_INIT().

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/cleanup.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index b1b5698cbf1b..1fb8058b897d 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -261,10 +261,6 @@ const volatile void * __must_check_fn(const volatile void *val)
  * CLASS(name, var)(args...):
  *	declare the variable @var as an instance of the named class
  *
- * CLASS_INIT(name, var, init_expr):
- *	declare the variable @var as an instance of the named class with
- *	custom initialization expression.
- *
  * Ex.
  *
  * DEFINE_CLASS(fdget, struct fd, fdput(_T), fdget(fd), int fd)
@@ -302,9 +298,6 @@ static __always_inline class_##_name##_t class_##_name##ext##_constructor(_init_
 	class_##_name##_t var __cleanup(class_##_name##_destructor) =	\
 		class_##_name##_constructor
 
-#define CLASS_INIT(_name, _var, _init_expr)                             \
-        class_##_name##_t _var __cleanup(class_##_name##_destructor) = (_init_expr)
-
 #define __scoped_class(_name, var, _label, args...)        \
 	for (CLASS(_name, var)(args); ; ({ goto _label; })) \
 		if (0) {                                   \

-- 
2.53.0

