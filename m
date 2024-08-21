Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787C1CDFB1
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724228687; cv=none; b=gxiCugJHU9AHREKKiAArBPMBPIisnqYs9GtHUIrXUhRrp084L89VjinjGwUqXI9icbMO8tuVrWK9+MXeLgIj5gQ7JW10UVgWi2hWqRh2+/XOQpnIr1LYgO3m26j8J3IonmWu6jbp3h3sDIfx83hSMhfovGA5JiPM0ID6v7TyHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724228687; c=relaxed/simple;
	bh=c/cIGm+l3IhzxLnCTKKpqBKBHV37OIBef9llsANa/kU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XUPIHRZj6R9Eb0iMB1b2PnDHMcEXjDH55q9ogbCGTF1lT76u8OJ7C4vWStIOCYcIfjOI60z8aHTK1Jn0LsKVFtzHvpa6U5QxjAenMI+EJ1z2//xbNa8TW0H4xPcWyrPMqRlCOu7gBGe0jyOluJh/pHMA3JoWGjxqM5Eu6a9sX30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CBE9F227A87; Wed, 21 Aug 2024 10:24:40 +0200 (CEST)
Date: Wed, 21 Aug 2024 10:24:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: call xfs_bmap_exact_minlen_extent_alloc from
 xfs_bmap_btalloc
Message-ID: <20240821082440.GA2431@lst.de>
References: <20240820170517.528181-1-hch@lst.de> <20240820170517.528181-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-6-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 20, 2024 at 07:04:56PM +0200, Christoph Hellwig wrote:
> xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
> xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
> doing the basic setup.

And the buildbot correctly points out that we want the following fixup
for non-DEBUG builds:

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 03b23875330734..0f793673d73dcb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3543,9 +3543,13 @@ xfs_bmap_exact_minlen_extent_alloc(
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 #else
-
-#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
-
+static int
+xfs_bmap_exact_minlen_extent_alloc(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	BUILD_BUG_ON(1);
+}
 #endif
 
 /*
