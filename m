Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FF313D897;
	Wed,  5 Feb 2025 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778924; cv=none; b=QBx9OuNnCkoB67LvyDb2GfMWGs0q6PaDpw8ZoTnprX+31Na0qKO8jbHo0aDc0Cf8G4MXAAitNNA0igfLKYLnyxHf65wEnX+WFw1KdOqjdq9paDOykg7rX952yECD/RPzWtmhmHAOOJ5+rJvii7R7qkpGwIveV3vsKGpkF58y/+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778924; c=relaxed/simple;
	bh=myy2ZOd3qMSPrKDP9pA48Y435EiJJWdIpkDupGmiYsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvusBoLDfilSQSbJ5TrkzQPJ0YC0vnAlgoIeojuQE1s7PaeaakPYUt65xW8jcGGe9H3czyz1uWGJWV9vFxu5EmzNgaPapdGgafazr/FdL+lNRy7+y5nWcyQ1/SKjbJeVJjMlOqfXchMhqcb50IYAjjDHVWRYfcmKLIhuTDIk+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K3y4+kPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K3y4+kPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C230C4CED1;
	Wed,  5 Feb 2025 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738778924;
	bh=myy2ZOd3qMSPrKDP9pA48Y435EiJJWdIpkDupGmiYsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K3y4+kPsjYqEUaKEdXnCoP3Y9LZaOBBaGyKwXPEseWpUe3F8fwPq8JUOQVKk5o+/N
	 icFeaMnkXJggGokysAogU07iG7yuzz++PPH0RkUHg/dUba11h8ZxmKn7mXTMJC6j4g
	 sUeWgWumkpurZaiqPUso78VCeGjrAft84TjzdQvw4nyEsQMQV2McZ8btn4D5LkM1pf
	 8XE+QOhwhHiG+OXCr8FuV2xTiuw0WDKHkKL2dORza+FdJYZ2cMRg2yeayt7vT0l1eQ
	 y1XvS1aH9l0ejICq1d0ZG8qIy8n3CwAxWyQBzNzm2sIP9VxXJga511zWkVb5Jyhouv
	 1qvlsrT9m4EBA==
Date: Wed, 5 Feb 2025 10:08:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/34] fuzzy: port fsx and fsstress loop to use --duration
Message-ID: <20250205180843.GK21799@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406519.546134.6155766711303511656.stgit@frogsfrogsfrogs>
 <Z6K17JRSyAy4_RQI@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6K17JRSyAy4_RQI@dread.disaster.area>

On Wed, Feb 05, 2025 at 11:50:52AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2025 at 01:29:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Quite a while ago, I added --duration= arguments to fsx and fsstress,
> > and apparently I forgot to update the scrub stress loops to use them.
> > Replace the usage of timeout(1) for the remount_period versions of the
> > loop to clean up that code; and convert the non-remount loop so that
> > they don't run over time.
> 
> ....
> 
> > @@ -1115,7 +1124,8 @@ __stress_scrub_fsstress_loop() {
> >  			# anything.
> >  			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
> >  
> > -			_run_fsstress_bg $args $rw_arg >> $seqres.full
> > +			duration=$(___stress_scrub_duration "$end" "$remount_period")
> > +			_run_fsstress_bg $duration $args $rw_arg >> $seqres.full
> >  			sleep $remount_period
> >  			_kill_fsstress
> 
> Why does this need to run fsstress in the background any more? If it
> is only going to run for $remount_period, then run it in the
> foreground and get rid of the sleep/kill that stopped it after
> $remount_period. i.e. doesn't this:
> 
> -			_run_fsstress_bg $args $rw_arg >> $seqres.full
> +			duration=$(___stress_scrub_duration "$end" "$remount_period")
> +			_run_fsstress $duration $args $rw_arg >> $seqres.full
> -			sleep $remount_period
> -			_kill_fsstress
> 
> do the same thing, only cleaner?

It does, I was probably just moving too fast with the mechanical changes
when I wrote this.  Will fix for the next draft.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
