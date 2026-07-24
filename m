Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA813515CB;
	Fri, 24 Jul 2026 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874309; cv=none; b=GOo8sM8SO2ckI0RZt2+ITychcYGmGupCKGx9SHnEF0RfNzqsfZyrPHXHnys+DnQMHHFXQMcs7iXtNIyGySgLi6PqEFRuEZ8xXwbkosz75xDuUb0Wz4flnobkBH5ZlzwPJ/u5Kt5/8g25wPsK344bbfgPRxt4SzVfwKaJfVv/apM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874309; c=relaxed/simple;
	bh=OPj0pMsTN781FbNk8Da6EQlrsafVn+dvsY8Udvytgz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U38pAHkSVAUEIKe8KzGK5fLNKptMlFA4A2HTr3zTe3FnJBorpNNIJW5R4qaOlLSFgAXvmh+SVQ+p+B7PUQdX+hGSJHLZwQEzTuWKsXjTPDSPS+ic8Ud+MP92mUcdNtRI+RdjvREtb5K6qlE8nfw728OtXdXM8Xz+zc7gvN9rSgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CCB3868BFE; Fri, 24 Jul 2026 08:25:05 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:25:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs: log a message at mount time when using
 integrity protection
Message-ID: <20260724062505.GF4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-23-hch@lst.de> <20260723210758.GL2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723210758.GL2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 02:07:58PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 23, 2026 at 04:49:47PM +0200, Christoph Hellwig wrote:
> > Log a message in the kernel when using T10 protection information.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Do these new log messages show up for any PI-capable device?  So if I
> put the log on a PI blockdev, it'll say "Using arglebargle integrity
> profile for /dev/sda" ?

Yes.
