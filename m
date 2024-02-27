Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CEC1B28D;
	Tue, 27 Feb 2024 04:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008184; cv=none; b=sRpsKylD/GUYtNzzKHxrXWgY8osRgK5QQOJBe+psYQr9pV8b945vtZsIFnb8VOi7shPWFc/A/qwtsx1Ehs//JVTDVZNjr2sUJ+xb2hNpRexyxgCDsM2Ll/Qu7M9t+9x/gWJIikHYQNAAIuA/MG12gfquult6WTwuHX46KorvALc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008184; c=relaxed/simple;
	bh=Wqtz8ECI/zS4ik3QqXnvGUZOvGh34Nb8hWRqe4Cnfxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Az2zfn9aTDgW+36gYFfyPjmbSumcYnnI+w8/NmG8Er3YLwPOYtRGnhjdOXkcd/l7eP7z8aLfE4nns/qzO/vurBcZ1dlsKknaQnTZh7AkHnqzB50uiWYXRe/K1Bk0klPXrRerk2fVNLW4Q6R5t80VDfjxqz5Z3ROxEt4x11XzIbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tavs06rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tavs06rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C868C433C7;
	Tue, 27 Feb 2024 04:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709008184;
	bh=Wqtz8ECI/zS4ik3QqXnvGUZOvGh34Nb8hWRqe4Cnfxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tavs06rFmwlschOLXeBXCYuxU3+mhslL1PnrVUmXYXHbl8Wz52Znb2CVumJ7knIqr
	 maGveWW2LVUjU90Afjg6duumH3gWbYUUD7jnSQXOuZbHbn2ntEgb/+xhTM6dd/jdsm
	 sPB+JmzalZRl48iEKrxvdE5Jrl304qL8i0mBjpERJwwkhTMNROEfWOB/QM3QJiB/HT
	 Ydb5jNC6xgObsoGpWOMUDtdxXKzIhSZguDBULJ1MqqvkJ0r9m0FJ5k33rmU9xXlOW3
	 kAz9nT/NjJD2r8DhvceFisBEZVjvOcUd3U+awiy/nJ5p9QEUk02hIgRu4uracYwbmZ
	 rFUu96bby5Y0w==
Date: Mon, 26 Feb 2024 20:29:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/8] generic/192: fix spurious timeout
Message-ID: <20240227042943.GS616564@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915261.896550.17109752514258402651.stgit@frogsfrogsfrogs>
 <20240227042346.joa66rfv5324mnmp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227042346.joa66rfv5324mnmp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Feb 27, 2024 at 12:23:46PM +0800, Zorro Lang wrote:
> On Mon, Feb 26, 2024 at 06:01:19PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > I have a theory that when the nfs server that hosts the root fs for my
> > testing VMs gets backed up, it can take a while for path resolution and
> > loading of echo, cat, or tee to finish.  That delays the test enough to
> > result in:
> > 
> > --- /tmp/fstests/tests/generic/192.out	2023-11-29 15:40:52.715517458 -0800
> > +++ /var/tmp/fstests/generic/192.out.bad	2023-12-15 21:28:02.860000000 -0800
> > @@ -1,5 +1,6 @@
> >  QA output created by 192
> >  sleep for 5 seconds
> >  test
> > -delta1 is in range
> > +delta1 has value of 12
> > +delta1 is NOT in range 5 .. 7
> >  delta2 is in range
> 
> 
> 
> > 
> > Therefore, invoke all these utilities with --help before the critical
> > section to make sure they're all in memory.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> This patch makes sense to me,
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Just better to give 1 or 2 whitespaces to diff output message (especially the
> lines with "+") in commit log :) I always need to change that manually before
> merge the patch :-D

Oh, you mean indenting the diff output in the commit message?

Yeah, I'll try to remember that from now on:

I have a theory that when the nfs server that hosts the root fs for my
testing VMs gets backed up, it can take a while for path resolution and
loading of echo, cat, or tee to finish.  That delays the test enough to
result in:

  --- /tmp/fstests/tests/generic/192.out	2023-11-29 15:40:52.715517458 -0800
  +++ /var/tmp/fstests/generic/192.out.bad	2023-12-15 21:28:02.860000000 -0800
  @@ -1,5 +1,6 @@
   QA output created by 192
   sleep for 5 seconds
   test
  -delta1 is in range
  +delta1 has value of 12
  +delta1 is NOT in range 5 .. 7
   delta2 is in range

Therefore, invoke all these utilities with --help before the critical
section to make sure they're all in memory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

--D

> Thanks,
> Zorro
> 
> >  tests/generic/192 |   16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/192 b/tests/generic/192
> > index 0d3cd03b4b..2825486635 100755
> > --- a/tests/generic/192
> > +++ b/tests/generic/192
> > @@ -29,17 +29,27 @@ delay=5
> >  testfile=$TEST_DIR/testfile
> >  rm -f $testfile
> >  
> > +# Preload every binary used between sampling time1 and time2 so that loading
> > +# them has minimal overhead even if the root fs is hosted over a slow network.
> > +# Also don't put pipe and tee creation in that critical section.
> > +for i in echo stat sleep cat; do
> > +	$i --help &>/dev/null
> > +done
> > +
> >  echo test >$testfile
> > -time1=`_access_time $testfile | tee -a $seqres.full`
> > +time1=`_access_time $testfile`
> > +echo $time1 >> $seqres.full
> >  
> >  echo "sleep for $delay seconds"
> >  sleep $delay # sleep to allow time to move on for access
> >  cat $testfile
> > -time2=`_access_time $testfile | tee -a $seqres.full`
> > +time2=`_access_time $testfile`
> > +echo $time2 >> $seqres.full
> >  
> >  cd /
> >  _test_cycle_mount
> > -time3=`_access_time $testfile | tee -a $seqres.full`
> > +time3=`_access_time $testfile`
> > +echo $time3 >> $seqres.full
> >  
> >  delta1=`expr $time2 - $time1`
> >  delta2=`expr $time3 - $time1`
> > 
> 
> 
