Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8A1CF2A6;
	Tue, 19 Nov 2024 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031423; cv=none; b=e5mt9/Od+HZOxyCsjVKE2WMqWOsJGk2heeMsUOuUaJvhIq4o4dHFssqX06ZG/FZQKMG5cu+4vppzWjJoPfuphLOXsVAi+omFAOBilMUhvs2uouYd4f0y8yNknDMut2R2hxo1nXiEPIqtesurdqaImrkJDZ01PFAvw+OXdmomRDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031423; c=relaxed/simple;
	bh=g/Bnq0c3kVfuw050gmnIzRFe6bXvM/oyCEthTZxId+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5KbJmAWnRs/gGdNG7MfzyvECqPeqxgUMzJSnqjZJF2cL5cMvCWU/ND2o7RFEGMjLQHeEkiOtMbMiShK7IlOz6vFxe5IKzjTOWjW8zhWHcYWUc1GRZr6it2G34xUd92/5kLWdmxYOGmpjatUbLACPs0Grm06/ee/MaYOdKQDPsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuWttsxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuWttsxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB0FC4CECF;
	Tue, 19 Nov 2024 15:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732031422;
	bh=g/Bnq0c3kVfuw050gmnIzRFe6bXvM/oyCEthTZxId+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JuWttsxZsna9Fly7NxGhHD5wWOr8/fFwEQB8zHZ24EjPQBrtKEoQWGoD4ui1ELHHw
	 bryhhSYWrcMTqDpYBVaExHW1AiAGo/0Bzl/L2WzbvsKAN8qLabnF7V9E26RX+QB0Fq
	 +/WE/mvNiP51f8pj5iby4bxSPL9vXBNzqMI1zU2u0/7AbsULqA79rQhEn2FXoIz/xn
	 7APLIawZE/7r1hBkhPjylWFiyJLuTUVJ7v3KDIqAimfRqHUYY+fbHvzP0jrynEuoFQ
	 sakBEZ8uct29UXypHl+TA3dphqxTwCGSvPCWAyBkusGh2/lEeqiCFDTpV9mOKV+c9L
	 WxiKPSJiVVMiQ==
Date: Tue, 19 Nov 2024 07:50:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 09/12] generic/251: constrain runtime via time/load/soak
 factors
Message-ID: <20241119155022.GO9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064562.904310.6083759089693476713.stgit@frogsfrogsfrogs>
 <ZzvtoVID2ASv4IM2@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzvtoVID2ASv4IM2@dread.disaster.area>

On Tue, Nov 19, 2024 at 12:45:05PM +1100, Dave Chinner wrote:
> On Mon, Nov 18, 2024 at 03:03:43PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On my test fleet, this test can run for well in excess of 20 minutes:
> > 
> >    613 generic/251
> >    616 generic/251
> >    624 generic/251
> >    630 generic/251
> >    634 generic/251
> >    652 generic/251
> >    675 generic/251
> >    749 generic/251
> >    777 generic/251
> >    808 generic/251
> >    832 generic/251
> >    946 generic/251
> >   1082 generic/251
> >   1221 generic/251
> >   1241 generic/251
> >   1254 generic/251
> >   1305 generic/251
> >   1366 generic/251
> >   1646 generic/251
> >   1936 generic/251
> >   1952 generic/251
> >   2358 generic/251
> >   4359 generic/251
> >   5325 generic/251
> >  34046 generic/251
> > 
> > because it hardcodes 20 threads and 10 copies.  It's not great to have a
> > test that results in a significant fraction of the total test runtime.
> > Fix the looping and load on this test to use LOAD and TIME_FACTOR to
> > scale up its operations, along with the usual SOAK_DURATION override.
> > That brings the default runtime down to less than a minute.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Question for you: Does your $here directory contain a .git subdir?
> 
> One of the causes of long runtime for me has been that $here might
> only contain 30MB of files, but the .git subdir balloons to several
> hundred MB over time, resulting is really long runtimes because it's
> copying GBs of data from the .git subdir.
> 
> I have this patch in my tree:
> 
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -175,9 +175,12 @@ nproc=20
>  # Copy $here to the scratch fs and make coipes of the replica.  The fstests
>  # output (and hence $seqres.full) could be in $here, so we need to snapshot
>  # $here before computing file checksums.
> +#
> +# $here/* as the files to copy so we avoid any .git directory that might be
> +# much, much larger than the rest of the fstests source tree we are copying.
>  content=$SCRATCH_MNT/orig
>  mkdir -p $content
> -cp -axT $here/ $content/
> +cp -ax $here/* $content/
> 
>  mkdir -p $tmp
> 
> And that's made the runtime drop from (typically) 10-15 minutes
> down to around 5 minutes....
> 
> Does this have any impact on the runtime on your test systems?

Nope, I do vpath builds (sort of) so there's no .git history getting
sucked up by generic/251.  The fstests directory on the test VMs is
~34MB spread across ~4800 files.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
