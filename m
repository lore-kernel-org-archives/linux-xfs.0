Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200877;
	b=B+77C1+GFYayK6GA8HaJw3Y708u8HJmruEfpjNoMIpOXykRp74MHahg26++stt55DQ5X
	 6punoPsbX93uj5XFHrP/TJp0kQeo2l5rEUt2k0KhWnLaU6b+M8GousOfSjllb2LdueViL
	 GWt9XP3tx9jIb+Gn0g2xrKZnn6iIGSSt2kfmSkZ9Xhi//jiQB551DLW+IeIrRcLjw3v7q
	 HTNLRwwBWPjB+RXCEVWGclQEJW0DQlk7y+odDuFyi541mnIpYAQLlBN6cCpG5NNNQ6hwX
	 6lvtI2cG+9MzublbPKJQ5ZQt1C03rdaMghKgkzBFGwLq4YR7JHrbWsyNfXm/T9lOg4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200877;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=VEiqNC6LJEY1AirUS0dkvb8QiFTMIh23FPrVpQl/W4w=;
	b=RBeapbkChps29KrU4Yj4uspAbOQv8rWoaCQ7aHSh6NS/cfMicR+UKYkgIXjYoja9YFvs
	 Bh3u3pOtB/45kEdz0nQm8OMo0OQAAkTU8tEP6p1PO11Q1iPG6ZK+zON+Dj1mUIRFMnePN
	 KdIOZUKfG/wzrBM645wlOceZ/eryanvjFv3RalL0aJITUzPHU/i7qMphzkKWZszsBzvYo
	 w/z8Rp3GspYCM1uSLqMVQ5YjY+zoQAVdFzu4tU04rYEdY1GVk1vyxroDeQlCsh3NJXI4s
	 BPosy1kI+z2li4lDIJGONNwjnctGCfq5n9iOEunI2ekBthw8Bl+ywEngVrIkQGJrGfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=xBdrtkaS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9E60A2623;
	Wed, 28 Oct 2026 15:21:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE9E60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=xBdrtkaS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VEiqNC6LJEY1AirUS0dkvb8QiFTMIh23FPrVpQl/W4w=; b=xBdrtkaSF82j2tQyZYSS1aWTkN
	fvAdMntsrbJ0b6AAVwzwO06HRRx5Xl3PlLGKyJN/Lmqo6/tE1OutB3ict5dY5StH7rsD2pGAlzcwc
	/PUh5BEPqgJOXyVsI8aNLGMMQ/Gjs/oEdiXZ+FaoHQKrP6zoVHR1TSsQWjkVFo+XJrZayWLWAs8wB
	CPH3+Eacy8XdQz+BU0CAo+ARorr9e+Ljv7BkvNUAYNuQrECbvsMxFzj0fphBH2I5156GdVvAeG3+Z
	ptpVomfiBfHh7Jpp2O7EUNMMHICk7IwCtHeCS9oxAlNrAmlxXkNehnnFsp7geDpR+qA/m9MgR6e/M
	s1RrJjCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5Sk-00000007KrL-28Lt;
	Wed, 28 Oct 2026 15:21:14 +0000
Date: Wed, 28 Oct 2026 08:21:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] fs: add SB_I_OVL_USE_SYNC_FS
Message-ID: <auIS6g2228TsykEq@infradead.org>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-1-802e512379a6@toxicpanda.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 27, 2026 at 09:09:27PM +0000, Josef Bacik wrote:
> sync_filesystem() writes every dirty inode of a filesystem and then calls
> ->sync_fs().  The data needs that.

That second sentence makes absolutely zero sence and barely passes the
grammer checker, what is that supposed to mean?

>Whether the metadata does depends on
> the filesystem.

The metadata does what?  Since when did data and metadata become
subjects that act on their own?

> ext2 copies an inode to its buffer in ->write_inode() and
> nowhere else.

Seriously, please rewrite this commit log to make sense.  It reads
like utter garabage without any meaning.

