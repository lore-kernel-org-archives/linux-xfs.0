Received: from forward202d.mail.yandex.net (forward202d.mail.yandex.net [178.154.239.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2DF313E07;
	Wed,  7 Jan 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767811416; cv=none; b=EIjzRq16jnYgOzqMyS8hVzevIHhyDhcwgmj/9E2WzWt2xtKJFyKkVgyTCTmtkYoAKxod0egXv6PF/KjZC1Nrn+8oVAl8IdeOfAy32dfT+Hp/eoXW0R1syFyAbeWTurb/kMshPpzeLxyBH9vEh3gxC9yRYLdo2FpQG/URzvD/SKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767811416; c=relaxed/simple;
	bh=a90Z8nQ2W052PHISezo3OIlyc6anDAZ5L4dIv147JsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DuhNE1rYARZhr4ixWBICtS9Z/La4nhaLR3CbXlzmn1fiVKZFPlQaw97kiLkxETGrUO1Itb5pkfGD9FD7T7BGc906OYyOz6lkdE/YqeJdIS0DUODmcgbnDKVDatwKYAJarHfISBC2btjmLJcIZet3/6Sl9NZLUCSH9S3hnfo/Mkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=qRHJX/Go; arc=none smtp.client-ip=178.154.239.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="qRHJX/Go"
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d100])
	by forward202d.mail.yandex.net (Yandex) with ESMTPS id C3D5486E01;
	Wed, 07 Jan 2026 21:36:38 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2dcb:0:640:715b:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id 26157C0051;
	Wed, 07 Jan 2026 21:36:30 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id SaSuiV7Gl8c0-3UejPh7x;
	Wed, 07 Jan 2026 21:36:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767810989; bh=CNwylmWZiMvqp9zMGa86ZSqv3JoZzXkcWAYbmEN7tbs=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=qRHJX/GoFBFqqLdNW9P7i9hUsNhXHX+18Z7k2/s9wl1yNxb6yZau7KE+jB29AFWOH
	 +9z/rt7Z2AbP1KoUy077xr/QCLu7mDBirkgIEvL/+4+jOy6fRXMwzLL+Lrw2kTI9+S
	 ooYTEHYqL1rFbQQ6urFid7SHmrzOAlhqPGiORm+E=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] lib: introduce simple error-checking wrapper for memparse()
Date: Wed,  7 Jan 2026 21:36:13 +0300
Message-ID: <20260107183614.782245-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce 'memvalue()' which uses 'memparse()' to parse a string with
optional memory suffix into a number and returns this number or ULLONG_MAX
if the number is negative or an unrecognized character was encountered.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 include/linux/string.h |  1 +
 lib/cmdline.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 1b564c36d721..c63bcff820a1 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -319,6 +319,7 @@ DEFINE_FREE(argv_free, char **, if (!IS_ERR_OR_NULL(_T)) argv_free(_T))
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern unsigned long long memvalue(const char *ptr);
 extern bool parse_option_str(const char *str, const char *option);
 extern char *next_arg(char *args, char **param, char **val);
 
diff --git a/lib/cmdline.c b/lib/cmdline.c
index 90ed997d9570..e2455a6d17ff 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -190,6 +190,27 @@ unsigned long long memparse(const char *ptr, char **retptr)
 }
 EXPORT_SYMBOL(memparse);
 
+/**
+ *	memvalue -  Wrap memparse() with simple error detection
+ *	@ptr: Where parse begins
+ *
+ *	Unconditionally returns ULLONG_MAX for a presumably negative value.
+ *	Otherwise uses memparse() to parse a string into a number and returns
+ *	this number or ULLONG_MAX if an unrecognized character was encountered.
+ */
+
+unsigned long long memvalue(const char *ptr)
+{
+	unsigned long long ret;
+	char *end;
+
+	if (*ptr == '-')
+		return ULLONG_MAX;
+	ret = memparse(ptr, &end);
+	return *end ? ULLONG_MAX : ret;
+}
+EXPORT_SYMBOL(memvalue);
+
 /**
  *	parse_option_str - Parse a string and check an option is set or not
  *	@str: String to be parsed
-- 
2.52.0

