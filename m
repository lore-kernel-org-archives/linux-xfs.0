Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F77831A065
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291545; cv=none; b=lyeForMDIGJdHjnjiZvVz4k+P8QZl2FIffnqKyzqdFwl3V8k0K6a4u/MrO5+eD2ytJvglkmN/SbKptN/c0MzurP5EEwww20W7eYxo+ALOdyoD0K16cFu9aaY5GwdVr2klHP+HpOA3WOju+H+F+JDZcpYpN9Au+yu0YWDe+h4Yfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291545; c=relaxed/simple;
	bh=YFJemUPHfQmqPovfTYA80VU6llN+D+u/vaR/ByRCqsY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIKlhmd4onc8OA3x4OnoNHlRlZ87ODbuFvDjtWe1B+d1SRzmDhIz6I/CkVuhIPGE9/VlvVxNPLeBPerL/mJqevqwtdxnHK5YXlX+lWefCe4x7iNQi29Z6nb8KskmANGjUdIPvs/4Zy/+1I17pK5KZfoGvbsJ/EY28gzynYZCxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rakzel+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rakzel+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0C9C4CEF7;
	Mon, 23 Mar 2026 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291544;
	bh=YFJemUPHfQmqPovfTYA80VU6llN+D+u/vaR/ByRCqsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rakzel+9evI/I+8yXIzaOqC1n1sXYQeldJasVuJqQ/dJxlGIs8c9YEkWAkm+85fig
	 LTTcDI/wfPOsFg5Z71P4wJGvEsFIoUINSmoy27sCqnMzf7uAn82FbCfQPKK+XA5JYx
	 xQweKiG0K6Hu4wqkMEhv9CgpA5yPoz1g6VcaZYUXKrE1xbOW+43JUmkfYDjnK17ou0
	 1PBCtACH2MstlOzJuLARhicgD77vIC+bcsWgckb5vHkuEBH1vZZXUec0bfIl/nfejx
	 YdgXyg8pEhG6Vl07BnIf87rvwKcYzQx9AY7v+rEx3YX0xd0niJZw2RlSPfazuuUBRB
	 kJuUX4DlYeS9g==
Date: Mon, 23 Mar 2026 11:45:44 -0700
Subject: [PATCH 17/40] xfs: add missing forward declaration in xfs_zones.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dlemoal@kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <177429121053.2266274.14102282411701301645.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: 41263267ef26d315b1425eb9c8a8d7092f9db7c8

Add the missing forward declaration for struct blk_zone in xfs_zones.h.
This avoids headaches with the order of header file inclusion to avoid
compilation errors.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_zones.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index 5fefd132e002ee..df10a34da71d64 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -3,6 +3,7 @@
 #define _LIBXFS_ZONES_H
 
 struct xfs_rtgroup;
+struct blk_zone;
 
 /*
  * In order to guarantee forward progress for GC we need to reserve at least

