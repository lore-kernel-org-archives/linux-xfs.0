Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973CD30DD2A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771531662; cv=none; b=FcKQ52xzk+XP5OwmDVFrwpvBhwTvVAip2Z2RN0qnBg6BYtV7IIz+PClWu1LJO99ybpAeBHY2CFJQ+ZEkLIpODe9ex9uleKB1xZ83Bc9I2i7NPgO6EpAIbZsG2oG/a7UKGvYhK+v5YMdaTi6DSz8w3YK/4o9sWijHcjs7ntrhivg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771531662; c=relaxed/simple;
	bh=4hKDGUDaKLhwYa10wo2QUB1w2/7YI/N2c1XW+iZG8HU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=liKo8cPcTENajmT5BYzWKtg+6KpIB51G3a0i1OTEdAieNoc6Ox0wfL54u6xdR4DcT0PorHDyNYFxfvveWrDe69QnzRqo2rw381aKycCyeFfjZBncdNWscGIzZOEW2wYL12BwhA7VfIODfOmySuAbSAfIN6aOnDoJvIqkzwpFIJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmqO1imb; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmqO1imb"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7950881727cso9660187b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771531658; x=1772136458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/qmzM+i4dYpgByb8fBfDVhdvTlZELGZrVQkv0zNaF9U=;
        b=lmqO1imbRIlo79Y9c90FVho2utTjZJQIdRzOHniaQM8FskebgEI4dwQ2qK6W9ew/YY
         TrmZv0HXIYr8kGiDvJQ3FZJqbblCKMFryGZTo9TP6765CQ3gf6PLMXWKFuBuiq/XTuHL
         SowL8LfohVNlVlzGgZxiTwb1fSp3G5iRloRUJUCIdIOtbrnS3N48pdQ0aFU22sEEbLbs
         2RUaNwGV5Lh0pRuOa4jCxalBPMgeZ7Vd3qlVHY0pHyfZpAHaTEjLIP64rUZty27mOmZo
         fqNYEP13hjG6HQKpSv/kF5et9V3HXhaimnohpW/tVqGSr3G0/T1f230s1xgGNZ+EAAdP
         J60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771531658; x=1772136458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qmzM+i4dYpgByb8fBfDVhdvTlZELGZrVQkv0zNaF9U=;
        b=kOxxi6UAihvS2PrLjXdV5xgKkHiiStLydJWTypTs3lej30ONxZobv08JnaMVzYSYSn
         1fqwMzfZgtFQWUeZFAV7a8Kd/BXZ21b96dxSvBH4kpJNs20+pzVJ7aKwikD+P56YO9tz
         J1it0LdS+3CrI08Lh/2sfTIjvsj11X0RXQYiBYPkyMLVid+QOFtqdo8F4vs7K7W01jZW
         LyP86yAjyFnSNDWCVdVNXngFxW7Qj1e0jr7QX2krSh3Pfu8tj1BQm3fiO0VBr13CF1aY
         RBwXYMt7iWHIMGdX4T7SGV6L3Kz1y191YsMHVN1E78h4ppqcJbMDKjzkhPPunnuC/7eT
         msEA==
X-Forwarded-Encrypted: i=1; AJvYcCWpGgxiFLxdYw3MNGK86zkhGGefNMzia0o9X0Ckmq9SkZPxcR/I4L1S35IZwv5Oq07SLIrmX4FASUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcoo1XibXCsu+eyd8ctV7zqogFFZX9YoA9zVIFIZUx8LJizcgV
	nqwMb5fHhbPNcnNlPdRu4o0Xd0tZeKsDySPNcrnz7VGS1ZoRaZSwO6wYbCTgjvI+gI4=
X-Gm-Gg: AZuq6aJ2kCaBZok9hgyS63TNDOBeiCsxwAjgJCp+aJOyMZvD3jSLYCSSLh+XfovfxZq
	YzR5uw+nXHljH0yBZb+ayz8+Kdj8axcmBh9Msfd2uIDqkcVe6+W13fboPkrrmQQrZBXg0chCZFV
	7xkW8N24kWfjCx9qI/EMg1Yfw6lP38MBsZjI9V9Ck8fuecYIIrr+GpfmBLa0nLOlcHDstw+pQmF
	wMdaT77CNjqm6i1lMGdyrkz2Td0H14JSWY+6NTe5zz4c4D+TcQll1q0l5Si+RRgn0BkN6FXRn6B
	TRTHsMQfGdG20pS7xt4mqoB3/SWjYPdJCGS+oDyUgs4k0Pr8L2SJvEzdCVjqSBNpRF81JtC3YLp
	1CLXXM1+ZfDIdPh2Xdiw2Q3Hr3Ks0jLU2U54eCbNYtdt32BudJvcwAo0/PgwikzbOyJuyDTfKjH
	ae1SmfYgg1WMo9JgHsGP0/ruVbm3ZPl8C4iOEjcmg4+cUaK8TdvAjAZE9UinemWYvv5nb0PEe0K
	2q+J/1KNxYc0BfrvgMHLOrRH9GwwNOgB3KYfhoe8yU=
X-Received: by 2002:a05:690c:6612:b0:796:4ab9:f29b with SMTP id 00721157ae682-797f7353b65mr48586537b3.39.1771531658458;
        Thu, 19 Feb 2026 12:07:38 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00:e3a8:26f7:7e08:88e1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c2667f9sm138276567b3.46.2026.02.19.12.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 12:07:38 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: cem@kernel.org,
	djwong@kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	neil@brown.name,
	brauner@kernel.org,
	jlayton@kernel.org,
	amir73il@gmail.com,
	jack@suse.cz,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] xfs: Fix error pointer dereference
Date: Thu, 19 Feb 2026 14:07:15 -0600
Message-ID: <20260219200715.785849-1-ethantidmore06@gmail.com>
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
---
v3:
- Add dput(d_orphanage) before returning error code in 
  xrep_adoption_check_dcache().
- Revert xrep_adoption_zap_dcache() change back to v1 version.
- Include function names where error pointer checks were added.
v2:
- Propagate the error back in xrep_adoption_check_dcache().
- Add Cc to stable.
- Add correct Fixes tag.

 fs/xfs/scrub/orphanage.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 52a108f6d5f4..682af1bcf131 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -442,6 +442,10 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
+	if (IS_ERR(d_child)) {
+		dput(d_orphanage);
+		return PTR_ERR(d_child);
+	}
 	if (d_child) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
@@ -479,7 +483,7 @@ xrep_adoption_zap_dcache(
 		return;
 
 	d_child = try_lookup_noperm(&qname, d_orphanage);
-	while (d_child != NULL) {
+	while (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));
-- 
2.53.0

