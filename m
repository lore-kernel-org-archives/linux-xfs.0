Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795198956;
	b=epciReZdIBmwErBiq+DeybE3mtjEL2eNezR+/GZzmm0dMWFOCFmITS39Yax9jVggpidW
	 KeChbgoEmzsx73PM7ttgVpxhY87cNq1BM2BKwtxJHgd9mR9L7bkXiNvu+/21xC1OgE0wG
	 j7ZpP5SPD0+CHaWAEG4O35CsSSGL2tuMsH7a6Zi86xiAWFjNyquF/A+GQA3OysChLrDvJ
	 lpnkfePTpSpKO6rgDflioNVmYrPWNeFuWfW4JtQrwcUuODmDQ6vBqntHiXnlVJehR2gTw
	 Joj145AIJ0mmx0+CWnAeJcpdA2vPKoRMjgcU4njvM9YONoz9CCHseE1mJp+QvQ1RSEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198956;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=sa+1/YmJNGnPG162mxzehne/t3dD6A6hEWjE6oBnRII=;
	b=tU42wx98dvf3m84/ququ6N7uDPvml3VfSrJrRWLv49BsDa6YfUcqlLcoe6e5UYUJ70Ix
	 lN1LBbhPQf6JVTSAzS5OOwpKJ/NqWXtD7zsEYM7EPe5oAK/kzuBTu6t1NO6Rd7HCBRLRe
	 v2Uitq4eRSpWLehD4p/T7jzkqE/aXalbhd06epCdo1Zxv3SX1cEfn3s/FRBvmeqXEiNQA
	 jzzKiVgB/ChKpyly6YTVfK28xCXg90niA3vnU4701oaUjtV4b7zPX3NGcxRKWkpydJv5B
	 ++764oaercrZeM45CkgqKYwTWFCjjX2ud2LCCCnLrcF+3ZSNuHq5S8ygNWHfydZD+uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A277606A886;
	Fri, 20 Nov 2026 18:22:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A277606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A1F36732A; Fri, 20 Nov 2026 19:22:29 +0100 (CET)
Date: Fri, 20 Nov 2026 19:22:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: glaubitz@physik.fu-berlin.de, frank.li@vivo.com, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com, brauner@kernel.org,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 2/5] hfsplus: move file related operations to file.c
Message-ID: <20261120182228.GB2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-3-slava@dubeyko.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118004844.3849979-3-slava@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 17, 2026 at 04:48:41PM -0800, Viacheslav Dubeyko wrote:
> --- /dev/null
> +++ b/fs/hfsplus/file.c
> @@ -0,0 +1,127 @@
> +// SPDX-License-Identifier: GPL-2.0

This loses the copyright information from inode.c

