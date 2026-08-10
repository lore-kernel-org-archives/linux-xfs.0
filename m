Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAF23B52E6
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403187; cv=none; b=Dw0epW3QiJe5Plygf+9DV318yBIBcNYQJWFUtaE1L9O56wtyjAZTsadhO/+k6Nxy6DD/sCYuHYEmiayXwWGdxX1KEJibdroMLzVx/ByBTDmSg7eKLyvKz26hwsE4e5sL8Z6Po8yk9+u6F1Vc3MZAyP8vzrbtaNJnaM6m9AbIRUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403187; c=relaxed/simple;
	bh=NNh5aG4w7LlGxuf1r7SXWUFUWOyJJe//FeT84ioNlzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfo14WAxN6+atBp+bEUCRpzn2JpgWoJEVQ53O1CWtWcZVut6Ad/k/o0PNWuIRTqUfRgNKG9jKi0eEyRq64x+m86bF6Z47nSBHslCn0N1a/3IFGoHMUzUoio/6ZVpKnWPO4MyUqu54K/YTapPL40MIpFMHnuKgSLefR8JE+sWZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=WczM8kNJ; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="WczM8kNJ"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5c39a34df41so74935e0c.3
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403184; x=1787007984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wbXsisKh0qf4tkJequwBHZTpDXZaOCmKMrgCvRHqAvk=;
        b=WczM8kNJommtabL/wvftUnWCFHJYqdkoSHfQkJ53EB84A274xoSPwfWOiN7iOqK9HR
         HICogaug0QhRwGhxMR60Z78I5zjvTT0CSQ2884mh/zzOU+u0U4ToUQqBeYDU+0Zg6jVp
         jekAuK416EOzeWwvU9w+oX97A3esR82rRukrnmWvWeDUHl+IW7ulD4Ro2plXSkkq4lVE
         eFlJj2aGxhXQO3saXDk3v3h+u3xrjwYAd7szbc4lde3ofj6P33ePPTe1LvYMpVEd9zHW
         LQRQ3v+yHIhOoeIPnH1eYn3tGfQw+GGTwg5q0TAj7tcWIVytDJY1p7T9L4JMSeGMF8FV
         r+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403184; x=1787007984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wbXsisKh0qf4tkJequwBHZTpDXZaOCmKMrgCvRHqAvk=;
        b=JDBoPdP13pBI0JXWlEhIPKbapQ6D0sz2VIojZ1dzYqj8qY9Qp9lLIau+LSTaYGBecg
         c09PCdIy7MGWf60pFLP9CpKUKQURIIiipphlud4vQUERg8B7slUp5Ybex8sgVlP+zSc4
         gsr3pqOqv/qTwghKLjWmrCWg22w/TaRRdL7SKbpi0YvVxovr5Qbn8+FTxeXhfFzok2GA
         +xdzEyj+GT0z3c/9lal0BPbX6NR6COMuG4IdadnF42kiFnQwQKLW0PvlIOR+bIf381ME
         L7JsOqTEbZEM/zFp5zot48uWLOPQZ4rsxktaLD5oXpoJir8tz3dsKktBHApXWP6kI5/7
         cSqg==
X-Forwarded-Encrypted: i=1; AHgh+Rq/1mCVbK9xb4M5c0Py3h4SGtuddUxYH6iIlwoCjiEfJw2PZwsaLMPdxcG3kIUQF3J8YatNSZzAUKo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzkg40eveLZzcTsifasXI1W8v4KgGBTiy3F5icXVaEUpmDp7Cdd
	RGaBSNhS5vh/DQkO46s82BR7kM7wfbOmIasfdIwQik0XOt/jQzSncHwE7580oI1FuSw=
X-Gm-Gg: AR+sD101v0xfk/tQSGYXia35dpf+XYpjV8zVDMyiwvSAeMOto9bkfse7LXw+76hxwIO
	J/+SUTUYTJmeHztNrnavoiVG/z9lFVFZhIziOV5EgA5Z5dWQCMCdmbFAFsISmzcsATHewdSLAqP
	59IvsUsU2zIEHT8/O4/ErEOp7Z3CMXTJfI/arOSRLYST7XmH1X04eUPgl+NP/QmPejPvcVIU9/W
	0GEZ+oxTP+j/d5szWz3gS9TK6BIqRkAU9JV0sppmknYvnzIR+WE2YFO4evseBbwddbpxJ5DxGlp
	tCPD6ar7SfvD/7S/af4BZHM+Bl49lAzgaD+rRW6hQACyagJeK/S4leMfjWpZ09lbEcPAqyX1Myl
	rBI4hxp3PaZ4uhpalATiQl9VlKVMsMXmjwrTryGJ608qQbVcEUkXeA+MXsTbr7/ht7RLs/oEeoj
	2B8QXl6llAVR98BlWQXjBl+s1+3a2flo+k+aX801xXWK9SMWH2M+VSf2IflQQO1/7vnjAevs4SJ
	g4ospphGkNDg54=
