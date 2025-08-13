Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98FE23D7CF;
	Wed, 13 Aug 2025 06:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755066253; cv=none; b=L1Xa5CCP+mpEAb9tgkmoEOv6jeLc+4CpDbwq8gibi5dyrTlIdgtD8ESNB4ITHSh0S0EDd++c/tOaxSBYZ6qu+vRsEmNEPN6/ArIcrokJSfcheAV/OmjZTP8w/KGZe+q6XEJo3CEk9MeabrDhkr09px72fsEYQpA/NUkcEA4g1RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755066253; c=relaxed/simple;
	bh=tTtu3lAYSZ2g6pudhAAcHgwH7DVpotk0bve6JuhwFf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCNXRW89iGKia0lVb4r6uYot3tDUCUr7/uWlUEF7IfG6mbjlhF901FxK2t1SAq9e45YxM3000fuAC5KIFmJ3NuWA+wtBpNo8ROlItWBTdjG22iSEslTk3PwVbOGOhAMtpNwWrjRnxKZvaLlEkstl+0e9F7d5c5z4cKazTacozo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EJinVF5S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EJinVF5S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=54LJmhJljoMGWoOaJ3VCI/+s1nNBIJe6jafJebmvdgA=; b=EJinVF5Si1aKxAZsH5vvRVOxOi
	VtjzpgHd8Uyo0t1nxYbJB9XweNHFLDP1rItSDpJv6WPwgUdqD+YuXzKsMKTR8Arm7ol7KlbLcgEQy
	ST6H6iuCbXZ7pNfs2mjLjvhpib0sX7bQgFyKKuvS8WwElDGdQ6LqsrEErUW7ubjxQmnHqOQIhkO1w
	u2nmtL7pGId7NR3ifJ5F4brjCwEEZs6jflLxakR1JerNLa5J5dvX9gEBTBkH3aC49NGHA1dfXLjbH
	QetekfjQdoMzdvB3IHpnZGONIGt196ioKZftOrG3zvoUYyEKlzaMilCZak5nikSmLfMtolBEzXCe7
	IGPCkgUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1um4uB-0000000CmBy-12Y3;
	Wed, 13 Aug 2025 06:24:11 +0000
Date: Tue, 12 Aug 2025 23:24:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <aJwvi03EX0LWzXfI@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
 <20250812185459.GB7952@frogsfrogsfrogs>
 <aJwfiw9radbDZq-p@infradead.org>
 <20250813061452.GC7981@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813061452.GC7981@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 12, 2025 at 11:14:52PM -0700, Darrick J. Wong wrote:
> Yeah... for the other ENOSPC-on-write paths, we kick inodegc, so maybe
> xfs_zoned_space_reserve (or its caller, more likely) ought to do that
> too?

Can you give this a spin?  Still running testing here, but so far
nothing blew up.

diff --git a/fs/xfs/xfs_zone_space_resv.c b/fs/xfs/xfs_zone_space_resv.c
index 1313c55b8cbe..9cd38716fd25 100644
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -10,6 +10,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
@@ -230,6 +231,11 @@ xfs_zoned_space_reserve(
 
 	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
 			flags & XFS_ZR_RESERVED);
+	if (error == -ENOSPC && !(flags & XFS_ZR_NOWAIT)) {
+		xfs_inodegc_flush(mp);
+		error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
+				flags & XFS_ZR_RESERVED);
+	}
 	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
 		error = xfs_zoned_reserve_extents_greedy(mp, &count_fsb, flags);
 	if (error)
