Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A214E31355C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769625920; cv=none; b=Knf/iHPayLrcxtnp0znmGQZ7bYYhOLjQkmtrRzCNQwJL1tn6c5Fd3XurYOiwLEhihGN8GX3GgAxNVwbZnNZr3TH/qX1iXQM8Gjal9QZT7cM5XRpqGjlidCGjV9kqcoN2cfcgQB0tIpxIpLcXfbGy3jt3LKXF8BSH79yqbge4Wy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769625920; c=relaxed/simple;
	bh=ugFNpZt593SMDq16Q1ctfAwFKw7H5bqS034lijqQH9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwpQ4Xwf5yWcS54afrdjWOrtXTqifaXjLCu+fe9B1x8Sb7UMYIKQGPh4Qx1A52Yd68cnAGjW8K759NioX1PWHKEP/tGFdLBRfzahoKC3fwZvSxdR+YXN80djtMhZ8/n6lbqWR/kQM7K8hTGFq/QRU4HuxmEKc5UUlUU3vqNEaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddTjF78J; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddTjF78J"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a2ea96930cso724205ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 10:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769625917; x=1770230717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RH4X3hUkJySCE4gfseMfScNt6Sl8Sovxi9vzIC9OT1Q=;
        b=ddTjF78JfiRjLnqKm40cHat8vjiXhja7iC2R6+00qdasyllPM2ooQwAq4/qmdEkV+i
         or2pbBtV8996RJMRpRyAMc0NElb5P6v07SADPEvYzW84qEb0Wp86LecqWBHEASn6Bmsl
         4T4CHUvK81JDZu6O4zmu9t5InvzEVxsZ7h9u+LNTtUMdj9XJBLkrYWSyWiaWDHaVHoKQ
         os+AjbsMP1d/JvYHz9Qmq7oOn+d5V93sVqj73hRqGQJYOdqSrV4khr7tPJcDR+GvqmcB
         vs8qad0PHpZBy151OeMkSMKP6eIlxZFKutg9usqEy3pr35c5Z7ZcIuuEaEEs7B0uBsbn
         FHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769625917; x=1770230717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RH4X3hUkJySCE4gfseMfScNt6Sl8Sovxi9vzIC9OT1Q=;
        b=aRvRy1ypGiiIjMHCkdKyiOwzSlYaJm1V0yT944PI+Ysdsg1E/Tv0qB76ADCK1zcjbZ
         1mBnk9f0tuI8ddLSHCgFtb0fYf/lA5lFBqPOCyvOw/HamedgGrdhNq0HifB/84lYAxlX
         FCxUrCBCvS0tTJKpf2XAKW9LnaDzvnie596leyAvv0NfIGGSvqliHm0Ac5bjJ1g+nB6p
         TQEXMNPI8WIN1MVUxzr18DNwY5OfHpe/A0j/ywqQsYCK801WCkLwfk+1PslIXvs7mnew
         mvJ9xT+VfUrQJ2gdhiGdQ9e+vQg2YR0muCw9bjd3hNRGm6L75GWfrXSkb5sOZEZjsHIk
         f8sQ==
X-Gm-Message-State: AOJu0Yz/MA9HzUZGyPX+h81TIVkIoapa9cX3JLEC/uuJEvPeI/a356iD
	zpMkibDnuJHaYBCgZs9i/O3hOLVykzY9w0t4Ka6WW1OqAf6AJP+FdOG4HQ8hVmc9
X-Gm-Gg: AZuq6aJIN8K/1ndFcctf/7l3hGsY9+W5BaAtCrsHIURE2eLke3/cNGmNatzXgq31Qh7
	HXtFUsOG3gKlJQD+hCDOvZV05zAzaDESy0dQVIsCZikf0TklWBBL1egpxB5dYDlAvF2xGjcdfH9
	ge8nTrY/GkVnyP4Qw4DCqeNELw/oh+SHGWCJ9I0G3jeOvH6/zN7s9hmk+SLs9IpMz1d3Ziu+QA3
	jH4w2Ez/ZyAg9EAZZ+LeV4sR/M32+8iNZE4FNHPeg8kw5bu+Hopmn/voj8j4QghU3seGNQunGAu
	tnabaycxYhuKdDhAlnYDXBSct50JSGBOSk3Z9WTPMiMOFSGInMUJ71bjrEJw+7TERh8Io64Se2Q
	hQJDxGL73/AhPTOgm0kJeZynOoUWAPQ+tSIT1nuF9+ivg9iGLvr7Qr9yVrn0HWA/zSeR4PRQ+Pt
	ceBPeLS74QriSDC1uuZMs5j1a9VwZRBElPiM33Z4K5mGuWWhZLk87f3iwcAoPGMKLtISOHTFGjQ
	KE=
X-Received: by 2002:a17:902:da4b:b0:2a0:823f:4da6 with SMTP id d9443c01a7336-2a870e252c5mr49930765ad.50.1769625917193;
        Wed, 28 Jan 2026 10:45:17 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3dd4sm29068745ad.65.2026.01.28.10.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 10:45:16 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v2 1/2] xfs: Move ASSERTion location in xfs_rtcopy_summary()
Date: Thu, 29 Jan 2026 00:14:41 +0530
Message-ID: <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should ASSERT on a variable before using it, so that we
don't end up using an illegal value.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..9fb975171bf8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -112,6 +112,11 @@ xfs_rtcopy_summary(
 			error = xfs_rtget_summary(oargs, log, bbno, &sum);
 			if (error)
 				goto out;
+			if (sum < 0) {
+				ASSERT(sum >= 0);
+				error = -EFSCORRUPTED;
+				goto out;
+			}
 			if (sum == 0)
 				continue;
 			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
@@ -120,7 +125,6 @@ xfs_rtcopy_summary(
 			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
 			if (error)
 				goto out;
-			ASSERT(sum > 0);
 		}
 	}
 	error = 0;
-- 
2.43.5

