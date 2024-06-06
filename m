Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF89713E02E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 23:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717715218; cv=none; b=eXHFEy4cqUbU0FJI5+g6GnXx1h6WQtu3PITAP3pyZuKDnzU3Mcy/2vBdN/zU4iomXGp2iHzqqG8n9iE3wMPGnS7+myVvAPLuRQr6tXllOquw+YPYVXJiYBeS84bzQhXqS0idJsUmESke+gmCg7D94hmyDNycaVCJ4T/yokuRMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717715218; c=relaxed/simple;
	bh=NWtD26Rs39WeP1a8d6var8ThIAofPNm+RlOSEzAgzXQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=eyedk0zSuP7tgUFBpdezSAuXdn8YL47p1SEaiJbHthVErHKP5XlWwx7l3Yi5zcjntX9E9IH3wwkYK9LM+/8XM8L4i1PyEpMRg/QCWRUN7iy6Ra5Zx1IJRydKAb+ukTuSxFeaa34xJLAfdBZpHgYThf5OgnTP04kayhTSlsl/IPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ZSwD+cpc; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ZSwD+cpc"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8D9FD11674;
	Thu,  6 Jun 2024 18:06:54 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 8D9FD11674
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1717715214;
	bh=l4Dpfe5PrzyCMmYZ3uMTrLXU46kRECXTk05XGUXuCRU=;
	h=Date:To:Cc:From:Subject:From;
	b=ZSwD+cpc9aTAktDhEF4jWNbd2lZRstcXZ6Ng+92tTYkDmfpb4YWUsydlnMdnfFS3k
	 Pjm/SMfHKIowcsbOunNMmpu5NK1LfcCfg9eIZlAdDt4EpI6FSxTomsM2kdVd0vlxJq
	 3VMsAs8bcMT8G+aHCePpSGrSolhpfBQR94UnR0s2OH8i6w15HKmZZkMujPfsbp6MOG
	 QP2PXC6FpEGDgpfnbqMCkHMwN+7XlXD0e3lXAee8KkEs6T8ZOCBnnbliBntFakzP0C
	 7tdW28ZhKKFOMEC6uHJyT911bklUQLEiw6aZolZ5OvOly7ss+9JMAb/1bXH/ZqeYao
	 BbZZF/hYFcokQ==
Message-ID: <5c18db44-41cc-4dfd-9c52-57299d01f5c3@sandeen.net>
Date: Thu, 6 Jun 2024 18:06:53 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH V2] xfsprogs: remove platform_zero_range wrapper
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
---

V2: remove error variable, add to commit msg
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
index 153007d5..11559c70 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -67,17 +67,17 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	ssize_t		zsize, bytes;
 	size_t		len_bytes;
 	char		*z;
-	int		error;
 
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
-	error = platform_zero_range(fd, start_offset, len_bytes);
-	if (!error) {
+#if defined(FALLOC_FL_ZERO_RANGE)
+	if (!fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes)) {
 		xfs_buftarg_trip_write(btp);
 		return 0;
 	}
+#endif
 
 	zsize = min(BDSTRAT_SIZE, BBTOB(len));
 	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {

