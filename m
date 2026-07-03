Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0829B1A6807;
	Fri,  3 Jul 2026 02:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783045324; cv=none; b=q87GFGs56fBGqzCeFOdrzKtjt1PlI0m7BTVUJwH3nWaPmbaA8ZXkGExoKHA+Cl419z9WsyplD8XKn6/JDU2XjNep+6KQuSySMJgsr4XURko/whU8JRk8JzNlbxApUK6TiZvYvEy3tFTSIbTi0oloCYDyVsxeu9NfNbDG8ppztFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783045324; c=relaxed/simple;
	bh=r5x2JXzun14eBWvQXkpuhFkCOFfhtwfPHeiZz/XqDqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCu0txswzc+kPJMq3G9I7ispK3sMUQ1w4S14gfWjs4uH+crpOzXgBBhAbbQr4M/saUSmN83g30cYP4tQcU5VXWh3sMoEfB08Vurx2qNCw+7iOR41B6Z9dn1QNksrUGFMT8kGHd1Y1t0d5GLGRRbbPt2jFS1GyCqAyEpVPvb/+HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f42c7804768511f1aa26b74ffac11d73-20260703
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d7d2da37-f7ef-4319-8d3d-8d385079c767,IP:10,
	URL:0,TC:0,Content:7,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:17
X-CID-INFO: VERSION:1.3.12,REQID:d7d2da37-f7ef-4319-8d3d-8d385079c767,IP:10,UR
	L:0,TC:0,Content:7,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:17
X-CID-META: VersionHash:e7bac3a,CLOUDID:ab91035c909b9ebe68f486d97b3ccd19,BulkI
	D:260702183512NX1JY8MF,BulkQuantity:2,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|865|898,TC:nil,Content:4|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT
	:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f42c7804768511f1aa26b74ffac11d73-20260703
X-User: sangyao@kylinos.cn
Received: from sang-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 717538519; Fri, 03 Jul 2026 10:21:52 +0800
Date: Fri, 3 Jul 2026 10:21:47 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/656: rearrange directio pread/pwrite for zoned
 filesystems
Message-ID: <20260703022147.o6ubq2ddisxe2ahi@sang-pc>
References: <20260702035523.GA9381@frogsfrogsfrogs>
 <20260702103504.GB6816@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702103504.GB6816@lst.de>

On Thu, Jul 02, 2026 at 12:35:04PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 08:55:23PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > On zoned filesystems, a write failure shuts down the filesystem, which
> > makes this test fail with:
> 
> Looks good an increases the test coverage.  This also makes half of
> "common: skip data write EIO survival tests on fatal configs" obsolete.
> 
> Darrick, Yao, Zorro:  I think we need to arrange all the tests in
> this area into a coherent series.  Should I do that?
Yes, please.

The ordering makes sense to me. Please feel free to fold my patch into
the series as needed.

Thanks,
Yao
