Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C21A3019B4;
	Tue,  2 Dec 2025 07:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660974; cv=none; b=kmWYRJ8RXJTsI8kvDFOdPmTzNy04w9o3RZ2TKnWUx4wHTYzEpLWeyNi+CeRlDj0BWc6TvqZo1tUlfLCOPedvzwtykfUEsKriDsLTQL8b+aOhR5HYwZpDWoDecAp2i2iJAH39iJiNKKem+UxxlS7z9IumWQ7QViq9FLqlJxJ7gA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660974; c=relaxed/simple;
	bh=yXvBtYRnIw6LmpCsHUquc9KhT62vgmWQoeC8wwqa/es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMKiZ4daLKuzXw8N24rn+M/FOP0RHwmx8y7gCzIAr3jdcif/nRvA5dB2nWn4sDMEycuSs1+regHttb07TBLJOPzAtYFVwAAbLVX6xeH63QcnNXfA+JTyZK+IBB175Qp6i7R1L8suDR/DPgSIG4uEi2B7rNvnbEsTzWZUIvSgIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 31A1768AA6; Tue,  2 Dec 2025 08:36:09 +0100 (CET)
Date: Tue, 2 Dec 2025 08:36:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/158: _notrun when the file system can't be
 created
Message-ID: <20251202073609.GA18426@lst.de>
References: <20251121071013.93927-1-hch@lst.de> <20251121071013.93927-4-hch@lst.de> <20251202044900.rdahcmhpf2t3gulx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202044900.rdahcmhpf2t3gulx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 02, 2025 at 12:49:00PM +0800, Zorro Lang wrote:
> >  # Make sure we can't upgrade a filesystem to inobtcount without finobt.
> > -_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> > +try_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 || \
> 
> Hmm... is "try_scratch_mkfs" a function in your personal repo ?

This was supposed to be _try_scratch_mkfs.  But I guess that typo
is a good way to make the test never fail :)

