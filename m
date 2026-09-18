Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45253457E67;
	Fri, 18 Sep 2026 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731162; cv=none; b=NmAJyTOysEnSkftKeo3wAYfue4alSghBUTW2GnEi2WVIZ9MeeKiEXK/mPeLk9yyihquWE/vO0OjJoGh5E0LQ+Sf2EAsRyUerz/rayGZzwCLJ+dfuW0JjIjXOt7n4SAHlbN1nDkVsP8xXhzGbYkLpp1VBMI4s6UTShSI+9yVSdAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731162; c=relaxed/simple;
	bh=cmjyhAdcK/WkgHdVostjGBFNXp2EakwTuOJEd9PSvvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mz+ZlnoTYhIJjItSUkiUIdC7KNA/gM+uQr3/+PTc4xlKJjQD0xMLCrYjiEb9GjXUUjtFqmLPkpn/i2HKkzFjNxDBX4NnlcRw73IMnbKH75wQutw3OnG+D9rtmzkgIO+9QNUfk2ouRD1aGgQVybIyr4U0W2kXeGbiOtAH8klHhko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfkKKvIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfkKKvIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B791F000FF;
	Fri, 18 Sep 2026 11:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731161;
	bh=Ij92FHptHJI6Kwyyc8AuywH9Pq/xn8IJW0Stq3h+K8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FfkKKvIh5sthZu2xEp5wPkjaYG2onLNKZ3PHcFHUpxrtYtQfch1RplxqAoUBAsBJp
	 cm2lj5OanGZyKR7SIXkaK1WnhNxHWZtX0M1SV2HKT2Fb2c9rGeC3IpKPdgjmwzfWHw
	 saR/+QX2xs3SUXYpBg68DmqX27hre4Pw3MvIhiqBZU65u6/xX3JwmpHZtldsvtuI37
	 sTWy7WD0rvDMWycFhXYuRMqXOz5dpyY5V8ZXXMPyKB+x8WSTqgHvckGJpewRA6mBGH
	 Q0FvjXIpF7cjOtu+2+LGY77SYdnj98jAb4m4+/REH+dj2VsQfHrd9beCiFaSg4S3BW
	 dm4HjWIr3az6Q==
Date: Fri, 18 Sep 2026 13:32:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>, 
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Message-ID: <aq0e9Ne7KJYMc21-@nidhogg.toxiclabs.cc>
References: <20260917200835.31027-1-lalitshankarch@gmail.com>
 <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
 <aq0dnoWhkq9JZkiu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq0dnoWhkq9JZkiu@infradead.org>

On Fri, Sep 18, 2026 at 04:16:46AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 07:16:32AM +0200, Carlos Maiolino wrote:
> > On Thu, Sep 17, 2026 at 08:08:35PM +0000, Lalit Shankar Chowdhury wrote:
> > > Replace kvmalloc_array() with the more concise kvzalloc_objs()
> > > implementation.
> > > 
> > > Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
> > 
> > NAK...
> > 
> > This is used to allocate composite objects managed through a
> > slab cache. This is not for fundamental basic data types....
> 
> I don't think so.  While the naming of the helper is a bit
> unfortunate, it is intended for allocating arrays.

I see your point, but what kv(z)alloc_objs() do is essentially

kmalloc(sizeof(object type) * count, GFP)...

While I see why it's useful for composite types, I don't see the much
the point of doing kvzalloc_objs(int, count)..
And still kvmalloc_array() looks a better fit in this case IMO than
kvmalloc_objs().

> 
> But this function really should not exist, instead bitmap_alloc/free
> should be switched to th kvmalloc family so that it will just work
> for large allocations and we can kill the wrappers in XFS.
> 

+1
