Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795192993;
	b=x3oiYs7xn8BCMd7rA9OostRCtilHNylSGRfTdDe2CCvAwqTHvRolUgLH0BryQoN+OmV7
	 CJYpdResjcXF+Ys21gXOYIwNk66N+KZIvJMEbHC73BZyAr9u++u3BDZPABLnP7NF1rGlc
	 CqeYpEGhQ0uqiWnm4MaHetDfWRa1kytHhjkNYc0Bzl3GqnuEJqu29GsnTqN+TIE8wAfIn
	 qHUuckDpNJlkl88UqK1q/t2G87bIbCule3SV+saRqvFQMuTStyb6JmjNYC4Q1RWP7adZ6
	 +ytNmqSSm7bByBJIWFPOy3cUqgHaLcheurYkpnOkf1l8oJoVba5Z7hkKhJGnQV5zczw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192993;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=+31TwLq8mlbw/chbUXL8vDb3S/TW39pYqyiL0lr5JVs=;
	b=A3F8mIfK7TSbNEORSuLTU5QRGLGB54TbVAmVCDRvgSoh4+dBwytHri7TRC/WrCNeWDDg
	 Bc2ljGzJYJaDqehLUCPUM0YFCrOrbf6G9iK6qAq4aircdJqPOsehl23vVt2dvECpCvJWg
	 tEYmkoAP48oUM7jD6vpwH8hQya//mV88Tf+MZ+D5iaAnGjUJOaiq03j4qOlRGPJGSbKBQ
	 CTUyFn+/ts4m07sDPOe+NmRqiT8oPBVoLuhlEJciH56JPhaCYNVP+ZigkK3cZ7SoWotWR
	 6zo42FiFQYXWqcmXbeMXsZCuWr03s/HVAWrF9jZsMVXjKvgxoy4q7QKj4vVPj5Kroyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591D606A33A;
	Fri, 20 Nov 2026 16:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E591D606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE6396732A; Fri, 20 Nov 2026 17:43:09 +0100 (CET)
Date: Fri, 20 Nov 2026 17:43:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, John Garry <john.garry@linux.dev>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] block: fail short atomic bounce bios in
 bio_iov_iter_bounce_write()
Message-ID: <20261120164309.GB32683@lst.de>
References: <20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu> <20261120-gratwanderung-wickeln-mitkommen-1fa50bede59a@brauner>
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
In-Reply-To: <20261120-gratwanderung-wickeln-mitkommen-1fa50bede59a@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 20, 2026 at 10:04:37AM +0100, Christian Brauner wrote:
> No objections per se, I just would like see Christoph take a look first.

No fucking idea.  As far a I can tell atomic writes are a mess and we
should not have done them in the first place.  Ask the people who
create this mess.

---end quoted text---
