Received: from forward206a.mail.yandex.net (forward206a.mail.yandex.net [178.154.239.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C21438FFE;
	Tue, 20 Jan 2026 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918892; cv=none; b=YmC3nWtbVXlNbtrLaEOOEhK2LgojGAnVgD366JjyciYSqSMzI7Wgz1HOIjywTwZFglc9/HmJi4PLW8fEV9aeUycf7egZeerCd/1YfA7i4VD86BJ/xmyPPJYzk1VYzNiYp3ueHbKb8/0l6NtjHfNO4BvhsuKx+OtpGj282HRQv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918892; c=relaxed/simple;
	bh=OljuYT46PDcKG606jpSgRx5a7qO0e5RSI226ZhlQbuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+dXzFV7f7+3/wBKoe2I62eWqoUlIBrv9yrsIOaOGMK3FOR/2QAQJ0ZFeH5HIl0ubJdyy+0/GL0qrZcLETB+98Bv9iDoL+bass4GdsNc+Ru1kQ2LhR04GqXil3F/Ms517zOnEsU0QOmeqhij97l5rZc76esh5Z4Lcc9GOUGIgbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=csG3+x2z; arc=none smtp.client-ip=178.154.239.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="csG3+x2z"
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward206a.mail.yandex.net (Yandex) with ESMTPS id C09BB86137;
	Tue, 20 Jan 2026 17:16:00 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2804:0:640:a3ea:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id 5220C80ACD;
	Tue, 20 Jan 2026 17:15:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-97.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id nFbKhtwHIOs0-77xn6yF1;
	Tue, 20 Jan 2026 17:15:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1768918551; bh=8Pf3ro56B2f2l6pIzVRaeha34TphGLgSxqupNiXLAkQ=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=csG3+x2z62Qd+/jQe5m99272gSK0n1bpWsjsll/sCceknk8B8xGBa/dcHfEYkUnwj
	 HeyuoyjL0SI+F7n5kCYuX6LP1wBPBmzDGzkoOdPm6aIku/EN5etBRdsbEGxq4+uPRE
	 z+8PjnDb6+NdfHviCukSZbqglB9GYEy/AAcxHh1I=
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
Subject: [PATCH v4 2/3] lib: fix a few comments to match kernel-doc -Wreturn style
Date: Tue, 20 Jan 2026 17:12:28 +0300
Message-ID: <20260120141229.356513-2-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120141229.356513-1-dmantipov@yandex.ru>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments
to match the commonly used style as suggested by kernel-doc -Wreturn.

Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v4: initial version to join the series
---
 lib/cmdline.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index 28048d05eb35..6922ddd90e7c 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -43,7 +43,7 @@ static int get_range(char **str, int *pint, int n)
  *	When @pint is NULL the function can be used as a validator of
  *	the current option in the string.
  *
- *	Return values:
+ *	Return:
  *	0 - no int in string
  *	1 - int found, no subsequent comma
  *	2 - int found including a subsequent comma
@@ -145,6 +145,9 @@ EXPORT_SYMBOL(get_options);
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with K, M, G, T, P, E.
+ *
+ *	Return: The value as recognized by simple_strtoull() multiplied
+ *	by the value as specified by suffix, if any.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -224,7 +227,7 @@ EXPORT_SYMBOL(memvalue);
  *	This function parses a string containing a comma-separated list of
  *	strings like a=b,c.
  *
- *	Return true if there's such option in the string, or return false.
+ *	Return: True if there's such option in the string or false otherwise.
  */
 bool parse_option_str(const char *str, const char *option)
 {
-- 
2.52.0

