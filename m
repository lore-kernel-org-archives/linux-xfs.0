Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418694;
	b=jmtqJRTFbK0Ohe489wkvw5+r6o5jRLlle+JgcworgU7SILyl5okaqvKe8iBsCxyMWH+D
	 iAn7D4q05MhwvDB7IlB/A9JD7dex0HOQe6FMDKPUAZVXPO05HNrNZFPaSIYD5JKTu/YOl
	 n2GZkl1UWg2MD2AxniQ1S3464aIV2BeL6V6xVwL3WEaZ1AJDMr6pMa4N46m5CxYmR6WwI
	 1D5cPgQJvNzuPEOdOJ4nV1ucocPujAlBSdaJpcACwarMXcK/MYV+g+gmC3zuWV6XuOp9y
	 vnXRl3upicB+NbdE6DuRDireMWR5XeMv/UkuXTS3zwrZXI4IIoeqR+iUANT31z5e5eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418694;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=QfZOkxdocHjlP5SKjddvfyYbQDQx1L4acvYghZprYh8=;
	b=E1vgrztkkhO7pkumdKgVXcvLd5+CWqUc+8A96TvIyjpUcEnyGAK1snMHl6V3FwXvfEac
	 FSuCYTmeqDAKucVmi2HYouNudnKC3k9R1PmotLIPwXyxoAxqPTUwnni+sA4kCaiHFvrP+
	 VBgt59GkKCxWUZH6qCYY9h6cOkF0F6VUOJKG1mE/vNgv3GwXduxGEVyES0lvQGhPS/wjA
	 O/nOV8bazKBpddx0r1Gz0fUAd/8Ogh0iLIo83YaRGu58QTN8V//X3CbIc3apE3pla02GK
	 bsM+s4um7wKr2l2emJqc1Zo/+jT55Gbv1dKKbh3NeRJvJI9KnPiyQEyJDvTCahs8uew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105E3606A327;
	Wed, 11 Nov 2026 17:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 105E3606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 073AE68D17; Wed, 11 Nov 2026 18:38:11 +0100 (CET)
Date: Wed, 11 Nov 2026 18:38:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/25] iomap: add support for data checksumming
Message-ID: <20261111173810.GB20167@lst.de>
References: <20261104085929.317544-1-hch@lst.de> <20261104085929.317544-3-hch@lst.de> <avRO_O8jx3zrccGq@quentin>
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
In-Reply-To: <avRO_O8jx3zrccGq@quentin>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 12:21:07PM +0100, Pankaj Raghav (Samsung) wrote:
> On Wed, Nov 04, 2026 at 09:57:06AM +0100, Christoph Hellwig wrote:
> > Add a new refcounted structure for a data checksum attached to
> 
> I don't see any new refcounted structure. Probably the commit message is
> stale?

Yes, I'll fix it up.

