Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D26E28D836;
	Wed, 11 Jun 2025 14:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749651494; cv=none; b=W3PTdaT6KvoMX2GGyiTZzDHltNApsUNsG1aXdUDCb14iEVcJoRkrSS6V2pZodd3Du3ImOS+SQs4EOLrC2TorYs/+TD9hTPYE0kToyWNl5uZnY2/6CyaQitwuFw0rR8/ajb71xqvZr4EyH29/5ku/NSB4TL7UlbjhKzUFdDN5DvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749651494; c=relaxed/simple;
	bh=wY6dJHTDNov2eqWKUcwLqvIqYDbcn8PsLlSxvS2FhfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5taloyQ9jl4pK9fSAJAnYKwU8O0lkOR88MV4Nn4yYJbTt++cSG9Zot22BSHYCLswrrnjt4Gm/UpDSIYmlJX7oQ1ns58RLhFvADux5g4rOqnmaRkGj31T4c77efvloDuIokr0wIXllyykIKti+UrC1IoeYNdv2vgA9/5ca16tqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JH4S6Ola; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JH4S6Ola"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E5FC4CEE3;
	Wed, 11 Jun 2025 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749651493;
	bh=wY6dJHTDNov2eqWKUcwLqvIqYDbcn8PsLlSxvS2FhfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JH4S6OlaSh8JqI6zu5zUSkGa5EinX0oXb22CnsQYvTGdasbiEuPlVzQMtFEe6CRxT
	 XZXCxKIIbOaAgV4xKdb69Dkg5MvL+s7ddHOcF98YhFSX6uyHUYc/eHQsEfhitbLH3I
	 FpB248ftKWiPiUadq1u5g1vLQanlfttE97fCWHHLwlSPjzw9/9OBpBfwPek/CufV/o
	 iwjaS9UZrmjG/i59kZXJ53aTAGHv5FIPUxPa3HlKKHFjq3Znr64hjuDhfNCedxmADF
	 mWw/GAZ3+VQcRsDQ+tEZLh2CnyLFmQIHuntmtdyVmeR6PsocAy5E95bhq+swQefvjs
	 uZnXAEE+fHWpg==
Date: Wed, 11 Jun 2025 07:18:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Ma Xinjian <maxj.fnst@fujitsu.com>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/603: add _require_scrub
Message-ID: <20250611141811.GE6143@frogsfrogsfrogs>
References: <20250610091134.152557-1-maxj.fnst@fujitsu.com>
 <TFkjtpdcmBChUeSsNRmVqz65HKT2J13UyIyaxbRu8CFBo8VPvXETVgIR6QZLuGK5BLpZOgS_1KQaE27kWB5PMQ==@protonmail.internalid>
 <20250610144600.GD6143@frogsfrogsfrogs>
 <a3lsfm4pyryspt257eprspy6zapgkai5xubtcpxpw3edygurrn@7wfi73j2sbqt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3lsfm4pyryspt257eprspy6zapgkai5xubtcpxpw3edygurrn@7wfi73j2sbqt>

On Wed, Jun 11, 2025 at 02:50:11PM +0200, Carlos Maiolino wrote:
> On Tue, Jun 10, 2025 at 07:46:00AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 10, 2025 at 05:11:34PM +0800, Ma Xinjian wrote:
> > > From: Xinjian Ma <maxj.fnst@fujitsu.com>
> > >
> > > This test uses xfs_scrub which is an EXPERIMENTAL and unstable feature.
> > > Add _require_scrub to check if the system supports it.
> > >
> > > Signed-off-by: Xinjian Ma <maxj.fnst@fujitsu.com>
> > 
> > Oops, thanks for the correction.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Experimental has meen removed from scrub in 6.16, is this still needed?

Yes, _require_scrub checks that the userspace driver program exists.

--D

> > 
> > --D
> > 
> > > ---
> > >  tests/xfs/603 | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tests/xfs/603 b/tests/xfs/603
> > > index 04122b55..d6058a3e 100755
> > > --- a/tests/xfs/603
> > > +++ b/tests/xfs/603
> > > @@ -20,6 +20,7 @@ _require_xfs_db_command iunlink
> > >  # until after the directory repair code was merged
> > >  _require_xfs_io_command repair -R directory
> > >  _require_scratch_nocheck	# repair doesn't like single-AG fs
> > > +_require_scrub
> > >
> > >  # From the AGI definition
> > >  XFS_AGI_UNLINKED_BUCKETS=64
> > > --
> > > 2.49.0
> > >
> > >
> > 
> 
