Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5510285C8B;
	Wed, 24 Jun 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310066; cv=none; b=qy7e5YY3eRmSgAs8LkSf4ZUVBVOGbtOXLrzJyAC4i6v6dAJV5lmwFezTI6ia1cWvPowSduQkmRDOXTjFsDM3+S8SuYGhyI4l2vAMokk5ZqM5lr8zYCdv0NukiM+Jof++eNOMyrKDQG7N0ncuR6KvWNF015nCQ3fiAOhcIupARRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310066; c=relaxed/simple;
	bh=6rYZlRUd4OFPM/QOs/0jVJu9/E4RylfaFxWJZtop3GY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mee/OjbN63diy307lBybRSIcapwsu3j2XjzQzB/VEVbQieFtUSkn0rcY1QN78kJX9YgZLzPS5CrZtoW/jikFu+r9ckpxcriM8hwwsn4cI0mbX0kFhwKYsBAS+yduXfFjDQtD2RoNtN299Cjzh7M39VMISFxuZHm7I8FivWxjK7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 18A7E68B05; Wed, 24 Jun 2026 16:07:43 +0200 (CEST)
Date: Wed, 24 Jun 2026 16:07:42 +0200
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
Subject: Re: [PATCH RFC v2 17/18] fs: look up the superblock via the device
 table in user_get_super()
Message-ID: <20260624140742.GD7692@lst.de>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org> <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-17-7df6b864028e@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 16, 2026 at 04:08:33PM +0200, Christian Brauner wrote:
> user_get_super() still finds the superblock for a device number by
> walking the global super_blocks list under sb_lock. Every superblock is
> registered in the device table under its s_dev since sget_fc() inserts
> it there, including superblocks on anonymous devices, so use the table
> instead.

So what is the benefit of this?  It's not like any of these are heavily
used fast paths.

