Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C6289E06;
	Thu, 26 Mar 2026 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774503513; cv=none; b=Jnx8fLopFiKEK8/jaqqzB9KlcKXjU8Jmoa87pPXQ5XP2bP3J6vo3tsLcW+WaqXkb9JuCQ4X3iz8cbbHA5iGcpvMgjV8aUVrUFQCXIjm8ZoJ8qfIM92f9gRWQ2Q3mZxj8kPOQeWoy6XD8LhUJ2TADlA7PBisZL5wLYbFwrTcFqqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774503513; c=relaxed/simple;
	bh=28qsPT0ZebSSTUkFUC6YZOg7/b0DZUMoJdmAKlkdhPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/K/VxnagKFYrycQ5eN1zMKiosk1QxnHRN65ISxBFY0jX+7F43V8yJCDOFYfmG5C5KIM5latepOC4WjWc2/QS+7Yj5DrbtZOxC7INqormsy2+PGixIjdYQusngVYO5OSCCq6k2xPQhwK2goJsBcBM0OQFRrOGzELgLVsX3ReWBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05F3B68C4E; Thu, 26 Mar 2026 06:38:29 +0100 (CET)
Date: Thu, 26 Mar 2026 06:38:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Carlos Maiolino <cem@kernel.org>, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5/7] nfsd/blocklayout: support GETDEVICEINFO for
 multiple devices
Message-ID: <20260326053828.GC23157@lst.de>
References: <20260323070746.2940140-1-hch@lst.de> <20260323070746.2940140-6-hch@lst.de> <736ddc8a-7a28-4900-b3c1-0368cad24085@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <736ddc8a-7a28-4900-b3c1-0368cad24085@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 23, 2026 at 09:53:33AM -0400, Chuck Lever wrote:

[full quote reviewed, can you please trim your replies to the relevant
 parts?]

> This always gets the data device. For an RT inode whose layout was
> granted with dev_idx=1, PR registration happened on the RT bdev (in
> nfsd4_block_get_device_info_scsi after devid_to_bdev), but the
> preempt here fires against the data bdev.

That's correct.

> The difficulty is that fence_client receives a nfs4_layout_stateid
> and nfsd_file, neither of which carries the dev_idx that was encoded
> in the device ID at layout grant time.
> 
> So the fix isn't just a one-liner — it requires threading the device
> index (or the bdev) through to the fence path, likely by storing it
> in the layout stateid when the layout is granted.

This is bollocks.  A fence happens when the client fails to respond,
so we need to fence fence access to all device for it.  Which means
we just need to track which devices it got access to.  I'll look into
it.

