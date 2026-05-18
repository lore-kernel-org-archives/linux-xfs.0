Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91F81ABEDE;
	Mon, 18 May 2026 19:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779131024; cv=none; b=m2J/AmYW3suYp6wJOOqHSUyasTzooxPjWD6cbXCv7ZcFknoUZhEiBx0QGR54O49gq7qe/Q+uuZ79tawvIdXzXYI7SlarWC0/iy9JRkLgngsqCxyMz/pFXM9lejcMGK/8uKWK1Y86n5uH+QqFp2pDQROVthTDr5KCgVxfXBlacF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779131024; c=relaxed/simple;
	bh=MBVyvLGS/0TJW2hGuvN8brXC6CoLB0ptAQYJLoYU+/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tz/hERG4Ov5L4pKqWwzf5bQ4VTnSHtJRKlXpikP1Lz6gxnHpIolqT7wWn3MTuSujqUAoD1o14yc+MxNzi9gWOkiiahARC9e/fPlm9wHC8FLFc3pSpCFLZ2DEe9s2qj0/j5sEV7tXPT9Ek6FOeTjp/3xYORNoOyxX56GgneX88hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFk7QRJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFk7QRJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC19C4AF09;
	Mon, 18 May 2026 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779131024;
	bh=MBVyvLGS/0TJW2hGuvN8brXC6CoLB0ptAQYJLoYU+/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UFk7QRJFz8lbC9sarxOdkR3AQFPGYDWZBigMHQuNhF5ZBc4wXmr54tSAnq/ctEbK1
	 ScFOgO+r1cGiD7Ha3Oyh8SNWL5bUYwaTNeBO32Y+AozwsHLYNRva3hCNlfsXxO/b4h
	 Muc9arwL3oibr/LjimHWzXWvc/jxoz0CJkivYVySaM7LQAgKmovRgRDI++fAgcSRwG
	 RyAose+C53+h1pkdK32ol+K7rvsEsww3UkfDrWMU7fP5/gAqmLPQs5882B+nppCqiY
	 hjJilOxmroZcxT61K5AqcWC5Twc3anHfJlqg+edVoj3f2kbX6tcysbn4vLpC/jRPb7
	 yJMMQ5TmPdJlg==
Date: Tue, 19 May 2026 03:03:37 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <agtbqjAxUsCsLwyr@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>
References: <20260518062514.506071-1-hch@lst.de>
 <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>

On Mon, May 18, 2026 at 02:27:42PM +0200, Carlos Maiolino wrote:
> On Mon, May 18, 2026 at 08:24:53AM +0200, Christoph Hellwig wrote:
> > The fsverity test generic/759 could be used to reproduce a regression in
                              ^^^
                              579

> > the xfs buffer hashing.  Carlos Maiolino figured out that even removing
> > the fsverity-specific bits would reproduce the issue.  This test is
> > thus a copy of generic/759 with the fsverity bits striped out, and
> > run 5 times as that seems to be the threshold at which the issue
> > reproduces reliably.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> > 
> > Not sure how to best credit Eric for the original patch and Carlos
> > for the extraction, any ideas?
> 
> To be fair, Andrey initially suggested stripping off the fs-verity
> parts, IIRC because he wanted to isolate his own series from this crash.
> My role was mostly reproduce it and hunt the bug down.
> Risking to come with yet another tag, perhaps something like:
> 
> Based-on-generic-579-by: <Eric...>
> 
> It doesn't look ugly to me, but who knows...

Hmm... Generally, we state which case was copied/forked from in the introductory
comments of the case and in the commit log. If you want to specifically mention
the original author, I think we can add a dedicated line in the commit log, for
example:

  'This case is copied from generic/579, which was written by Eric Biggers.'

Currently, we don’t have a formal commit trailer to define this specific scenario,
but perhaps this is a good opportunity for us to discuss and agree on one. After
all, copying and modifying existing cases happens quite often in xfstests. For
example, we could specify the source case in the commit body, and then add a
commit trailer likes "Based-on-code-by", the whole things like:

   This case is copied by generic/579, I removed the fsverity-specific part to
   reproduce ....
   ...

   Based-on-code-by: Eric Biggers <ebiggers@google.com>
   Signed-off-by: Christoph Hellwig <hch@lst.de>

What do you and others think?

