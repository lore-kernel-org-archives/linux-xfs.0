Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3172262B
	for <linux-xfs@vger.kernel.org>; Fri,  8 Mar 2024 02:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709863202; cv=none; b=psNLqBTFiGvf+/JaiFp+fwNSc1PGv2L2Dfi4CCm5DbAUKmVJPfpypH9CFvH92ZPtzm9vgY4+ehSsDbxqHYNSGxlSt9Ng8QEkT8qNzhLUTiUZb5tCF83Vc6Wnl3/yRdug4FHfboQ5jKFC9R3fHwtPx39Q+r0ciALznL9dh15SRfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709863202; c=relaxed/simple;
	bh=JjBNnzKC9id9p7QFftineoXbQY243jNuD6d97+uc4cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7YZe39zo51FQEx4yX5zHKFcOMvzyXPZ9++66ODqCrYd63SkvAG+Cq8+70lxvTm+qGYxQ8A9z5IZOSxmRkCqIrMXPN6i1h9UmKwDgaM9rH9JYkXWMTHc+oIcyoir3u0A/V5EIHgMatUHOv+CIvUjomC4PuT1PgOWfC9e5PpFiUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dsv6H5q3; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dsv6H5q3"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc75972f25so13382065ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Mar 2024 18:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709863200; x=1710468000; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MLYc7BKQVYfFVjsRePJzvoAnkhzhPJ6R/TxL2FyKgY=;
        b=dsv6H5q3S3tPzSmLnaLXuvvcPCm3E4DiynF+wKtG8Jh5TxAkaqeKvK9r0piLXLa1Fj
         B/lTiDen00ZuHnrETOVEPhIgcZFCmfyf7eFAxw8UFnjpp+uA1RWsLbc5qYQoOQHzFr8C
         xOSpg9BRLg/G43NfvtwuS/bGJqPeOyCwl8bPINPKIn8xx3Shbzqj9TKumA+PYuXv4iUQ
         i4l/vx/iPPqhszF5g/bbSobNEg0/7CGf8nw5bFzTwRutTV4INo+QoAyiFop2XW4YvEre
         tnh7zIeEcr8nmKR5SzH/IIGo/FgMBHKnDvu/VGrAz6n/A7dm5kbqiiAlrw2TQM2MD2CI
         +B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709863200; x=1710468000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MLYc7BKQVYfFVjsRePJzvoAnkhzhPJ6R/TxL2FyKgY=;
        b=Sk+MDzwZ26Wr8rhmpXpDrPrH4c8Xa548v2k9zLBb+l8Ql/shM/h85t61IJdS2AUlsF
         V97Zrl/llOvOO3ZYF9ZkUDFBN16CcgQeMOoy0Ma0xd+8qhVUGQ+UcMciyR+tOqIBN/sg
         LDecU0ZyTYhEjvtKlfa5AlkI7/2jQ6M263CMJtVli9TalLnUUGRUu00L7b5CbpIQQqb/
         xiObJD557HILnW/VW9WKeanMx2ipmaLYnNA6qtDJQCjMQhsMP/Hsm1NTpnN0X/7HKcxP
         XT/P4X0/ZZAfP2xC9awpfAOEwLLlG34pvb8yhOSuE6wRnMMR7izL2YKyw0ylazIeRaGb
         KW/w==
X-Forwarded-Encrypted: i=1; AJvYcCVVUT1Rzdvf8VTF/vSQa2vd6AB/u2xRTXJJgF+nRwvSy8OLJFw5vc/UCCxZF+QXI3q5hW1WuaK9pShwBCSFxeeuFaYIYOeVAFbU
X-Gm-Message-State: AOJu0YzS0XnlHrdV6+0VUrqFWCE/lYbGGiEBfmEFCXvfV9LSRy51emxI
	kRAPd+mKTEmmdivqtkVgwVpHfXvuCM9ZDfmmR1J3+NRlgjgPoeqLLjQa98YwgDo=
