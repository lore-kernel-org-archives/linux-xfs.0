Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612543A872C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775560183; cv=none; b=N1q8Q11NEWmMMYtPpNURQYx8ElE9nMigcXQafx7KdMKd4GcB5rClCsq7eSLnWDV9jsW2vCVRNuW5qjZroTIczZhSYSfxW9hBXxjaUJbarCaiY4MfAUkR0qYmLxcZeSu+X7wLsJiIQqtVWR6sWVp2BoRozTf7qY7S3QjLH/A5/W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775560183; c=relaxed/simple;
	bh=1nbQrytkX4LOqrj4mvq50UHNU7wyZvu/IrW0qASsQyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDz+l5BBazNs6OFveybfOgaJa719wz8oNDrwQ4WfRgrNkt04QzDYIvYnYwXANXMe2vAvZoDWg1fHE7IXUMitaMpYRW50O1ZphURWHH/Bw+YziXoFYknWfciIENbBhc7wLEo2gxB6TuL84UXmxz/tJndchje5FVVjQ4XG0PiPn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ALO/pkJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ALO/pkJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224A6C116C6;
	Tue,  7 Apr 2026 11:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775560183;
	bh=1nbQrytkX4LOqrj4mvq50UHNU7wyZvu/IrW0qASsQyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ALO/pkJvBOSqZQg8zSkeUSAUAz4Oz9cdsS32PS2RuEueqyvCdb5kPeyDMOmV5SfrD
	 KAz7+UxrHoVl8dW6bTAYr+MmwUfSpKRYfW49451umJqXtP4wVkF1Ah3pOrDqUk6utg
	 1DeFy8bBOYz7+YUZtWkpEYXdHft5Nq5BRKz98qnCXo40xE77i2L5zl1F24KTnmSAxS
	 iMt6XTBazJmrgVCoPOpaSW1QFxeDyVRTWIUgt/5ToMMurXaOwxYIn/5A3GN/ZOA9Ei
	 zNbsMkGq3sw1kceOpGDumTzbBHahgnMZxX7qRlnvd87UWiBDT8Kc4UBYW4wDqyzwrL
	 id+iC7CJK/UMQ==
Date: Tue, 7 Apr 2026 13:09:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] fsr: always print error messages from
 xfrog_defragrange()
Message-ID: <adTl2U7cr_mvuqV2@nidhogg.toxiclabs.cc>
References: <20260331122639.100956-1-cem@kernel.org>
 <20260331122639.100956-3-cem@kernel.org>
 <20260331160937.GE6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331160937.GE6223@frogsfrogsfrogs>

On Tue, Mar 31, 2026 at 09:09:37AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 31, 2026 at 02:26:31PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > Error messages from xfrog_defragrange() are only printed when
> > verbose/debug flags are used.
> > 
> > We had reports from users complaining it's hard to find out the error
> > messages lost in the middle of dozens of other informational messages.
> > 
> > Change packfile() behavior to print errors independently of verbose or
> > debug flags.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > 
> > ---
> > V3: Rebase on top of patch 1 changes
> > V2: Update commit description
> > 
> >  fsr/xfs_fsr.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index 390f7c5276df..24617f55e329 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -1464,19 +1464,14 @@ packfile(
> >  		case 0:
> >  			break;
> >  	case ENOTSUP:
> > -		if (vflag || dflag)
> > -			fsrprintf(_("%s: file type not supported\n"), fname);
> 
> Err.. did you mean to delete the fsrprintf call here as well?

No, I probably should have messed it up when rebasing on top of patch 1.
I'll fix it.

> 
> --D
> 
> >  		break;
> >  	case EFAULT:
> >  		/* The file has changed since we started the copy */
> > -		if (vflag || dflag)
> > -			fsrprintf(_("%s: file modified defrag aborted\n"),
> > -					fname);
> > +		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
> >  		break;
> >  	case EBUSY:
> >  		/* Timestamp has changed or mmap'ed file */
> > -		if (vflag || dflag)
> > -			fsrprintf(_("%s: file busy\n"), fname);
> > +		fsrprintf(_("%s: file busy\n"), fname);
> >  		break;
> >  	default:
> >  		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
> > -- 
> > 2.53.0
> > 
> > 
> 
