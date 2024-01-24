Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823927E563;
	Wed, 24 Jan 2024 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115494; cv=none; b=EN8TSt9Kd9+vQ3Ccz4+5NlvZHjSrsKZnaioZrCr1VMEglbcr7KlJ6/eKrkmTv+rjRkcXswfmaexRcLPc8BFMfI0FI41gefNTN6zs66EAmwUtw94SFfD9OKaOX3UJv4Nil1YP+lW7QTE3xD/AYQhJw21CiQTM0rg+WAJTgu+/AIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115494; c=relaxed/simple;
	bh=IqtdLR2/xNPXwEMdnrgzKKLE1iF0mbOeVibFd1fJboo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=trI0ZwZNuk3NxlltMj+CmTpxXCV7tv3yrFHkqNQAZYghneSsBA4IkynRh6RtvuiyH8E1t/QQZM+oca8WWFhKYkq9bIFWReGOahC8N6BqfxBVo9ISIUHxRDECUKVZeX4XjbjwVpKxuifPnc9IbCaHqtqpeCyR/QMpaCEzg9r1uTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJoNl48H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJoNl48H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23B7C433F1;
	Wed, 24 Jan 2024 16:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706115494;
	bh=IqtdLR2/xNPXwEMdnrgzKKLE1iF0mbOeVibFd1fJboo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jJoNl48Ho7cuHTEfKIANc5J5cPeQ17w+FhVge/shX6fOcmkw8uw93BspwrmU1HOdR
	 pZFMywUyZsygxKW3956x/nTXkb+ICUn4OdJkX6iDgdg8Giug178PzpVaAhIVfNG55q
	 3XeRrNVMzg3DTiCTQYwnyO+McY5kedrhErIbnsxXjZUfVQVbn2lobL477fpxbwB8Tk
	 Ka6LsEvAlzme0jD0kLYwVTKJ3m/I1ha0sS0+kbyhtMUd8dwD/fKCHGEWk3lpdUDv0M
	 C6+UX3uM+L2h+1+6RsnW+u6kNqpEF9kOpf0ILwHtJXuAPHz/TwJXvgpT2HRv468zZt
	 T8nMJcIjCguEw==
Date: Wed, 24 Jan 2024 08:58:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	zlang@redhat.com, fstests@vger.kernel.org, mcgrof@kernel.org,
	gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstest changes for LBS
Message-ID: <20240124165813.GF6226@frogsfrogsfrogs>
References: <CGME20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab@eucas1p2.samsung.com>
 <87frynkfao.fsf@doe.com>
 <d1cd9f19-21ed-430a-b146-906a6b6f0f70@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1cd9f19-21ed-430a-b146-906a6b6f0f70@samsung.com>

On Tue, Jan 23, 2024 at 09:21:50PM +0100, Pankaj Raghav wrote:
> On 23/01/2024 20:42, Ritesh Harjani (IBM) wrote:
> > Pankaj Raghav <p.raghav@samsung.com> writes:
> > 
> >>>> CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.
> >>>
> >>> Hi Pankaj,
> >>>
> >>> So I tested this on Linux 6.6 on Power8 qemu (which I had it handy).
> >>> xfs/558 passed with both 64k blocksize & with 4k blocksize on a 64k
> >>> pagesize system.
> > 
> > Ok, so it looks like the testcase xfs/558 is failing on linux-next with
> > 64k blocksize but passing with 4k blocksize.
> > It thought it was passing on my previous linux 6.6 release, but I guess
> > those too were just some lucky runs. Here is the report -
> > 
> > linux-next: xfs/558 aggregate results across 11 runs: pass=2 (18.2%), fail=9 (81.8%)
> > v6.6: xfs/558 aggregate results across 11 runs: pass=5 (45.5%), fail=6 (54.5%)
> > 
> 
> Oh, thanks for reporting back!
> 
> I can confirm that it happens 100% of time with my LBS patch enabled for 64k bs.
> 
> Let's see what Zorro reports back on a real 64k hardware.
> 
> > So I guess, I will spend sometime analyzing why the failure.
> > 
> 
> Could you try the patch I sent for xfs/558 and see if it works all the time?
> 
> The issue is 'xfs_wb*iomap_invalid' not getting triggered when we have larger
> bs. I basically increased the blksz in the test based on the underlying bs.
> Maybe there is a better solution than what I proposed, but it fixes the test.

The only improvement I can think of would be to force-disable large
folios on the file being tested.  Large folios mess with testing because
the race depends on write and writeback needing to walk multiple pages.
Right now the pagecache only institutes large folios if the IO patterns
are large IOs, but in theory that could change some day.

I suspect that the iomap tracepoint data and possibly
trace_mm_filemap_add_to_page_cache might help figure out what size
folios are actually in use during the invalidation test.

(Perhaps it's time for me to add a 64k bs VM to the test fleet.)

--D

> > Failure log
> > ================
> > xfs/558 36s ... - output mismatch (see /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad)
> >     --- tests/xfs/558.out       2023-06-29 12:06:13.824276289 +0000
> >     +++ /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad       2024-01-23 18:54:56.613116520 +0000
> >     @@ -1,2 +1,3 @@
> >      QA output created by 558
> >     +Expected to hear about writeback iomap invalidations?
> >      Silence is golden
> >     ...
> >     (Run 'diff -u /root/xfstests-dev/tests/xfs/558.out /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad'  to see the entire diff)
> > 
> > HINT: You _MAY_ be missing kernel fix:
> >       5c665e5b5af6 xfs: remove xfs_map_cow
> > 
> > -ritesh
> > 
> >>
> >> Thanks for testing it out. I will investigate this further, and see why
> >> I have this failure in LBS for 64k and not for 32k and 16k block sizes.
> >>
> >> As this test also expects some invalidation during the page cache writeback,
> >> this might an issue just with LBS and not for 64k page size machines.
> >>
> >> Probably I will also spend some time to set up a Power8 qemu to test these failures.
> >>
> >>> However, since on this system the quota was v4.05, it does not support
> >>> bigtime feature hence could not run xfs/161. 
> >>>
> >>> xfs/161       [not run] quota: bigtime support not detected
> >>> xfs/558 7s ...  21s
> >>>
> >>> I will collect this info on a different system with latest kernel and
> >>> will update for xfs/161 too.
> >>>
> >>
> >> Sounds good! Thanks!
> >>
> >>> -ritesh
