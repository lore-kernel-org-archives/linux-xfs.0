Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794498823;
	b=AlvwZ7v7OpRJm/7h5Z2FIdEsvyftrSWLSjCo9oyn5zyLwzYtITeOy7vybV5znglPAxXN
	 u2dyriP4yc24K9h2k9BOJ5opqyCHyteuPHjf8dtrHumIwSgxJaSV3V10iQCKp1HFZnTX/
	 l7rvquuQl1cZ2xqA7SvgfdnC6qb57LxQfIspbKD15JZbb4eT47CTs5UeZ23pHwm9mX9GH
	 fggUOtszHseqRw/MymHkcPduaVZeMXBcoudevrc8h3cVEvekVYN6WnQf5569815md51y9
	 loDMx1Qy1BjR/LkxjUEy+BINLIb4rvUyXMzsj1IX2qHiD0BpTG4ed3A6vtugGFPGS/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498823;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=m8VYf8DKPNVLIhZ7iDsTylr2SkKYoaAxGTCBsdGPsDU=;
	b=gtISaj7zzS4uGYgFa4D2VJCJ/Q5/94w6BH34sqbM6yTbl7I9U4ap3vgp/fa7DL/1cPbt
	 ViDBAeLTQ/xNA2Df/G2R7T1qLVO9+bPXg1RF6BxqBX+VUcqxsfH1WWAB8uGpR41c26L/w
	 AqUCQQxb9jH9dKILb0pgwiieilMu+1oURex60QZrjpMl6VcJ1AzLWMR4M0HjZ1V/dXa8T
	 8CQZsKH/K+uQmfGQ+kIrAOEKefpoZoCqbnJl5DTYB2x3Au3VjkmXIjFMZpKLHDi70n30h
	 0fXM7vgxeqqSSU/G6W4X6vJTI6zZZMp6GiokScmwTDqpoE/vXU+wR2chglM/gyW4bcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24320606A323;
	Thu, 12 Nov 2026 15:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24320606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C798568D05; Thu, 12 Nov 2026 16:53:31 +0100 (CET)
Date: Thu, 12 Nov 2026 16:53:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test that statfs does not report negative free
 blocks
Message-ID: <20261112155331.GA32171@lst.de>
References: <20261112154917.751315-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261112154917.751315-1-hengyul@cs.unc.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 12, 2026 at 10:49:17AM -0500, Hengyu Liang wrote:
> +# Only the data device counters are checked.
> +_disable_scratch_realtime
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +_require_xfs_scratch_non_zoned

Why do you need _require_xfs_scratch_non_zoned?  If this test is always
working on the data volume due to disable_scratch_realtime above,
a zoned vs non-zoned RT volume shouldn't matter unless I'm missing
something.

Otherwise this looks good to me, thanks a lot!