> 
> > 
> >  tests/generic/4201     | 108 +++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/4201.out |   2 +
> >  2 files changed, 110 insertions(+)
> >  create mode 100755 tests/generic/4201
> >  create mode 100644 tests/generic/4201.out
> > 
> > diff --git a/tests/generic/4201 b/tests/generic/4201
> > new file mode 100755
> > index 000000000000..fc367beeadaf
> > --- /dev/null
> > +++ b/tests/generic/4201
> > @@ -0,0 +1,108 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright 2019 Google LLC

I saw you tried to keep the original copyright of generic/579. I'm not sure if
we can have two Copyright lines at here, one is yours, the other is the original
one?

Thanks,
Zorro

> > +#
> > +# FS QA Test generic/4201
> > +#
> > +# Race dropping file systems caches vs fsstress an repeated reading of files.
> > +# Based on generic/579 with the fsverity bits stripped out, and an increased
> > +# number of runs.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto stress
> > +
> > +stop_run()
> > +{
> > +	# Stop all subprocesses.
> > +	_kill_fsstress
> > +	touch $tmp.done
> > +	wait
> > +}
> > +
> > +_cleanup()
> > +{
> > +	stop_run
> > +	rm -f $tmp.*
> > +}
> > +
> > +. ./common/filter
> > +
> > +fsv_file_size=10000000
> > +nproc_enabler=$((4 * LOAD_FACTOR))
> > +nproc_reader=$((6 * LOAD_FACTOR))
> > +nproc_stress=$((3 * LOAD_FACTOR))
> > +runtime=$((20 * TIME_FACTOR))
> > +
> > +run_test()
> > +{
> > +	rm -rf $tmp.done
> > +
> > +	# Create the test files and start the fs-verity enabler processes.
> > +	for ((proc = 0; proc < nproc_enabler; proc++)); do
> > +		orig_file=$SCRATCH_MNT/orig$proc
> > +		fsv_file=$SCRATCH_MNT/fsv$proc
> > +		head -c $fsv_file_size /dev/urandom > $orig_file
> > +		(
> > +			while [ ! -e $tmp.done ]; do
> > +				rm -f $fsv_file
> > +				cp $orig_file $fsv_file
> > +				# Give the readers some time to read from the file.
> > +				sleep 0.$((RANDOM % 100))
> > +			done
> > +		) &
> > +	done
> > +
> > +	# Start the reader processes.
> > +	for ((proc = 0; proc < nproc_reader; proc++)); do
> > +		(
> > +			while [ ! -e $tmp.done ]; do
> > +				# Choose a random file for each iteration, so that
> > +				# sometimes multiple processes read from the same file.
> > +				i=$((RANDOM % nproc_enabler))
> > +				orig_file=$SCRATCH_MNT/orig$i
> > +				fsv_file=$SCRATCH_MNT/fsv$i
> > +
> > +				# After the copy from $orig_file to $fsv_file has
> > +				# completed, the contents of these two files should
> > +				# match, regardless of whether verity has been enabled
> > +				# or not yet (or is currently being enabled).
> > +				cmp $orig_file $fsv_file |& _filter_scratch | \
> > +					sed -e "s/'//g" | \
> > +					grep -v "SCRATCH_MNT/fsv$i: No such file or directory" | \
> > +					grep -v "EOF on SCRATCH_MNT/fsv$i"
> > +				done
> > +		) &
> > +	done
> > +
> > +	# Start a process that occasionally runs 'sync && drop_caches'.  This makes more
> > +	# reads go through fs-verity for real, rather than just returning pagecache.
> > +	(
> > +		while [ ! -e $tmp.done ]; do
> > +			sleep 2.$((RANDOM % 100))
> > +			_scratch_sync && echo 3 > /proc/sys/vm/drop_caches
> > +		done
> > +	) &
> > +
> > +	# Start the fsstress processes.
> > +	_run_fsstress_bg -p $nproc_stress -l 0 -d $SCRATCH_MNT/stressdir
> > +
> > +	# Run for a while.
> > +	sleep $runtime
> > +
> > +	stop_run
> > +}
> > +
> > +for i in $(seq 1 5); do
> > +	echo "Starting run $i" >> $seqres.full
> > +
> > +	_scratch_mkfs &>> $seqres.full
> > +	_scratch_mount
> > +	run_test
> > +	_scratch_unmount
> > +done
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/4201.out b/tests/generic/4201.out
> > new file mode 100644
> > index 000000000000..2c3f3d42ff3f
> > --- /dev/null
> > +++ b/tests/generic/4201.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 4201
> > +Silence is golden
> > -- 
> > 2.53.0
> > 
> > 
