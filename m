Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [178.154.239.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E923645D;
	Thu,  8 Jan 2026 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891222; cv=none; b=aStcytSP2tx0N6VS0IU75NZ5TjIqoCsTOsKlnnP3NAiblIQisxRFONxeiTsWS8jVPOvjthokq2z866iLhsKDejxzbQ9ONnX036nVQJfjbSKyuXbXYXjgD3/owdcIPIbASYXsn2ofmoEokeGiAey/klZ63JY9A69pdGUHxBBFYl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891222; c=relaxed/simple;
	bh=xJ2lF05HsUYPJdkNVxlozlmCX91yF3Ts6h/sCU4imY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yo4NA0i11AsxhWxbfrJY0paYZfHUUrnBtyDHjYllpJGHskCw9Wqub0sNvzkU4d3jnCwD5BE74NYk8/WvhdbepksGGeRunMluaffFUTIincL8F4U8kqDxzxDI73jOjJ6k+Eb1cB4NuI9xoRy+ligFKSBrcg6OyyzbMZ8NymDV91Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=TgQrwaqG; arc=none smtp.client-ip=178.154.239.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="TgQrwaqG"
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 4E2F2C0053;
	Thu, 08 Jan 2026 19:53:30 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id RrRCtaIHHKo0-A58lfNYt;
	Thu, 08 Jan 2026 19:53:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767891209; bh=/UtPaKPpavERstCJ1xO82njGs8D3agtNyRW66w5WrIw=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=TgQrwaqGF4El2E1uAOhOKInPmXXTl8Ikq1ITCtxVNFxVQR+LH2+7F4jEbx4rNMGww
	 uhczrE4vNoMMwHYtmSpsW4wuSAd5CLIF3KpBXRWxQnaKnybEXfYyAIW1MWPdB/XfAB
	 Io392DEQMlCfxYD8ItzLbyp2JQ9u153X1VGvgp5o=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for memparse()
Date: Thu,  8 Jan 2026 19:52:15 +0300
Message-ID: <20260108165216.1054625-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
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
index 90ed997d9570..cf81c6363f6c 100644
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
+ *	Unconditionally returns -EINVAL for a presumably negative value.
+ *	Otherwise uses memparse() to parse a string into a number stored
+ *	at @valptr and returns 0 or -EINVAL if an unrecognized character
+ *	was encountered. For a non-zero return value, memory at @valptr
+ *	is left untouched.
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

