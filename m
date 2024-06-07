Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE3F188CBB
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717773896; cv=none; b=uUBSJAP+tV1j4433nPlP5tf0voR98Kj00wO3jNB0wsD76FYZm0gXJmeLWA6R6jtqE62ujM3TLTbLjsWsH/BCGZ44pEI19zXNhNfCeV15VlmilFfIn1Lm49X1/KXIMz+1yG0tEXRXXuuABP/yCNSdTjOONuStAq9nDZWJcvJCFEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717773896; c=relaxed/simple;
	bh=ksvBLldepftFrxYQ5LoW3zznQ6bbYR378jWhEzfGFGE=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=a2O+zRFXqo4d3Iz238lTxB7x6sIdxxPpjjKaF3oXfblGgTSumBMrZ+3TSxrIIRWs3rj7lCMlJNLXb+Uex202PZL1SeQIcRKTAc6Q8chY3BmBNfDwNiXTCWpsDK5ZG5jv01cwOP96GyUTkErP2rDrkt7IQzF13rthdYO4CNpkSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=rPjVeZek; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="rPjVeZek"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 00B2448C707;
	Fri,  7 Jun 2024 10:24:52 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 00B2448C707
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1717773893;
	bh=p/5D+rr93Zh+0chkKlYaGiKj8IYcMuosSG1iBBBaAoE=;
	h=Date:To:Cc:From:Subject:From;
	b=rPjVeZekN+FPZu3SyKpBX3+NuxnYIGsyqclLyaWYR3RVbqcq7BU9nhVFJtCJgsh0N
	 hsblp0H9Z1SYyUQFYt9ON/K2TYxRh9aq/qUw9cPwgpwmrROp45k4Xb10Kz3spf0scc
	 LUmoMJeBYt4xY8VV8NGvv+X0MYBoOtepIpxb0tPGW/v6kI9D+lOM3p57GxY+GcF+9s
	 1LtrSNkcpZJC2dSErRz9lDLDe5L9zDUFWI3B4Q/Tkb06MKypFnCx+gcsd3U/6A1NXF
	 8Vj2KyIBzBeZ/SN5eJG77bSNVGNq6LnJObZiRRNUn/iUmu4PUhOdYO/KoSN3Y5ncTI
	 3+M8rbSGM3RSA==
Message-ID: <be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net>
Date: Fri, 7 Jun 2024 10:24:52 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
 Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH V3] xfsprogs: remove platform_zero_range wrapper
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that the HAVE_FALLOCATE guard around including
<linux/falloc.h> in linux/xfs.h has been removed via
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

Darrick points out that this changes a public header, but
platform_zero_range() has only been exposed by default
(without the oddball / internal xfsprogs guard) for a couple
of xfsprogs releases, so it's quite unlikely that anyone is
using this oddball fallocate wrapper.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V2: remove error variable, add to commit msg
V3: Drop FALLOC_FL_ZERO_RANGE #ifdef per hch's suggestion and
    add his RVB from V2, with changes.

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
index 153007d5..b54505b5 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -73,7 +73,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
-	error = platform_zero_range(fd, start_offset, len_bytes);
+	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
 	if (!error) {
 		xfs_buftarg_trip_write(btp);
 		return 0;

