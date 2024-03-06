Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805781DA4C;
	Wed,  6 Mar 2024 12:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709728511; cv=none; b=bJnS1TfNkW2IJsjKPY2/4zWqq9ik+2p8UrbQ/OzdPX8eWM+ycgp4qJMdzH6CNSF0us+deF/m98idZ7JBlrhoPpAkQjkgS1NkO8Tw4uEghhqcNnER2pVW3aW2YVk65ZyjW7aEpn9Sxm8/f2UoWaGW4iSsPWOnCE/KkcbhOcrbxDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709728511; c=relaxed/simple;
	bh=fWeI83M9SllzmmwRVoUzhdlwWDPbRvMJ0yYQPcjR+EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtsvLjE3ISOy0KpvMjNFr75lo6qQ3ecJ88MFrPh5fEk7XvGTJLvWDPdEcdE8HDeOTu4tF5iRwzo0jODcvjzhoHO+pwkwhE9PPUtcJa3/eraMZgibX/97bVPFfmB3Qdp5Pf7DYml2S3XLR+aWErJuHQpMGumFmShPo6F2xAqy54c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JF9jcqfa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JF9jcqfa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pMJt7ru71X7BbY61U1eDHHpqO7p3FsPHLnxlYmruOjE=; b=JF9jcqfaaC2ddl/O0kBHY770gq
	PTLK9WRJ2F0/Ln+2tPiWuusv3joopQUUDWvqlh4SFnhkj6x712oz514ww/LVvcPeHQJ6BrYa5+hN0
	kWXlqjO/qV9164Kszi9ntYN89/Apc2oK91nWovHMPw8zIsBGftTrOKoT1yPndScVmL7kNNQl5I8lO
	dALMLuab8FS8gpk83kHqu0UCX9lQtMx1/C8GucLw0hw2T3wJeBrALtCkreXVXCnaiGpinkWu1m4qt
	Mc6eTcZ/uQwUeau1tIbc7gPA4cKfYo95d3m0iJmS4vqMCFYRuPNp1kzx4b5kfS6ZX70QlHwQDgQEh
	DpkJIhUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rhqUH-00000000DRN-3lCk;
	Wed, 06 Mar 2024 12:35:09 +0000
Date: Wed, 6 Mar 2024 04:35:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: kbusch@kernel.org, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <Zehi_bLuwz9PcbN9@infradead.org>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 06, 2024 at 12:49:29PM +0530, Chandan Babu R wrote:
> The above *probably* occured because __blkdev_issue_discard() noticed a pending
> signal, processed the bio, freed the bio and returned a non-NULL bio pointer
> to the caller (i.e. xfs_discard_extents()).
> 
> xfs_discard_extents() then tries to process the freed bio once again.

Yes, __blkdev_issue_discard really needs to clear *biop to NULL for
this case, i.e.:

diff --git a/block/blk-lib.c b/block/blk-lib.c
index dc8e35d0a51d6d..26850d4895cdaf 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -99,6 +99,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		cond_resched();
 		if (fatal_signal_pending(current)) {
 			await_bio_chain(bio);
+			*biop = NULL;
 			return -EINTR;
 		}
 	}
