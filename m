Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A82428DF07;
	Tue, 25 Nov 2025 06:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052510; cv=none; b=EuHQa6fz98zjxb4EadYfGoP4+glZ3feFYLZWRG2uv+i3xR+Ab/H1nwL3+1i29/LSoNHhckBrIXFmFJJIYlVqPZCnCw/oe8IWdNsoGhuQDUlANQ8jcKbBw5JIvatQQo5eEXc/y4Jzqg6D+FlPp2L/TDENTBSpht2FkfzLYiGOOCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052510; c=relaxed/simple;
	bh=qcJKguKnvjfow2UPj/VYVJZFhuWA02Yw0wBHbOzOM28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnEC4uabZZkLVrgPVEx4w+joxy8jQu+rIf5ipxmCDuEQUnfP4MaBmpSSFJ1wO9Wb+P7pm1SXHzBdtJio1rJwiKlwUh34cZwdJrBKAIWxc237F0ZJlzroM17FSQDAuUVSiD1WbezY+ZDcavbRSh4jc7iM8o4I2OCUkvcZYkKRpXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 31FCA68BFE; Tue, 25 Nov 2025 07:35:06 +0100 (CET)
Date: Tue, 25 Nov 2025 07:35:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	syzbot+a2b9a4ed0d61b1efb3f5@syzkaller.appspotmail.com
Subject: Re: [PATCH] iomap: allocate s_dio_done_wq for async reads as well
Message-ID: <20251125063506.GA14851@lst.de>
References: <20251124140013.902853-1-hch@lst.de> <aSTR3GHyAZKdRCqo@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSTR3GHyAZKdRCqo@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 25, 2025 at 08:45:00AM +1100, Dave Chinner wrote:
> But I can't help but wonder about putting this in the fast path....
> 
> i.e. on the first io_uring/AIO DIO read or write, we will need
> allocate this work queue. I think that's getting quite common in
> applications and utilities these days, so filesystems are
> increasingly likely to need this wq.
> 
> Maybe we should make this wq init unconditional and move it to fs
> superblock initialisation?  That would remove this "only needed once
> for init" check that is made on every call through the the IO fast
> path....

I agree, and I originally did that, and it caused a long bikeshed.
So not feeling like reopening that can of worms right now even if I
agree with the sentiment.
