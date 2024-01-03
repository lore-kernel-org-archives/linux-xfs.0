Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D42D1CA94
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LObqSLQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF61C433C7;
	Wed,  3 Jan 2024 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704309996;
	bh=feK2MVz9VvGc8TkTCMSZTTALMkK7P+NxfEbw3UumiRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LObqSLQZCk1uCq2FjLh4e6Xh0DnsTmPcwienqI/t+TL63BvTFQQODXb/3uZJCtPQI
	 WWIY0wpLtlHgD4qP0KXrwcvef3UAXx35qWU3czav42zoyqt7M2wOhJSL/1UGv0Zufl
	 UmmjKoMK7YUOabCB3/XFiEj4NO74hM6CWpzPIXn+qqajvj7lEf2pULylwzXnfOXim9
	 6QHH1Y/i42F0RfqMURiCwKHhg0zH3BuzCbJD4MdolGLSRFE3i0UBqyf4K7Z1izdH4w
	 +YX9FW4K3rMdPh9IDBqeWwzxVSAofGx3dH6ggEz0FwDeXghi07D4nVlQOEd68EMyhO
	 TLdKq90bcxAfw==
Date: Wed, 3 Jan 2024 11:26:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 3/9] xfs: create buftarg helpers to abstract block_device
 operations
Message-ID: <20240103192635.GR361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829626.1748854.5183924360781583435.stgit@frogsfrogsfrogs>
 <ZZUgK4Ah6QJkgOyL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUgK4Ah6QJkgOyL@infradead.org>

On Wed, Jan 03, 2024 at 12:51:55AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:14:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the next few patches, we're going into introduce buffer targets that
> > are not block devices.  Introduce block_device helpers so that the
> > compiler can check that we're not feeding an xfile object to something
> > expecting a block device.
> 
> I don't see how these helpers allow the compiler to check anything.
> I also don't see any other good reason for the helpers, but maybe I'm
> just missing something.

Oh, right -- originally, this patch made struct xfs_buftarg do this:

struct xfs_buftarg {
	dev_t			bt_dev;
	union {
		struct block_device	*bt_bdev;
		struct xfile		*bt_xfile;
	};
	struct dax_device	*bt_daxdev;

Dereferencing bt_bdev/bt_xfile was controlled through a buftarg flag.
IOWs, it employed the tagged union pattern.

When bt_bdev_handle came about, I gave up on the tagged union and simply
added another pointer to struct xfs_buftarg.  There aren't that many of
them floating around in the system, so the extra 8 bytes isn't a giant
drain on resources.

struct xfs_buftarg {
	dev_t			bt_dev;
	struct bdev_handle	*bt_bdev_handle;
	struct block_device	*bt_bdev;
	struct dax_device	*bt_daxdev;
	struct xfile		*bt_xfile;

Now we don't need these wrappers since we can't accidentally dereference
bt_xfile as a struct block_device.  I'll drop this one.

--D
