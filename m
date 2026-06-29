Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A692D23B9;
	Mon, 29 Jun 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782756480; cv=none; b=NF0TjhxZ4cTisnOEE/PTUJRo3E3skU0cjS4SF+WkXvbeO22R6zwMqvtI45PxBGwaQ3f5A3GxrUPWRocd+hqqZu2vgp+MI+ObW11jhf6amS2aHPV989PVa5B+UcSMOGXa54QuMrHxPqqzXxNlH6kM1JATxjC/yQfAko8G3f6j6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782756480; c=relaxed/simple;
	bh=s/SAiaq0jXurxyKgKsoMsfFxTdJufRRof9lVYaIRpt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhIG7hHDV9M+/6SClqqB5vLV+t8E0MnCgReGzEFOKWzs/zX033CJDlVqdLxrCCxL+aYByVuCuHDQxn0XlM24itJQlWPMCkw7+/8/g8XlFzu1QJAXxR7MK1kPe6wJyzPJJiTI9bR9oIqjduGbCfUIik6rn/8sPiSXphq+HuW/Nx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nawHhbZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nawHhbZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1BB1F000E9;
	Mon, 29 Jun 2026 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782756478;
	bh=pi3bF7BeSVSXlTVa54TUti2mJ7aQOooo1O+C74GUeZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nawHhbZeUIh815UzV2bR0iYnLXkavwh4dDWp/aOzWfXhmMJUfgDB1Q1+m7dvLOyF4
	 vol2FYQ+Is95tmmfvAk4kpnW38FiLbZgImdVtrKX0aPSTZNqLSmzlBhEdv+wKm/oqL
	 pSUerziKaas0lycnrDLmSMKTXnGdRLUFwkFjU2OoyY8F6bZrdCqamH3bfrsstNpSKd
	 YnsIMEU5MRnSEh70iC/U4FpvkORJVyn55sBzCMzSf4Uk/rwqIohRXJlBXkZ8WlHp+/
	 K7B7RL2+KCIafGuhzrnZ1KyTcrVCVClqFichhrkIr7TEkW5A9sO5pZLOG7W+lOw0M/
	 f35Y4ajZ4CGKQ==
Date: Tue, 30 Jun 2026 02:07:52 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <akK0EXZraOjc8okd@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
References: <178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs>
 <178240619668.1665857.17134786745403757824.stgit@frogsfrogsfrogs>
 <akKvzArcNLWKCACL@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akKvzArcNLWKCACL@zlang-mailbox>

On Tue, Jun 30, 2026 at 01:53:38AM +0800, Zorro Lang wrote:
> On Thu, Jun 25, 2026 at 09:51:17AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Both of these tests use _scratch_mkfs_xfs_supports_concurrency to detect
> > if they should be adding -lconcurrency=0 to the mkfs options that are
> > used to format a loop device.
> > 
> > However, this doesn't work in practice because of three factors: 1) the
> > scratch device could have an external log set up; 2) the loop device
> > does /not/ have an external log device; and 3) -lconcurrency isn't
> > compatible with -llogdev.
> > 
> > Fix this by creating a more general mkfs option detection helper and use
> > that once we have the loop device set up.
> > 
> > Cc: <fstests@vger.kernel.org> # v2026.05.17
> > Fixes: ffc8bad17e5b2f ("xfs/21{6,7} Use default -l concurrency=0 on mkfs.xfs that supports it")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  common/xfs    |    6 ++++++
> >  tests/xfs/216 |    9 ++++-----
> >  tests/xfs/217 |    9 ++++-----
> >  3 files changed, 14 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 88299acdd086be..81add2086866c8 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -64,6 +64,12 @@ _scratch_mkfs_xfs_opts()
> >  	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
> >  }
> >  
> > +# Figure out if the supplied mkfs.xfs options are supported.  A device or file
> > +# path must be specified as one of the options, though it will not be written.
> > +_mkfs_xfs_supported()
> > +{
> > +	$MKFS_XFS_PROG -f -N "$@"
> > +}
> >  
> >  _scratch_mkfs_xfs_supported()
> >  {
> > diff --git a/tests/xfs/216 b/tests/xfs/216
> > index 1749647c11f716..48657242e65daf 100755
> > --- a/tests/xfs/216
> > +++ b/tests/xfs/216
> > @@ -22,11 +22,6 @@ _cleanup()
> >  
> >  _require_scratch
> >  _scratch_mkfs_xfs >/dev/null 2>&1
> > -if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> > -	loop_mkfs_opts="-l concurrency=0"
> > -else
> > -	loop_mkfs_opts=""
> > -fi
> >  _scratch_mount
> >  
> >  _require_loop
> > @@ -76,6 +71,10 @@ mkdir $LOOP_MNT
> >  
> >  loop_dev=$(_create_loop_device $LOOP_IMG)
> >  
> > +if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 $loop_dev &>> $seqres.full; then
> > +	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0"
> 
> Hi Darrick,
> 
> This patch conflicts with Christoph's patch:
> https://lore.kernel.org/fstests/20260618134834.237647-3-hch@lst.de/

Oh, sorry I reviewed this patch at first, then found your later discussion,
so I should do this:
  https://lore.kernel.org/fstests/920faac0-2841-4d7b-95c3-135441d0ea7c@sandeen.net/T/#ma0ead04f569bcc81595ca729744f1466838876fc
right?

> 
> I've merged that patch into patches-in-queue branch, if you don't have
> objections to that change, could you rebase on latest patches-in-queue
> and send this patch again with Christoph's RVB :)
> 
> Thanks,
> Zorro
> 
> > +fi
> > +
> >  # walk over standard sizes (up to 256GB)
> >  _do_mkfs 1 2 4 8 16 32 64 128 256
> >  
> > diff --git a/tests/xfs/217 b/tests/xfs/217
> > index 23aae842d1fb61..34ac8dae8ef43f 100755
> > --- a/tests/xfs/217
> > +++ b/tests/xfs/217
> > @@ -21,11 +21,6 @@ _cleanup()
> >  
> >  _require_scratch
> >  _scratch_mkfs_xfs >/dev/null 2>&1
> > -if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> > -	loop_mkfs_opts="-l concurrency=0 -d concurrency=0"
> > -else
> > -	loop_mkfs_opts=""
> > -fi
> >  _scratch_mount
> >  # 16T mkfs requires a bit over 2G free
> >  _require_fs_space $SCRATCH_MNT 2202000
> > @@ -63,6 +58,10 @@ fi
> >  
> >  loop_dev=$(_create_loop_device $LOOP_IMG)
> >  
> > +if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 -d concurrency=0 $loop_dev &>> $seqres.full; then
> > +	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0 -d concurrency=0"
> > +fi
> > +
> >  #
> >  # walk over "new" sizes supported by recent xfsprogs.
> >  # Note that the last test is for 16TB-1GB as 32bit platforms only support
> > 
> 
