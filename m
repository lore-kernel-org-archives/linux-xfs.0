Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72573148312
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 23:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721777392; cv=none; b=nXvtHlShypHO5OJ814Q8sCH3XfakppdZgn8OmHkrq/y7/ECVn7biKzx1q7Pgbkx/YzukPukqpgSRAAH81XlnU6A359/qvI0VFr8IyFZ1RRs+Kp6sLzZgkKOChjCx8CVu2VuifeOVpDypQ8gqBZFmLP0biCHOIndT3NCdUbc+qQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721777392; c=relaxed/simple;
	bh=YQ+AGSXiLaZrVAEGxX11k++cezNLUMJ1PytUX8m0YBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fJvr/2OKd6qHdS6aqX233jGYODOWSgYHgkkzcyPeNiswO02Y4AyD24Ao3rniqfCoyOedqfF9wMwkF4l29ZGGQhVWIAO8SUNIa1OnHzfgqA4on/Vhc1e3sbf5yPbE8r0j9QFEYYpJt5RewkxsVlfbGEJQ4sNzwa1bvjdkr/VyD5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1NlkSb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1NlkSb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA783C4AF09;
	Tue, 23 Jul 2024 23:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721777391;
	bh=YQ+AGSXiLaZrVAEGxX11k++cezNLUMJ1PytUX8m0YBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1NlkSb2zhdTgi03nMLVMtssbW/wxlBQfIayu2uP111u8hEOU8hyrHr3LwVwWrL/k
	 gmuQ1F6HHDnJDGQcCO1SPSD7P7wlK1saWMl+NYvYDTCE6CDorp9AWY64gq9dShumf/
	 +oMMZ49wNHi6tIDFnOIY6+MSdX4xa/7ngc6xURWimQ7YwVYfOYtSPMocZLZV7/mWPj
	 4ZvACQeN+1O/+q0hJIgRjbdJC1Mhf42ILM8gL4EEtBT9rTQkanqANoMmKeoweiylaH
	 c77WKYrgn37ojRRMfbfetEb86r28DQ/6h3IbimtYAgEFJTDt9ejaVGNMN2PecLJ+sr
	 1U0Sk4Nkl0U9Q==
Date: Tue, 23 Jul 2024 16:29:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services
 by default
Message-ID: <20240723232951.GT612460@frogsfrogsfrogs>
References: <20240703043123.GD24160@lst.de>
 <20240703050154.GB612460@frogsfrogsfrogs>
 <20240709225306.GE612460@frogsfrogsfrogs>
 <20240710061838.GA25875@lst.de>
 <20240716164629.GB612460@frogsfrogsfrogs>
 <20240717045904.GA8579@lst.de>
 <20240717161546.GH612460@frogsfrogsfrogs>
 <20240717164544.GA21436@lst.de>
 <20240722041229.GM612460@frogsfrogsfrogs>
 <20240722123449.GB12518@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722123449.GB12518@lst.de>

On Mon, Jul 22, 2024 at 02:34:49PM +0200, Christoph Hellwig wrote:
> On Sun, Jul 21, 2024 at 09:12:29PM -0700, Darrick J. Wong wrote:
> > You could also do:
> > 
> > for x in <ephemeral mountpoints>; do
> > 	systemctl mask xfs_scrub@$(systemd-escape --path $x)
> > done
> 
> That assumes I actually know about them.

True.  So, do we want a compat flag to opt in to online fsck?  Or one to
opt out?  Or perhaps filesystems without rmap or pptrs aren't worth
autoscrubbing?

> > (Though iirc xfs_scrub_all currently treats masked services as
> > failures; maybe it shouldn't.)
> 
> Independent of the rest of the discussion it probably shouldn't.

Fixed; will have a patch out shortly.

--D
