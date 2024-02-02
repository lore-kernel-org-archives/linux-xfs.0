Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5612C801
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706916824; cv=none; b=FBZ4IjF0QCepjIomhRPzxL7IInu/dvLRb2kTzaaqGOjvzJO4TFRCTqG7Zlj7Js7itUqaEf3xUjjto7vzn3dX0bFwsKezCtDU6XkBH6/OVcKMbYTeZ8xrKNXXvjW4CulXdQFBVC5RTTlLJNnDldNxAADZMc9lPzp8tlGAY9fxdHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706916824; c=relaxed/simple;
	bh=iclG1KsbI+k1I/nVcJPH01ea2c/wYs+D7WE/fFpi0gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jY+Jw5D8RaMr2GAFl4lx11t96LfKPvjICQUpv2dGI7kdiCB066uDHcCNdmDDPoJrQcStOgSYR0VvW+b2SGJ1IpjX+QcNzBw524dBvai0dI8t6DShnzowac9etkiHqKn1iWqCnZCUf8RpgLh5qlcPauTU/Sw3d+5tt9IdKzgcUXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVk9IhZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVk9IhZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FEBC433C7;
	Fri,  2 Feb 2024 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706916824;
	bh=iclG1KsbI+k1I/nVcJPH01ea2c/wYs+D7WE/fFpi0gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVk9IhZyRebqRixeMpXBHdLPubhnHt0P+rQ26oKMIKeEYccTHguVGlK+xpWvRCHQd
	 /yu/UPKovWFESKK5gtvpp+Q7EpYGKZ2+VTnQrnaSCtWtZrmh8yigBFIBGCCeYMxNEL
	 nv+fIVAfeAsFCdq7jkrzmKy6iYfbsu452Aqav3wiNZokrIkeJD93jP5BgJqnkIoM97
	 DTGaxxMuT06DlA7qNlGz9mVeKBCIMVWYJHi5pmW2JDPfYdQyqmTIHCxWRT/cn5m8nY
	 wsua8il4MJa+jxupy0wrLJE/0qIIQ/KA/OVcOpQJrsEfR63hjPsD1mMLqAhtFR2HG5
	 lsSdkSn+Fz+vQ==
Date: Fri, 2 Feb 2024 15:33:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20240202233343.GM616564@frogsfrogsfrogs>
References: <20240119193645.354214-1-bfoster@redhat.com>
 <Za3fwLKtjC+B8aZa@dread.disaster.area>
 <ZbJYP63PgykS1CwU@bfoster>
 <ZbLyxHSkE5eCCRRZ@dread.disaster.area>
 <Zbe9+EY5bLjhPPJn@bfoster>
 <Zbrw07Co5vhrDUfd@dread.disaster.area>
 <Zb1FhDn09pwFvE7O@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zb1FhDn09pwFvE7O@bfoster>

On Fri, Feb 02, 2024 at 02:41:56PM -0500, Brian Foster wrote:
> On Thu, Feb 01, 2024 at 12:16:03PM +1100, Dave Chinner wrote:
> > On Mon, Jan 29, 2024 at 10:02:16AM -0500, Brian Foster wrote:
> > > On Fri, Jan 26, 2024 at 10:46:12AM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 25, 2024 at 07:46:55AM -0500, Brian Foster wrote:
> > > > > On Mon, Jan 22, 2024 at 02:23:44PM +1100, Dave Chinner wrote:
> > > > > > On Fri, Jan 19, 2024 at 02:36:45PM -0500, Brian Foster wrote:
> ...
> > Here's the fixes for the iget vs inactive vs freeze problems in the
> > upstream kernel:
> > 
> > https://lore.kernel.org/linux-xfs/20240201005217.1011010-1-david@fromorbit.com/T/#t
> > 
> > With that sorted, are there any other issues we know about that
> > running a blockgc scan during freeze might work around?
> > 
> 
> The primary motivation for the scan patch was the downstream/stable
> deadlock issue. The reason I posted it upstream is because when I
> considered the overall behavior change, I thought it uniformly
> beneficial to both contexts based on the (minor) benefits of the side
> effects of the scan. You don't need me to enumerate them, and none of
> them are uniquely important or worth overanalyzing.
> 
> The only real question that matters here is do you agree with the
> general reasoning for a blockgc scan during freeze, or shall I drop the
> patch?

I don't see any particular downside to flushing {block,inode}gc work
during a freeze, other than the loss of speculative preallocations
sounds painful.

Does Dave's patchset to recycle NEEDS_INACTIVE inodes eliminate the
stall problem?

--D

> Brian
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
> 