X-Google-Smtp-Source: AGHT+IEezWZlZy5CuteXB2TEn2oTd6sCaxkoIZ1Q+l6TmpaJgK87Z5LH44REIf+RAxUhKaLcxM/Xpg==
X-Received: by 2002:a17:902:f604:b0:1dd:2eed:52a5 with SMTP id n4-20020a170902f60400b001dd2eed52a5mr10668307plg.37.1709863199796;
        Thu, 07 Mar 2024 17:59:59 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id kx3-20020a170902f94300b001dca40bb727sm15350687plb.88.2024.03.07.17.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 17:59:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1riPWe-00GVgK-19;
	Fri, 08 Mar 2024 12:59:56 +1100
Date: Fri, 8 Mar 2024 12:59:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com, ebiggers@kernel.org
Subject: Re: [PATCH v5 11/24] xfs: add XBF_VERITY_SEEN xfs_buf flag
Message-ID: <ZepxHObVLb3JLCl/@dread.disaster.area>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-13-aalbersh@redhat.com>
 <20240307224654.GB1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307224654.GB1927156@frogsfrogsfrogs>

On Thu, Mar 07, 2024 at 02:46:54PM -0800, Darrick J. Wong wrote:
> On Mon, Mar 04, 2024 at 08:10:34PM +0100, Andrey Albershteyn wrote:
> > One of essential ideas of fs-verity is that pages which are already
> > verified won't need to be re-verified if they still in page cache.
> > 
> > XFS will store Merkle tree blocks in extended file attributes. When
> > read extended attribute data is put into xfs_buf.
> > 
> > fs-verity uses PG_checked flag to track status of the blocks in the
> > page. This flag can has two meanings - page was re-instantiated and
> > the only block in the page is verified.
> > 
> > However, in XFS, the data in the buffer is not aligned with xfs_buf
> > pages and we don't have a reference to these pages. Moreover, these
> > pages are released when value is copied out in xfs_attr code. In
> > other words, we can not directly mark underlying xfs_buf's pages as
> > verified as it's done by fs-verity for other filesystems.
> > 
> > One way to track that these pages were processed by fs-verity is to
> > mark buffer as verified instead. If buffer is evicted the incore
> > XBF_VERITY_SEEN flag is lost. When the xattr is read again
> > xfs_attr_get() returns new buffer without the flag. The xfs_buf's
> > flag is then used to tell fs-verity this buffer was cached or not.
> > 
> > The second state indicated by PG_checked is if the only block in the
> > PAGE is verified. This is not the case for XFS as there could be
> > multiple blocks in single buffer (page size 64k block size 4k). This
> > is handled by fs-verity bitmap. fs-verity is always uses bitmap for
> > XFS despite of Merkle tree block size.
> > 
> > The meaning of the flag is that value of the extended attribute in
> > the buffer is processed by fs-verity.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.h | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 73249abca968..2a73918193ba 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -24,14 +24,15 @@ struct xfs_buf;
> >  
> >  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
> >  
> > -#define XBF_READ	 (1u << 0) /* buffer intended for reading from device */
> > -#define XBF_WRITE	 (1u << 1) /* buffer intended for writing to device */
> > -#define XBF_READ_AHEAD	 (1u << 2) /* asynchronous read-ahead */
> > -#define XBF_NO_IOACCT	 (1u << 3) /* bypass I/O accounting (non-LRU bufs) */
> > -#define XBF_ASYNC	 (1u << 4) /* initiator will not wait for completion */
> > -#define XBF_DONE	 (1u << 5) /* all pages in the buffer uptodate */
> > -#define XBF_STALE	 (1u << 6) /* buffer has been staled, do not find it */
> > -#define XBF_WRITE_FAIL	 (1u << 7) /* async writes have failed on this buffer */
> > +#define XBF_READ		(1u << 0) /* buffer intended for reading from device */
> > +#define XBF_WRITE		(1u << 1) /* buffer intended for writing to device */
> > +#define XBF_READ_AHEAD		(1u << 2) /* asynchronous read-ahead */
> > +#define XBF_NO_IOACCT		(1u << 3) /* bypass I/O accounting (non-LRU bufs) */
> > +#define XBF_ASYNC		(1u << 4) /* initiator will not wait for completion */
> > +#define XBF_DONE		(1u << 5) /* all pages in the buffer uptodate */
> > +#define XBF_STALE		(1u << 6) /* buffer has been staled, do not find it */
> > +#define XBF_WRITE_FAIL		(1u << 7) /* async writes have failed on this buffer */
> > +#define XBF_VERITY_SEEN		(1u << 8) /* buffer was processed by fs-verity */
> 
> Yuck.  I still dislike this entire approach.
> 
> XBF_DOUBLE_ALLOC doubles the memory consumption of any xattr block that
> gets loaded on behalf of a merkle tree request, then uses the extra
> space to shadow the contents of the ondisk block.  AFAICT the shadow
> doesn't get updated even if the cached data does, which sounds like a
> landmine for coherency issues.
>
> XFS_DA_OP_BUFFER is a little gross, since I don't like the idea of
> exposing the low level buffering details of the xattr code to
> xfs_attr_get callers.
> 
> XBF_VERITY_SEEN is a layering violation because now the overall buffer
> cache can track file metadata state.  I think the reason why you need
> this state flag is because the datadev buffer target indexes based on
> physical xfs_daddr_t, whereas merkle tree blocks have their own internal
> block numbers.  You can't directly go from the merkle block number to an
> xfs_daddr_t, so you can't use xfs_buf_incore to figure out if the block
> fell out of memory.
>
> ISTR asking for a separation of these indices when I reviewed some
> previous version of this patchset.  At the time it seems to me that a
> much more efficient way to cache the merkle tree blocks would be to set
> up a direct (merkle tree block number) -> (blob of data) lookup table.
> That I don't see here.
>
> In the spirit of the recent collaboration style that I've taken with
> Christoph, I pulled your branch and started appending patches to it to
> see if the design that I'm asking for is reasonable.  As it so happens,
> I was working on a simplified version of the xfs buffer cache ("fsbuf")
> that could be used by simple filesystems to get them off of buffer
> heads.
> 
> (Ab)using the fsbuf code did indeed work (and passed all the fstests -g
> verity tests), so now I know the idea is reasonable.  Patches 11, 12,
> 14, and 15 become unnecessary.  However, this solution is itself grossly
> overengineered, since all we want are the following operations:
> 
> peek(key): returns an fsbuf if there's any data cached for key
> 
> get(key): returns an fsbuf for key, regardless of state
> 
> store(fsbuf, p): attach a memory buffer p to fsbuf
> 
> Then the xfs ->read_merkle_tree_block function becomes:
> 
> 	bp = peek(key)
> 	if (bp)
> 		/* return bp data up to verity */
> 
> 	p = xfs_attr_get(key)
> 	if (!p)
> 		/* error */
> 
> 	bp = get(key)
> 	store(bp, p)

Ok, that looks good - it definitely gets rid of a lot of the
nastiness, but I have to ask: why does it need to be based on
xfs_bufs?  That's just wasting 300 bytes of memory on a handle to
store a key and a opaque blob in a rhashtable.

IIUC, the key here is a sequential index, so an xarray would be a
much better choice as it doesn't require internal storage of the
key.

i.e.

	p = xa_load(key);
	if (p)
		return p;

	xfs_attr_get(key);
	if (!args->value)
		/* error */

	/*
	 * store the current value, freeing any old value that we
	 * replaced at this key. Don't care about failure to store,
	 * this is optimistic caching.
	 */
	p = xa_store(key, args->value, GFP_NOFS);
	if (p)
		kvfree(p);
	return args->value;

-Dave.
-- 
Dave Chinner
david@fromorbit.com
