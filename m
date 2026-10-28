Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793204945;
	b=FE50RHY5WOUn16ApKOUmSJ6gKsvtGjnh4VgL6Lsd35j2ZmGWllAh0iDbqp+2wC7e/Nf3
	 +G93BfEJfi1de8nQobwPwHHUfDFQcTenhXd48ICjgFNSF12ofc1ySjm/xXYPTIhK8RI7/
	 /tAd0dyAagRqNzQvWpqKYy38vvMjw3BT7E/Lx+2tSz1ayEPBPGKDaelYb4CoBEuVw4AiX
	 cVezWhumYwDvAhHWIj6Wqy0khvu9ueCS1PBSr7yo16YQgIwJreeDWNjSpkC2aumqV2MTy
	 +shpf3Y50LkqFssxZ/6wwxHXyQNPNNytWCIFSyDuvQqrbKggPuMBl3nvbx27pZjsSXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204945;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=m3Qi8jh6bvyv+rU748JUDXbOoG8wQ0F9dt+Hesa3sxk=;
	b=U3m874+bspi81pwtCK/E+Lk3YWqNHe7gZCE+k2TTr0JqhkBfjE7i39mA46xvEKvTIMhM
	 qe/VPpxydZUEWa1ZGK+OYxSvlQZwGVoR1OjwQfuFIVXWYXwAfSbCd2P9nh93VbiKr3JeB
	 0xwG28xeUD62vsj5EnfSYobXH9HzN4RyxSFM0SRt3Ygv7rwFz+JMuC3KcVkZH41uCfk0R
	 vxrQw433KProb90KcN6QT9796a3Nm9y8hKRggvIo1ZrfCtmSKA9+Igxdiwj2WjPwQS8Jr
	 cYfKmt7fbMNyYDr88mUNL4QljaQOUfQLsaStBXdtd3xdLVU9MyFoZW9Ue/cO4apnCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E8F606A31C;
	Wed, 28 Oct 2026 16:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61E8F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C0BC768AFE; Wed, 28 Oct 2026 17:29:00 +0100 (CET)
Date: Wed, 28 Oct 2026 17:29:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj1072538@gmail.com>, hch@lst.de, djwong@kernel.org,
	cem@kernel.org, brauner@kernel.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 0/4] fs: support dma-buf backed direct I/O
Message-ID: <20261028162900.GA22640@lst.de>
References: <20261016091919.971295-1-anuj1072538@gmail.com> <4649a20f-aba9-418e-987f-66f21ab24410@gmail.com>
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
In-Reply-To: <4649a20f-aba9-418e-987f-66f21ab24410@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Oct 18, 2026 at 11:18:27PM +0100, Pavel Begunkov wrote:
>  	file_ref_t			f_ref;
>  	/* --- cacheline 3 boundary (192 bytes) --- */
> +
> +	/*
> +	 * A tag representing the underlying subsystem for dma-buf I/O.
> +	 * See struct dma_buf_io_ctx::importer_tag.
> +	 */
> +	unsigned long			f_dma_io_tag;
>  } __randomize_layout

Growing strut file into a new cacheline just for dmabufs is a no-go..

Also note that a file can be placed on multiple block devices when
using RAID or just btrfs placements (not sure about f2fs).

