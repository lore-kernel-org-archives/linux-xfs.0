Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20544A3849;
	Mon,  5 Oct 2026 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211741; cv=none; b=jpc0Xb7MDepWj08DbMuc4X1PKZzzayLpxzF6RLiPB8WfZFnZdXp2gzPYulQ9S2lhU6jPsjuPgXHbKm0iOvFakSsguVh2Y6ydpj4lyhnkQyLMyWNAJ3Ap+wpO5z3bFSor3utCFF/g7IMXaqL0Yuil1GG0/YAeR/nbQxYTb0BDOwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211741; c=relaxed/simple;
	bh=iUc4VbdCVONPvsvtxlVbcNKAyNfxC+G1VjwkGuIBI4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kINEpInXDSmWVyYzztLskLHhkPbEiPs/4K15MxzmynND1XjcNpBSTqfoPgjnAUX/nNHD12hH7TxmuvFkdNDyGKCoE4S0UTBIwbqVMUmfjemGx26AxGccPlWgt9otakp/A9o3R7KHH4XSe5jM/9auLN3YDcNCoKUF4QcScDvwCzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lF5PHMsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF5PHMsj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E5CA01F000FF;
	Mon,  5 Oct 2026 14:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791211737;
	bh=DJib5vYkCU87E0pxL3TZj3IEDUc7lIe0SqAR3sx2Gco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lF5PHMsjFbBkj11RNjkl9BWBCQlsNgIh/fyqZWyHOqtAEUh+GO3MVZ3I1wluALtlb
	 ktp182eDiKe6I8qkcr7WA4qLODuxP86u+iQwND8NX5vz2T/UJu5Iyuy2Ks2hcplL3z
	 zddfWgyfb2l3uDpR8EtmiH/xBDyNNAcJ2gS5DUCVSHX6ssBi27wzOTvg3T/j7lf5k/
	 4wCoN8H1YmFCdAilJG1ZPsw07VUxKOTICxuFyJrgAozXFOFJ+DLJOs167ZNymkEvlN
	 J8jzNgLS74tzdxSiwxA+JE7O+REoQ6AWRV6qUdF6LUQScs+7CY4t/72UsJpYxBgtp+
	 D6CzXVOyJereQ==
Date: Mon, 5 Oct 2026 07:48:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add a _require_xfs_data_csum helper
Message-ID: <20261005144856.GA2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-6-hch@lst.de>
 <20260929013850.GH2705364@frogsfrogsfrogs>
 <20261005132029.GJ26805@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005132029.GJ26805@lst.de>

On Mon, Oct 05, 2026 at 03:20:29PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 06:38:50PM -0700, Darrick J. Wong wrote:
> > Any chance we could export file data checksum type via statx or
> > somewhere?
> 
> I think Christian would hate that.  But maybe fsxattrs?
> Note that the io_uring support when I get around it will implement
> FS_IOC_GETLBMD_CAP, which also has this information, although in a
> somewhat convoluted way.

Oh wow, a new ioctl.  Having not tried to do anything with it, it looks
promising.  Would it be useful for a filesystem with software checksums
to advertise something like this:

struct logical_block_metadata_cap foo = {
	.lbmd_flags = LBMD_FS_CSUM_CRC32C, /* doesn't yet exist */
	.lbmd_interval = i_blocksize(...),
	.lbmd_size = 4,
};

Even though userspace cannot (yet) access the per-fsblock crc32c data?

Also, if the fs supports per-fsblock checksums and the storage supports
per-LBA PI, which gets advertised?

--D
