Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2352932C8B;
	Wed, 21 Jan 2026 00:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955960; cv=none; b=HAvfINbND4YQj8dfen9zF1QoCJyY89AYZRsgUoZuizAY6r/Rq2Y789uCVoyLZL+riS8s1qa6UA89EQBX9BqSYwvw726tHY9+pdUpvuft9aRunyVIpqpjMUZOzH14PWENDmsHqOCKHcdsMWcE4I9wzIpxtmqzrnziCYlS0GNv6zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955960; c=relaxed/simple;
	bh=Hk7DIvi+hIRD7Df5vMPjfB41RIxGDMn6Cr7vWqAtajk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dde9bJV6Rq75L+uNc6NIpLeZk2MdqmOYnjdK/pkx59w4pFBzQvxZieiEj5XtmRG6ILPzGrWASuLvE78x1e/STkeC+FX2ejY1/DePNeBOBsNuXzZEWXYAZcto+OHDI+6IKeC4irnrdYndaXdSbzctWb5R5J7WRvOqKoRr65I++ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUS/TMFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUS/TMFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC2C16AAE;
	Wed, 21 Jan 2026 00:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768955959;
	bh=Hk7DIvi+hIRD7Df5vMPjfB41RIxGDMn6Cr7vWqAtajk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUS/TMFEsT9fQlNrv8lmYNa3voNS5eawtqiNBCWDTlD4+JwiT+L8MCagDK/gHTz4W
	 rC2vVcXrWNfboCPOu9hNTr70uAXNdDhR/ErHEcHdVbOY/219CCb0hC5eSjUtvKeS34
	 fG6/ihHhoeOpvPqgy3FnPlcnc3LYIpdj66tb/usETeiQIHhsX6hXVZkaYVlnE0Y20k
	 2daQ/t5QfELZlLo5C08cxHCg2A4uaJvL3Ai6ZTkFZUjtAPZ42F3ozOo8EobKuyEJua
	 uy2E89BAECSm6TvjUgt/YD7AYHmCNWnup3tJphzrFnppp6Crc9BQ8IDSU0jCorOYUz
	 8LTjVyB01RyuA==
Date: Tue, 20 Jan 2026 16:39:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2 2/2] fsverity: add tracepoints
Message-ID: <20260121003917.GC12110@quark>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
 <20260119165644.2945008-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119165644.2945008-3-aalbersh@kernel.org>

On Mon, Jan 19, 2026 at 05:56:43PM +0100, Andrey Albershteyn wrote:
[...]
> +	TP_printk("ino %lu data size %llu tree size %llu block size %u levels %u",
[...]
> +	TP_printk("ino %lu levels %d block_size %d tree_size %lld root_hash %s digest %s",

Would be nice to make these consistent.  3 of the parameters are the
same, but the naming and order differs slightly.

[...]
> +	TP_printk("ino %lu pos %lld merkle_blocksize %u",
> +		(unsigned long) __entry->ino,
> +		__entry->data_pos,
> +		__entry->block_size)

Likewise here.  So now we have "block size", "block_size", and
"merkle_blocksize", all for the same thing.

> +	TP_printk("ino %lu data_pos %llu hblock_idx %lu level %u hidx %u",
> +		(unsigned long) __entry->ino,

And here's data_pos as a %llu, whereas in the previous tracepoint it's
just pos as an %lld.

> +TRACE_EVENT(fsverity_verify_merkle_block,
> +	TP_PROTO(const struct inode *inode, unsigned long index,
> +		 unsigned int level, unsigned int hidx),

And the 'index' here is what the previous one calls 'hblock_idx'.

I think consistent naming would be helpful for people trying to use
these tracepoints.

- Eric
