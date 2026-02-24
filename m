Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0C3A1A33;
	Tue, 24 Feb 2026 15:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945448; cv=none; b=gFwSU8enW2Qfr2F2xkMbpyQOcgKQWlmVLVzUsWRStVyMnb+uOjRg+sLvgu0hrnfWbq0bX2jfZxV1cSSaS2w/zpVLEE25+xs8p732uu/YcrYd3/LEDN/qfg2sfbo8qwj3NC2XZhltjUZGdKelcNSSGfDXECsP5UGUcHThm37vC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945448; c=relaxed/simple;
	bh=rWFO8CZOotuLVmwufovMRUQplJCgF3XyPfme8d4XwBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjBi89Ymh1A+Lb5b+SpRnN86JYWR+pf6MdbsN/WAToqIToOX5/7JD3GadM6YDXoD0sPkoDWgoID6Th6//6y2qKL+lQzei3B4/njboKtZ0GPp757F6lQQp/fUtJBbvEbcEEk59hFWv6XUNann+U2HctwA3AhprFc1Z28JZiXwWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F58568AFE; Tue, 24 Feb 2026 16:04:01 +0100 (CET)
Date: Tue, 24 Feb 2026 16:04:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260224150401.GA14612@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy> <20260220151050.GA14064@lst.de> <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 24, 2026 at 01:09:58PM +0000, Pankaj Raghav (Samsung) wrote:
> As you replied, either direct IO or writethrough semantics might be the way
> forward. That is why I mentioned the first step is to do a prototype of
> writethrough and see if adding atomic support on top will make sense for
> the buffered IO path.

Yes.  And even without addin explicit writethrough semantics, this
is almost guaranteed to be a win for O_(D)SYNC.

