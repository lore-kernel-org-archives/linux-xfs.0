Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E85C35E1B1;
	Sat, 29 Aug 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788015100; cv=none; b=Kih/FMgfn9dZ9L2bInrbpcZaDWkosjQEU/+5csw1fa8tqkv8DMOQrzvo0Pc4Xb9BRIqQnXW4+BXC7CVTcS1r+fJD4M/hfYvtwOH+g54ac/y72uopaaZHBYuZwXFOLRWOCFAgMOsJV81ObLf2415jIX1LirKY7bMfaW9hGUgIpE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788015100; c=relaxed/simple;
	bh=StKd2ZIap2J+HRJgyGPM6HsvOrfkPs3zR5k1WEfSonA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpsrqwSRr2l/RJ/sSxOrKvxXx18mgcNV4aekl4dgFmohhOf0RN/ZArlUfkpA716lw5hI2Ue6ksJrWRt3auWkKTYh7pT1rHgolzVK2StnL61eBsDeFpkf8wDOH7U7gQ1k79pe7qDUExdjl5HdbZp5Lgfym/RhcHbCzcNGOzcTIZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yyM1OyiD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yyM1OyiD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bx10bEY/grytVZ3FAi9tmQtowXP7McpUMX6Ne8Ta2yA=; b=yyM1OyiDLAU2UCK0dYc1cSrokc
	jpImvVd9z4tjGyxdwdGEqJBU38z/QPxwVqOGAQjQ9Nlgj4CnZLuUFvCyvRuA53HWoq39j9YQy2JAB
	Qjb1/OeESL/bty10UMyaiyPVmeqCSfMQLjZ2gTso4CZ/aNmKdjEnGY3hBz7VcI1LmFvEff3fAKpOC
	i19PVvkCnNuoKDM++itYauWh0TNvpMZUKZvYd7Uq6SK0I5xfmA7TbqTRYSunX2y3ucbBmKbLkVIHE
	GcRN/ORqp4cZFsywN1Tow9VP6qWIgd0PBdG3FQkHDKdhUiBOVoylfhq1EaV5waddpugOP4Y887Gth
	giBEqlVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0KP0-000000072CH-32rN;
	Sat, 29 Aug 2026 14:51:26 +0000
Date: Sat, 29 Aug 2026 07:51:26 -0700
From: Christoph Hellwig <hch@infradead.org>
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
Subject: Re: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Message-ID: <apLx7pdNVkHPkrAq@infradead.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This causes regressions in xfstests xfs/006 xfs/264 when running with
a RT device because reopening the dm substitutef RT device returns
-EBUSY:

[   20.814542] XFS (dm-0): log I/O error -5
[   20.815055] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
[   20.815960] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
[   20.906440] device-mapper: zone: dm-1 using native zone append
[   20.954262] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
[   20.970876] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16

I'm also a bit surprised a RFC patch without any xfs rviews landed in
Linus tree, especially as the series alsso got various NAKs..

