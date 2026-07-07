Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA7935898;
	Tue,  7 Jul 2026 05:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783400685; cv=none; b=m/zEoF6yi8ADrHJ7zvznsTm9xcnr9aOqTkv/+KIJaOg+fKXDd3nwpn4+sGamJloRZbJhwjYKdh+9FD/w3uXkUp6u6B/wUm3ehSXGMtzHMMJGijxcRStMxtRlPiBzFKDWlge3IB85uIC1JvVYUak2hfU0dPNt1LSKUqDHx6M4inI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783400685; c=relaxed/simple;
	bh=122UnNb+3CsopEoMD25XKO1vWSRtcnHYelc+4XsXONk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcgN3buezy2/RLz5J4wFdYll+U6/eZCJm3URJ3LVWn5PyjOUxLgZV/K0lgcdx90oHRURyPsPGA1nGaf7ODXhUMqpz50xN/zrqh9+WArXK0T8xdXfhrpuRNn3cKbbu5IiLmrWeKmkIkiHFVVTq/afhuBTt0su4f1dx+QU8IQigKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BC1168B05; Tue,  7 Jul 2026 07:04:34 +0200 (CEST)
Date: Tue, 7 Jul 2026 07:04:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260707050433.GA12963@lst.de>
References: <20260629125229.3400726-1-hch@lst.de> <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-zitat-begossen-tapfer-0ff968ffa21a@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 30, 2026 at 12:59:38PM +0200, Christian Brauner wrote:
> On Mon, 29 Jun 2026 14:52:29 +0200, Christoph Hellwig wrote:
> > iomap: add a separate bio_set for iomap_split_ioend
> 
> Applied to the vfs-7.3.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-7.3.iomap branch should appear in linux-next soon.

Any chance you could propagates this to vfs.fixes?

