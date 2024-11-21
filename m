Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB391C2DCF;
	Thu, 21 Nov 2024 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186376; cv=none; b=C30/YVJPSjBOITDeeQn8XWAI9NeqyvKQjRmYa4O7cvH8LygfRJbDT1ly1uEz/ZF66AH6J3CdauUSyo+EakiGhqy+o+ebEMCRJ4tRUo05iKEQJYq7d3XNNGpYRMeCEu3NcFN/6xolnzg3Cjhahc4S3KOPtWqokqv0532O0GQ6EGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186376; c=relaxed/simple;
	bh=9f6eG0VNrIAnlJ5R4XM7NYNDQSRqGnhJ+jEvM35hZvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgN9o4ssP0O8k3NtL1yUXqAgJj3eXv9H1uD3CpdfG5ob+I3hb6XoLlrTX5ttkzHFxKCrRtRFb98SUKovVyGwAu38R4yD3yWv6dWddpmT/6Q71Rn6jYQj/0ng0Mdq12snPc7EP6oRtnliuhNpZEpPOWqO+nzhJLhZffochdJN4aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4AA168C4E; Thu, 21 Nov 2024 11:52:48 +0100 (CET)
Date: Thu, 21 Nov 2024 11:52:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@lst.de,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121105248.GA10449@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <20241121101325.GA5608@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121101325.GA5608@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 11:13:25AM +0100, Christoph Hellwig wrote:
> proper zeroout ioctl, which fixes my generic/757 issues, and should

It turns out then when I extrapolate my shortened 10 iteration run
to the 100 currently in the test it would take ~ 30 minutes.  I'm
not sure that's really a reasonable run time for a single test in
the auto group.

