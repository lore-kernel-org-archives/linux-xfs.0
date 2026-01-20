Received: from forward205a.mail.yandex.net (forward205a.mail.yandex.net [178.154.239.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5D33F23DA;
	Tue, 20 Jan 2026 14:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919041; cv=none; b=UoROviz1AJyCzqI085udRYxGQ+7jOEixDFEiREaBRUt2MYDaAuVrRHQIr9Nfx+fu70kFaW2MEVWvyi+GfcbMCthAUkaccp/7/0QcwTJugzc91T+jf1HV0Xx2S/IjyF6S32OIwdpGxLg9IcZTXe6y7tB7315x2fiC5T+4aGG+8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919041; c=relaxed/simple;
	bh=WzpMbZgQu3K4W6EDET40JNbZc+YN/FIy8TZFEuIAjBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7kIWHBXkeq25Bch9avh0/y5uXxuVCgCvzInEWZcrb4dOAww6+5HvR2bubjlpUTpSV5U32fJ9Xh/9D7SIPiVf4aGHII8ueFO8WQo1LixzMzyQqfy9g9Cwb7qFqAcIYrTu/46XTRWGgT9FnWYR6dU70JNmTPLNg8MPE5MEV0JGdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=MEYNHT3C; arc=none smtp.client-ip=178.154.239.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="MEYNHT3C"
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
	by forward205a.mail.yandex.net (Yandex) with ESMTPS id D1D56C5308;
	Tue, 20 Jan 2026 17:16:00 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2804:0:640:a3ea:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 7ADF580E10;
	Tue, 20 Jan 2026 17:15:51 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id nFbKhtwHIOs0-caNFhe1s;
	Tue, 20 Jan 2026 17:15:50 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1768918551; bh=gvCcVnb5ucvM3yIsuEjtt+WPA1Hw2EKrLVQRUjzdFsQ=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=MEYNHT3CiukRbKZY9+ySiswQ5e7dmOHv/LUJiCJPvhuy8jb4u7aipDJymfch4GiSn
	 IcJd44hYojgzJMQJkO1B2mrd20wAUmhS3eYGu7UP+aa0uSeQWH+aRjm4PP8Y0kH9bQ
	 ieJP+Bi1FpOcwJ27RBGjyJGF3LcgzGnwafWxN+C8=
Authentication-Results: mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v4 1/3] lib: introduce simple error-checking wrapper for memparse()
Date: Tue, 20 Jan 2026 17:12:27 +0300
Message-ID: <20260120141229.356513-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce 'memvalue()' which uses 'memparse()' to parse a string
with optional memory suffix into a non-negative number. If parsing
has succeeded, returns 0 and stores the result at the location
specified by the second argument. Otherwise returns -EINVAL and
leaves the location untouched.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Kees Cook <kees@kernel.org>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v4: adjust documentation to match kernel-doc -Wreturn's style
v3: adjust as suggested by Kees and bump version to match the series
---
 include/linux/string.h |  1 +
 lib/cmdline.c          | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 1b564c36d721..470c7051c58b 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -319,6 +319,7 @@ DEFINE_FREE(argv_free, char **, if (!IS_ERR_OR_NULL(_T)) argv_free(_T))
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern int __must_check memvalue(const char *ptr, unsigned long long *valptr);
 extern bool parse_option_str(const char *str, const char *option);
 extern char *next_arg(char *args, char **param, char **val);
 
diff --git a/lib/cmdline.c b/lib/cmdline.c
index 90ed997d9570..28048d05eb35 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -190,6 +190,32 @@ unsigned long long memparse(const char *ptr, char **retptr)
 }
 EXPORT_SYMBOL(memparse);
 
+/**
+ *	memvalue -  Wrap memparse() with simple error detection
+ *	@ptr: Where parse begins
+ *	@valptr: Where to store result
+ *
+ *	Uses memparse() to parse a string into a number stored at
+ *	@valptr, leaving memory at @valptr untouched in case of error.
+ *
+ *	Return: -EINVAL for a presumably negative value or if an
+ *	unrecognized character was encountered, and 0 otherwise.
+ */
+int __must_check memvalue(const char *ptr, unsigned long long *valptr)
+{
+	unsigned long long ret;
+	char *end;
+
+	if (*ptr == '-')
+		return -EINVAL;
+	ret = memparse(ptr, &end);
+	if (*end)
+		return -EINVAL;
+	*valptr = ret;
+	return 0;
+}
+EXPORT_SYMBOL(memvalue);
+
 /**
  *	parse_option_str - Parse a string and check an option is set or not
  *	@str: String to be parsed
-- 
2.52.0

