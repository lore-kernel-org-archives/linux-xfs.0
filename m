Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F063148C2;
	Tue, 16 Jun 2026 12:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781613290; cv=none; b=NFH/SXdV8TIrLs4j7zXMmb2OAQjQzAYE83KWwZ5ZJkSTpGYt8b6PaMThXINNGMIFlpSyVgOO2Bx6JdzKmXR0dwR4tMCSJ/ZYsZibyGBJ747q6AyNdY35ZaqwGzyhfGj9DUP743LDS3be/twh29L7Ov5IWIQTxrGvLejN4kNOM2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781613290; c=relaxed/simple;
	bh=a0DI4+5wlK9F0Q0UIVBU3wY7FRrk+JKdmgAafkm2OGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDdVlp5at615JZ7nnO5cdhLVmPgyzeTgbtzz3I5zEJimlodd2MoFlFAS8sMysIxtLGQ11BJe2x4lGN1E7pfoO3jabxAyOh3amnmgJU7cUbh8WQx+LJHBrLwYc3Xtfv1UWQZnU1tcABktHWPGZ2SKC7Tm98Nirm63Yn86O2+h2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DE2768C7B; Tue, 16 Jun 2026 14:34:43 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:34:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 2/8] fs: add a global device to super block hash
 table
Message-ID: <20260616123443.GA21024@lst.de>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org> <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-2-bb0fd82f3861@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 02, 2026 at 12:10:08PM +0200, Christian Brauner wrote:
> fs_holder_ops recovers the owning superblock from bdev->bd_holder, which
> forces the holder to be exactly one superblock and prevents several
> superblocks from sharing one block device. That's what erofs is doing.
> 
> Introduce a global dev_t-keyed rhltable mapping each block device to the
> superblock(s) using it. The holder argument becomes purely the block
> layer's exclusivity token (a superblock, or a file_system_type for
> shared devices) and is no longer needed by the fs specific callbacks.

Err, no.  block devices need to have a specific owner.  If erofs wants
to share a device between superblock it needs to come up with an entity
that owns the block devices which is not a superblock.

IMHO sharing devices between superblocks is a bad idea, but that ship
has sailed, but please keep it contained inside of erofs.

