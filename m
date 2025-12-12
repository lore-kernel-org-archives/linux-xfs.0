Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3D30E0CC
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 05:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765517285; cv=none; b=QayR/iawDgDBKg5VDtRfYawg82DyA2v6ycJLL7N5n5f4ewURZ8ZEruHG0cGF5YBlHh/LHf/Xfzb3DESy7UY1n9QmDvxLKLmkE+dnlTD5lIbsK3ZonHRmBTjsDFd9yR9+nQocMdHIDciAIxmDS6GCLBPnFueOru0cvmlFcqHPMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765517285; c=relaxed/simple;
	bh=dwE/qZKcNCGrfCJQ6gtD3NM4hI6icPMNFkY5S1TsT24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbtV5QVhjxtRZczKjLpqb4CTuO3pwiJ4/yjmejqZLfv/uyh+oESEM2h+gQtCgIO9TEz1WXSbUADMIhF76dMs/3iB5XQ9n53MXZ6i8lZSxglueOa1kohoBSkNPexfYPoPatPuiYf2iyGRVV+550396ajJjresgGfS/AejuVhbNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z9E0DwZp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9E0DwZp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gNmaHELIPaw/Snd9qRuXqTcLma/9FLPNMhPlesN3STI=; b=Z9E0DwZpC4BmMgUVX3O1/fXZOF
	kBpPruoXGHwmqRzWBv4KLvtGvICQHAsH63AurjvgtPqRwOA8O4E3keG6r8lEjVFjioOiwTa8mTaVs
	tnLqk9Jfs1uOBK1CpLxlMo4pMG/FSEgVzG6xtJ4RNZCp/j9OlPUlw7X+16rlFHO/bp9VZa5XMb3g+
	Sc1LBJ1faQdtJnZ3XM1foODJKuY6NsJ45h7fiG9lZklJo0oU9bd+fcCwVwGdvfz2n2c186NcibAjn
	sPerp7xLAiUZijoIYzP+1kJ05zxQDW6TCyHAlxFv5tk3Mcvs+GKUIyo8M33dTn54IexDEtzCsEa/H
	JaPGpNQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTvhB-000000006or-2Z5C;
	Fri, 12 Dec 2025 05:28:01 +0000
Date: Thu, 11 Dec 2025 21:28:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v1] xfs: test reproducible builds
Message-ID: <aTun4Qs_X1NpNoij@infradead.org>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211172531.334474-1-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 11, 2025 at 06:25:31PM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.

Cool, thanks a lot!

> +#
> +# parent pointer inject test
> +#

I don't think that is correct :)

> +. ./common/preamble
> +_begin_fstest auto quick parent

Same for the parent here.  Instead of parent mkfs is a good group here.

> +
> +# get standard environment, filters and checks

This is kinda redundand.

> +IMG_SIZE="512M"
> +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> +PROTO_DIR="$(dirname "$0")"

So this is basically packing up tests/generic/ in xfstests
directory.  Is that the best choice?  It won't really have non-regular
files, so the exercise might be a bit limited vs creating a directory
in $TEST_DIR and adding all file types there.

> +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of getrandom()

overly long line.

> +# Compute hash of the image file
> +_hash_image()
> +{
> +	md5sum "$1" | awk '{print $1}'

md5sum is pretty outdated.  But we're using it in all kinds of other
places in xfstests, so I think for now this is the right thing to use
here.  Eventually we should switch everything over to a more modern
checksum.

