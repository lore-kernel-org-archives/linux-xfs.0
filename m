Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55453090D7;
	Mon,  6 Apr 2026 05:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775454671; cv=none; b=gTvnAMCqC5/CBquHlHVDId0Cq4Hjt+S6iKlHm0sMJbF8UrNR/JTAHdofy340XYFW5UEGqUfmzoXhKh5QyDMj42G36l80FZZCha9mwhWvITDzaKN3j6BscK3jinh51hQTbhpg0Sy7hK7pWARgXCAQgDWX7TnKC26gt1O/Wo5t2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775454671; c=relaxed/simple;
	bh=wrbOOn1wwoaAafTTBMhc57XErUqkzza255SfJkV25zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOuRnO7A8sG96rp+Tb7sF4uPoEZyw1X9e3fNSz23fzwcuCq8ehGMjK+lACOvev6CIl0TjGUm7UfzoL1eideXcsufQ8X7yQJwwbuGbObCaBTIKVqMjkQCeqCSdIpAM4wswI6RlzfHTfJIcfSPUY/oAiv+ArJI2iwdlCZud7+u2VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3B25968BFE; Mon,  6 Apr 2026 07:51:07 +0200 (CEST)
Date: Mon, 6 Apr 2026 07:51:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] block: add a bio_submit_or_kill helper
Message-ID: <20260406055106.GC16443@lst.de>
References: <20260401140433.125924-1-hch@lst.de> <20260401140433.125924-4-hch@lst.de> <dcb49ff0-fafd-42a1-addc-768912fba4f6@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcb49ff0-fafd-42a1-addc-768912fba4f6@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 01, 2026 at 08:42:15AM -0700, Bart Van Assche wrote:
> On 4/1/26 7:03 AM, Christoph Hellwig wrote:
>> Factor the common logic for the ioctl helpers to either submit a bio or
>> end if the process is being killed.  As this is now the only user of
>> bio_await_chain, open code that.
>
> There are two changes in this patch:
> - Inlining of bio_await_chain().
> - Introduction of bio_submit_or_kill().
>
> Please consider splitting this patch into two patches such that it
> becomes easier to review these changes.

No, not really.  We don't need a separate patch for killing a trivial
one-liner.

