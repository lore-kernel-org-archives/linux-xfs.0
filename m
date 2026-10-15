Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F85A31283E;
	Thu, 15 Oct 2026 05:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792043988; cv=none; b=uaIyIDAH9wHb22UPYFWPNN9mz7aMy01S3v1B6XsxobDUQghNc93/Xubrs8f5dgqb25VQovXqEFRetv6UlDOn1TMztWoA02Ie5LB2NkHUh+Av/KVTuhHpBEvHs6iPrcWMtX8JSaksN/vw/87kCekdU2o3CdcIUMO8cRBT1bQNTvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792043988; c=relaxed/simple;
	bh=pswwWAOfJVxbZxBwVkLl3KJc9+9yJMC4XFbQ3p3MHxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B0CjH8T9dFHHE/ZWZpZLkz/8Q1470Vc9feXziMBHuq5RjCL/G8C1Uazd5+VVa6GBCX9lyqiENsErvhWoiNNWH19gCSceEnpWAbUYRgdKRWXQ9V3TbwcAQGN50lT3hX4SBuRzsaqUZ5Bl5gKDdFFqOWXjSG72JLkHMlzq1KoOf2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AEHWiRIf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AEHWiRIf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5uRQO4lXlNJFyFGRPNVqsl1LoiVcgsHwx6iiiaN/izQ=; b=AEHWiRIf2WJvW+UqePgNAK3Rak
	YiPnr6TaznJM5iQ9C6B9fxuh9lonAeKcOpYkyheEsMBRlM4Dn7kp+LryTUc/8nbgNVK6aWyZHWAD9
	4RytAs3akDy+7Xx0BZgAC2ODYyk6XcOkdWSqovNbxffBuOjZ2sTFrwyHXUdCJwCUR+AeqsDBQHg3H
	34f9DCLtamxxCUBEE+uE9CIs5i27mmZus7UpE1zFlGh+G/0i9SMi1OH0UuQuxCdVeTtUG6UqR4rLB
	jjcQGTsnMivus9hnuXASZmIiCoreImdZgi3tEzQruj6MrReN5UW81u3B4SJl11Hkq7zkXMjYDm1Fk
	0amCS9uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xHEVF-0000000Guac-383O;
	Thu, 15 Oct 2026 05:59:45 +0000
Date: Wed, 14 Oct 2026 22:59:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] generic/805: mask unmount failures on cleanup
Message-ID: <atBr0ViKkOt0wZ12@infradead.org>
References: <20261015033236.GV6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015033236.GV6253@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 14, 2026 at 08:32:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On (what's left of) my NFS-booted QA fleet I get test "failures" like
> this:
> 
>  --- a/generic/805.out	2026-09-22 13:33:18.326820071 -0700
>  +++ b/generic/805.out.bad	2026-10-14 18:58:34.438866321 -0700
>  @@ -1,2 +1,4 @@
>   QA output created by 805
>   Silence is golden
>  +umount.nfs: remote share not in 'host:dir' format
>  +umount.nfs: /mnt/s: not mounted
> 
> This is caused by the _unmount call in _cleanup getting cranky about the
> scratch mount not being mounted despite the -q flag.  I think this is
> because umount(8) detects the underlying fs as NFS and delegates
> entirely to umount.nfs, and that program whines.
> 
> So fix the test by redirecting the output.  We've already decided if the
> test passes or not before we get to cleanup.

We really should not end up here with NFS.

Oh, this test is missing a

_require_block_device $SCRATCH_DEV

so that all the dm magic is skipped when on a non-bdev fs.

