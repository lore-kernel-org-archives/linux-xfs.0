Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1598C11;
	Wed, 14 May 2025 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227864; cv=none; b=k7/tUosd9+BlJid+WJh8s2IvaWeZA+Su5QE84h0cIN6LpQ0Ukr1NlSwZjrMjSg22pG9PNY+WcixB1ZYhpVnYIUnQW9h4xxHVx7HRi/y8R2QxJcmbBPd+zddHixLlkwlN3rUf+HazWTC20Aspj5f6QOTXfb/i+6v8qLidzkK3+FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227864; c=relaxed/simple;
	bh=aoIgivyn3cMuGn3M6E7U0ZerjfJymRuR9xNII8UZZXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8eI4qpm5yK0dCfir3p6nnFiSQo+BR9le4qszu0a9Tcr8LMjWRQOyuq4jepsDwYJW+3577KeLmse3PPf061XGC2DAmzfArDdDMtDDq06lBmgw+QlvBYJ9QFGKdZmTj2MYyWbx3hcMXyUk0QeTrkaPlwBa5U8kZk6DQy1tdCGX9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7167E68BEB; Wed, 14 May 2025 15:04:17 +0200 (CEST)
Date: Wed, 14 May 2025 15:04:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org, cen zhang <zzzccc427@gmail.com>,
	lkmm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: mark the i_delayed_blks access in
 xfs_file_release as racy
Message-ID: <20250514130417.GA21064@lst.de>
References: <20250513052614.753577-1-hch@lst.de> <aCO7injOF7DFJGY9@dread.disaster.area> <FezVRpM-CK9-HuEp3IpLjF-tP7zIL0rzKfhspjIkdGvS3giuWzM9eeby5_eQjL5_gNG1YC4Zu0snd2lBHnL0xg==@protonmail.internalid> <20250514042946.GA23355@lst.de> <ymjsjb7ich2s5f7tmhslhlnymjmso5o2lsvdoudy3dtbr7vjwk@moxzvvjdh6zl>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ymjsjb7ich2s5f7tmhslhlnymjmso5o2lsvdoudy3dtbr7vjwk@moxzvvjdh6zl>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 14, 2025 at 10:00:28AM +0200, Carlos Maiolino wrote:
> I agree with you here, and we could slowly start marking those shared accesses
> as racy, but bots spitting false-positivies all the time doesn't help much,
> other than taking somebody's else time to look into the report.
> 
> Taking as example one case in the previous report, where the report complained
> about concurrent bp->b_addr access during the buffer instantiation.

I'd like to understand that one a bit more.  It might be because the
validator doesn't understand a semaphore used as lock is a lock, but
I'll follow up there.

> So, I think Dave has a point too. Like what happens with syzkaller
> and random people reporting random syzkaller warnings.
> 
> While I appreciate the reports too, I think it would be fair for the reporters
> to spend some time to at least craft a RFC patch fixing the warning.

Well, it was polite mails about their finding, which I find useful.
If we got a huge amount of spam that might be different.

