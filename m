Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214836C0A6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103391; cv=none; b=FrYvA3wub+cQ45AO9sF0UupiNKXNlKW5+aK2me8PKPl3sF0qw/EgIe+oIIKM07KzUQEVIpGhel+2GqCqR98z+umAWGUHdneiyKQdUSCkjYnfBwlxJdfBOlnjEYDQ2DqzeS2gyQsoFNUGmvNadFs0rgfdDxdoKW4xian6S+TQs7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103391; c=relaxed/simple;
	bh=tUWU2sVrEhBhYlltIsXA97vRDKXK1l2wD3LkE0IUOxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWo5345JxVG0DWakIi9jhk8fuBQm4npnaeCm2CFyDLwDAwwAvH+d53SENSyBvQ6hw9nZ7yYQcTPPvuXAD7EbMRPyNDWFudVGmJHXvxqsaOtcfy0CYf+B0LHU+c9gihClR6JK5uDtofYlxDK37+3KuZWGgyYUlIn4ZDSGKC9oLyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOzDZ3Kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOzDZ3Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F02C116D0;
	Tue,  3 Feb 2026 07:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770103391;
	bh=tUWU2sVrEhBhYlltIsXA97vRDKXK1l2wD3LkE0IUOxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LOzDZ3KhJ0RUad74TMVfIV6anfJwfEeee2pUU6ftR3HnAHt8JAV25TfPXcXsBldad
	 LE+uHRlc0Gyv6w7PUJTRC2CXVrhhVKf4wA/VRWZT+R7792ltazYR/sN7QWqtukHK+B
	 Yqpacln2CFVGAMvKcWtiXo6mi3eDgss/3sm83orQxLI3Bs1zzn2hEOvFF12uuCMY8/
	 iAZzZ7e8Unb+bCzNsvPczw7IMP/EKa6m4Li71hPtVQ4xMPB+7K88YviiGS2RlMeJ1e
	 WXGPnCsr8uAYXAS2wKkj5GvY4Qh8BAVOMXX8n58OJg+wOQ1AXZx//R8QMCc9A1jL9a
	 rCwYObVful//A==
Date: Mon, 2 Feb 2026 23:23:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <20260203072310.GC1535390@frogsfrogsfrogs>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <20260130165534.GG7712@frogsfrogsfrogs>
 <aYBSzg3IhFffphuI@infradead.org>
 <698e4433ee0b01978deed124792c7e57@herbolt.com>
 <20260202185013.GH7712@frogsfrogsfrogs>
 <aYGE65iSRZWmxyVI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYGE65iSRZWmxyVI@infradead.org>

On Mon, Feb 02, 2026 at 09:17:31PM -0800, Christoph Hellwig wrote:
> On Mon, Feb 02, 2026 at 10:50:13AM -0800, Darrick J. Wong wrote:
> > > I do not have strong preference here.
> > 
> > <shrug> Since the original message said "krealloc prints out warning if
> > allocation is bigger than 2x PAGE_SIZE", I figured that meant you were
> > trying to mount more than (2 * 4096) / 16 == 512 different xfs
> > filesystems on the same host.
> 
> I don't remember any such message.  But array or xarray iterations
> should still scale well enough for a single mount time operation into
> the 10.000nds of entries.
> 
> > I don't have a particular problem with the array search and large memory
> > allocation since I never mount that many filesystems, but you would
> > appear to be the first user to complain about a scaling limit there...
> 
> I was really just concerned about a single large allocation.  But yeah,
> it's not that large...  That beind said I think the xarray version will
> also look nicer than the original one.

It's better than the raw kvalloc'd blob we have now :)

--D
