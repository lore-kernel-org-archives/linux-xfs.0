Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8B737D11B
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 13:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771938609; cv=none; b=DzGE04yB/IJhLmnZlKfhjNYZVPtc3VIBMGxz2dsAHRelGvey11fabadJ3ZYnZoK/nA94m4HlQHMFGRMgAU2tcUQ63ejpkWbHoLuHDeJxdR7uHKJ0ObFZZN4AT/FjE6gRZyzYcp+m7j4zQe5mL6XVNMeWA47Kj1ueA5egNLQcnXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771938609; c=relaxed/simple;
	bh=KRyQEqdx9nDxD05wNjoY0C4vqHurq7T/UtjpGKJqkio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSR4oPe4R9OzymDDlYyF5kquuW3xLGSlDVKOxupZXCfCdvvrh66vAa1yJgVPGv121tRO+bhMg5KlAbmDK8j02HDsUoVaNNGD8u7suF0uVrz9SOUKK9ohrQ4ZwqtfHTAgxVehu1Z178/agyYL7x25lgWSjgUJmhO43hHFOcAFEqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vBUnboDs; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vBUnboDs"
Date: Tue, 24 Feb 2026 13:09:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771938605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iHmLfEoIM1CK3zmKD5Au1dNJD5+SaRgc7xYd5V7yZqE=;
	b=vBUnboDszDrSTC7QiGdYqXIqUsnhzZtkBEA7USdkiADpAfHtm6T9DfjxqFbBXytJE/L6tf
	VArkOf8r/dQ6ACwRXGLIXwSKcO5/2Ce6K7WlXo7QHh9xSLKOPcT0T9ZXHVvQDlVPSJhahv
	JWl83yCyyqPB8h4ZtUK0L5NzrygQuY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <rn5qoix7rattqns5ut7q6wmasjm4x3usfbh5x4e7yg22fzpiqt@744cbmehelmt>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
 <20260220151050.GA14064@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220151050.GA14064@lst.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 20, 2026 at 04:10:50PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 20, 2026 at 10:08:26AM +0000, Pankaj Raghav (Samsung) wrote:
> > On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> > > Hi all,
> > > 
> > > Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> > > for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> > > remains a contentious topic, with previous discussions often stalling due to
> > > concerns about complexity versus utility.
> > > 
> > 
> > Hi,
> > 
> > Thanks a lot everyone for the input on this topic. I would like to
> > summarize some of the important points discussed here so that it could
> > be used as a reference for the talk and RFCs going forward:
> > 
> > - There is a general consensus to add atomic support to buffered IO
> >   path.
> 
> I don't think that's quite true.

Ok, s/consensus/some consensus/ :). I do get your concern that buffered
IO might not be a good fit for doing atomic IO operation (I also
mentioned that in the proposal).

As you replied, either direct IO or writethrough semantics might be the way
forward. That is why I mentioned the first step is to do a prototype of
writethrough and see if adding atomic support on top will make sense for
the buffered IO path.

-- 
Pankaj
