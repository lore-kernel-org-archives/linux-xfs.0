Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490559;
	b=IU6CvG1l426pHx76VjXENpszJuLR5wXboYOI/waTO2e9sqk5plJLC5CMfJ9jLXrOpjZ7
	 RWjzxJ7Lg2SZH1gXHXJToQPBaxlkhg8KK7c0gHEregFynWJW07CEs6zFCk2pJESlP4mol
	 dRgnDqgOAUfHiXYe5yJB07z6/E8ZtkbtDIWSTmbvC9Ol9Oi5QA5Hq/o/z5F+rPz0WeY2L
	 SsOprf4TAdGgftzymwGW5ZNzh5DC5ZhmxUyUPwCgke/qGlt1zBi1g+7ETWCZc9VAk0PtX
	 5i+a0/4XIoFmOpo6a43/Hu4x3R1uDxeeooi6znRTPTer4xBSsajq91hv+mzEfIormcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490559;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=gu2yimROkptom7mFHjHWb3yYMN4ZPdSdwdQcw8fCLwg=;
	b=dLYq18LyYgWWV196zkDCawqGeRtU1eUIHz5WF3ngmQZGs4B1fidMK38icFL5XUCGF0qo
	 gn4V85UnfmHMoHlhSlYAk1nPJQ+JOH287MvF7Jxej7idVoaf/HtwvEsSJU2EKdydXMiRm
	 C+8lbSWVLEedZfDNDWGJx/nYRVmz5E1LUzAUzMX42dgNeDV1uZJyiRy6BbVkGjQG/d1aP
	 ryQ3BgqmvUJ2Vkx13Z++mNR2yt5O+zPdBMwMdMtuh2p+CKuWBot48cj46vroRctGeu1vf
	 CNT//SzCvIppDi9uH+zWwAbww0TmlUfNUNYHMdOXwSGb1zP8CUFXZNOlB9677op1+Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287F2606A884;
	Thu, 12 Nov 2026 13:35:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 287F2606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A80D46732A; Thu, 12 Nov 2026 14:35:55 +0100 (CET)
Date: Thu, 12 Nov 2026 14:35:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v8 13/15] xfs: resample the extsize hint after taking
 the ILOCK
Message-ID: <20261112133555.GC22165@lst.de>
References: <20261112010229.51029-1-mason@kernel.org> <20261112010229.51029-14-mason@kernel.org>
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
In-Reply-To: <20261112010229.51029-14-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 11, 2026 at 08:02:42PM -0500, Chris Mason wrote:
> A write fault on a file with an extent size hint can overrun its block
> reservation and shut down the filesystem, if it races with a change of
> the hint or of the realtime flag.
> 
> xfs_iomap_write_direct() sizes the reservation from the hint and the
> flag before xfs_trans_alloc_inode() takes the ILOCK, and the allocator
> reads both again under it. But a write fault only holds the MMAPLOCK,
> and FS_IOC_FSSETXATTR changes both on a file with no blocks without it:
> 

... and my previous suggestion of taking the mmlock in fileattr_set
would take care of this as well.

