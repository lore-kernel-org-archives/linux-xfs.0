Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57E7361DB8;
	Wed,  4 Mar 2026 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772642988; cv=none; b=c+K9XfuJkAlMEX5vSka1PESuaA5Ep3XBRCbuWbroYm7ftOm6JfOLk/Q0zSRxfwt6825rEtbOn+zem+eVemhVcDcK2r0Iyco/HWM1wtU0xTnCG45L+FlhkMGON0C6U1HnPtRWk703FY7HSRIurLDQ2jj8lz3BpJE7+l/RGm5CTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772642988; c=relaxed/simple;
	bh=zqrzxr1MA8BzlrUKvBCJrNGlu7J1lpLLID3A02GKxfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1uk4u0JeTk8KcU+kQLykJfM/FAYl/xCx3yXOc4+aouck7PCzF7aKYtSRmhn2nHvUTbJ1nYV4RhiJLv2aRCaVPE3AgOB5lTE1SDPjfob0uaiTLj+J6lBrFL2Kco2AAI09sTXChp5BEvqL7qrf8CfD2V63a+wduapKv1cm6p/os4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HBZ2uYlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HBZ2uYlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E782C4CEF7;
	Wed,  4 Mar 2026 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642988;
	bh=zqrzxr1MA8BzlrUKvBCJrNGlu7J1lpLLID3A02GKxfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HBZ2uYlY/PN5t2rnhIqi0RZojzcYf+Vzvdqya9uYo1D0XnfIS7zt1liSpuX2V+yAF
	 aTF7uvB7oIM5raF1t5tOyrYltww8jmbogf4A2+Jq4wnnCsezUOqaOEp7pEqwskc7IM
	 gtPpVGMF5B0NrI34G6o4nHU2nrYwBHjDGcDVC1CEvtn72rS/9qKm6t7Wf+qb6p3ZzZ
	 CjMutR84DfOqG1LS5eqSr+WI3VbXfvUOPOyw6VvMwQJdXMJ/PMb2WlsOGFlWFTtF4L
	 6JyGrkU+fovY/91P2lOMVNoCwt7ybE8ztMzTliKakttHZRmaQ+TmFI0mq1mrSSDWxr
	 +gKZzFc0S0F4Q==
Date: Wed, 4 Mar 2026 08:49:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, luca.dimaio1@gmail.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/841: create a block device that must exist
Message-ID: <20260304164947.GX57948@frogsfrogsfrogs>
References: <20260202085701.343099-1-hch@lst.de>
 <20260303175300.GT57948@frogsfrogsfrogs>
 <20260304125502.GA13048@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304125502.GA13048@lst.de>

On Wed, Mar 04, 2026 at 01:55:02PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 09:53:00AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 02, 2026 at 09:57:01AM +0100, Christoph Hellwig wrote:
> > > This test currently creates a block device node for /dev/ram0,
> > > which isn't guaranteed to exist, and can thus cause the test to
> > > fail with:
> > > 
> > > mkfs.xfs: cannot open $TEST_DIR/proto/blockdev: No such device or address
> > > 
> > > Instead, create a node for the backing device for $TEST_DIR, which must
> > > exist.
> > 
> > Hrm.  I'm still noticing regressions with this test, particularly when
> > the blocksize of the test filesystem is different from the block size
> > of the $IMG_FILE filesystem.
> 
> That is with the test in general, and not because of the block device
> fix, right?  Your description seems to indicate that, I'm just a bit
> confused as it is replying to my incremental patch.

Correct, I'm just complaining about x841 in general.  Your bdev fix
eliminated one of the sources of test failures.

> > So I started looking for fsblock discrepancies between
> > xfs_reproducible_test.img.[1-3] and noticed that EOF block contents are
> > different if the file being copied in has sparse holes in it that are
> > not aligned to the fsblock size of the new filesystem.
> 
> Oooh.
> 
> > Next, the region at 3k causes mkfs to re-call libxfs_file_write, but
> > this time it writes 3072 bytes of zeroes and 1024 bytes of copied-in
> > data, thus obliterating the first write.
> > 
> > That bug's on me,
> 
> Yeah.
> 
> 
> > and I'll fix it in writefile by rounding data_pos and
> > hole_pos outward as needed to be aligned to the block size of the copied
> > in filesystem.  And I'll update xfs/841 to compare $PROTO_DIR against
> > what's in the new filesystem.
> > 
> > That fixes the data corruption problem, but then the test still fails
> > because now the space map isn't the same between mkfs invocations.
> 
> Aarg.  But I'm glad we got a test for this feature that's uncovering
> old buggy/sloppy libxfs code..

Yeah.  I missed the detail that none of the existing protofile tests
actually tried to import sparse files, let alone checked the results.

I'll try to send the fix patches in a bit but QA blew up last night so I
should probably go figure out why there's suddenly log corruption, or if
some cloud thing got really FUBARd at 17:08 last night.

--D
