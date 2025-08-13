Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9791B2E5411
	for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 07:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755071733; cv=none; b=cuuCF6VmwAYwEBtmPPP3z+e3piVrm/yDV6P0QKamkkBbY01n7aE42UoCHPvcRDL9VSo3fkcdvlWFiw3qwEzlvxzrGQ1qnAoW9GnTcEulJljMteZgjlasrd0DKoN7SM5Ilti1jHWYccKYXrxm4h2gGQi+lozFyp/zNqgzxZerRQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755071733; c=relaxed/simple;
	bh=JsazoS1i0FD2+Cq8n4BwF7ZF9/NDgO1tQMbuIk8JJTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBGkDpxMrD5O4xFJCl65Fit7H+Hdn4taxZQ1EXsF4JM5lNzGxFanseeQp/p/casoTxBJU/ltX90zKXXAi7rPpeErpPUXZsm3g1Vh2y3Kln9PmaIUq2yLrXd1lYNY6qfdOlPTlQWrYv0AGV+Wefmjv5Do0vnMGZXnJ22VlfcmXfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SBWAyMJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SBWAyMJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338F8C4CEEB;
	Wed, 13 Aug 2025 07:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755071733;
	bh=JsazoS1i0FD2+Cq8n4BwF7ZF9/NDgO1tQMbuIk8JJTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SBWAyMJ4TCYGm6/q1rQiol1u5L8ZdjyDc+TrIzH5U978drI0qxKpuJ+WwPcpAP6EU
	 2/Dfn4Nf0LyYP0J3l45ch6HdzXirTe9oBuUoLXgKueGmwpUGdowGHwY7ssQ1nqb2aw
	 /FC8JQQSYAJmJ9pXE1frBdRzUsJoqJqoWSPn5ZG/il/loeAVDEkVEg4ka6b+soilMc
	 LLI8CHm7DrHjTebva4nzxXzZUvpBOhwecrAZdj7wS3XAj23uMJ6TAPHhiE2xwrbKmb
	 ZABYEqYrswFnCV+rE4NZMiyVqhJVFean8CVJMsdiT6VHQvqsvQErx2WOi57IyJ27rt
	 CCjqBeiWP4OUA==
Date: Wed, 13 Aug 2025 09:55:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Fix logbsize validation
Message-ID: <st5ta5gtndv3imwhctcg7jcn43xycaneqrolaasst4oad7kcmw@qwsrrp5jw24q>
References: <20250812124350.849381-1-cem@kernel.org>
 <NEhMkOfkHiSb1Z_kFTIY6gdvqPkD5X1fHfzBwZdzLcRKofvVBfkIyJ_05PVDnki1B_dGpDdTpixxuJIzFDb5pg==@protonmail.internalid>
 <20250813021655.GQ7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813021655.GQ7965@frogsfrogsfrogs>

On Tue, Aug 12, 2025 at 07:16:55PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 12, 2025 at 02:43:41PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > An user reported an inconsistency while mounting a V2 log filesystem
> > with logbsize equals to the stripe unit being used (192k).
> >
> > The current validation algorithm for the log buffer size enforces the
> > user to pass a power_of_2 value between [16k-256k].
> > The manpage dictates the log buffer size must be a multiple of the log
> > stripe unit, but doesn't specify it must be a power_of_2. Also, if
> > logbsize is not specified at mount time, it will be set to
> > max(32768, log_sunit), where log_sunit not necessarily is a power_of_2.
> >
> > It does seem to me then that logbsize being a power_of_2 constraint must
> > be relaxed if there is a configured log stripe unit, so this patch
> > updates the logbsize validation logic to ensure that:
> >
> > - It can only be set to a specific range [16k-256k]
> >
> > - Will be aligned to log stripe unit when the latter is set,
> >   and will be at least the same size as the log stripe unit.
> >
> > - Enforce it to be power_of_2 aligned when log stripe unit is not set.
> >
> > This is achieved by factoring out the logbsize validation to a separated
> > function to avoid a big chain of if conditionals
> >
> > While at it, update m_logbufs and m_logbsize conditionals in
> > xfs_fs_validate_params from:
> > 	(x != -1 && x != 0) to (x > 0)
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >
> > I am sending this as a RFC because although I did some basic testing,
> > xfstests is still running, so I can't tell yet if it will fail on some configuration even though I am not expecting it to.
> 
> Heheh, how did that go?

quick group seems ok, I'll run something more complete today

