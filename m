Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106A92F7F1D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450855; cv=none; b=mTznZdJUaQ4EZ5vdhxTG0/3WUnpuH+zb1jK746cigYvnn0/8Ys207s8lj5gUYdXK3saNyFMrEW7IB2+WqQCTDqCq8ZjHFFzUw4Mg4IOKzFrav00a4bfXAv44qCD9vczoMd04d/ZQ0kW9LD5GsvCpEZUM1R4eAHU4FqwPaQRc2sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450855; c=relaxed/simple;
	bh=1H5M234+4Fg/Pq6qk0rP5Oq9G8Tl/o5fQwWqQNUz3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cT0yeYXkirLoM89hFD3/Xm+Ry+VWvsFb8j2L5L8urtAPew+YPL/pvb1Yevwq+Kbn2FsP12Yl3fXeO+nG0HuZ7F2/BrJiizFLAnBBPp9ySZuYb20y2HVG+QnuEuM8mdVBNu0a1vyehCQQS4o4m/bbm+PI42QYF9cXYlyqf9uv22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z/SYkSgk; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/SYkSgk"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-381018b9375so4788412a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 12:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783450853; x=1784055653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nlVujRWWeuEM6btf5nuU1hM8tEcJ0tIS4bqjs/e+5Gk=;
        b=Z/SYkSgkA7ZkmBorPME1NfSI6hABjD8CFRX3/+w/j3yk4M335m2BcsgmAte0h+JCjh
         zvquwhcytb6Fjd0XmDN3ODm0czajtWTIkwQuLccfVT3xyF6atuE9CQp7eQacfPl/RpHK
         E4Hbpj0j1Ium3xx13DdVjZ5t0iBlmcbcckIYEU0Co8C+LrlD2R6qDOejEFsfLLIph3Me
         1Ip2s30UIkn4mge6oHJfz3dXgy1Ivh4vcPXBcHOxJwLMjeNxdJ3d4y3nkddOacMUE2er
         3bKKXsJSB22DiC2EB44OG/g5pql1lLlrsIjB0T6eYVIX20Zd81gsXAY/UqpGvjVF9Ic8
         7/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783450853; x=1784055653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nlVujRWWeuEM6btf5nuU1hM8tEcJ0tIS4bqjs/e+5Gk=;
        b=aeK+X9eZPpuK7Wt33GmNoyoYElO/Jvn4byBqDrrXzuYULjW4t7n+XZuHmba2tC094z
         l0mXSMLa+v6nwjBI0iOQ+cgGTJo9QSCZiEgsg2kaVeMju5uJFT79tT6HfD9+jtP49UKs
         QeNnk0iPqNnnrPeqCxmtRgSO0gEAyavCDortvZEutlYXQYD94L3VTNa8zbfuhPhTb0j0
         RgmO5zDk3soPIpkq+e6w/yZy1DiUeWYJruLv9tjaLWnNid3L8vmgEGTDHwukIPamNjv9
         jH3q87j0yLkSC84l0Z57WP1savZiNpFteQOESspYJrTODBmcMtom7qh+As9Y1zEk2vit
         55bg==
X-Gm-Message-State: AOJu0YxxMu5y5QunY7OpEIlHSB2CbWN1UGYRP2hguJUTtTMrMEOYiJ1m
	2IFpTABl0LGe7uDVxxJ8ht0Q0rMfW1Ui2E9gGfdX+C6UFZNqzzAFfhvpu+p4mVBXkP8=
X-Gm-Gg: AfdE7ckwm/lfav5t7ZK9OLIj7C62qcDTT0fR/DGmD5rpJzw0Ij+vKiin11a0bAc5is/
	IZkLxjM+TQtcGES6f32+vGY1c2SFkk39G7BYfpSkV6zcskaRm3qjFjUUXL5MbTqzg7z3iujuS8G
	vQ1Hv8JrbTxhXzoLPKbBbYQ5c8rSWx0Ybr3ixYXGc2OVMjHuUP97VU+AGMCQfOaSFtxHPxOcoTj
	cYK0yn5Oi24G50T7UhPGx/um+RveSceaduxGftIL6DadmoThGWjM4SBlk/b4rxbpn6ILZvCHY1d
	ixJ1J8WSP5UquTDjOPaOKAPSLukwzde7Fxyutenz8GYxHufPaeBp+37hSG0biYmr2b7OOIyUU9w
	59xCtdsx900HZUk8rFgzarPmix3D2/VzSG3XparTLVfziQguNiRfJPQzQe6qsWcPvhZ5OQGRcD3
	IHULfL
X-Received: by 2002:a17:90b:1ccf:b0:383:5a16:bd79 with SMTP id 98e67ed59e1d1-38758a361cbmr6163480a91.22.1783450853223;
        Tue, 07 Jul 2026 12:00:53 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a583bcsm12305248eec.19.2026.07.07.12.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:00:52 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v2 0/2] xfs: fix out-of-range remote xattr value length
Date: Tue,  7 Jul 2026 16:00:36 -0300
Message-ID: <20260707190038.3811440-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707140118.3217585-1-qwe.aldo@gmail.com>
References: <20260707140118.3217585-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 tightened only the read-time leaf verifier.  Darrick pointed out that
the underlying problem is the signed value-length check in the consumer,
xfs_attr_copy_value(): a remote value length is an on-disk __be32 that is
stored into the signed args->rmtvaluelen, so a crafted length such as
0x80000000 becomes negative and slips past the "buffer too small"
-ERANGE guard, and is then used as a copy length.

v2 fixes both ends:

  1/2 rejects a negative or oversized value length in
      xfs_attr_copy_value() before it is used, so a bogus length cannot
      become a copy length even if it reaches the value copier.
  2/2 is the v1 verifier fix, rejecting the malformed remote entry at
      read time.

Both are bug fixes and are now cc'd to stable.

v2:
  - 1/2 is new: fix the signed value-length check in xfs_attr_copy_value
    (the consumer / root cause), per Darrick's review.
  - 2/2: cc stable; otherwise unchanged from the v1 verifier patch.

v1: https://lore.kernel.org/linux-xfs/20260707140118.3217585-1-qwe.aldo@gmail.com/

Aldo Ariel Panzardo (2):
  xfs: reject out-of-range attribute value lengths in
    xfs_attr_copy_value
  xfs: reject remote xattr entries with an out-of-range value length

 fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

-- 
2.53.0

