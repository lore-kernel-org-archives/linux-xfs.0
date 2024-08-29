Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D5119414E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937503; cv=none; b=nVm4zfiD1cwpbwjuDZFVuBDHLxBxKvfHP3f/qc6OwjRW4FbK6R2TrhWLfH42Dxg9zEyTiBj189c9zGBxtpmzMoODCKywi7Lpe/guTlcMmkCuh5ZTbZT2DCY04IiCBe6T3i146HP0AStF279VGbP6wKqJ9m4Aff9qMZYILZCewGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937503; c=relaxed/simple;
	bh=uPLVSCKb/0/As5ZE7FS3xCdSh1HfdfdxZUmjWBFaUEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBu75LEV2KrEhsP4JwJyfzF56uiZRGdQMBz0m8912gQRYYmtC8GS4nqEWwBBqebfElBVPXN3wfRclj8JuFyJn2zTVZfqo7G/+0pUZ5NQVyl7yA2Nl/9goKP5iem/hH/zP96GISOlO5HbtOrVvUNpUEjbOw7MA+Qdd/1kGsG2dr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoFGtoZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoFGtoZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3771C4CEC1;
	Thu, 29 Aug 2024 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724937503;
	bh=uPLVSCKb/0/As5ZE7FS3xCdSh1HfdfdxZUmjWBFaUEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QoFGtoZdFocGciJ+k+xkWeyEnzKHDQYaLQe4qm+0Q9CdHDtqiUJpRzdoqHmuohvRO
	 hAdK7J9Db9jLDIvaBkzLLgHwkHbDtZua0Rix+6poOROeCjljnGg3m5D0Rxq5mYbUQ6
	 cU9GTbniFlw4w8B1GZbIFbEkz+T/h18sITi5Df/PQA+VXXCzAD8eoF98x+Hyg0/66n
	 +56Bk/I77TNpOAH21ZnHPScsmr0wi8KTzSkahA3FXd4BLLFeOpaZuPuOwXI2vPZ66B
	 SAN4b1f9uIjQfST5bfp5Xzf3XQWQ4b4gB0f83ltro/v/OP9KeeFVmmsV80/g8XaYhr
	 iRSZlv4AttTeQ==
Date: Thu, 29 Aug 2024 15:18:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	hch@lst.de
Subject: Re: [PATCH 1/3] libhandle: Remove libattr dependency
Message-ID: <zvy5npuity7acnphyagseag4ywmtazdzfzzqyxkeqr2hwurmtx@fblb265pyec4>
References: <20240827115032.406321-1-cem@kernel.org>
 <20240827115032.406321-2-cem@kernel.org>
 <20240827144112.GN865349@frogsfrogsfrogs>
 <Zs6o5q_zv1T3wPSw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs6o5q_zv1T3wPSw@infradead.org>

Sorry, came back late for the party...

On Tue, Aug 27, 2024 at 09:34:46PM GMT, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 07:41:12AM -0700, Darrick J. Wong wrote:
> > Hmm.  Here you're changing function signatures for a public library.
> > attrlist_cursor and xfs_attrlist_cursor are the same object, but I
> > wonder if this is going to cause downstream compilation errors for
> > programs that include libattr but not xfs_fs.h?
> 
> Oh, I forgot that jdm.h is public.  Yes, this will cause the compiler
> to complain, so we can't do that.

I spoke with darrick on Tuesday, and it seemed IMO that libhandle is supposed to
be a xfsprogs thing, not something that should be packaged separated, but I
might be totally wrong here.

If we ought to maintain jdm.h intact, then I'd come back to pack definitions
into libfrog/attr.h, but what I don't like about this, is we'll end up with two
definitions for virtually the same thing, xfs_attrlist in libfrog and attrlist
in xfs_fs.h, unless we do use Darrick's idea and mimic libxfs behavior in
libfrog/attr.h, something like:

#define xfs_attrlist_cursor attrlist_cursor

So we could use it within libfrog, without messing up with public libhandle
interface?!

Carlos