X-Received: by 2002:a05:6122:811b:10b0:5bd:7446:e3ff with SMTP id 71dfb90a1353d-5c3d8d2a974mr3435285e0c.0.1786403184503;
        Mon, 10 Aug 2026 16:06:24 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c4130b358csm4079079e0c.14.2026.08.10.16.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:24 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] xfs: correct the parent pointer space reservation comment
Date: Mon, 10 Aug 2026 17:06:16 -0600
Message-ID: <20260810230611.2859909-12-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2488; i=floss@jetm.me; h=from:subject; bh=NNh5aG4w7LlGxuf1r7SXWUFUWOyJJe//FeT84ioNlzE=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljTRG87aijZKn3RyqSuNdDpFcbWIcNNA3Fv LL1n2VxtmaJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 H97tDACNSkjSduKs7yBuGaO3TXyJA4JaR52PXs/TIUBjGAZfwm52F+FF8XJyZi4LHmlmVX/UXPq LiCiqQ/NYQ83y3zySj5iL0TYzIqJDUhBTGreX5eOIr+ORJF4tt+jtG8WsHuamds0yH0N2keUidf qfkLlPlAOk8FG3k1SBLiyRJ4DxFwP+IrKxtmFWVk4aX1yJ1ehjDjwvCFXpfJsAB6lD0idmfhtQE S0b5W2YDd5LCRbOLTufCUTEiOGVVqhdJSzsHdrpGBpndbxqutS2yzMoaN8n3frzqVs6J4dpgodb cIANkFdLugS2hY/xAVgWX/1OhTg+wFB2pa2PP+MzTKtZ1bs89+28HQNeOz7uv3Y2oYYDDsOT55T /7hFnweiBvYTZ47CScUQnzRgUyuEhHHq7eymAsHQvHXAqs1D5Cu2sggPpHHnJe4/Zum+vbJBN9q R0XbuTfcNO8Sitb1fYq0uBpIdeRX4/tpYCmaunqSy1mW7T1VadPpWUYqmUU2ykqBuNmOY=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

The comment on xfs_parent_calc_space_res() claims parent pointers are
"always the first attr in an attr tree".  They are not: a parent pointer
is recorded per dirent, so by the Nth hardlink the attr fork is already
in leaf or node format.  The reservation is still correct, because
XFS_DAENTER_SPACE_RES() covers a split at every level of a maximum-depth
attr dabtree whatever format the fork is in, but anyone auditing a
shortfall here is led by the comment to look for a bug that is not
there.

Rewrite the comment to state what actually bounds the result, and record
why the double split allowance and the extent-add term differ from
xfs_attr_calc_size().

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 9b8f495c9049..c4cd547033e5 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
 	unsigned int		namelen)
 {
 	/*
-	 * Parent pointers are always the first attr in an attr tree, and never
-	 * larger than a block
+	 * A parent pointer is recorded per dirent, so an inode with N links
+	 * carries N of them and the attr fork can already be in leaf or node
+	 * format when one is added.  That does not affect the reservation:
+	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
+	 * maximum-depth attr dabtree, whatever format the fork is in now.
+	 *
+	 * The name is a dirent name and the value is a struct xfs_parent_rec,
+	 * so the leaf entry is always local and never exceeds 272 bytes.
+	 * Parent pointers require V5, hence a 1k minimum block size, so the
+	 * entry always stays under half a block and this needs none of the
+	 * double split allowance that xfs_attr_calc_size() makes.
+	 *
+	 * The second term hands a byte count to a macro whose parameter counts
+	 * mappings, so it asks for more extent-add allowance than the single
+	 * mapping a parent pointer adds - how much more depends on the block
+	 * size.  It over-reserves either way, which is why it is left alone:
+	 * correcting the unit would shrink a reservation that is only generous.
 	 */
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
-- 
Javier Tia

