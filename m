Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C571EC01D;
	Tue, 15 Oct 2024 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994603; cv=none; b=HVtSKIb+d3EmZYZhVweNz3y78c2gfTuPoqG4xHMJWFE9pY3s5HTI3l2pcP20/ufiTFdeW7na/O4hYaqMnML21pCeETYMpvLYbyJkAvMQpcdf+rVEp6o+3D4Aqh0vGVMQkcU++3IwTNP3BME9orYND9q3humaB26y8pjaXZgJR2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994603; c=relaxed/simple;
	bh=Wvy+KDLyL2BJg0IBa3f1Q9qY7pRHwI5YqL2YZau4ngM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6FwFCesPwJnOvXdln/bel8Vuxhy1ISGSkCsYwTBNulGEx2e+6J3e3ItEGCb5HdP/EBwGR5lOVTBM/9k1G30XO4NgkHsQ7Eg3XaBFmipcc9mnsfQuXGW7tzZ8tONBDxWzuycKv9i0Fo7qCRzgGwoFXKmlwmTHpQ62aKm70TRwdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2096F227AAC; Tue, 15 Oct 2024 14:16:38 +0200 (CEST)
Date: Tue, 15 Oct 2024 14:16:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, dchinner@redhat.com,
	hch@lst.de, cem@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hare@suse.de,
	martin.petersen@oracle.com, catherine.hoang@oracle.com,
	mcgrof@kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com
Subject: Re: [PATCH v8 6/7] xfs: Validate atomic writes
Message-ID: <20241015121637.GC32583@lst.de>
References: <20241015090142.3189518-1-john.g.garry@oracle.com> <20241015090142.3189518-7-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015090142.3189518-7-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 09:01:41AM +0000, John Garry wrote:
> Validate that an atomic write adheres to length/offset rules. Currently
> we can only write a single FS block.

> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (ocount != ip->i_mount->m_sb.sb_blocksize)
> +			return -EINVAL;

Maybe throw in a comment here why we are currently limited to atomic
writes of exactly the file system block size and don't allow smaller
values.

Otherwise this looks good to me.

