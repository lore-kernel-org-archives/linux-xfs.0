Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6644062F;
	Thu, 24 Sep 2026 22:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289202; cv=none; b=gbn9XxCync9kgf185/ERJMVeyi6rnfLu7V591DjpexreKjyqVCuIwSZQnzVtbgqXPkJHXVpFxSRr+/Xdz0yR8FDN4PJbz7vWXu0ecyOVVLkxWH+cyJaqbIOiNfInFzSYT1B8MTPsQmhaeCVwIlwGOC9NcdQeGPrSjMGuWN/DJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289202; c=relaxed/simple;
	bh=W054aJWmlJHKzW6oPx8VKYQYVWiaXOeKtfexZkmp3l8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROHM4JOup70Bma+CmMiWi+slEn5L5+XJ/ZS5RpAFWFNAWNYYvXow5Wm3IcZk9FzH3BeQtdy1ppdLb4CpyP1/djsFb3YjVR4MECGpeH1cdb4xBw8VssmO57njWZOm7bInz2as1jQ1SuaXG1ZToEMMbFBRcaGvS5MppYNUBkBENmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byj9zyCW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byj9zyCW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 283E61F000FF;
	Thu, 24 Sep 2026 22:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790289201;
	bh=UMuARAtDk+W4Ll03EVKTtXobHLWpPxSvvRkgfOhlfSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=byj9zyCWzZYfUWl7Kz0a+puoEIWhKEy7L2TVykloMkuWOLFtVVUvpQXg6WxFYnk0X
	 J/MZSh8jcoqGqq73NK6ehY9iKEsOmzrvQHW1J/pqelacY8KsUdT77+ZlmDuI9JQBiR
	 NzIYVTpmWEatLbH0x7VzQEXtKffluVbcGF/ksnwVTswamb2FN6+zH1ydhCMqZluXb1
	 dnverRGFm6NQNylDCZGjca7nRKHCbBR1uZJLIPOXMX0NeVOY7001QcvFFfbDLihJ2T
	 5amcJzHr/b9/m8p6BOJnOS/qTpQfl2aNP9kbSepYpIUNiw6VBgDa9c3kAvUKcPMWBn
	 UorU1DnAVzvsw==
Date: Thu, 24 Sep 2026 15:33:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] iomap: don't resubmit an ioend after
 ->writeback_submit() failed
Message-ID: <20260924223320.GL2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-2-parri.andrea@gmail.com>
 <20260924184910.GI2705364@frogsfrogsfrogs>
 <20260924203013.9967-1-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924203013.9967-1-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 10:30:07PM +0200, Andrea Parri wrote:
> On Thu, Sep 24, 2026 at 11:49:10AM -0700, Darrick J. Wong wrote:
> > I looked around the codebase and saw that iomap_writepages also calls
> > ->writeback_submit.  Does that need to null out wb_ctx?
> > 
> > My guess is that none of the callers do anything with wpc after
> > iomap_writepages returns so it's not harming anyone, but we should drop
> > the stale context too, right?
> 
> Your guess is right: that ->writeback_submit() call is the last thing
> iomap_writepages() does, and all of its callers (xfs, gfs2, zonefs,
> exfat, fuse, ntfs, ntfs3) have the wpc on the stack for that single
> call, so wb_ctx is never looked at again.  Christoph made the same
> point on v1 [1], and the last paragraph of the commit message now
> spells it out.
> 
> Clearing it there as well would be harmless but dead code, so I'd
> rather leave it out; happy to add it if you feel strongly about it.
> 
> [1] https://lore.kernel.org/all/arITXTsUhrA0N-qr@infradead.org/

LOL ok thanks for the reminder.  My brain is fried this week, in a good
way. ;)

--D

> Thanks!
>   Andrea
> 
