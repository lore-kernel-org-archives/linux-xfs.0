Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275798;
	b=DVBFDaE+yS4WRxwLQAJq1rhdzasHzan37DrNBeLPYl8BwUoBLXw/OdbLHMAw59ygyyQC
	 yYrx3RZLDs6bhBUllAH6z9167XLCTjehnlkMUHGGEweholwu/C6X74eBaKBc4Y0jIrXu8
	 Q1GKFHrPAw946pGz77s281J2+Ql+y2ImvF8guR9mzjHDvhHoH5Zvrvqr45DAC9hglu1n0
	 m2cezr2M3mCZHdz4MYs1X9dwbl6VyBUuyQANLDGB5Mz44na/RPxJCseGKTa7BI0E0zDW4
	 GF1Iu/RkP+PIo6nnYbGPU4R/Qt/QVHZ+rm4gVhx5L3TcPKHGZbmld/K7H0NDz+O3LBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ep5xvhWczLZZx3IlL2iibxdd0CGO6TxlutNW+n0+Gw0=;
	b=K0riwFHw1xIqwRz1U9lSNRXsxUXcB3nouG3jJUf/hps5B1u4SVvPpRGgh2iH4hucQdWQ
	 v+IG8lIqG2w5y+3P++CM4YRPcEhVknz0mlKw87K+W1QpdPabuOWgemZNuy73qea5+/8HD
	 Hy6sGWcWZhUVnuvuvuDh0ciYtWBBn8BFaVrjIMGGZYXdPWRdEgFLXrNcr2x9s0iwlX7Jf
	 UHt1wsdsTCZo4ctJ8qvJSGEpbRRypCRhvkibB+7sY5qgyaUry2guKeyohMYW7vXqL0UcV
	 yd4XNaHGdXD/sCtCbX2HCjL9KBQrgoeXImbO95/1y2lPULeM3Bjk4LAZ8556w9tpzug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dg8BAOQP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174B3606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dg8BAOQP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA29E1F01825;
	Thu, 29 Oct 2026 12:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275797;
	bh=ep5xvhWczLZZx3IlL2iibxdd0CGO6TxlutNW+n0+Gw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg8BAOQP+9iHH+rRUJF//0MX0agdLtMHtvhg71vVrKOMSZi/wfPxi0dRQZL9FLjtI
	 f5HfkKIw/HCNnKhi2Jsomz9iowjHIBexkMoMXX1wuMZkaVzwoPqfmMjU4lQ3gpZbf3
	 IjXuaOVTU2f6EASHJQ0X50178TEt4inJRpI6r7GPB6j8FbvZQHRZP1YVU+XLssDqEv
	 rQP8e1sS7B+q02TdnsAT3X7OvgYROq4QrOUvpasEgvCmm3jnBFZOqzNuU2ql9GRnka
	 eYtkVUMJ9aTYqix8FMg+akPmGm/UslfUFDvC/U7skImHZNTN624HxUkBt8gbuSvv6F
	 FAKQWf6G7kK5A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 08/28] xfs: validate attr entry pointer before field access
Date: Thu, 29 Oct 2026 13:06:05 +0100
Message-ID: <20261029120631.803074-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongling Zeng <zenghongling@kylinos.cn>

Source kernel commit: b7eea80be25f3334f131d52982b3131aba77b97d

xfs_attr3_leaf_verify_entry() accesses lentry/rentry fields (namelen,
valuelen) before checking if the entry pointer itself is within bounds.
If nameidx is crafted to point near the end of the buffer, these field
accesses can read out-of-bounds before the bounds check at
name_end > buf_end is performed.

Add explicit bounds checks for entry pointers before accessing their
fields. Use offsetof() to check that the start of the flexible array
member (nameval/name) is within bounds, which ensures all preceding
fields are safe to access.

Fixes: c84760659dcf2 ("xfs: check attribute leaf block structure")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 86c5c09a5db4..b6288395f853 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -325,6 +325,13 @@ xfs_attr3_leaf_verify_entry(
 	 */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+
+		/* Validate lentry pointer is within bounds before field access */
+		if ((char *)lentry >= buf_end)
+			return __this_address;
+		if ((char *)lentry + offsetof(struct xfs_attr_leaf_name_local, nameval) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -332,6 +339,13 @@ xfs_attr3_leaf_verify_entry(
 			return __this_address;
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+
+		/* Validate rentry pointer is within bounds before field access */
+		if ((char *)rentry >= buf_end)
+			return __this_address;
+		if ((char *)rentry + offsetof(struct xfs_attr_leaf_name_remote, name) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
-- 
2.54.0

