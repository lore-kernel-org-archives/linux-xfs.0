Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351D29AB03;
	Mon, 25 Aug 2025 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108509; cv=none; b=MG7zp+aGb1xiql/AX5HQ2eutxbM4OkKf7uI19aK6DhIRk+FlHISK365Xq2Jvo/PpUTQpG3V72FF/l5uZjHcG3cGcYOqrHwWO/S+BrB7fosy2Kv5q8Uk6Mq9iM7c501T4b3Sv8u3Hh39Bjc+mCRqbYc/Tm/0ruMPGJwhO7p/LCrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108509; c=relaxed/simple;
	bh=yUwyQSjPgTyoXYO3CKgw3iUNbrBWCVTOhYMSnEpKlrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cI2X9EoAYIzHF/Eyrr+rKd4WdCqshsCFfxmlXb5eZIs2G7KpO/xn9eOV54R3Y4vJThOClohyCljXBWv9mkWQ8TmSOK08U9SzZsMAvO6jC0lFt+kItc8qx3IVgfwjuXxlwTjOGqeIQWuQaa+6qzzzLtH7fd/djhFAHWcKV8rvlt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ki2oCaW/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ki2oCaW/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jsh4ai5AN2vxCVAdRk70X1tRdSAt7TW9eqIURxMtMIw=; b=Ki2oCaW/6/nh/Ndpcm3xRDTNkA
	Zfxvp5A4BrYP6esQxsyyUPe+eqiZALIjdHs2kPNVjOmj7NkC6XCwmsiXskLEauUmMLsu84Iy+pDNQ
	zoZsohYd7y0VheH282PO73BEx9tftMp7Tzu1ZMQpkHsp33Y9EZ5g6ag90UMPFVnkAvcCPAfMJVpKn
	a99ocGhzmsgAOkoM2BoTNObG85PAAVyBmlZsslaDlUppRbLdWKbWBiRTqCU4LSA+9Xa8Kae0tQpeq
	TxXCJcdkqmT3Kp+FuE42zfDjXZjJ8e/ThUuInGJS6pi7Dwwi7WSJcV2UHIui3WftArS87FB/75zoA
	rv6JCNvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqS2k-00000007EFY-1bW1;
	Mon, 25 Aug 2025 07:55:06 +0000
Date: Mon, 25 Aug 2025 00:55:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Message-ID: <aKwW2gEnQdIdDONk@infradead.org>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822152137.GE7965@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 22, 2025 at 08:21:37AM -0700, Darrick J. Wong wrote:
> We only flag corruptions for these two error codes, but ENODATA from the
> block layer means "critical medium error".  I take that to mean the
> media has permanently lost whatever was persisted there, right?

It can also be a write error.  But yes, it's what EIO indidcates in
general.  Which is why I really think we should be doing something like
the patch below.  But as I don't have the time to fully shephed this
I'm not trying to block this hack, even if I think the issue will
continue to byte us in the future.

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f9ef3b2a332a..0252faf038aa 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1290,6 +1290,22 @@ xfs_bwrite(
 	return error;
 }
 
+static int
+xfs_buf_bio_status(
+	struct bio		*bio)
+{
+	switch (bio->bi_status) {
+	case BLK_STS_OK:
+		return 0;
+	case BLK_STS_NOSPC:
+		return -ENOSPC;
+	case BLK_STS_OFFLINE:
+		return -ENODEV;
+	default:
+		return -EIO;
+	}
+}
+
 static void
 xfs_buf_bio_end_io(
 	struct bio		*bio)
@@ -1297,7 +1313,7 @@ xfs_buf_bio_end_io(
 	struct xfs_buf		*bp = bio->bi_private;
 
 	if (bio->bi_status)
-		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
+		xfs_buf_ioerror(bp, xfs_buf_bio_status(bio));
 	else if ((bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
 		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		xfs_buf_ioerror(bp, -EIO);
