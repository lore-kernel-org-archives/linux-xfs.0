Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E331CB329;
	Fri, 22 Nov 2024 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732278935; cv=none; b=DtOgtz3YkgYQLdtmvGF789MPb6OsWaeGut/TLLGA9uKZrnC/ryYayUjo1kMlqrKVc/qBRkYMFxqvwlVjY9r4h1aeGykm31yPcKQF2lff00f9UO8JmWuN3zLy3aBVb5gp0Aplu2vIl1ebHvjM+TK0jYN5zxfuSlK9ajWP7wQ8JH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732278935; c=relaxed/simple;
	bh=V9E3jOEpZysDNrVidVCiXFUZ1Z9HaY5NSs+ho61i2Xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CyhDdPvtnXW1V1AtqpRyUNIbYC87Nuec7IQHPbMkNZJiGF5bvh+ImkBM9HnfZL10DyKPeI0kwQBEsqexyMvF92uOgJzaCHR5KyNzyULxq2tdDY9qT51ZilGTrA0mYUtFpcS0GZC45UkrpH123taPxnaUMGdlZfxpE7KGbcBVaPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B08C568D0A; Fri, 22 Nov 2024 13:35:29 +0100 (CET)
Date: Fri, 22 Nov 2024 13:35:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122123529.GC26198@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <20241121101325.GA5608@lst.de> <20241121105248.GA10449@lst.de> <20241121163355.GU9425@frogsfrogsfrogs> <20241121171924.GV9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121171924.GV9425@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 09:19:24AM -0800, Darrick J. Wong wrote:
> Oh, that's with your BLKDISCARD -> BLKZEROOUT change applied, isn't it?
> On my system, 100 loops takes 96 seconds with discard and 639 seconds
> with zeroout.

The discard path is guaranteed to fail after the first iteration, but
that at least happens very quickly..

