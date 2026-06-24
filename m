Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71B53BBFAC;
	Wed, 24 Jun 2026 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309965; cv=none; b=Et/pX3L1tmXp3Q4UuIiomxTVmliHrPgc09csHulzLoJTaezxvBz55qLoDek3ReWyeFDds87jwViBOIq6+Lza6SytMQ5lG2h3WVSub1Uu5TWj2LzTsVOPeF3i0jZnFWnrrV6fL1g/dcakUtFKg6Vosrrjil3KT1PQiPW82F4W07k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309965; c=relaxed/simple;
	bh=roaViA9aJBw3cU6wAmwXaVTw3OtsMa1WxYE0Ewmr/YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjcAcDyNZkOHg6NlhK2/VPSJG31LuAG2EQvE2WLBku4wleYYtX3SIjVA6eMRUmfFvkNKUBNfT4a0vSJwQqR3GLbTrr3uaBEoRzZIcZtL3RDdECVkuzDRWuCInjcMIjaDTTfLhnplnHyii7VRT1wwqecOP9OuAx1FhPNm36uD9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 127DD68B05; Wed, 24 Jun 2026 16:06:00 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:05:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 07/18] fs: maintain a global
 device-to-superblock table
Message-ID: <20260624140559.GB7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-7-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, I still think maintaining a dev_t to sb mapping vs having a holder
register a claim is a major step backwards architecturally.  I spent
a lot of effort to get us out of this.

