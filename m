Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794505242;
	b=B9nnCpo7IuixKEPnqDnPoDEXxwfgyrMbbMXvJsPC7y0NxN4M2oFRRKt9Tn+AuvKBeek2
	 P/iJNrRwLVxXKCk7h/SAXoBrP+DAGPPtl1sVDeq0VLdH9+TsTmAd7Hg0i13cqgTud9XUF
	 vJAYRY3N8TkvY0IJP+ffFBgmrzyanN7vjo8YSMoBJEKydbHWSdDDPccwLcPkTwb+oPp3w
	 rJ25OSjrJ6lc5eNXFjfbNChdtHPmuKSR5jSZus10OPbLoS9WnRN+Pc9vP8Z34Cgp98mXJ
	 /kXDmaS/dB5Ptl4JluLhVSKVv1FnT4Wqq26BMeGFfK4DxBuzOX5Y/QpmPsaK9CBqU3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794505242;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=3HycigxJ8iO5UPrZ4lW5CT57sWavP0A82ir4z3uiWuo=;
	b=Yi8s5epaV2gSOqIBGUdEtqrpUSmqEhqdCOEJcoyzC8huofxy7ETVX7wopVBkquq/wGzW
	 O09ST8G5PVIdBGQNVFM56tgoHjqu0M6ilzV80VVl9QjyfQMBwFisQiXY45U87/Ent2Ow1
	 boeKyhX/TJQMYL4/5+NFGHzRR8ScWqmc8UWlKneX7u9G2/pLliq9I8hJNrEObW/xGoTQO
	 QKmhWWQn8eeOUmbP1k3Xhk8uDltTEtIWNe19EqZknNyydt/jd2He7ZkxQ727YDCZGiYBS
	 i3h7QcC9tnbyvVcifVOFB9g55ChFjWKBSPAxvTVqqH/GgR5+XuYqJlb/DWfBhSYmkJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91A9606A205;
	Thu, 12 Nov 2026 17:40:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B91A9606A205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CFF06732A; Thu, 12 Nov 2026 18:40:37 +0100 (CET)
Date: Thu, 12 Nov 2026 18:40:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test that statfs does not report negative free
 blocks
Message-ID: <20261112174036.GA6486@lst.de>
References: <20261112155331.GA32171@lst.de> <20261112173303.979651-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261112173303.979651-1-hengyul@cs.unc.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 12, 2026 at 12:33:03PM -0500, Hengyu Liang wrote:
> On Thu, Nov 12, 2026 at 04:53:31PM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 12, 2026 at 10:49:17AM -0500, Hengyu Liang wrote:
> > > +# Only the data device counters are checked.
> > > +_disable_scratch_realtime
> > > +
> > > +_scratch_mkfs >> $seqres.full 2>&1
> > > +_scratch_mount
> > > +_require_xfs_scratch_non_zoned
> > 
> > Why do you need _require_xfs_scratch_non_zoned?  If this test is always
> > working on the data volume due to disable_scratch_realtime above,
> > a zoned vs non-zoned RT volume shouldn't matter unless I'm missing
> > something.
> 
> I copied it from xfs/306. _disable_scratch_realtime only unsets
> SCRATCH_RTDEV and removes "-r zoned=1" from MKFS_OPTIONS. When
> SCRATCH_DEV itself is a zoned device, mkfs still creates an internal
> zoned RT section, and the root directory has rtinherit set, so the
> files are created on the RT section. I tried this on a zoned null_blk
> device without the check: all the fallocate calls fail with EOPNOTSUPP,
> statfs on the mount point reports the RT counters, and the test fails
> with and without the fix.

Oh, ok. 

Looks good then:

Reviewed-by: Christoph Hellwig <hch@lst.de>

