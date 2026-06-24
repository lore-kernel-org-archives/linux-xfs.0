Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79744223708;
	Wed, 24 Jun 2026 10:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782297656; cv=none; b=mq+uurG2emdEveyiPWqNEY4yYPGSn8dsl0z/kzzLjqRuzg1PRxWwkSiDHK28HPaGgyQ2MZjLFhiNmwUFPvWP0JV2hMKu7X6I3Of/vjCoDdqxn+AZmwJ+FR451I438B4Pz8piCSx3v+1oEci5KW8ncZ62CkBQ/dD64UQtj+ZMYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782297656; c=relaxed/simple;
	bh=ajGgeyYncEaHvrt8qvqergJfnTM/ArTYVdRgQ4eYPkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+zmdcm57Uf8XWLWZfBZkWCOlPjb+gIzKRAfPzXvxHnSsYTWtbt8XHAP5mkBayvmErlNwjzWkpkuD1Km4m5j2EJ8UIrJV/nxSQE7Xu3PpVFmVVWamj9eU9zjk3866GQykUYc6IfAxDqzfXbC5lfiCjNb9jzTPvVJuatil7cUlnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBnTQocR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBnTQocR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1181F000E9;
	Wed, 24 Jun 2026 10:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782297655;
	bh=JkNPLU40GXU7jQSvyKS8fifL1izzRSqGX7zJnJXQxKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UBnTQocRXi77/kvdQMJDb2buTezeVch5WZmrcSDXefnqedsBIsR5JJj1fa7KfeFn9
	 r867yGK8QxoFO3Lj0PF2IdHNOuF09e2aNBZteHyFKZAsRwnqh4/hiBASUgpygngXt4
	 XS6yRXD4IjMQFCpROoNBw6VHuU6dO6tHCbVepgu+ECdB1paEPrFkXqUnND8GkeEPy+
	 OMoKsb2P0GvubRCIUuthiHPHwnIvBzXKkfxa/qy3wDVUdSdZ7vB22YZhRf3VEx5GQT
	 OS4RsFolgVnhY/jrCBUfWn/CrgGEcaLWTW2zfv4JeROky8uv33qieTMlpkaAtGmMF+
	 sDR6OHvxzauyw==
Date: Wed, 24 Jun 2026 12:40:50 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>, 
	Matthew Wilcox <willy@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <ajuxIMzTbzxEuX5g@nidhogg.toxiclabs.cc>
References: <20260623142109.1838702-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623142109.1838702-1-hch@lst.de>

On Tue, Jun 23, 2026 at 04:21:05PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> we ran into a bit of a funny case where adding an SSD to store metadata
> to a (zoned) XFS file system reduced the performance vs using a HDD for
> both data and metadata.  It turns out this is due to readahead code
> looking at the BDI limits, including the io_pages value that can't be
> inspected or tuned from userspace.
> 
> This patch has the simplest fix for that by just updating the values from
> XFS, but for a long-term solution this feels a bit ugly.  Other, a lot
> more invasive options would be:
> 
> 
>   1) support multiple BDIs per file system.
> 
> 	This would work pretty well for XFS, as data for a given file is
> 	always entirely on one device, and the VFS writeback code is not
> 	used for metadata.  But it probably doesn't work well for other
> 	cases

Giving the current tendency of filesystems being multi-device, this
doesn't sound bad IMHO. Wouldn't accessing io_pages of each BDI also be
worth even for a journal dev? I wonder if what you ran into wouldn't be
possible if somebody would be using just a SSD for journal and a non-rt
XFS on a HDD or a different/slower device.

I don't know how stupid that sounds but perhaps it wouldn't be that
complicated to support multiple BDIs without making it unpleasant for
filesystems that don't care?
sb->bdi could be turned into a dynamic array and a new sb->s_devcount
fields to keep track of it on multi-device filesystems. Filesystems who
don't care about multiple BDIs would have it pointing to a single BDI
struct. Again I feel I'm missing something, so it might sound really
stupid :)

> 
>   2) stop propagating these values through the BDI
> 
> 	Have a way to query these parameters from the file system, either
> 	through a method if we want to be fully dynamic, or through fields
> 	instead of going through the BDI.  The downside would be that
> 	sysfs modifications of the readahead size would not work after
> 	the file system initially queried them.

It doesn't sound bad, but to me, not better than keeping multiple BDIs.
But my lack of knowledge on details about BDI handling might be hiding
something from me.

> 
> Thoughts?
> 
