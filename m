Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9EC24A069;
	Fri, 20 Feb 2026 15:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771600255; cv=none; b=TIiuTUOhuV/UguZRn+QyuViRszIOgjQpsptFolHv+KPU2iVhbx/VJIlG5q9AmHC1NZkdriX4+gDyTdqK3adHWkBg2PeahbtRQUSeyvXqmfGXyUhdGRkIJZQkYqIKhkmhFbTsMRzeJ9dRnhaLdbNZte5EvDdlvXc1gyFIJ3VjbNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771600255; c=relaxed/simple;
	bh=ENmU5+WPUI0R8hYUB4d9b1mvfoTENkFshgzopVSgLTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QenLX3bOvhlWnHZlN87wUYUHQsZk0VG2LOy/OOnlep9yQH0afpxf0PR4cetv0YVqlXIHjBj2z1E1Uzhh6WHBWino60DIrNEQwzV3Vi5T9qv5/gInm40cL82MwcMWXcrEFWLZUOpk1252XBWPmEq5ZO9WbrO898StdqXzWnqTblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 71F7668B05; Fri, 20 Feb 2026 16:10:50 +0100 (CET)
Date: Fri, 20 Feb 2026 16:10:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260220151050.GA14064@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjuplc6ud6ym3qyn7qmhzpr3jzjxpf6wcza3s2cenvmwwibbxr@aorfpiuxf7qy>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 20, 2026 at 10:08:26AM +0000, Pankaj Raghav (Samsung) wrote:
> On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> > Hi all,
> > 
> > Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> > for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> > remains a contentious topic, with previous discussions often stalling due to
> > concerns about complexity versus utility.
> > 
> 
> Hi,
> 
> Thanks a lot everyone for the input on this topic. I would like to
> summarize some of the important points discussed here so that it could
> be used as a reference for the talk and RFCs going forward:
> 
> - There is a general consensus to add atomic support to buffered IO
>   path.

I don't think that's quite true.

