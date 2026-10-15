Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E98952BE5F
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792073403; cv=none; b=Vdo3RKF+M8Ru5L5O+/neioIkqKKW9ZeqgwZoJFefBC0EQX2r08sOO582eaXhLxEwGU7UnPWkmF6hCem3eGhqvZee5jxyQTgjtGROJm1pEUJfXknebsbxrmS+keMah2bZqHckyhIEX9ybMk82C1i73RsXdsBtWNjypXzemAHvNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792073403; c=relaxed/simple;
	bh=IoHF48dbE7mSf4cxc6kAiqoGLhZGegSeGkb8H4uroPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENddGG5h9icB7gIKqYpA9im6B4MqmPANED8aULwlQXGrOE/uhXmxWIVGEodbCR/3GgLJ2Kvq6pZ1sg9JxX/H306W2tei5JFqQyPw+J0hKDpFI3Wz4fEkloIFBtVSt7tPKzRPYCmfUazgrgFeqT3w2Iym5+S6hQGjeEX7NVjxq/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rz+Utc8b; arc=none smtp.client-ip=91.218.175.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rz+Utc8b"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IoHF48dbE7mSf4cxc6kAiqoGLhZGegSeGkb8H4uroPU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792073399; v=1; x=1792678199;
 b=rz+Utc8bAGijsFCr/QEl8LzFZmlaXbdU+3KQ3TSCpCvY0NCBAVrqDDFHlDy9pKg1g4YOoEAy
 Q2F0H1awh18TQ2zYMDsIv97QFBbg+/gXwf1gB4N5daxMpDk/kLiOdTYOTiJlAyJHTJGL1nVvL5q
 M4Hjn4R55sL1v33sffhObyDs=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a2a20668fccf1d9d;
	Thu, 15 Oct 2026 14:09:59 +0000
X-Mizu-Trace-ID: a2a20668fccf1d9d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 15 Oct 2026 16:09:50 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andres Freund <andres@anarazel.de>, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <as-BQAbk7U43vkqs@quentin>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>

Hi Ojaswin,

I was comparing normal buffered IO scenario and writethrough.

In a normal buffered IO scenario, for unwritten extents or CoW extents,
we first convert them before ending the writeback on the folio.
xfs_end_io calls xfs_end_ioend_write().

static void
xfs_end_ioend_write(
        struct iomap_ioend      *ioend)
{
<snip>
       /*
         * Success: commit the COW or unwritten blocks if needed.
         */
        if (is_zoned)
                error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
                                ioend->io_private, NULLFSBLOCK);
        else if (ioend->io_flags & IOMAP_IOEND_SHARED)
                error = xfs_reflink_end_cow(ip, offset, size);
        else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
                error = xfs_iomap_write_unwritten(ip, offset, size, false);

        if (!error &&
            !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
            xfs_ioend_is_append(ioend))
                error = xfs_setfilesize(ip, offset, size);
done:
        if (is_zoned)
                xfs_ioend_put_open_zones(ioend);
        iomap_finish_ioends(ioend, error); // #1
        memalloc_nofs_restore(nofs_flag);
}

#1
iomap_finish_ioends()
  iomap_finish_ioend_buffered_write()
    iomap_finish_folio_write()
      folio_end_writeback()


On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> @@ -1185,6 +1186,384 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
> +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct kiocb *iocb	= wt_ctx->iocb;
> +	struct inode *inode	= wt_ctx->inode;
> +	ssize_t ret		= wt_ctx->error;
> +
> +	if (wt_ctx->end_io) {
> +		int err = wt_ctx->end_io(wt_ctx, wt_ctx->written,
> +					 wt_ctx->error,
> +					 wt_ctx->flags);
> +		if (err)
> +			ret = err;
> +	}
> +

<snip>

> +static void iomap_writethrough_bio_end_io(struct bio *bio)
> +{
> +	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
> +	struct folio_iter fi;
> +
> +	if (bio->bi_status)
> +		cmpxchg(&wt_ctx->error, 0,
> +			blk_status_to_errno(bio->bi_status));
> +	bio_for_each_folio_all(fi, bio)
> +		folio_end_writeback(fi.folio);
> +
> +	bio_put(bio);
> +	if (atomic_dec_and_test(&wt_ctx->ref))
> +		iomap_writethrough_done(wt_ctx);
> +}
> +

But in the writethrough patches, we first end the writeback on the folio
and then call xfs_dio_write_end_io(), which converts unwritten or CoW
extents.

Is there a race possible as we are doing the other way? What if folios
are reclaimed between ending the writeback and conversion? A new read in
that area will return zero filled folios as XFS still sees IOMAP_UNWRITTEN?

I don't have a reproducer, but my hunch says we can run into this if we
have a lot of AIO as the end_io will be run via a workqueue?

Do we do something similar to buffered IO where we do
folio_end_writeback after extents conversion?

--
Pankaj
