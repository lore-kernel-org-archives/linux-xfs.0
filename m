Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960810;
	b=cbYs+/32nkNEOizRZ2V+Y12Zas15hqYrm3ToVff8e3O/qgw1ym+Mp0kCXdioPjBRN/mx
	 TyM1bwtNeaQFkbFWZtL8JTprC8wlw6vqkCSVuL/c3ycUWloeflq65jEC2FVUGadFnELeI
	 CdNyWU6elTqsK8JYk4AFJ8zpyloAOoWqBJU5RVEmxo56Auu13J7GH2QiJFE8sHsP/4gCk
	 kQ8MZNN1JmPWJcAQSvvC9cNahxqlAo9UA+haIAyugzGXmA7HxhlB3ClH4I0ACJPvlLNCQ
	 NLgMWfJJaCqGfU/i8HTySgT0TVfzUfxZ6QQNGV3BoTxmEMqJdJU/jKkbhjJNUrYoK/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960810;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=IDd0PkFD96tB3HX+cbmDGfBHoWFdw6mbsKQkNBRynhjJwGw37+R2HasWRLbTGX98Ynxh
	 LPag0cxO2xlodq+uVRgNahAhHliFqDVPBouusU2awVSKEXbKDzHEqy0g0tBHPyVfo2NCL
	 48qd0wX8F4ir17deA9bHk2jfBdi9jvpGapbu84FqZNChIX8O1ws8Npf4kltzuO4FENy7A
	 cIf1YhjEhwKK1Ydy5XHvSMElSB6JJnaBZnyMBU27uEy8xIEShZl9/UYyh0e8tyM09rg6L
	 tvm6U0dSKyuTOfrKlA3pSkl9PsW8bAZjGZTeAAsHb+2BzJTZXmjsAJ0PoflWSJjU/fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27453606A32C;
	Fri,  6 Nov 2026 10:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27453606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A031B68BEB; Fri,  6 Nov 2026 11:26:45 +0100 (CET)
Date: Fri, 6 Nov 2026 11:26:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev,
	dsterba@suse.com, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jaegeuk@kernel.org,
	chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261106102645.GB5319@lst.de>
References: <20261105115532.613467-1-aalbersh@kernel.org> <20261105115532.613467-3-aalbersh@kernel.org>
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
In-Reply-To: <20261105115532.613467-3-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

