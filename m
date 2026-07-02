Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD4385D97;
	Thu,  2 Jul 2026 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783031137; cv=none; b=cby76h9zhs5I5m1HB90qxqEZD7wAQUEGtXbnhNtxvzZE6943ggGLn63d1s12l6QE0iOoJVkxM3BWp11yzvCKQciG7LK1t0GSTLq9X8Q12LP1Waj/Njgr2MOiZzepXszBQJ1gjp3/RVXj+0O6lpPHZ9R9MY6tMTwO2Of787r0sHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783031137; c=relaxed/simple;
	bh=rYUZQU4IoRnRAd/35XA8va9YZ39q23yriUAvglcSsC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+++Z7u2tYfMAUL9E2CwML5GsnZsP41R/6j65iWIOgIZcvBuuahywKFzcv2aJu7k5hchL0iX+6QQnnkZzzZtBgw6VtPUEM4yR7vdQCtbRIIsdfGVTdYhTaXZefowrNmVmwHQMXYPWn7XBBuGlH1PL7nBIQva90R1al78tSefN8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/0e+aXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/0e+aXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B494E1F000E9;
	Thu,  2 Jul 2026 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783031135;
	bh=iEx8hd2bPMd7iqL7IWWUMNOa5KtZU8bVEw3FFSPuhSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b/0e+aXLv2cCNHCot7pa2lTHf3nRDTaLBBzpV0kGcFlMKG9HwNZtiQma7yjRb4SSe
	 Rvc5uEh5OjGHXCrbtzPwV0140dcuPbsRq0r55P3qoePRYLwRVM1MJ+by73r9g9WXPs
	 f7D+lPhJKeNReXDDuzMTqYphZTx1HD8p0S0jFuwPJffWCXj+6v2bJGwsV2ZnEUX1g/
	 qjQOjj7mjY2YY0u2POUk1XSH3uLX4SWhZw2qy4JBHOOLu8SDqGNnhL5ep4BlDUWpr8
	 t45Yh9+ZwGTdPydbNYHg9Ee+F4kODm0imoSHiAvfIrmgG4LXdUuqPq2s9A76PN2JT5
	 uGCwf2w0ql13g==
Message-ID: <faa6ca07-ddc4-4365-b1a5-8f02b32bfbbc@kernel.org>
Date: Fri, 3 Jul 2026 07:25:32 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>,
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260623142109.1838702-1-hch@lst.de>
 <20260623142109.1838702-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260623142109.1838702-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 23:21, Christoph Hellwig wrote:
> When using XFS with a main device on an SSD that stores metadata and a RT
> device to store data on a HDD, we fail to take the I/O sizes for the RT
> device into accounting, leading to up to 5% slower read performance when
> using an SSD for metadata vs storing data and metadata on the HDD.
> 
> Fix this up by taking the RT settings into account.  Note that this
> updates the BDI owned by the main device, and leaves those settings in
> place even when the file system is unmounted.  This is a bit unexpected
> but not different from manual tuning through sysfs (although that is only
> possible for the ra_pages value).
> 
> Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Until we have a better API to do this, given the performance improvements this
gives with HDDs, I am all for it.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
