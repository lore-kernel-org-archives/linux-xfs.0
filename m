Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF9A146D40;
	Tue, 26 Nov 2024 04:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732596930; cv=none; b=mmpqc5esSztHw0KYusWhV83fHhfCF8aoTtZKNXxUILzioX+g+iW6r621u+0Ki3IHfJ1FapD4RC1a5/lQYcGNxuvnTmfd0lOlf1TJbkJXS7o7mlkmyhePnkgmg1RdYYeo8tTrg8fyyaVlVaBVSvb2iRTTgbEUrVkGHRs5ZNqW8j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732596930; c=relaxed/simple;
	bh=zvRC8Tl8sga2HYS2j19v6fERMCMmsr1tTBQEvYCNcCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4As3K6nOJwb8LXvMvBj1zP+v6a8U01Hweiz+ddAuQ4Z9mNqZ1Wcm/eWgd9hm0iZVE8cssgbydjyCMcrDFJZ6KGwqdKQPYzTT/cNuftAs+RfjBS6VJRN/MBMI3e3Pg0ZMWm2njSfrQqxRbgl/I1zV8L1FqmT8sACB3jIL5Wx3vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=moG/iaU5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="moG/iaU5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9PTpwmpjGgvkLiwCm50c4gsCHJTaC7KAoxcJW3gK08A=; b=moG/iaU5Tc6fMBwjTaR1MBkLmC
	TW7IowSuHP8f/xQOjMQiwiiXVfjGi4TNUDCHWq1yitv8osiTL2JAyl7w3HRxaimiBRL5uMuZNKZv3
	yvWWWNe02q/cy6jpck6UUC1nZOvJ+5a9Hlo1hWEiWw1JELZu1ef0GO/mtVdkhqUfTR/FuYgG5pI+k
	s+TWqpGNtiSV9bVKSIbBZITxXyPwsevL4UklQNxJm5Lu225g95DsFCu9NGtMLPpDLj18dnWOOq3xZ
	IjH+QOGVDmDix5ib+Q0pEe3uPkwjLcaPcq4K9ZmlcbZf+5tiSHGCkj1rpW7mCOPTgC7cusB1iJ+Vl
	dJC8Fx6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFnbj-00000009dQ6-2OOs;
	Tue, 26 Nov 2024 04:55:27 +0000
Date: Mon, 25 Nov 2024 20:55:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] generic/562: handle ENOSPC while cloning gracefully
Message-ID: <Z0VUvxaPnnAs7UEo@infradead.org>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <173258395162.4031902.7701863569170725350.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258395162.4031902.7701863569170725350.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:22:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test creates a couple of patterned files on a tiny filesystem,
> fragments the free space, clones one patterned file to the other, and
> checks that the entire file was cloned.
> 
> However, this test doesn't work on a 64k fsblock filesystem because
> we've used up all the free space reservation for the rmapbt, and that
> causes the FICLONE to error out with ENOSPC partway through.  Hence we
> need to detect the ENOSPC and _notrun the test.
> 
> That said, it turns out that XFS has been silently dropping error codes
> if we managed to make some progress cloning extents.  That's ok if the
> operation has REMAP_FILE_CAN_SHORTEN like copy_file_range does, but
> FICLONE/FICLONERANGE do not permit partial results, so the dropped error
> codes is actually an error.
> 
> Therefore, this testcase now becomes a regression test for the patch to
> fix that.

Still no big fan of having a btrfs-specific must not ENOSPC
assumption in a generic test.  So my preference would be to move
the must not error at all case into a btrfs specific test and make
your newly added ENOSPC handling unconditional.  But I guess the
state with this patch is strictly better than without, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

