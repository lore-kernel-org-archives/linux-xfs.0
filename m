Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617136;
	b=yS/SQmjhre3QBvhS0Ng+/zPC6mq2ZbgUN9znUxzEEv570tC8+qK9IStDjgG7rn7qFjHG
	 ED1KtSyHyAp7P6/CUgbwVUGlnm1J+5fRsoEti6hhrnvSS/JyL7YYEoUBpeUGhjuSfVBYw
	 SP87SF52t3r4mlde3N35/V/2+t+mHvNtKi9jFj2CfDI9fhMKX8AAwBWJdj8Otrl0F5lqP
	 iG+l7DpXWMOsK+eNAsrbmBc81VX/kXawRqczy5Ymcl+NuYgEmv3Y/98/X+J2eja692coU
	 WTKrNnoNkSnAKF7vhOjKpTOxenD5IhCL70U7XYQ65ZzEFcJNNR7Wjz9JfeMHlKzdpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617136;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=PtRllFgQeaJJif96OcO1z/etvW3YwrHKGtxNZDdO9hA=;
	b=biOmP/0BXjlakA9eLa1wOVRwHPsnjgvlbLtBzXR+bpE1lcUkFWdyWTYJXLySfblgscJt
	 rKV/lmu/ijMuUFORxFrZaUpUeQ9UE1lbk9FJnhQgHfGCah10LWBMaWM5654qk8kfsG/5Q
	 /viBKwLzkxitx8NDomiEauoTFk8KghBejuY+N0dpC/+9K9GfS/W2U0XdE0Ayqt3339gB+
	 4uApSRIewgEkqaFczOZ+99JvTJVu9fNPMAFkK+UZESL/OSWSnAsn4SHNWM5sxLKwx0whB
	 C5gDf+t+wVWG4kl8MMmA11BJcf/8lJM9o1E8D+qEQrayUyX5W6/uPAvGtiV1bZD3XZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB6B606A32E;
	Wed, 25 Nov 2026 14:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAB6B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2966F68BFE; Wed, 25 Nov 2026 15:32:07 +0100 (CET)
Date: Wed, 25 Nov 2026 15:32:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <20261125143206.GA15229@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com> <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de> <20261125085814.GA24887@lst.de> <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 25, 2026 at 11:15:40AM +0100, Jan Kara wrote:
> I think we agree regarding the direction where this should be going :).

Well, that's good.

> Regarding the tracking of longterm pins, I remember when we started working
> of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
> to take pinned pages off the LRU (they cannot be freed anyway) and use that
> space in struct folio for the tracking we need. John? even had patches for
> that but the performance overhead was too big (primarily due to LRU locks
> contention) for direct IO. But for longterm pins, the additional overhead
> of the setup could be acceptable and that would significantly increase our
> maneuvering space in what we can do (because longterm pins are yet another
> page refcount in the end).

Yes, additional significant overhead for plain FOLL_PIN would be bad.
But for longterm pins it should not be an issue, as they should last
long enough to amortize additional cost
