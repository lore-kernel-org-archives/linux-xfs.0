Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE321CA0D
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752078958; cv=none; b=ElSPxZ/XGRWK4AEMCN0MC+d5CHNJq1Ev9hsH15u1kmhxUbJQZBSr/F0sHgy24L95YrtGRLvLZ39r+V/Q/blY1jFrl+l3ZfYMXUsqPpvKFU4zfQuFjpA1/7XxdRBMiIyTvHNRJ3riQYxsbcjxlZBImjDSI/kjhegnVmZmqOKcv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752078958; c=relaxed/simple;
	bh=5/2n3eEkEsTvDiXizKubVbnJeKIwprNABI1rQjZroHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMciUrIFTBJ2LX/OWcpON9PIWYRCX9nAOiRM8HBi23fTtobPWlWqO7eZ4iDR+l1pTfe8U7rLap7pjcpsKTkrMIAUCIY4IxhWxepryDJna1r9u1vw4efLxRpOr33WYCuv3sJqpVBqrVgCSn1rnWQL3G/gmpBIMaLL+5DHiZ7+2lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgztE6X2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgztE6X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E25C4CEEF;
	Wed,  9 Jul 2025 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752078956;
	bh=5/2n3eEkEsTvDiXizKubVbnJeKIwprNABI1rQjZroHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MgztE6X2jLPZgvMRRvMjrO3ke6ldLNXmXQEEI3sDjGfSzc6CfdiLfGH+w+T9PG38o
	 RJT2BZ4ET9dsdqNZnaN4VRJsqu1e9c03k+QisUXG9vzDp3u2DYFqvm9p679yoNkhTA
	 nCuLwwbNCLwqnSrQ2+PwPwnDQu/RXh6kVQtlsoSR1MteiP5KlaN24qsvcyeB5M5hEk
	 2/dk6YfhLyBtOlLS8DcECY/hcxO+3WDeA6buokZKfwOS1J/PFnE5MTxoqk1liDqt0R
	 MVsPIbI68ros+eBPD/wo3xI7pieERitonO1kgv6oxBVyjYAQjcmzK0O3O8LDjqTiy7
	 GIoGyMpcfBHwg==
Date: Wed, 9 Jul 2025 09:35:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, catherine.hoang@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_db: create an untorn_max subcommand
Message-ID: <20250709163556.GH2672049@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303875.916168.18071503400698892291.stgit@frogsfrogsfrogs>
 <ede6d2ff-62e5-4b82-95e7-edb683199aca@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ede6d2ff-62e5-4b82-95e7-edb683199aca@oracle.com>

On Wed, Jul 09, 2025 at 04:39:12PM +0100, John Garry wrote:
> >   };
> 
> Generally it looks ok, just some small comments.
> 
> If you are not too concerned with any comment, then feel free to add the
> following:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>

Thanks!  Replies below.

