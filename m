Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FEC3D72;
	Tue, 12 Mar 2024 22:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710282699; cv=none; b=o5WJATJ7BifOHqBP28gyBFqnnxdCelb++I6yxvkJGbAGOz2jNTCtBQWJpWJcpWZyxmXciEIXLcu4GUGVODlf3sl65LJ6+wIB4T+4w5QP+Se/pwdR0Ot1BcDot+vTBRUBiHUsf96AT+NYdi79Xfp9thN0z589gsDL2bJAq5UckUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710282699; c=relaxed/simple;
	bh=MvssfGlmE5yuT31v6XRtqIl8AzcrXBwEXXQ4KNdNKM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHdzCTsJaQyp4AvEZJViT8hhfvbTgR9eX2aUsHSuxNliXiG8k5L6Uuxheuf4GiO8cAtNXTEF75pv5LDGVvnvk3ghcwVgua4C2MO0A33sFr3BAtIKmAtGtZ0646wpDaqywoXhTWFjtynsUhH2VCF5eLVd2OVIEcsnKlrijSrFf24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6AFB668C4E; Tue, 12 Mar 2024 23:31:32 +0100 (CET)
Date: Tue, 12 Mar 2024 23:31:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] block: move discard checks into the ioctl handler
Message-ID: <20240312223131.GA8115@lst.de>
References: <20240312144532.1044427-1-hch@lst.de> <20240312144532.1044427-2-hch@lst.de> <ZfDTZpuumZSn6oPp@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfDTZpuumZSn6oPp@kbusch-mbp.mynextlight.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 12, 2024 at 04:12:54PM -0600, Keith Busch wrote:
> > +	if (!nr_sects)
> >  		return -EINVAL;
> > +	if ((sector | nr_sects) & bs_mask)
> >  		return -EINVAL;
> > -
> >  	if (start + len > bdev_nr_bytes(bdev))
> >  		return -EINVAL;
> 
> Maybe you want to shift lower bytes out of consideration, but it is
> different, right? For example, if I call this ioctl with start=5 and
> len=555, it would return EINVAL, but your change would let it succeed
> the same as if start=0, len=512.

We did the same before, just down in __blkdev_issue_discard instead of
in the ioctl handler.
