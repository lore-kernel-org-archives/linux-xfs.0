Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9371DF964;
	Mon,  6 Jan 2025 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736187203; cv=none; b=j0qOHNuvccm1dxmf5csMUjmtBHO2LknCpNOO7btHRasm4JQ77dC3RUVueJIT5VA5WJsRubekJD4J/Kub+eTX+UFaUKBPTES9TtV+tv2tevjCYbdqnqLKV9it9XyLenKfxRGZbNa2ZiyRsBpKdkO5IVfYsXhUSHa6ZE5M6/zGyMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736187203; c=relaxed/simple;
	bh=mqFFl02nI0uPhKNwZiHKzf0HQ/qmM+PfDre54TjvT30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbB93ERpy6Vlz27RmJLNsUcuqFPb0iJgCmkY3gc9rBSuBbU8043k82dPsgtCmbTSs9wxtw4I/fC80EFqTleL2XOnpAqa9MyuHnUq15Z/VnCy2QB5rYx62ujPo9lThkADoDBQuwWXuDwsc4T13kESIjOVYaFgQV15LdIgnN8NYv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+4Inkq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+4Inkq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DB6C4CEE1;
	Mon,  6 Jan 2025 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736187202;
	bh=mqFFl02nI0uPhKNwZiHKzf0HQ/qmM+PfDre54TjvT30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+4Inkq7AMJWNgh45dDFbtl6xCJT2UCapPOCljDYZFXDsoxgIHJW/fXOlQ2q726LB
	 oSUl1OvTY1tkklLm6qv2OO9QwxK2aYHDbS71X/MQx2MM0aShWggBLfOHkwBjR60rYn
	 QK0MC3lKziy0LKOXpq0LqVpk884DdK6B+tNLqtEJu9kjm5gJZsPOVM1oXuBU/U9ISb
	 4tqG27hWMt+P2L8aDTrB4Cd/nWYITCZaL0rEU5w2Tn57ja78AAfaMGuLFMwS15keP1
	 IAPSDqvnfD9mS7terfnffA77zSa489VT7o6OUWUVh0jpZAaomB2vKdDsmSL7ckUIQA
	 twEC2SdsNKeqQ==
Date: Mon, 6 Jan 2025 10:13:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/032: try running on blocksize > pagesize
 filesystems
Message-ID: <20250106181322.GE6174@frogsfrogsfrogs>
References: <173328389984.1190210.3362312366818719077.stgit@frogsfrogsfrogs>
 <173328390001.1190210.8027443083835172014.stgit@frogsfrogsfrogs>
 <20241222124421.skfeoi35bpvjjamt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241222124421.skfeoi35bpvjjamt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sun, Dec 22, 2024 at 08:44:21PM +0800, Zorro Lang wrote:
> On Tue, Dec 03, 2024 at 07:45:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we're no longer limited to blocksize <= pagesize, let's make
> > sure that mkfs, fsstress, and copy work on such things.  This is also a
> > subtle way to get more people running at least one test with that
> > config.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> 
> Hi Darrick, sorry for missing this patchset long time :-D

No worries.

> >  tests/xfs/032 |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/032 b/tests/xfs/032
> > index 75edf0e9c7268d..52d66ea182d47e 100755
> > --- a/tests/xfs/032
> > +++ b/tests/xfs/032
> > @@ -25,6 +25,17 @@ IMGFILE=$TEST_DIR/${seq}_copy.img
> >  
> >  echo "Silence is golden."
> >  
> > +# Can we mount blocksize > pagesize filesystems?
> > +for ((blocksize = PAGESIZE; blocksize <= 65536; blocksize *= 2)); do
> > +	_scratch_mkfs -b size=$blocksize -d size=1g >> $seqres.full 2>&1 || \
> > +		continue
> > +
> > +	_try_scratch_mount || continue
> > +	mounted_blocksize="$(stat -f -c '%S' $SCRATCH_MNT)"
> 
> _get_block_size $SCRATCH_MNT

Fixed, thanks.

> > +	_scratch_unmount
> > +	test "$blocksize" -eq "$mounted_blocksize" && PAGESIZE=$blocksize
> > +done
> 
> I'm wondering if we can have a helper likes _has_lbs_support(), if it
> returns 0, then set PAGESIZE to 65536 directly? (and we'd better to
> change name of PAGESIZE, e.g. MAX_BLOCKSIZE)

I suppose we could, though how do we detect large block size support?
If it's just mkfs+mount then that's not a lot better than the loop that
exists now.

Another approach might be to change the loop to:

while [ $SECTORSIZE -le 65536 ]; do
	while [ $BLOCKSIZE -le 65536 ]; do
		...
	done
done

But break out of the loop if _scratch_mount fails and BLOCKSIZE >
PAGESIZE?  Then we don't need the detector loop.

--D

> Thanks,
> Zorro
> 
> > +
> >  do_copy()
> >  {
> >  	local opts="$*"
> > 
> 
> 
