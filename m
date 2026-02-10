Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2458E385526;
	Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737689; cv=none; b=KWJcdY/mBt3+N+oE4yo1lz4HfZk1afXbjEn0HKqB56yRVnCADCYpbQUjLUThYscb8aL/GyL62D8WjrWPW7IPJsqAlLkndnRy7xzKExdkI0QPA/QXZ+mRlr7RkgWQmRLrvvQR7oUdIGTKylSW01IcVkbuzaKkU2YOKDfqZPhp8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737689; c=relaxed/simple;
	bh=EEPkgTner+uThlcWIJo7lzklokUlur2thDRKzEhY0h4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hl01PJ8dszbjwjSXR4QnsQ0X3ehutTUgBu2R7a0lv34g3VCuJ/Gx2UsziKTUFw0R1mRXJQrETfJ5ztBWiat1aSziyoQqW5a6LM7GVzD61pi1HY/F/mdKlOiUp5pnTEoKatenaF3pK4VqTpwqPpk7w/myJvBK8gm85vhKw/fW2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1E7E68CFE; Tue, 10 Feb 2026 16:34:37 +0100 (CET)
Date: Tue, 10 Feb 2026 16:34:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH v2 1/2] xfs: remove duplicate static size checks
Message-ID: <20260210153437.GA31245@lst.de>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 10, 2026 at 03:59:41PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> In libxfs/xfs_ondisk.h, remove some duplicate entries of
> XFS_CHECK_STRUCT_SIZE().
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