> 
> >  fs/xfs/xfs_super.c | 57 ++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 40 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index bb0a82635a77..38d3d8a0b026 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1059,6 +1059,29 @@ xfs_fs_unfreeze(
> >  	return 0;
> >  }
> >
> > +STATIC int
> > +xfs_validate_logbsize(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int			logbsize = mp->m_logbsize;
> > +	uint32_t		logsunit = mp->m_sb.sb_logsunit;
> 
> Why not access the fields directly instead of going through convenience
> variables?

I did this to pack the lines length a bit, I initially was writing it
inline to xfs_finish_flags(), then decided to move it to a different
function and I kept the local vars.

> 
> > +	if (logsunit > 1) {
> > +		if (logbsize < logsunit ||
> > +		    logbsize % logsunit) {
> > +			xfs_warn(mp,
> > +		"logbuf size must be a multiple of the log stripe unit");
> > +			return -EINVAL;
> > +		}
> > +	} else {
> > +		if (!is_power_of_2(logbsize)) {
> > +		    xfs_warn(mp,
> 
> Odd indenting here  ^^^

Yeah, sorry, will fix that.

> 
> > +		     "invalid logbufsize: %d [not a power of 2]", logbsize);
> > +		    return -EINVAL;
> > +		}
> > +	}
> > +	return 0;
> > +}
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock _has_ now been read in.
> > @@ -1067,16 +1090,13 @@ STATIC int
> >  xfs_finish_flags(
> >  	struct xfs_mount	*mp)
> >  {
> > -	/* Fail a mount where the logbuf is smaller than the log stripe */
> >  	if (xfs_has_logv2(mp)) {
> > -		if (mp->m_logbsize <= 0 &&
> > -		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
> > -			mp->m_logbsize = mp->m_sb.sb_logsunit;
> > -		} else if (mp->m_logbsize > 0 &&
> > -			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
> > -			xfs_warn(mp,
> > -		"logbuf size must be greater than or equal to log stripe size");
> > -			return -EINVAL;
> > +		if (mp->m_logbsize > 0) {
> > +			if (xfs_validate_logbsize(mp))
> > +				return -EINVAL;
> 
> If you're going to have xfs_validate_logbsize return an errno, then
> capture it and return that, instead squashing them all to EINVAL.

Fair enough.

> 
> AFAICT it's no big deal to have non-power-of-two log buffers, right?
> I *think* everything looks ok, but I'm no expert in the bottom levels of
> the xfs logging code. :/

Heh, I couldn't find anything that really prevents log buffers to be
non-power-of-to, in fact, that's what happens today when we don't
specify a logbsize, but we have a non-power-of-2 log stripe unit.

FWIW, I thought a bit about the possibility to simply prevent log stripe
units to be a non-power-of-2, but the whole reason the user who reported
this hit this problem was that he's using a SSD reporting 192k stripe.
Quoting his own words:

"if you are wondering why I am using a 48b stripe, ask the ssd
manufacturer"

So, it seems to me that restricting log sunit to be power-of-2 aligned,
is not gonna play well with some hardware out there.


> 
> --D
> 
> > +		} else {
> > +			if (mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE)
> > +				mp->m_logbsize = mp->m_sb.sb_logsunit;
> >  		}
> >  	} else {
> >  		/* Fail a mount if the logbuf is larger than 32K */
> > @@ -1628,8 +1648,7 @@ xfs_fs_validate_params(
> >  		return -EINVAL;
> >  	}
> >
> > -	if (mp->m_logbufs != -1 &&
> > -	    mp->m_logbufs != 0 &&
> > +	if (mp->m_logbufs > 0 &&
> >  	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> >  	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> >  		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > @@ -1637,14 +1656,18 @@ xfs_fs_validate_params(
> >  		return -EINVAL;
> >  	}
> >
> > -	if (mp->m_logbsize != -1 &&
> > -	    mp->m_logbsize !=  0 &&
> > +	/*
> > +	 * We have not yet read the superblock, so we can't check against
> > +	 * logsunit here.
> > +	 */
> > +	if (mp->m_logbsize > 0 &&
> >  	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > -	     !is_power_of_2(mp->m_logbsize))) {
> > +	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE)) {
> >  		xfs_warn(mp,
> > -			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
> > -			mp->m_logbsize);
> > +			"invalid logbufsize: %d [not in range %dk-%dk]",
> > +			mp->m_logbsize,
> > +			(XLOG_MIN_RECORD_BSIZE/1024),
> > +			(XLOG_MAX_RECORD_BSIZE/1024));
> >  		return -EINVAL;
> >  	}
> >
> > --
> > 2.50.1
> >
> >
