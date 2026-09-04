Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DB445ACD;
	Fri,  4 Sep 2026 09:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514484; cv=none; b=K7nunfogWe3ca9FfgStlRtYSKRRnDgWsurh/HUcyF1CAzYqF/GcSI2ssw0y88Na7Qsza2x2DHK52r+FTC5ez/VTyHh5OW/8qR8/vcOT+h+NbrKyNU7jWfs+taL++JR764C9LfEm5ugmE+D+ZCYwEj2ZXLyz+RssH1TQvRyo3Exk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514484; c=relaxed/simple;
	bh=RaAQC1csl/TZXaFPApDzX6VvxQ/8nf34Pz0A5s9J87o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bihUak2+EqnoVVGMDMIdosQviefrXy/qZYIgFhpbeIdUKnkWWBfMi3OIgKdkbEbf276gxJL+QnLJzYp09/hx9eQSX8Ty6jQ1mFtuo8b2RBSJUUeJG5p1ldPh4NPC0e4cXJF6AEF26nNE524RoWqIYTbkgWP7qYsOiBew8a5UySU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP+7vBL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP+7vBL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C921F00A3D;
	Fri,  4 Sep 2026 09:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788514483;
	bh=eK397mSRVgm1qG90uV7zAPfrgCr1A8mrhqFDHCunWWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MP+7vBL4CvZI8+aPjTemUNhZqygTPRJsrM48ckDbY6znvXHMXoCdgptFL3eP0SrXV
	 9UIwYJnGwO3EMtZJPbTAwfE5XGwRhNEApT/RS8oROfqjyJbRY6Fhsn8CcFmt7P1IrP
	 oWCm+RlxLuwYXotdgllqn3bnLzE/dCkGs4b+JAjQptz6KoJCYdjxAegePnGOPPKkpU
	 dAMpq/zIrNwrcBTzAz+vbadLH0COjmFu9p+bqScj2ZT46xdpsMlnmdYvvTRprVFfPU
	 7CKX1SP3al+vXQPaqpbTc3/8xtG4pZC6nptsxHrZmr1/rA64v8Wf/wwM4KTWbg2PcO
	 1Bn1WFM20fdug==
Date: Fri, 4 Sep 2026 11:34:37 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 4/8] xfs: port to fs_bdev_file_open_by_path()
Message-ID: <20260904-resignieren-ambiente-beweis-b7a6044bb60f@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-4-bb0fd82f3861@kernel.org>
 <apLx7pdNVkHPkrAq@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apLx7pdNVkHPkrAq@infradead.org>

On Sat, Aug 29, 2026 at 07:51:26AM -0700, Christoph Hellwig wrote:
> This causes regressions in xfstests xfs/006 xfs/264 when running with
> a RT device because reopening the dm substitutef RT device returns
> -EBUSY:
> 
> [   20.814542] XFS (dm-0): log I/O error -5
> [   20.815055] XFS (dm-0): Filesystem has been shut down due to log error (0x2).
> [   20.815960] XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
> [   20.906440] device-mapper: zone: dm-1 using native zone append
> [   20.954262] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
> [   20.970876] XFS (dm-0): Invalid device [/dev/mapper/error-rttest.264], error=-16
> 
> I'm also a bit surprised a RFC patch without any xfs rviews landed in
> Linus tree, especially as the series alsso got various NAKs..

I said I'll wait for Jan to comment and once he Acked it it landed in
-next for multiple months.
