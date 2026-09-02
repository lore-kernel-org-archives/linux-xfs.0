Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D03A3C8713
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 23:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788393463; cv=none; b=GT6onsixMn0yAwu81sLB7zKBUysR5VKHiQs+AENiWOYppb9lHdVfvtdu6E22UFf7HyiO6snUIwvohbBhvs7eu2WE8qZsdxJ37XJPQZdlSoOA2QshTelwbeNb8u4f+Jp+jAg9H0ALIx130+imQ3cakyqVere2Cfuzc4nRsgj2I0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788393463; c=relaxed/simple;
	bh=8mupjITil084HUmvaQdDB3HexkqsKJkY/zvwRH/BW/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P95w3DyvLscSYPmJxqXwEbSPqoqEfUKaHlS5/ODo0RLSsAnnbr327t15GiQ7CSlHVrJU+TWnpPL2NBQjh7vyE8C77FAd33bZM95HyQ9XaYH1NSHbz9teJrL6x+Gmib8oj1sG8EQKOEgR7rvy9Ogxj49hAuFsL+8uvDL/0pCnWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhQLuaY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhQLuaY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A67F1F000E9;
	Wed,  2 Sep 2026 23:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788393462;
	bh=TOibHGpb1BS6PqIyvf5AlEprLA0FNp8jn9l56d6JZmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KhQLuaY3aQqtHYXcraZMAAxDjNxt2xZtHeUz4vb4garxXak5tVGHeYkkOVAEUdkH8
	 MsJOBw5NFgm97oWVuuJsp+ndosAVaimoIqbEDLGtoVTMFF36np1YnDCOI+8+oczSEK
	 qUE5MUxHaM5ejSt1lad4AC71BhhyDMXd2xCeTYBmrmlRS5nzPjWg3Iim09P706tW64
	 IUfpEUSk3E/OLbUJSPS3C0tENMc9LpCggJuaJUhiPNPPs+TXamK6eOsbPs5/l745Uc
	 8N7UvsE29jyeFtHaK6EpMeGieQk7lhPGctiqFuJZqNvzsFhNLLwzE2CtcNy0rflyKg
	 yi/AnUCrDa64g==
Date: Thu, 3 Sep 2026 09:57:34 +1000
From: Dave Chinner <dgc@kernel.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs_repair: add -R to replay a dirty log before
 repairing
Message-ID: <api37phrWBn56RHo@dread>
References: <cover.1788110147.git.cw@f00f.org>
 <ac7ec2c4f9f0a64d2994dd21fd4d620942b2c745.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7ec2c4f9f0a64d2994dd21fd4d620942b2c745.1788110147.git.cw@f00f.org>

On Wed, Aug 26, 2026 at 10:25:44PM -0700, Chris Wedgwood wrote:
> xfs_repair refuses to run on a filesystem with a dirty log, and the only
> way past that has been -L, which destroys the log and every metadata
> update it describes.  The advice is to mount and unmount the filesystem
> first, which is not available when the filesystem cannot be mounted, or
> when the machine that crashed is gone.
> 
> -R replays the log first, using the kernel's own recovery code, and then
> repairs the result.  It is defined to be equivalent to mounting the
> filesystem, unmounting it cleanly, and repairing that - so it retires the
> log afterwards, and refuses to run alongside -L or -n.
....

> +	/*
> +	 * From here on intents are being completed for real.  Userspace writes
> +	 * no done items, so an intent finished before a failure is still
> +	 * described by the log we did not retire, and replaying that log again
> +	 * - here or by a kernel mount - would apply it a second time.  Say so,
> +	 * because the obvious response to a failure is to try again.
> +	 */
> +	error = -xlog_recover_finish(log);
> +	if (error)
> +		do_error(
> +	_("Log recovery completion failed: %s\n"
> +	  "Some intents may already have been applied.  Do not replay this log\n"
> +	  "again, by mount or by -R, as that would apply them twice.  Use -L to\n"
> +	  "discard the log and repair instead.\n"),
> +			 strerror(error));

Urk.  That's a red flag. Log recovery should -always- be retriable,
even if there are failures replaying intents.

The progress that intent processing makes writes new records to the
journal (intents and modified objects), and so running log recovery
a second time will continue where the intent replay failed last
time. i.e. it will recover all the changes up to the last failure,
then attempt to replay the remaining intents that are pending in the
journal.

If the userspace log recovery cannot be run repeatedly on recovery
failure without bad things happening, then the code is buggy. Only
once the recovery gets to the point that no new objects can be
recovered because of persistent failures should the user need to
resort to clearing the log....

Also, why are you copy/pasting and subtly modifying all the kernel
log recovery code here instead of running the kernel code in libxlog
directly?

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
