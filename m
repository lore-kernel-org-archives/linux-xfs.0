Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC82D3655EE
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589742; cv=none; b=rFetN3B9ri57mFJTFYWA3BD1bx0bifflmCye/eBuIB5m552uIaTJaczk07XEVAm7yiez+59aS1IiysVE2ti+Scorv8f3lvh0B79gULMJcW2pcA0GptbW3kDY9xXqavw3XWGLUQCa8nihVdc/Vh+U/7sYjy/z8mLs2AQX7KPdUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589742; c=relaxed/simple;
	bh=0FKvU6gSwOvxc0tUW8KL9GRyZJQIbaOeoxqB7ixQOsM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPPYTqAxUX5GDiPdn6L218VCVMpXWeJkUE7fKlJChrzwEvg+SKpqGI9lxpM9gcWEMNjlRG1HuL55s06CmpNZTGxncIio02WgeAqioSNDTYUnWNnoyVeKG/3u47X6CM/NZNoqBah/T39W8Lkz7ToeWzgB+153guvjGv9UPynfud8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqPRmBtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqPRmBtY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 82F7A1F000FF;
	Fri,  9 Oct 2026 23:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589741;
	bh=k/r6i+NerjGBe9Bsxr1051OFoj2HJxtATcbWi4ccy/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=MqPRmBtYsZt3iY06t3lsOEbgdETLotNtTN8X3MnZHsODepWcpVhuBMi6AEilPvCsi
	 /gp7pYdVXvLv2EB2cA6UHfwjSvZlMw486MMijI32+ebauhFuEQ1yzVCIM8dfmsSlNf
	 tSJWUhlNY6xEj56XpZ0QvRgbglZhj6jyms2W/iqbpx7iKVxBJ6vCDWgrPD1JBiEfNt
	 0njylCypgnlWeH7OKlR9/xAu3cnvbJGCJc4i35it2rZMSrIf/9bw+eMAXh4boeQcs3
	 jL9XvY7nbLzDV1PUUMTKQwZMVxivkRU8XVYg6jpxVSIQkwol46hq1HcLEEUePo54qM
	 LfXX8jKeKt+GQ==
Date: Fri, 09 Oct 2026 16:49:01 -0700
Subject: [PATCH 13/26] xfs: give the deferred barrier op type a name
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947604.3719791.4577274000913309790.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 libxfs/xfs_defer.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index d6e3e05f7a4960..3f53cd41235229 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -222,6 +222,7 @@ xfs_defer_barrier_cancel_item(
 }
 
 static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.name		= "barrier",
 	.max_items	= 1,
 	.create_intent	= xfs_defer_barrier_create_intent,
 	.abort_intent	= xfs_defer_barrier_abort_intent,

