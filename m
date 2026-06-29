Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8A30C166;
	Mon, 29 Jun 2026 23:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782776945; cv=none; b=n3KJuBzaqplEvycAY2FYHo2lxogmKhvKwD+3ZxPEGWhPG3OBF2qlAdIYHrFCi990ieCzyMCJdaqYfcCBIhkkfYqq0BcQbr6k9nWp8w1LnMe/+v4kH8b5k/5zWFCrOUwgslc5ueq7sJmfqVuTiiXpwroZ1cooOjcNlFBoxQaEWx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782776945; c=relaxed/simple;
	bh=pwHCnUHSf7hYwpk0T9AW+6TJ1jEFo18xT4gss+zBufc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXdOPQLizIFyFncJYB6FYkV4atxJ1rUtE7n4cM+ayn8K6F4g+6OYuNsnLQu8cJ7lqVvi0Lo3P0SuvBfda5ANLzvO2EGKTUyyNc5uNOfcy3lPNYveIspJEedSVGsppxwzbD+YlTQxv+peqZL3LBRavvzqmpl04otaCPgclstaPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNAQFbEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNAQFbEX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 95CD21F000E9;
	Mon, 29 Jun 2026 23:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782776943;
	bh=cNUkZI/ilJkqBGVT9/+b827dpSw+DXeCtGiw1GbxoaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SNAQFbEX2Z1BX+qVuObElP5SFLn9u7Suk29aDqq4iB944wgDz03kd7abHdcaZcCwS
	 7FEscIHy0UXm6TCPSuGuNlNgU4RM29ic0X/Q8c0VU7HZ3JB+/TjQ/Z1RoReBcZMp3O
	 na9fsT02IPPEfZqaDl87FWXCrxOOkxGB+YfsVPJlA+5V3u50QagvjQCwoA62yZvn/E
	 GIpR/aMwG/JfEb+14VTAabbE8KrgRNrPyarEKivF7Uj/5n5X3bmIvWhhcYXNCsV7i3
	 XIIOoWgmijIy8oSCAFn5hqZN8LgMxwHumXXo+NWTTqW/QNGWnGEsgDGyQeZ5agqm/T
	 WWh3A37CxqoZw==
Date: Mon, 29 Jun 2026 16:49:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Yingjie Gao <gaoyingjie@uniontech.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: retry dqpurge when dquot buffer is busy
Message-ID: <20260629234903.GF6078@frogsfrogsfrogs>
References: <20260626095253.3445540-1-gaoyingjie@uniontech.com>
 <20260626205257.GA6078@frogsfrogsfrogs>
 <20260629124356.GA22595@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629124356.GA22595@lst.de>

On Mon, Jun 29, 2026 at 02:43:56PM +0200, Christoph Hellwig wrote:
> On Fri, Jun 26, 2026 at 01:52:57PM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 26, 2026 at 05:52:53PM +0800, Yingjie Gao wrote:
> > > xfs_qm_dqpurge() marks a zero-reference dquot dead before trying to flush
> > > a dirty dquot. If the attached buffer is busy, xfs_dquot_use_attached_buf()
> > > returns -EAGAIN.
> > > 
> > > The error path restores q_lockref.count but then jumps to out_funlock,
> > > which continues into the successful purge tail and destroys the dquot.  At
> > > that point the attached buffer has not been detached and the dquot log item
> > > may still be in the AIL.
> > > 
> > > Restore the retry behavior by dropping the locks and returning -EAGAIN
> > > after resurrecting the lockref.
> > > 
> > > Link: https://lore.kernel.org/linux-xfs/20260625175519.GF6078@frogsfrogsfrogs/
> > > Fixes: 0c5e80bd579f ("xfs: use a lockref for the xfs_dquot reference count")
> > > Cc: stable@vger.kernel.org # v6.19+
> > > Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> > 
> > Yeah, that's more like what we did before 0c5e80bd579f.  I think the
> > lockref resurrection part still looks ok, but maybe hch has an opinion?
> 
> But is it the right thing?  In dqpurge we really want to kill of the
> dquot, so doing a trylock is not very useful, so we really should not
> do a trylock here but just lock the buffer.
> 
> Darrick, do you remember if there's any lock order inversions we need
> to care about here?

I don't remember off the top of my head, other than (afaict) the trylock
might be a remnant of not wanting to block in quotaoff purge while the
QUOTAOFF log item is also pinning the log tail.

--D
