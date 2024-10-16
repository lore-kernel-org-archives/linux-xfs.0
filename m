Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732D221E3BA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 04:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729054601; cv=none; b=BEpBFFtwOFYTUQafSjE8A5nkV4jl6huKZ+I3rQ7fbyKIoOScQ8Laj7dkP1z/Q/OofiuMYYCWGfUH2ED9OEzegrlGkUypksSobMhhj0QdmrXq/OoUM5qS3jOlI7BDMVGvVLJGlFY16Gys4B9hOFXBNs0EF6nbRoD/z4iEAQgwDd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729054601; c=relaxed/simple;
	bh=Kaz8bU6SeNWzbws3j/CyAWMZkgnX9zUIB+kS1ToWHiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxB7nSZxdF9uWJXgikopuBlyQSaYf5HkKRYBNyiNdhCBOEPqtGyJNZ7PckBYn8wMfwvUJU1uVQq7l067DsCEg7tdcicgjQajvcOOaSTQ8cvcIxiFmXYMuFCM0A5K8FajPyqoCHpun73yHZiGs/Z35sLbGV82UDhyKDEsKEmzWfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmZusqq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmZusqq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42589C4CEC5;
	Wed, 16 Oct 2024 04:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729054601;
	bh=Kaz8bU6SeNWzbws3j/CyAWMZkgnX9zUIB+kS1ToWHiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AmZusqq2fGr59wjWSTc2DvOqttHNI91l6rntKX11QHVKV4suaJaevymUyrqooCtId
	 1TJ6eGJpivTqDt9tzo6BcckrRAAk7gHwd8tr/cPU4XnU+DCQYKYY77w3hhHEgzZ0xU
	 Jci8b6Ols5JxYG5KX9Z/lhfD5O/C3x6lynbUqHRH9DHtJVCUqGGCGQQfgd9b/5In3E
	 BmzG/W3lrDr1MkvT2OClWGOjota09UBFbrYbV173g94tMNkKCWrO6CjgMP1n0Nt9m9
	 ieJi8ogqAxbPa22UCOhuYTdQqywHpxo/RznunhuQlD8sQbpcQVsgMI8wt/qakMGKJV
	 I8uzrnatHZ2ZA==
Date: Tue, 15 Oct 2024 21:56:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <20241016045640.GL21853@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
 <20241015182541.GE21853@frogsfrogsfrogs>
 <Zw70vBF6adb0GAzA@dread.disaster.area>
 <20241016002051.GK21877@frogsfrogsfrogs>
 <Zw83h2swL9fqs3xm@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw83h2swL9fqs3xm@dread.disaster.area>

On Wed, Oct 16, 2024 at 02:48:23PM +1100, Dave Chinner wrote:
> On Tue, Oct 15, 2024 at 05:20:51PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 16, 2024 at 10:03:24AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 15, 2024 at 11:25:41AM -0700, Darrick J. Wong wrote:
> > > > > > +	if (xfs_has_metadir(mp))
> > > > > > +		xfs_warn(mp,
> > > > > > +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> > > > > > +
> > > > > 
> > > > > We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
> > > > > function to format all these experimental feature warnings the same
> > > > > way....
> > > > 
> > > > We already have xfs_warn_mount for functionality that isn't sb feature
> > > > bits.  Maybe xfs_warn_feat?
> > > 
> > > xfs_warn_mount() is only used for experimental warnings, so maybe we
> > > should simply rename that xfs_mark_experiental().  Then we can use
> > > it's inherent "warn once" behaviour for all the places where we
> > > issue an experimental warning regardless of how the experimental
> > > feature is enabled/detected. 
> > > 
> > > This means we'd have a single location that formats all experimental
> > > feature warnings the same way. Having a single function explicitly
> > > for this makes it trivial to audit and manage all the experimental
> > > features supported by a given kernel version because we are no
> > > longer reliant on grepping for custom format strings to find
> > > experimental features.
> > > 
> > > It also means that adding a kernel taint flag indicating that the
> > > kernel is running experimental code is trivial to do...
> > 
> > ...and I guess this means you can discover which forbidden features are
> > turned on from crash dumps.  Ok, sounds good to me.
> 
> Yes, though I don't consider experimental features as "forbidden".
> 
> This is more about enabling experimental filesystem features to be
> shipped under tech preview constraints(*). Knowing that an
> experimental feature is in use will help manage support expectations
> and workload. This, in turn, will also allow us to stay closer to
> the upstream XFS code base and behaviour....

<nod>

> > Do you want it to return an int so that you (as a distributor, not you
> > personally) can decide that nobody gets to use the experimental
> > features?
> 
> I considered suggesting that earlier, but if we want to disable
> specific experimental features we'll have to patch the kernel
> anyway. Hence I don't think there's any reason for having the
> upstream code doing anything other than tracking what experimental
> features are in use.

Here's what I have now:

enum xfs_experimental_feat {
	XFS_EXPERIMENTAL_SCRUB,
	XFS_EXPERIMENTAL_SHRINK,
	XFS_EXPERIMENTAL_LARP,
	XFS_EXPERIMENTAL_LBS,
	XFS_EXPERIMENTAL_EXCHRANGE,
	XFS_EXPERIMENTAL_PPTR,
	XFS_EXPERIMENTAL_METADIR,

	XFS_EXPERIMENTAL_MAX,
};

void
xfs_warn_experimental(
	struct xfs_mount		*mp,
	enum xfs_experimental_feat	feat)
{
	static const struct {
		const char		*name;
		long			opstate;
	} features[] = {
		[XFS_EXPERIMENTAL_SCRUB] = {
			.opstate	= XFS_OPSTATE_WARNED_SCRUB,
			.name		= "online scrub",
		},
		[XFS_EXPERIMENTAL_SHRINK] = {
			.opstate	= XFS_OPSTATE_WARNED_SHRINK,
			.name		= "online shrink",
		},
		[XFS_EXPERIMENTAL_LARP] = {
			.opstate	= XFS_OPSTATE_WARNED_LARP,
			.name		= "logged extended attributes",
		},
		[XFS_EXPERIMENTAL_LBS] = {
			.opstate	= XFS_OPSTATE_WARNED_LBS,
			.name		= "large block size",
		},
		[XFS_EXPERIMENTAL_EXCHRANGE] = {
			.opstate	= XFS_OPSTATE_WARNED_EXCHRANGE,
			.name		= "exchange range",
		},
		[XFS_EXPERIMENTAL_PPTR] = {
			.opstate	= XFS_OPSTATE_WARNED_PPTR,
			.name		= "parent pointer",
		},
		[XFS_EXPERIMENTAL_METADIR] = {
			.opstate	= XFS_OPSTATE_WARNED_METADIR,
			.name		= "metadata directory tree",
		},
	};
	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);

	if (xfs_should_warn(mp, features[feat].opstate))
		xfs_warn(mp,
 "EXPERIMENTAL %s feature enabled.  Use at your own risk!",
				features[feat].name);
}

and the callsite:

	if (xfs_has_parent(mp))
		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_PPTR);

> -Dave.
> 
> (*) https://access.redhat.com/solutions/21101
> 
> "Technology Preview features are not fully supported, may not be
> functionally complete, and are not suitable for deployment in
> production. However, these features are provided to the customer as
> a courtesy and the primary goal is for the feature to gain wider
> exposure with the goal of full support in the future."

Similar here, though we usually massage the dmesg text to mention that
only certain customers are supported.

--D

> -- 
> Dave Chinner
> david@fromorbit.com
> 
