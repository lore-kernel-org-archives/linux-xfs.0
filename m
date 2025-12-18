Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF51821773D;
	Thu, 18 Dec 2025 09:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766050555; cv=none; b=T5cfTgB7Gksn1QbLWNqoWjpdkv7EQ7ABwzhIapKkPdcaEMCWxK6dkqLvGPhG0kZZ5cNGqGjuBnbt7Ho4NWltFz65dUCxKxs8HKvryWwvLq0ADv5S2RMo6qUuSBTvJ1GFbEDB8Il5bO6V8sYxE934t/1yf4hR21scS8G9kMbj3B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766050555; c=relaxed/simple;
	bh=KsziqKqgTLyBtdcS2PnFtdunbQVwJwzGSiHRWprY5Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5/w6yVPbS4oc6HH2XYOjw2satX/tmFB59ztV0bVQKb22NImC7hoqmcP5R6g6GoFbmqMLUXym5u2rn2iSAXfNVRY/0O8FA5It9aQnrv8VGJa5yMyOgtEz5IBt4ugInhHsjD0v2ABnZO/mBMmtaiId5wBcFjcVnMZNgCElvMvCLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F116F68B05; Thu, 18 Dec 2025 10:35:50 +0100 (CET)
Date: Thu, 18 Dec 2025 10:35:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <20251218093550.GA10201@lst.de>
References: <20251218063234.1539374-1-hch@lst.de> <20251218063234.1539374-2-hch@lst.de> <b5dbf7d2-8e4e-4a96-a04b-a14ed83beb2e@suse.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5dbf7d2-8e4e-4a96-a04b-a14ed83beb2e@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 18, 2025 at 10:20:31AM +0100, Hannes Reinecke wrote:
> 'reuse' has a different connotation for me; I woudl have expected
> a 'reused' bio to be used for any purposes.

You can reuse it for any purpose.  That's the point - it keeps the
payload, but you can resubmit it.

