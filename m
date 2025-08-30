Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBCB20B1F5
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 18:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756577421; cv=none; b=GAYP9fHLgwwPZ+zVeIPSLFvUJQPoAmO7XPobAxBPnZyEAVxsTD9RLbvswh3DZbvFdZ0Usa3fcDeAgHAfs5jjiXN7Xr1BCdhK73FojxVocvrRxhKc+EqCPbpVJF1qdW9WKNZHOBmoNn044YVEZlj8RU+PGo0Gr7GvZ6l2k/zp/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756577421; c=relaxed/simple;
	bh=e8LICi0cXz51O6R/UzunjggaSQC5v9PpGCl8YSUf3pY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lmLRe7/V2aABsSxLOHnKvvrnzNLGGfkglxMmGSnm+g294QTIntYiMJtCKlpLj5YMhxIEI8pYNSnr5eEA4blzec65lD3b1hMzuu7JwpT/7WwbxdFNQzsewYE8jhoOSHn3U8uNKYs03T7geEtPJ7jsoN2W+KGgWA9rcesuntv4U70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adamthiede.com; spf=pass smtp.mailfrom=adamthiede.com; dkim=pass (2048-bit key) header.d=adamthiede.com header.i=@adamthiede.com header.b=h7LQv1Lf; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adamthiede.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adamthiede.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=adamthiede.com header.i=@adamthiede.com header.b="h7LQv1Lf"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cDjpn56szz9scY;
	Sat, 30 Aug 2025 20:10:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=adamthiede.com;
	s=MBO0001; t=1756577409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XUHkduUtQbNiOZF/UN8y1qgMHVow7pTUGqnFD4YDeX4=;
	b=h7LQv1Lf62ft4Tex3omau2122G4mbtqFtsrexSkHqSrD+gZTguZsz8Ml8wn7EJtu9i3we3
	N81G64OdZ3uYuSKCk4f7Uymu+aWGjkMCNquFPOezl6DJVrec9P+RURyJyg6Ib7F8m2N+x9
	Sx7Kj8qBPVGJPC7Po0nd494XFhOQUOXX1aCztolCcaGamWVN7a66PL8011CBG6V9Vu9X2z
	CAV8EnS4tQdH+e5nWxMhVE8PXQMHtqFGLOGIBW9Zo9SRr0YX5rRLSkAY0ERZwy2AZEAfvA
	VgCVkc3EsXemU6ZQG7N5P/LZaNwCxkTGwWNGfPOqGHH92+cKN62ur0ha6hUFpw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of me@adamthiede.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=me@adamthiede.com
Message-ID: <1ad4a974-b18f-4bca-99df-5e7b93e5d852@adamthiede.com>
Date: Sat, 30 Aug 2025 13:10:06 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: xfsdump musl patch questions
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 linux-xfs@vger.kernel.org
References: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
 <81fc13da-9db8-3cf2-2a17-30961e0543d5@applied-asynchrony.com>
