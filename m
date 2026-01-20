Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4A0186A;
	Tue, 20 Jan 2026 00:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768867584; cv=none; b=A3gG6mmyNqLC0W1V9mUPTlEdbeUilXNBDRWgszlx+asXVfTTsjfe6A//S4AluZ3UXcSzBejtUxJMUpDpapNbnOsnBPEf/gerdILvVnc6WouDSATsHSdI1V23OZbSP27JJroorzQjTa/gAwMDzSdrwcrkGhtsQcq3EW3LLz+yu/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768867584; c=relaxed/simple;
	bh=7AxLG/YcdyqdxCEQU/Ua94p7Q62MoMu2WC+pp2D4TAk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=E+0bHgwb28oOFLjr9W2Xo9blpn5m40w+Q0ogGnYIUiTzHTFq6CIzRK2kd2suATIRXKd8o8ZTmTeY1BVzvATzQrUzGqxNsNmoKyL2tHAsMnbzld1fKDb1PKd+UPGmVp7akebOBtuwZl+BlI60hZxw5PO501ET9yLIBXKOlCzTPYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AaUoBQBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AaUoBQBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D79C116C6;
	Tue, 20 Jan 2026 00:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768867584;
	bh=7AxLG/YcdyqdxCEQU/Ua94p7Q62MoMu2WC+pp2D4TAk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AaUoBQBok5xNSr4kp1UROFO/AqzijrkCcF8HaBgGpue5tQxmMSS0Klml6s1b9mdG3
	 SSCEOzmTT+B+z0ad5I7vm0OgkQJaWrmgERqJI6pYa+d1ImSMhJPSJ5CJOW3q9q3D7h
	 5pN9KZqmUue/YRjA/N4SuxiJ5ptMWc2Bo+kK84JY=
Date: Mon, 19 Jan 2026 16:06:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
 linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-Id: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
In-Reply-To: <20260108165216.1054625-1-dmantipov@yandex.ru>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  8 Jan 2026 19:52:15 +0300 Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Introduce 'memvalue()' which uses 'memparse()' to parse a string
> with optional memory suffix into a non-negative number. If parsing
> has succeeded, returns 0 and stores the result at the location
> specified by the second argument. Otherwise returns -EINVAL and
> leaves the location untouched.

Where do we stand with this patchset now?  I saw a lot of discussion but
not a lot of clarity.  Thanks.

Unrelated:

> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -319,6 +319,7 @@ DEFINE_FREE(argv_free, char **, if (!IS_ERR_OR_NULL(_T)) argv_free(_T))
>  extern int get_option(char **str, int *pint);
>  extern char *get_options(const char *str, int nints, int *ints);
>  extern unsigned long long memparse(const char *ptr, char **retptr);
> +extern int __must_check memvalue(const char *ptr, unsigned long long *valptr);

Sensible.

>  EXPORT_SYMBOL(memparse);
> +EXPORT_SYMBOL(memvalue);

memparse is used in many places.  Seems inappropriate that these things
are implemented in lib/cmdline.c?
