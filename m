Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9691EDA0E;
	Wed, 13 Aug 2025 05:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755062158; cv=none; b=S+x2LjYSmQPByMyIbY5b4D9ciH2L0WYD4A8cLyxdrM5yrqhYRY8KELkVRlNcS/eHP5nGRLs0cXcvCZqV1+TZ1rkdeZVla2428bOrPzE+YCXeD3utoRLhpr4PEWSD32b//9UjOi5P3YlbVvZ9pg+PikiILIQtpsCFs6PoZ0QgtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755062158; c=relaxed/simple;
	bh=kVd0IT2jy/J5py6+56KwHHnsVfjNirfAl67tXgH9FH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIiO3lPoBvpsZ6Z6YCLpMr3cu7fYeh6AiNL68vBSVfGoZn1BvkD3dyo+diTTwheFArYSYom2vCQt2zSvIKS91Iqp6UcnQKTFI2CfmqGj2CQ6Bt8E+9T/dcz+Iq76uAtsjRZbxnOoHOXY0zWTpReqkUfjohpLiimxcW9HiPU48ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T6HBLa6A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T6HBLa6A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pvEUdbXoO1liZTN5YgYmpKxCtx/zUVKAu3N1LIpPO7E=; b=T6HBLa6AtHAREhHsVPnGFO7JLV
	YXhFCtLb0HoSzliTRHmQuT0lB0/yckpjYY89mgmz4VXQkMG4G5S6vLzurqawd77D3eYzFW/lPfLW4
	NXY1ZZ5kFeu9YsTvZ/EbV0r1VKnGau/5HbFnkqvt9Jm73OO+YO4Bcf1t2uLzpa8gHhRnU4ERN+C3z
	F2+UvKwNRMQw/wwED3Z+4jYx0dJ45U9oclZbr9oThrubmPHMF9UOu9q6mA+iBi4SKXbrvjW7s6wfW
	KU5d1+IvYPPC2w6odeGxGmkSt766cgcOFb5cTnxo3aMuZVvqRdDpuc/7DEWENkNh6a5/YQ5Cn3R95
	iVdfEEvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1um3q7-0000000Cdsv-1yvq;
	Wed, 13 Aug 2025 05:15:55 +0000
Date: Tue, 12 Aug 2025 22:15:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <aJwfiw9radbDZq-p@infradead.org>
References: <175381957865.3020742.6707679007956321815.stgit@frogsfrogsfrogs>
 <175381957936.3020742.7058031120679185727.stgit@frogsfrogsfrogs>
 <aIopyOh1TDosDK1m@infradead.org>
 <20250812185459.GB7952@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812185459.GB7952@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Aug 12, 2025 at 11:54:59AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 30, 2025 at 07:18:48AM -0700, Christoph Hellwig wrote:
> > On Tue, Jul 29, 2025 at 01:08:46PM -0700, Darrick J. Wong wrote:
> > > The pwrite failure comes from the aio-dio-eof-race.c program because the
> > > filesystem ran out of space.  There are no speculative posteof
> > > preallocations on a zoned filesystem, so let's skip this test on those
> > > setups.
> > 
> > Did it run out of space because it is overwriting and we need a new
> > allocation (I've not actually seen this fail in my zoned testing,
> > that's why I'm asking)?  If so it really should be using the new
> > _require_inplace_writes Filipe just sent to the list.
> 
> I took a deeper look into what's going on here, and I think the
> intermittent ENOSPC failures are caused by:
> 
> 1. First we write to every byte in the 256M zoned rt device so that
>    0x55 gets written to the disk.
> 2. Then we delete the huge file we created.
> 3. The zoned garbage collector doesn't run.
> 4. aio-dio-eof-race starts up and initiates an aiodio at pos 0.
> 5. xfs_file_dio_write_zoned calls xfs_zoned_write_space_reserve
> 6. xfs_zoned_space_reserve tries to decrement 64k from XC_FREE_RTEXTENTS
>    but gets ENOSPC.
> 7. We didn't pass XFS_ZR_GREEDY, so we error out.
> 
> If I make the test sleep until I see zonegc do some work before starting
> aio-dio-eof-race, the problem goes away.  I'm not sure what the proper
> solution is, but maybe it's adding a wake_up to the gc process and
> waiting for it?

Isn't the problem here that zonegc only even sees the freed block
after inodegc did run?  i.e. after 2 the inode hasn't been truncated
yet, and thus the blocks haven't been marked as free.