Content-Language: en-US
From: Adam Thiede <me@adamthiede.com>
Autocrypt: addr=me@adamthiede.com; keydata=
 xsBNBF+n+90BCAC2ZRLVcvdXDgfY7EppN05eNor3U7/eeiNCCEIWZkYLhikUEP1ReLGBkXpK
 Pc70hfnKAKkCoth3IwhDty9WXMNU+iLNei4ieb2luW+UqluR6xIUIA+txahMU9YcjVaQTKf/
 yZWO4yl6pfBPCxC2UdPZKBAdGoi5NnE0ABFNbhBETQhhBic533lZn33ByupfI3acECnQdjgQ
 llCUpDbw4I+S/N1iFiEHcbMXH7ZB00e3IYNorZ1E9v7p++5rDY1fQ9gXpieg1vFKwSq1NJWo
 9xx336YjaTUbX0EwrdKd9l8AktA3yRjckaK5TAcwSQaDtHvhpbl4ebvPhtwHh699MroXABEB
 AAHNH0FkYW0gVGhpZWRlIDxtZUBhZGFtdGhpZWRlLmNvbT7CwI4EEwEIADgCGwMFCwkIBwIG
 FQoJCAsCBBYCAwECHgECF4AWIQQtG9pGQ7sz3tf8M/kC7fV9o/vRzgUCZL1HxQAKCRAC7fV9
 o/vRzgyRB/wLqRCvvWhQCMgvzeKvru9wcXquhb77K8H/ByLbfiT8YBuP3lZFVh0IQhgO9Ylk
 fIoOJE4V+jjxyOnO2d9xjGbvAmmR6yT0gfLzSVWqrC4k+V9MWLv43nrNzxt41dvo5j824FAl
 X+zaiRZCdO8Jtxg5Elpiop2SKLi1utX1Z8i6YZh+ccJZlchUBAGUTk+D4UjK7vUcjLWT96ya
 CtdtTfXyw36CvGOPEWfc6++Kkl/5sgej1i7biPYzu/r0vssaQYTXKSrv6Cfa3Maa89ASiTtv
 q4qmhLnJeCrPxWlRAf6LEizeBEkOasYni2u8sp4wBezEq45Ozu45sfPkqLpPolG7zsBNBF+n
 +90BCADBRt+vrToRBEG580n77S99qSEkbKD+oJtCVyovnjMNkg0K9UG68LIeCX/ezngiV1M8
 JISvw5iFOuUFqGX/1hLl9wgt/YpuIrgWOp8XxkotavTCloLDvQmufJPO1L8bnnA+WgP2YgVZ
 5MJTj/t4DI+yQgysEjsH8aurHO2uuqgJE+xK+2dy6Cl/wskuGxObksSPmmFH5PH0Joziwrtl
 61ouLE2XwKbkMgIGEKkbFgbfwz3/QuLZGBni+OOtLzXeZ9wNTW/AHUPy6S9U4F+5z6/09fVT
 tTH0cvrgAGjbASlYx2VqGONXAsxCfjulq6ryJBFlPLp949c/JTTgOojukCSbABEBAAHCwHYE
 GAEIACACGwwWIQQtG9pGQ7sz3tf8M/kC7fV9o/vRzgUCZL1H0gAKCRAC7fV9o/vRzlamCACs
 vHw+0heTm+BfC3S8DUST6889gidIIwdqBep1ByzetCph7Bq8Y8BlT5YTX0u/bSKkxCzFgeTm
 vC341Q09ST2XjLAl1ZTdzGhH9gcgYyOw34pr5fPQRJLB392mPzD8YReRzciNbhWzj+DLgeVe
 ouyfGajd6jDjkf4FEq+trQLGZhpfsKn3JnDbzBUs945D50l/vz9q/QN3qZO+H4F6g8ZeMnqo
 FOEFN26xVtdEDr+0DNFsbgKmEzs675kdAY78ZZdbEetX/FSknxJ+FK1ZW3J7Yswwulj34AXP
 LB49Mk8Ot7fo6mdt0DkV11JS9LmKxKvpY+KTlrKG+i7pVCSZvVUx
In-Reply-To: <81fc13da-9db8-3cf2-2a17-30961e0543d5@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4cDjpn56szz9scY

On 8/30/25 12:46, Holger Hoffstätte wrote:
> On 2025-08-30 13:23, Adam Thiede wrote:
>> Hello - I'm interested in packaging xfsdump for alpine linux.
>> However, alpine uses musl libc and I had to change a lot of things to
>> get xfsdump to build. Mostly it was changing types that are specific
>> to glibc (i.e. stat64 -> stat). I'm not much of a c programmer myself
>> so I am likely misunderstanding some things, but changing these types
>> allows xfsdump to compile and function on musl libc. xfsdump still
>> compiles on Debian with this patch too.
> 
> You might want to double-check with Gentoo's Musl porting notes:
> https://wiki.gentoo.org/wiki/Musl_porting_notes
> esp. 2.6: "error: LFS64 interfaces".
> 
> We currently still take the "workaround" route:
> https://gitweb.gentoo.org/repo/gentoo.git/commit/sys-fs/xfsdump/ 
> xfsdump-3.1.12.ebuild?id=33791d44f8bbe7a8d1566a218a76050d9f51c33d
> 
> ..but fixing this for real is certainly a good idea!
> 
> cheers
> Holger

Thanks - using -D_LARGEFILE64_SOURCE also fixes the issue without the 
enormous patch. However the following small patch is necessary since 
alpine builds with -Wimplicit-function-declaration

diff --git a/invutil/invidx.c b/invutil/invidx.c
index 5874e8d..9506172 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -28,6 +28,7 @@
  #include <sys/stat.h>
  #include <string.h>
  #include <uuid/uuid.h>
+#include <libgen.h>

  #include "types.h"
  #include "mlog.h"
diff --git a/common/main.c b/common/main.c
index 6141ffb..f5e959f 100644
--- a/common/main.c
+++ b/common/main.c
@@ -38,6 +38,7 @@
  #include <string.h>
  #include <uuid/uuid.h>
  #include <locale.h>
+#include <libgen.h>

  #include "config.h"


I think this one would be good to include at the very least.