> > +STATIC void
> > +untorn_cow_limits(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		logres,
> > +	unsigned int		desired_max)
> > +{
> > +	const unsigned int	efi = xfs_efi_log_space(1);
> > +	const unsigned int	efd = xfs_efd_log_space(1);
> > +	const unsigned int	rui = xfs_rui_log_space(1);
> > +	const unsigned int	rud = xfs_rud_log_space();
> > +	const unsigned int	cui = xfs_cui_log_space(1);
> > +	const unsigned int	cud = xfs_cud_log_space();
> > +	const unsigned int	bui = xfs_bui_log_space(1);
> > +	const unsigned int	bud = xfs_bud_log_space();
> > +
> > +	/*
> > +	 * Maximum overhead to complete an untorn write ioend in software:
> > +	 * remove data fork extent + remove cow fork extent + map extent into
> > +	 * data fork.
> > +	 *
> > +	 * tx0: Creates a BUI and a CUI and that's all it needs.
> > +	 *
> > +	 * tx1: Roll to finish the BUI.  Need space for the BUD, an RUI, and
> > +	 * enough space to relog the CUI (== CUI + CUD).
> > +	 *
> > +	 * tx2: Roll again to finish the RUI.  Need space for the RUD and space
> > +	 * to relog the CUI.
> > +	 *
> > +	 * tx3: Roll again, need space for the CUD and possibly a new EFI.
> > +	 *
> > +	 * tx4: Roll again, need space for an EFD.
> > +	 *
> > +	 * If the extent referenced by the pair of BUI/CUI items is not the one
> > +	 * being currently processed, then we need to reserve space to relog
> > +	 * both items.
> > +	 */
> > +	const unsigned int	tx0 = bui + cui;
> > +	const unsigned int	tx1 = bud + rui + cui + cud;
> > +	const unsigned int	tx2 = rud + cui + cud;
> > +	const unsigned int	tx3 = cud + efi;
> > +	const unsigned int	tx4 = efd;
> > +	const unsigned int	relog = bui + bud + cui + cud;
> > +
> > +	const unsigned int	per_intent = max(max3(tx0, tx1, tx2),
> > +						 max3(tx3, tx4, relog));
> > +
> > +	/* Overhead to finish one step of each intent item type */
> > +	const unsigned int	f1 = libxfs_calc_finish_efi_reservation(mp, 1);
> > +	const unsigned int	f2 = libxfs_calc_finish_rui_reservation(mp, 1);
> > +	const unsigned int	f3 = libxfs_calc_finish_cui_reservation(mp, 1);
> > +	const unsigned int	f4 = libxfs_calc_finish_bui_reservation(mp, 1);
> > +
> > +	/* We only finish one item per transaction in a chain */
> > +	const unsigned int	step_size = max(f4, max3(f1, f2, f3));
> 
> This all looks to match xfs_calc_atomic_write_ioend_geometry(). I assume
> that there is a good reason why that code cannot be reused.

Hrmm, that /would/ be a good refactoring opportunity.  Oh, ugh:

STATIC unsigned int
xfs_calc_atomic_write_ioend_geometry(
	struct xfs_mount	*mp,
	unsigned int		*step_size)

Ok, I'd have to get that into 6.17... :(

> > +
> > +	if (desired_max) {
> > +		dbprintf(
> > + "desired_max: %u\nstep_size: %u\nper_intent: %u\nlogres: %u\n",
> > +				desired_max, step_size, per_intent,
> > +				(desired_max * per_intent) + step_size);
> > +	} else if (logres) {
> > +		dbprintf(
> > + "logres: %u\nstep_size: %u\nper_intent: %u\nmax_awu: %u\n",
> > +				logres, step_size, per_intent,
> > +				logres >= step_size ? (logres - step_size) / per_intent : 0);
> > +	}
> > +}
> > +
> > +static void
> > +untorn_max_help(void)
> > +{
> > +	dbprintf(_(
> > +"\n"
> > +" The 'untorn_max' command computes either the log reservation needed to\n"
> > +" complete an untorn write of a given block count; or the maximum number of\n"
> > +" blocks that can be completed given a specific log reservation.\n"
> > +"\n"
> > +	));
> > +}
> > +
> > +static int
> > +untorn_max_f(
> > +	int		argc,
> > +	char		**argv)
> > +{
> > +	unsigned int	logres = 0;
> > +	unsigned int	desired_max = 0;
> > +	int		c;
> > +
> > +	while ((c = getopt(argc, argv, "l:b:")) != EOF) {
> > +		switch (c) {
> > +		case 'l':
> > +			logres = atoi(optarg);
> > +			break;
> > +		case 'b':
> > +			desired_max = atoi(optarg);
> > +			break;
> > +		default:
> > +			untorn_max_help();
> > +			return 0;
> > +		}
> > +	}
> 
> From untorn_cow_limits(), it seems that it's best not give both 'l' and 'b',
> as we only ever print one value. As such, would be better to set argmax = 1
> (or whatever is needed to only accept only 'l' or 'b')?
> 
> > +
> > +	if (!logres && !desired_max) {
> > +		dbprintf("untorn_max needs -l or -b option\n");
> > +		return 0;
> 
> similar db command handlers use -1, but I guess that it's not important here
> since you just rely on the print message output always

I think you'd have to set argmax = 2 to pick up the parameter, right?
And then you'd still allow "untorn_max -l -b" which would immediately
fail, obviously.  But this works just as well.

> > +	}
> > +
> > +	if (xfs_has_reflink(mp))
> 
> this check could be put earlier

Sure, but what would be gained?  All we've done so far is parsed the CLI
options.

> > +		untorn_cow_limits(mp, logres, desired_max);
> > +	else
> > +		dbprintf("untorn write emulation not supported\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct cmdinfo untorn_max_cmd = {
> 
> it would be nice to use untorn_write_max_cmd

<nod> I'll s/untorn_max/untorn_write_max/ in this file.

--D

> > +	.name =		"untorn_max",
> > +	.altname =	NULL,
> > +	.cfunc =	untorn_max_f,
> > +	.argmin =	0,
> > +	.argmax =	-1,
> > +	.canpush =	0,
> > +	.args =		NULL,
> > +	.oneline =	N_("compute untorn write max"),
> > +	.help =		logres_help,
> > +};
> > +
> >   void
> >   logres_init(void)
> >   {
> >   	add_command(&logres_cmd);
> > +	add_command(&untorn_max_cmd);
> >   }
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index 2a9322560584b0..d4531fc0e380a3 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -1366,6 +1366,16 @@ .SH COMMANDS
> >   .IR name .
> >   The file being targetted will not be put on the iunlink list.
> >   .TP
> > +.BI "untorn_max [\-b " blockcount "|\-l " logres "]"
> > +If
> > +.B -l
> > +is specified, compute the maximum (in fsblocks) untorn write that we can
> > +emulate with copy on write given a log reservation size (in bytes).
> > +If
> > +.B -b
> > +is specified,
> > compute the log reservation size that would be needed to
> > +emulate an untorn write of the given number of fsblocks.
> > +.TP
> >   .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
> >   Set the filesystem universally unique identifier (UUID).
> >   The filesystem UUID can be used by
> > 
> 
> 
