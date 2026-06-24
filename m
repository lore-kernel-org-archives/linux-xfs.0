Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13768258EF3;
	Wed, 24 Jun 2026 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310013; cv=none; b=rus4ID8s6TU3UVKedz53oJRZ/it2N+j7JkFWVTjOWMHRkygKtR+rNUGcIU5DUI+URROrqiJ1gOhMtMqxKiMYSl/yIhQoLvp2BYexZ1Nkm2ZWUvKU8/ZYzW/5G+mni9RtwpErpg6+FdWYvbvlF6ua0G1ZN1omP2casUKl7JoQFCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310013; c=relaxed/simple;
	bh=j+0/of5+W5lMlDS7/6y6EQPFaIqV60XX3CR7d9RmbZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+6Wi7gZsEI64A3qATLDqygdlq+QyvCwtMjjaBZcnkPaf4nlIQaNYxrk8ilkylfRClaaKMGWLjECKc0LOW31PJgYdoogsJ1sc6AMvS1owh3z8oWB7eGX6lCrKO+sjPLuIXcHfJz8Oaf4WlTz7T40BSLgJnW/8udfcyMEptWuqQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7FDC568B05; Wed, 24 Jun 2026 16:06:49 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:06:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC v2 08/18] fs: add dedicated block device open
 helpers for filesystems
Message-ID: <20260624140649.GC7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-8-7df6b864028e@kernel.org> <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xlfnmwv2upjia6ozd4z5l5icaewor4a6cgkafnigulndzmt6r7@rhay3h3wablo>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 06:28:50PM +0200, Jan Kara wrote:
> > +static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
> > +{
> > +	struct super_dev *sb_dev __free(kfree) = NULL;
> 
> Frankly I find the use of __free on sb_dev more confusing than helping in
> this function. If you didn't use it, you could remove the somewhat
> confusing retain_and_null_ptr() calls below, remove this initialization and
> just put one kfree() into the error handling branch when super_dev_insert()
> fails...

It is.  __free is really annoying for anything but trivial local
scope only variables.  
