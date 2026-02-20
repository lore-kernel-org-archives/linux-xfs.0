Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2F2C3749
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 03:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771558728; cv=none; b=M/cL2H9HtJ9vJZLU9Ku6pNGtTLNuomjCD7XsjFhQXz1lOfewMTKWul7m+Zqa/bgW3+5bAmjVAilAfVHb8cQ/SUqQWPVtE0EY8Kr4brkvWlfSU12wDThEokLZwhTSfTIxYoHGrv8A+UMVYiBGEOAKsv+Q9UpKd9eUcaQSty2BMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771558728; c=relaxed/simple;
	bh=ERiI0ik+7C8U2bOZoMUPA8NBk6mNeP8oUH1ilI5DrIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hE7BjGrwreHBbqKn1wBS4sMyReXDnBGuQN+0XBW5xId7tBCEm9D+Tf+QDbpeZFM0pJxHD6pFik1hJOO1exHLzsdpx0Hkagp9keOhIurZgYTsxSX7fTgfcxc4qXovgx8a1XVyW+CWpZoqeilu734im3+C6fNk9aGw2L2MAGl7qks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I2mzisgh; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2mzisgh"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64ad46a44easo1563745d50.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 19:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771558726; x=1772163526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TYi5KdDTrgKmUbM9Hgtml02i+c073pK3aRdi4XL87EQ=;
        b=I2mzisghLi54jACxIHeX8n3kJC+GUbKVsBaMTS0RIZ1mrQ7Uy+rXOU5GNEbSJJ5kVj
         d96b8G2UbQKwo1R1/3iv5Xc4kb5Nnl7UqbnqWwJxsqmPkTFrgVT+bMl9Wcm5J1OooJQ6
         TI+5UDTRMCa0r0UtTkS6m0d4vf/fG+QIZ28K71uLaxB7Gxmw6iPmi8vLveN7Sgsujf4a
         h2ljmIBhLr8qR1pbzqgX6OM77tMCFM9QsL7WTwQMR4nTtjZfQHtdAvJi4dk6MFxKMU8K
         oOKkszHSEZyPGz8xUpUW3rC7z0f7jfq65VQA/L5uuRhEdAJVYFPImPyfyGny9rGvH+Te
         ozYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771558726; x=1772163526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TYi5KdDTrgKmUbM9Hgtml02i+c073pK3aRdi4XL87EQ=;
        b=B5LshrsBxxLmds5wDHQnHN5L4lK46obUyL1BKfBIBc1Fd+iltscq5v1cUtyndnqosV
         Q9meann/Q9mnvnabfL4ZehDjuCVwqCCtGM6g686/Eg+aHTo/A2s96X0g83eg3AZnuf6Y
         UYLDsa2wrcLRobgOJRHVO+VZ5JpsMgMbO1sZ0UVaiAjudoaEXylhqU5fUDs0/dvnUzXN
         Ok1xegJezlVJVNvSVCxhkmnTrCV02A8TMoF+S7RY0VXeo/p0aOdkwZnly6EFjPV3maLX
         6kKmRjSUg04+9h7q4IQrP0fDowTwTTnUr/xE6aJ96/spkve9WW7QhUZwljNUF+JNn9lK
         P6/w==
X-Forwarded-Encrypted: i=1; AJvYcCXkKp3qVxK665w2m7oeCippMeLEI+lQ/WVGK7cf8dYPqfNcr2iMpT7mbsp0iInjBlkr2f7wdpHmPzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA4gWunAGf4LO5khwXEpfTDymQemyFq3TNnP1L3w8LqCL48Nch
	2LMg4ULV1Zn0PbM6fH7acyTS2hn8MJMgQIvHdWrribfQTwE1RRGwCxiIDcwNwFXqccY=
X-Gm-Gg: AZuq6aIEiD6V6/DLanREC55h9UOMgtoTSsF/dJ9uDQqPwcPXGdV+i7Rif+Xhi4J8Jse
	XtX8H+5/7xB5hDfxofpIeZLjhN9qTtbfzSk0Le/AZWiZRBnBQi1mpH9iXq9j7+L9jkvMX7VtFHw
	Iwm/PIdom+mgBVIN9wkQZ8d7/l08Yg6BrBSL9ABU2JDLIZJAXR+uZuBYK3MUiDyFR2uce/fAgnj
	B4KndxBf0Y3HI0OrDNBSOfSpi7M2lP9mZL5J0u1kwMsjghqowrJ3FfgmClpFnY0LOHkvX0Z1LZW
	Lib3wtMQWXr6XwUhoXHz+Y6iHoWz5FdRon7XUIQDE1ZXiwDzhsVscjsKGlfLGsd/VfwyZ/ABEiw
	Il+jdZxSxYjLrdFkPhpOub6Bz9N+xA9r+XfHMAShr62995Wym9YgXH7RXC+f3Yrl0jTWH6pMxr2
	ZYRXyk34ykv5WBv4lkyvG59Q0Uvm+PcfWbF/molRFDuJqcjHvTyFJ5zVDKdZktaEwR/XjATNMB2
	nRHqYu2vs/5L2HYooegWwU9E3ZsfupveI2+KChDep4=
X-Received: by 2002:a05:690e:408a:b0:646:b1f3:aeb2 with SMTP id 956f58d0204a3-64c70ba3c7dmr277466d50.3.1771558725713;
        Thu, 19 Feb 2026 19:38:45 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00:e3a8:26f7:7e08:88e1])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64c22eb2059sm7927069d50.10.2026.02.19.19.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 19:38:45 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: brauner@kernel.org,
	neil@brown.name,
	jlayton@kernel.org,
	amir73il@gmail.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v4] xfs: Fix error pointer dereference
Date: Thu, 19 Feb 2026 21:38:25 -0600
Message-ID: <20260220033825.1153487-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function try_lookup_noperm() can return an error pointer and is not
checked for one.

Add checks for error pointer in xrep_adoption_check_dcache() and
xrep_adoption_zap_dcache().

Detected by Smatch:
fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
'd_child' dereferencing possible ERR_PTR()

fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
'd_child' dereferencing possible ERR_PTR()

Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
Cc: <stable@vger.kernel.org> # v6.16
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
v4:
- Add blank line after closing brace.
v3:
- Add dput(d_orphanage) before returning error code in 
  xrep_adoption_check_dcache().
- Revert xrep_adoption_zap_dcache() change back to v1 version.
- Include function names where error pointer checks were added.
v2:
- Propagate the error back in xrep_adoption_check_dcache().
- Add Cc to stable.
- Add correct Fixes tag.
 fs/xfs/scrub/orphanage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 52a108f6d5f4..33c6db6b4498 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -442,6 +442,11 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
+	if (IS_ERR(d_child)) {
+		dput(d_orphanage);
+		return PTR_ERR(d_child);
+	}
+
 	if (d_child) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
@@ -479,7 +484,7 @@ xrep_adoption_zap_dcache(
 		return;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
-	while (d_child != NULL) {
+	while (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));
-- 
2.53.0

