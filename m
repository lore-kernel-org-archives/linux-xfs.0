Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275820;
	b=F0aWFry1EUkZtj8SKSjrgnG1mI3b5Q/pXkwpDwKMQz5cIQcyfuidbl8Dm6cT5BaR0Psv
	 HyJGtgoWzAoK9BRqOfvNibuhPO7BYO0V5TBSOtulDFm0kTVEAvdqyIT1UZEVWsSEkNl1s
	 ryRk03UbB9Z9ASqYuBwSkJt8dofZe0y/vjNT/03PfxFnfLEBBoC+G5ZUMrACV1UIx1+Sl
	 17seg9HSflSFF7deRI6JqKKUiKyvcKIJaKNmxpq6rVs8chG1EfO/0OXqBz/RVGv7ioW1X
	 JDD7lRT5T98UUEuIawIGsO8gdVADX/l6fYf/7L/n/u5bXpFw33tVkQKYOIyfYpZVNYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=n7W5kEK35SAYpuMZv56I+hSsV4aDuu+dHLsT2OFe8Eo=;
	b=rTFQLVNDQyloroogbimk0YrOWBmNJsHXKtN7Hnf9hJ190fNPAocWxOtAxCpmLA89u3qy
	 hWSU+EtG1sDWUJF2BCVVX/9uWXqUtVZcuTs99EIJq/ACNZf7p6uZMBuOKQcUKW25su1tU
	 1Z8iJY2wt582cuWJ87TOR8/jbDkhfPb7uLP3hLAlSL4vmwO12Ea1NCYipN0UDHmbLXB7Y
	 LAN2yruP3dmtL7AmcXgxF+B5Y+8S1XlTbQ3tlejTMpu+1aVSdewQTCbNeRrql7r3RUioh
	 sVbpUCCAWqeN4fEp05OPL27PDrNGHCJrFHcQG9Qb0HBK9ptZlg2Rvx3obuGffXuYc3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NeOrWKZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F572606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NeOrWKZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B426C1F01828;
	Thu, 29 Oct 2026 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275819;
	bh=n7W5kEK35SAYpuMZv56I+hSsV4aDuu+dHLsT2OFe8Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeOrWKZIa6W5XxRj9EumyrPqK+VecnkBoZ7h7MgHrGuSDCRrIWhyZVvZ8uR/DtI3c
	 KpZTZEqQUrs/8uuukGMcyaxuEvuHTHg1MMts7Mkp1TGoAegmQ2nxSGeZ2V52Lu+I2h
	 ghRNlr5BPQbvB5vDVCZ7Vbz1Q32QzDpEBP0sAAPzZfO3xsX4BRWI0hRZtSYDO61nee
	 qHMcHrSOepqE6LdQ9mbH092HdGVy97zrVedHXUDVVBDgHRD/Od3y49wwFwznMjGK5U
	 HNW4MTPWSW0jLQJkp87q+lqxs8fPwpbF7gS9jl3wSIs35eWT0TEHwy5FHSmfkDOARl
	 9duXsTT7ZjF9Q==
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
	zenghongling@kylinos.cn,
	Javier Tia <javier@peridio.com>
Subject: [PATCH 13/28] xfs: give the deferred barrier op type a name
Date: Thu, 29 Oct 2026 13:06:10 +0100
Message-ID: <20261029120631.803074-14-aalbersh@kernel.org>
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

From: Javier Tia <javier@peridio.com>

Source kernel commit: 91c15cee394e9958898ef1ed55d9ced4c26e2800

xfs_barrier_defer_type is the only xfs_defer_op_type with no .name.
Every other one carries a short string used for tracing and reporting:
attr, bmap, extent_free, agfl_free, rtextent_free, refcount,
rtrefcount, rmap, rtrmap and exchmaps.

That has been harmless because nothing dereferences the field, but it
leaves a NULL in a table where every other entry is populated, so the
first caller to print it gets "(null)" in the kernel and undefined
behaviour in the userspace libxfs build of this file, where xfs_alert
lands in fprintf.  xfs_defer_add() already treats a missing member of
this table as worth shutting the filesystem down for, so an unpopulated
one is out of step with how the file handles its own ops tables.

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4aa232fbd214..6c247d73cf1d 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -226,6 +226,7 @@ xfs_defer_barrier_cancel_item(
 }
 
 static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.name		= "barrier",
 	.max_items	= 1,
 	.create_intent	= xfs_defer_barrier_create_intent,
 	.abort_intent	= xfs_defer_barrier_abort_intent,
-- 
2.54.0

