Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3C1DDF5;
	Tue, 27 Aug 2024 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724781221; cv=none; b=bDEVZlL/sVylLkQMADFqZPbCYupznqrNSKAdA5hXuaTU5gIo4xD5Xc40NrzR4Dfe7k/pGmkpXPB1KBDk4XR5Iww+34DfXb/BmSNpuQKUG+PaZ7E3o3LG6Ncuc9HDF5oy23sSp7qTeIE8QcsDqHNqRooWx+Rp3xKc9/mPiw90+nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724781221; c=relaxed/simple;
	bh=U338rpc4wK7JK5dAvhU6nIhlrQaqgzG2x/Ra0BY7rL8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RAdi+uSrSRO+Ui5366ndng6VBBgk/icrof4iSTouo5WIBSVeNPihm1YSsyvDP0jD8Kdl7quMmUvajtbd7eluQ8urh0CgJVzHJjkGKblM01hYOB255d712wV/9kwlMabS0BLj8P/V8FCYej6c7vR1IgTqj0n2f4E5VO+bhZN6bHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwT00Gie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwT00Gie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387ADC55DE3;
	Tue, 27 Aug 2024 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724781221;
	bh=U338rpc4wK7JK5dAvhU6nIhlrQaqgzG2x/Ra0BY7rL8=;
	h=Date:From:To:Cc:Subject:From;
	b=cwT00Gie1Oyq4OONCZp5zq/DqEQx0cUlq52iyZ9sDIM5YI2q08BBKzxRvrCTo/B6U
	 bCnafFhLtbe+wY5sE3eMqd7IzDPYueP3o0SCBMwCNpe0kh/1T97jgrjtNnS7/afAs3
	 8amjxdnOrkFQOfl5aGvLq8MbcUqdrtVOVhsnqa2PeETvBY2M7Nw0moFZYJPkKslzdV
	 68h4XduAL7Pro5Nogrw/En7WucNRUfF7+yimOr84FCPuGG1FQ+F3APTYhkPY9ppIDp
	 m/CupkEFltSXp5hgP2F4Kf+SuQAzTNzRlrhh4U0U7cut7CmryIefA8pA5j/c/IWqEi
	 BcHi2SY2wVUmg==
Date: Tue, 27 Aug 2024 10:53:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-block <linux-block@vger.kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH] block: fix detection of unsupported WRITE SAME in
 blkdev_issue_write_zeroes
Message-ID: <20240827175340.GB1977952@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

On error, blkdev_issue_write_zeroes used to recheck the block device's
WRITE SAME queue limits after submitting WRITE SAME bios.  As stated in
the comment, the purpose of this was to collapse all IO errors to
EOPNOTSUPP if the effect of issuing bios was that WRITE SAME got turned
off in the queue limits.  Therefore, it does not make sense to reuse the
zeroes limit that was read earlier in the function because we only care
about the queue limit *now*, not what it was at the start of the
function.

Found by running generic/351 from fstests.

Fixes: 64b582ca88ca1 ("block: Read max write zeroes once for __blkdev_issue_write_zeroes()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 block/blk-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 83eb7761c2bfb..4c9f20a689f7b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -174,7 +174,7 @@ static int blkdev_issue_write_zeroes(struct block_device *bdev, sector_t sector,
 	 * on an I/O error, in which case we'll turn any error into
 	 * "not supported" here.
 	 */
-	if (ret && !limit)
+	if (ret && !bdev_write_zeroes_sectors(bdev))
 		return -EOPNOTSUPP;
 	return ret;
 }
