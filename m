Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B138419D89B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 03:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717645108; cv=none; b=ahFbTCNdlIbC5acAF19z5Skd/FAk7RXrnQ6yNg+1re+I17x974ND5UhKnIgGwkmkjcNqmBLT8s/zvk80cFxORhQBg7JJNRmCMGdJQg2QCjvWN/yV14u/HcDu+/JDEVy0hO+piZZt1rhwnkoE4qWKKBnFVYrqK/Ctrs7tv+c8Fqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717645108; c=relaxed/simple;
	bh=F6d4FuLZnGPX5ox+WcqzZg0tF7kFCEUWDtXOGW6ImpQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=mBAQQCA3Inxt+OjikhyiIg2/m0AXrr0YkG6zPFd8xsIWjuGTFdQ/nz8nqZlnsy+hJx3lzd100Fb9G9f3A/nzyUBX9gusvf6xJttBBhjG3xdxyvuG69ySsM55DCvzZj2WXkB6TqNveK0vMWATxZLJVMkZ9MLdChyMv0nmhv4EjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKn2El/c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKn2El/c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717645105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BYYOM6/Zq1w3Nv2P35V7hdABbH53Vjf+HNVaJtFtnA4=;
	b=cKn2El/cmDmeMTqdgK3+j3WPb5A3FeAQwSkpDKD6gXteSXqCR4VqyVRUyULgJejVEmmvU4
	bq7M0vw+OuGgnvJfOUgimf79Qokpd4vsRS0Y5nKOM0KaCRRF0Gugb5I+q/tdBPnNdjPicA
	NCOAGrXNi/vlu+bA1E4jFkeCembJSYU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-zuheyTD6PaqlXf2voKN9aA-1; Wed, 05 Jun 2024 23:38:23 -0400
X-MC-Unique: zuheyTD6PaqlXf2voKN9aA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e94cac3ee5so60644439f.0
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jun 2024 20:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717645103; x=1718249903;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BYYOM6/Zq1w3Nv2P35V7hdABbH53Vjf+HNVaJtFtnA4=;
        b=OY98a0K1BkMe5MMz4dHqc4zsYU3CmTZS32NYtRDcHwkqpmzdRFSKHqnyb+zUx3UgUF
         TAek+ph4+hjH35n3h40uBSYCxN2pITLp8lmyQYFxgLrz9IGppRZ7/u2SKRFqQKXHrjlb
         ZPzuE9KWQjh7RUhgSySvuhF+MPjRxMvfsQfadp0uykmgMie6jzUTSzzheFonrAX/qDJL
         ldG2+laEIA4uZ9/aaRReQ38glJlF1lMkGTfMZePrdnT9Ft2DxRiYmfs5NfkNpIzyVErg
         j62sbwqvvT5BHxZ6RKwBYMayTci0Qf39/flI/RwmE18fT4DUTycgct+8Rb4wbCoJlbJr
         IWXw==
X-Gm-Message-State: AOJu0YwtbmarWi4smZzFwNYFCySvcHYYuUa9PtJ6Z2CLg3BFLw9B9mka
	/d41grUFlBV1T8XX4PPVkxIUAUJt3BT8VYuvJ1CrIGTEEX2DrrEtOxDktcXH5tqHjX8iP+rj9nu
	gV1WncZngmiPmW94YjGd1WSKUHsN+B3efP+1HnAU1znwsp+w4PMyGm8nGYTQOXMBoh4qF23tXdY
	K47Bm7sefE1oRYVIm+knAA+iAMEPz7gXPmLA3t7cUt
X-Received: by 2002:a05:6e02:154c:b0:374:9fd2:79a1 with SMTP id e9e14a558f8ab-374b1f65dfbmr44836225ab.28.1717645102895;
        Wed, 05 Jun 2024 20:38:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9YDsVP0/P6e07kkYPI3pwWOddUpoO0SazNDhzmfe6KD2qYPYEYTHpNbCQpHH1A7gt9IQfJg==
X-Received: by 2002:a05:6e02:154c:b0:374:9fd2:79a1 with SMTP id e9e14a558f8ab-374b1f65dfbmr44836005ab.28.1717645102239;
        Wed, 05 Jun 2024 20:38:22 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-374bc1b6070sm1285375ab.65.2024.06.05.20.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 20:38:21 -0700 (PDT)
Message-ID: <a216140e-1c8a-4d04-ba46-670646498622@redhat.com>
Date: Wed, 5 Jun 2024 22:38:20 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: remove platform_zero_range wrapper
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the guard around including <linux/falloc.h> in
linux/xfs.h has been removed via
15fb447f ("configure: don't check for fallocate"),
bad things can happen because we reference fallocate in
<xfs/linux.h> without defining _GNU_SOURCE:

$ cat test.c
#include <xfs/linux.h>

int main(void)
{
	return 0;
}

$ gcc -o test test.c
In file included from test.c:1:
/usr/include/xfs/linux.h: In function ‘platform_zero_range’:
/usr/include/xfs/linux.h:186:15: error: implicit declaration of function ‘fallocate’ [-Wimplicit-function-declaration]
  186 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
      |               ^~~~~~~~~

i.e. xfs/linux.h includes fcntl.h without _GNU_SOURCE, so we
don't get an fallocate prototype.

Rather than playing games with header files, just remove the
platform_zero_range() wrapper - we have only one platform, and
only one caller after all - and simply call fallocate directly
if we have the FALLOC_FL_ZERO_RANGE flag defined.

(LTP also runs into this sort of problem at configure time ...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NOTE: compile tested only

diff --git a/include/linux.h b/include/linux.h
index 95a0deee..a13072d2 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -174,24 +174,6 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 	endmntent(cursor->mtabp);
 }
 
-#if defined(FALLOC_FL_ZERO_RANGE)
-static inline int
-platform_zero_range(
-	int		fd,
-	xfs_off_t	start,
-	size_t		len)
-{
-	int ret;
-
-	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
-	if (!ret)
-		return 0;
-	return -errno;
-}
-#else
-#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
-#endif
-
 /*
  * Use SIGKILL to simulate an immediate program crash, without a chance to run
  * atexit handlers.
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 153007d5..e5b6b5de 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -67,17 +67,19 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	ssize_t		zsize, bytes;
 	size_t		len_bytes;
 	char		*z;
-	int		error;
+	int		error = 0;
 
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
-	error = platform_zero_range(fd, start_offset, len_bytes);
+#if defined(FALLOC_FL_ZERO_RANGE)
+	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
 	if (!error) {
 		xfs_buftarg_trip_write(btp);
 		return 0;
 	}
+#endif
 
 	zsize = min(BDSTRAT_SIZE, BBTOB(len));
 	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {

