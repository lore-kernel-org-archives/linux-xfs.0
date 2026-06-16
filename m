Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397744418DF;
	Tue, 16 Jun 2026 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623172; cv=none; b=otUZUfQv4J5PVXC09nmVI5EFSgE607uvnHz/ZDcuVHF9LvSTYYvwtb7VSabJycaqI+sVKDOpVceTzeqRW8GYWvmaHUTAvPFWUGL9CrKk2lKTRhq0Lqao6LTIohEo29selZtNqktMZ4jsOrf7jIezmFGfXp4FM9kagHikpJjCyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623172; c=relaxed/simple;
	bh=fnM67QtKDbK8xZKF0hGe2BloDUuVbND5ZSldQPQ92vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfGm7apQRoUoptLRm7qiybabZCHwZrjuyVZZL3yBGMlas7GzgcuU6RCklW4iHzznp7H+fp3o5YuhCZEcmKlFTljfWfLlMg9Dhqz4PY66TEeqZNi6UCFY/buRSb1maufhIKZorVXcy0aW2SvjdC5X1DgePrP605JscVU0TECB5ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3KHeFMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3KHeFMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A73A1F00A3E;
	Tue, 16 Jun 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781623170;
	bh=juOgUzeXy3XGsInNpe15bufLEDlOx+XQzIp5A397JkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C3KHeFMfPC+yAaSzIg0d95m3I0xEpDsWlEwoaPTaoJYfJNDKmTv0cKSZzfbbqc/Wu
	 d8akawUi2BghCvAvmcEZuhA3kfz3EKR5coklh4zJ3VKagdyvPjIftRaVpdj913u1s1
	 K3nWzCRQGfqvcgJH3rQlu5kPL3I3tsC12bpvccsgaixq/ewzcDBZaNKj7UEjUIcS/V
	 0whVK+dEe/g8IyC4ymEkWjZ1nKTeBmsQ+TpuUxZ7RR5tY0sUiLwcJ2g88pAwV9kzeM
	 CI9cdL91HodKXSF6pakZ+9nvoRMoav0GjecnDRdjd31LHvVLTYwCQH0xPigTZ7hKpv
	 T5OvUAgdpT3fg==
Date: Tue, 16 Jun 2026 17:19:25 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash table
Message-ID: <20260616-gepumpt-gemischt-verblassen-b4cec29c7a6e@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
 <20260616123443.GA21024@lst.de>
 <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260616-fragil-duktus-nachverfolgen-60f54584c206@brauner>

On Tue, Jun 16, 2026 at 04:59:53PM +0200, Christian Brauner wrote:
> On Tue, Jun 16, 2026 at 02:34:43PM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 02, 2026 at 12:10:08PM +0200, Christian Brauner wrote:
> > > fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> > > forces the holder to be exactly one superblock and prevents several
> > > superblocks from sharing one block device. That's what erofs is doing.
> > > 
> > > Introduce a global dev_t-keyed rhltable mapping each block device to the
> > > superblock(s) using it. The holder argument becomes purely the block
> > > layer's exclusivity token (a superblock, or a file_system_type for
> > > shared devices) and is no longer needed by the fs specific callbacks.
> > 
> > Err, no.  block devices need to have a specific owner.  If erofs wants
> > to share a device between superblock it needs to come up with an entity
> > that owns the block devices which is not a superblock.
> 
> It already did.
> 
> > IMHO sharing devices between superblocks is a bad idea, but that ship
> > has sailed, but please keep it contained inside of erofs.
> 
> We need a simple device number to superblock mapping anyway and that can
> simply be centralized in the vfs. And it can work with anon device
> numbers and block device numbers uniformly.

Plus, after we're done we then also have a centry place where we can
intercept what devices can be mounted by a filesystem uniformly.

My first approach for this was of course to just add fs_file_open_by_*()
wrappers and move the relevant security hook into there. But while doing
this - ignoring the ton of bugs I found - I realized that having a
mapping so we can go from device number to superblock is very helpful.

We could of course keep the mapping just local to erofs but I see no
reason why the vfs cannot just provide this ability natively given that
it has all the required machinery. I'll let Jan chime in as well.
