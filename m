Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8178A3A1A38;
	Tue, 14 Apr 2026 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155053; cv=none; b=cu4529SjWx7eTH4CEnC4M93AYjabUVw/HwEe03Ky6kXbnlMVBRPgADkLJd0K+0VSOJ9f9vE/KU2NPyaXiqoLD2P+rMLgOWIdycEqXji6MQHIRaLxc1pkh4XbEv0ZTLUFYguh6kbzN9ZGicoiLGxhUWRFgIGQPmwUAw1aseXxO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155053; c=relaxed/simple;
	bh=dTMATmkItMXEV1SQYZZ4P7+Bbt8t3XatvgBmcTSPYJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jS42rLl+nKmdNuo40UBDb06EsTrqKaFiGfGXto4/RYYvNl3DTGYWujUEURMrJ0s2M913Wjy4L3jlZFqxcrzPhgcQi7x42XiOD0myGAt/n35bHiCUbCPhl7tcNz0ml2f+yfuyOIUvdvEn8sB3kfFx3BRQQtPkCIl5cAI/Dy3JJTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 312C768CFE; Tue, 14 Apr 2026 10:24:09 +0200 (CEST)
Date: Tue, 14 Apr 2026 10:24:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/5] block: add a bio_submit_or_kill helper
Message-ID: <20260414082408.GA11656@lst.de>
References: <20260407140538.633364-1-hch@lst.de> <20260407140538.633364-5-hch@lst.de> <b2e8e413-39bf-4255-8aad-a30d7fd676ea@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e8e413-39bf-4255-8aad-a30d7fd676ea@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 07, 2026 at 11:37:50AM -0700, Bart Van Assche wrote:
> Without this change, if a fatal signal is pending before the loop starts, 
> -EINTR is returned. With this patch applied, 0 is returned,
> isn't it?

I looked at this a bit, and it turns that while this indeed changes the
behavior for discard, the other ioctls had the return 0 when nothing
was submitted before the thread got killed behavior, and this makes
discard match them.
Given that we won't return from the system call for a fatal kill it
should not matter.  Adding Keith who wrote all this to confirm.

