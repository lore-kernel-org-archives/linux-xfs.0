Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28D51ABEBA;
	Mon,  4 Nov 2024 23:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730763268; cv=none; b=DezzcTXzf7q7+wfBkvVG2C7fNk+tf2QTBZ6emjor2OQ2vXgw4uJyCplpocqcgFReUU41ihC6PhKA1c7zJ2W/5Jz6yDA4S0PbgA5U5sliuYg/oKu8PO7guGrbote807UvW7UmFGyUsBCOXP5mG3c+S3I3cBkTZL8WNV/Ame2cTnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730763268; c=relaxed/simple;
	bh=VJ3HsOUL6NtbeU26c0/6S0Ayai7dOCbHdRQQp56UG4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMhDMX5ts5H62TVLtSSbjGh9bc1WJpiFBcuOQJu0jvMMlCPmhu4KG796ad6NaADknBYVbzA/BoofoRSrFuOtcWzKx0Y33Denckf3SyQFvwZolLkpp5cAkoMoR9EUvPWN0sWmoSRYm8EJsl9DylmLe9b/Td0aL2NDWHp9LRyPysI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9iFy6E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9iFy6E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887C0C4CECE;
	Mon,  4 Nov 2024 23:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730763267;
	bh=VJ3HsOUL6NtbeU26c0/6S0Ayai7dOCbHdRQQp56UG4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h9iFy6E3dzy/+smu2uPGxrOvcOxPyalYp5jJ4XbGqa3GJ4Ixrca5HqDEkPlaUhVox
	 HDGiOROB04LySPFgID3m+Q9ccbrOoU1olBRDbpbGzBNasU7YNCFODgfVB00EiTTZIL
	 J1XwrBDDWXSSV4br3uJE3X76FAvEoATSovlYzG37Lo0PeYxHdwuJV3RZXQLZbyTpV4
	 wDLCX627D1mvNtKzGqPywB0v5PuZgWxpAYPHJtlGtTHBeKrW9xkyUEFdJlBShmlFq7
	 gK7tPVrkjfjXXr6BdLpDmiwdB0GXcd3wv+Ecb7yF0ibcwu0w+a3SlBySqNG3leHdOE
	 Yqa/oE4m/Rw4w==
Date: Mon, 4 Nov 2024 15:34:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/157: mkfs does not need a specific fssize
Message-ID: <20241104233426.GW21840@frogsfrogsfrogs>
References: <20241031193552.1171855-1-zlang@kernel.org>
 <20241031220821.GA2386201@frogsfrogsfrogs>
 <20241101054810.cu6zsjrxgfzdrnia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241101214926.GW2578692@frogsfrogsfrogs>
 <Zyh8yP-FJUHKt2fK@infradead.org>
 <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104130437.mutcy5mqzcqrbqf2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Nov 04, 2024 at 09:04:37PM +0800, Zorro Lang wrote:
> On Sun, Nov 03, 2024 at 11:50:32PM -0800, Christoph Hellwig wrote:
> > On Fri, Nov 01, 2024 at 02:49:26PM -0700, Darrick J. Wong wrote:
> > > > How about unset the MKFS_OPTIONS for this test? As it already tests rtdev
> > > > and logdev by itself. Or call _notrun if MKFS_OPTIONS has "rmapbt=1"?
> > > 
> > > That will exclude quite a few configurations.  Also, how many people
> > > actually turn on rmapbt explicitly now?
> > > 
> > > > Any better idea?
> > > 
> > > I'm afraid not.  Maybe I should restructure the test to force the rt
> > > device to be 500MB even when we're not using the fake rtdev?
> > 
> > All of this is really just bandaids or the fundamental problem that:
> > 
> >  - we try to abitrarily mix config and test provided options without
> >    checking that they are compatible in general, and with what the test
> >    is trying to specifically
> >  - some combination of options and devices (size, block size, sequential
> >    required zoned) fundamentally can't work
> > 
> > I haven't really found an easy solution for them.  In the long run I
> > suspect we need to split tests between those that just take the options
> > from the config and are supposed to work with all options (maybe a few
> > notruns that fundamentally can't work).  And those that want to test
> > specific mkfs/mount options and hard code them but don't take options
> > from the input.
> 
> So how about unset extra MKFS_OPTIONS in this case ? This test has its own
> mkfs options (-L label and logdev and rtdev and fssize).

The trouble with clearing MKFS_OPTIONS is that you then have to adjust
the other _scratch_* calls in check_label(), and then all you're doing
is reducing fs configuration test coverage.  If (say) there was a bug
when changing the fs label on a rtgroups filesystem with a rt section,
you'd never see it.

Hang on ... is this a general complaint about _scratch_mkfs_xfs dropping
MKFS_OPTIONS in favor of the specific arguments passed to it by the
test?  Or a specific complaint about xfs/157 barfing when the test
runner puts "-L foo" in the MKFS_OPTIONS that it passes to ./check?

If it's the second, then let's do this:

extract_mkfs_label() {
	set -- $MKFS_OPTIONS
	local in_l

	for arg in "$@"; do
		if [ "$in_l" = "1" ]; then
			echo "$arg"
			return 0
		elif [ "$arg" = "-L" ]; then
			in_l=1
		fi
	done
	return 1
}

check_label() {
	local existing_label
	local filter

	# Handle -L somelabel being set in MKFS_OPTIONS
	if existing_label="$(extract_mkfs_label)"; then
		filter=(sed -e "s|$existing_label|oldlabel|g")
		_scratch_mkfs_sized $fs_size >> $seqres.full
	else
		filter=(cat)
		MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" \
			_scratch_mkfs_sized $fs_size >> $seqres.full
	fi
	_scratch_xfs_db -c label | ${filter[@]}
	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
	_scratch_xfs_db -c label
	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
}

--D

> Thanks,
> Zorro
> 
> > 
> > 
> 
> 
