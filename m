Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EAB3A9631;
	Thu, 15 Oct 2026 14:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075011; cv=none; b=OgFEKAejOOXTQXJZyWp7AzVWM13GobcwRcOqIcl7V7uWsLUfVaSTl0LJCCxQDG8Jh/asH4fUBr11NEJZ8Y8dwSajhF+Y3hR5lH7K6HeAmnITZmvPR5UK5ceLeW030RTKWuxaskvAB/MiMi2PKs18cO2nS7i0j/AOwM2OyKYuuco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075011; c=relaxed/simple;
	bh=2UAJMPuaoR/SdnUnli9rY9zzyo0/bLUAQnyDPmb6qX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czhQERZa5tPpqq7tRIFrnclFdAYN4fnnMZR2DDnv/9d6l63FNowYw+Pl8X+6JdTKyNRBDw1UTNLd1kdHNQCY+I0GjUQTBg2ZG3HkOGUuBA5XEOxkQlfJgqZe4nXmTHJzkRbQVD6Q1eF/mXIH2B84EOj1pq9q9PvC6FQMp43xz1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K21sz84g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K21sz84g"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7CAAC1F000C4;
	Thu, 15 Oct 2026 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075009;
	bh=LIiy8t5/bfXGieZxKBp/2PX8numSxsFYmYUd6dm2bZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K21sz84gK98pmzWXiRJNCvASwUjyPakO4jljI9kjFtmiYDVsFlkxuMRcCEH6IWjgF
	 J5bfXYS/YTDFyW7PMI52BgnYkbKbWbfLbLQHOX6v6+nlG7d1Xpy8KpxS4XBInpj5AQ
	 BOHsj3/la/Gp2CEkOh2/tg8smQD+qaFRDUa3pGrBrjWlFSFw/QXIV0Nm97xt1qyfoR
	 UvLt7JuCDMZ+Dqy/goKLq2OYWBNLmgu+/qXaGwqK1lcTbSN4MTm4TfV8gIFDEspxP8
	 a04SxG5DFnGS59ZJbYfd0UZ30hp9QO1evrSuzQX0DsrN2GaKs5qg74+S2YU3/61tQI
	 tuTmyTTFDCgPw==
Date: Thu, 15 Oct 2026 07:36:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] generic/805: mask unmount failures on cleanup
Message-ID: <20261015143649.GM2705364@frogsfrogsfrogs>
References: <20261015033236.GV6253@frogsfrogsfrogs>
 <atBr0ViKkOt0wZ12@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atBr0ViKkOt0wZ12@infradead.org>

On Wed, Oct 14, 2026 at 10:59:45PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2026 at 08:32:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On (what's left of) my NFS-booted QA fleet I get test "failures" like
> > this:
> > 
> >  --- a/generic/805.out	2026-09-22 13:33:18.326820071 -0700
> >  +++ b/generic/805.out.bad	2026-10-14 18:58:34.438866321 -0700
> >  @@ -1,2 +1,4 @@
> >   QA output created by 805
> >   Silence is golden
> >  +umount.nfs: remote share not in 'host:dir' format
> >  +umount.nfs: /mnt/s: not mounted
> > 
> > This is caused by the _unmount call in _cleanup getting cranky about the
> > scratch mount not being mounted despite the -q flag.  I think this is
> > because umount(8) detects the underlying fs as NFS and delegates
> > entirely to umount.nfs, and that program whines.
> > 
> > So fix the test by redirecting the output.  We've already decided if the
> > test passes or not before we get to cleanup.
> 
> We really should not end up here with NFS.
> 
> Oh, this test is missing a
> 
> _require_block_device $SCRATCH_DEV
> 
> so that all the dm magic is skipped when on a non-bdev fs.

_require_dm_target already checks that scratch-dev is a bdev, but I
think you've misunderstood me.

The test vm boots off NFS to test XFS, so / and /mnt are NFS.
SCRATCH_DEV is XFS, so when SCRATCH_MNT is mounted, /mnt/s will be XFS.
After unmounting SCRATCH_MNT, /mnt/s will look like it's NFS, so that's
why umount does what it does:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt/s
# umount /mnt/s
# umount /mnt/s
umount.nfs: remote share not in 'host:dir' format
umount.nfs: /mnt/s: not mounted

(I'm not fstesting NFS, I left that to Chuck and Anna.)

--D
