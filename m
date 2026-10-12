Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CCA42AF8A;
	Mon, 12 Oct 2026 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821653; cv=none; b=A3NVafjf/JFCXTRG94sb4u/WLHW3nnduXlLQuKaUG0MITz4PlaiVfLs9WuJSC0F/chZJuGjHzOI9Ra8Bk9IoYP7FxEUSHYIzh8eSBkHdQ/edoiqIKfBTeq0e+xwNEyvgb7wHNatVGdlMymw+Rf8BgJES4ujETUfJh33f+T/dCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821653; c=relaxed/simple;
	bh=oUX5jRgYlBfqJa3UzkdN4w2r1GNIJ4T8zJaDZ8O7N9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uM8a+3AZZQhoYcfUabmO2F4VIgt5QcvFmjSX/yf0OFlFgWr7G7xzKnr41Q9euZ8gBL1qkH19fyoats343xhVW6jdcFbsqbjw1P0bfxTXXFxjYiScZJvyRmZ7qX4muZYDD/qiwFhs29eTq32RpqYndU6Z1Xm484R4/Lmg/hPScJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nsw3HyZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nsw3HyZF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8ED351F0089C;
	Mon, 12 Oct 2026 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791821652;
	bh=EaJfxWaqPoDpgc/uhrpwuatc5/CZmqihr2bOkdZEp2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nsw3HyZFJPpk04JzuIaUQRmcPT6dUN7pUqcxKqHHHwaMEkciVrK2rDlm+5OxNhv6i
	 wninMvq1c5JHEi3SUhufOewVsDfArSg0fRW4sNgDhPkbQMDU0BWCVl20In5ZmLU48n
	 DknaPpgy74twCz9idS2If/WEWiIrzp9NP7K4IySn1hNw285esA9uvmYGr0BsbBzuGP
	 ljsAQbCdr+BR7Q0VXQvegh19sdLMQxk0xoVmGH0E4jHZTBZbnKIpbiuaNJbKdwJCO8
	 I5yMVreVTs3wWjue6GU+6AF8fyuInQB6r6cuH4qnr0x4ZXJbVr0GMcTOzdLHYiBAfB
	 zzf3wGRyIjHxw==
Date: Mon, 12 Oct 2026 09:14:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
 negative
Message-ID: <20261012161411.GC2705364@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065859.1058822.2001240285823845729.stgit@frogsfrogsfrogs>
 <aszdtdNDmnOSHSQT@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszdtdNDmnOSHSQT@infradead.org>

On Mon, Oct 12, 2026 at 06:16:37AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 11, 2026 at 10:59:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM complains that percpu_counter_sum can return a negative number but
> > we instead misinterpret that into a huge unsigned value and do bad
> > things to fdblocks.  It shouldn't do that, so let's add a retry loop and
> > an attempt to freeze the filesystem to (hopefully) zero out the incore
> > delalloc counter.  It probably won't work, but at least failing the
> > repair beats doing the wrong thing.
> 
> I wonder how we could even end up with a negative value here, given
> that we should not see live changes.  I.e. might it make more sense
> to just treat the theoretical negative values as 0 instead of a never
> exercises retry path?

I'm not sure how in practice you'd end up with a negative value in
the incore delalloc count.  I changed it to try to freeze the filesystem
on the off chance that the summary counter corruption is mirrored in an
xfs_inode somewhere, and that purging them out will fix it.  Or take
down the fs :P

But I could just bail entirely if the incore count is negative, since
in theory this situation Should Never Happen(tm):

	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
	if (delayed < 0) {
		ASSERT(delayed >= 0);
		xchk_set_incomplete(sc);
		return -EFSCORRUPTED;
	}

Perhaps a better long term fix would be to sum the i_delayed_blks
counters across the entire xfs_inode cache and correct the incore
counter, but that sounds expensive for something that we shouldn't have
to worry about unless the CPU forgets arithmetic.

Oh hey, I should do the same for m_delalloc_rtextents.  Let me go fix
that too.

--D
