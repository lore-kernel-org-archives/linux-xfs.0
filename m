Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CEA33D6CB
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771408662; cv=none; b=f+kMmX/LmOiAMYi6XO0PmTZhb6nRJ78Naz2gPPiZV1rrJutS37n017pyO2VEphOn37PM8MD3ZxbxUw1dSC4egg0CIJMKurW68FQ95HlP5mQoupJpXDrQspSMRRMdtmfip8YepgNZPFGNDKnKiaG0kU8qdug0zJrKBk/YEyra0UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771408662; c=relaxed/simple;
	bh=6aOIQiPaQR+XKiGerpItA4/7Z/95kKFkL1ZGyjcNy1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gF2G0R0YJ8AvVOcIiBbFJiRcBiycXEj8CEtOw63iP/NSQYQO0NlZjQPoSPKvZDyJxnYsXa9uE28Jwo2jg1esaXsmvDjy2FyH7iFFEjf1J0D005jHLR5xI82s4q2q9YoV9e9MXw7RPF09uG5Fca9v3w6j5wxd50xllaeQy+pWPjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQ4x99Hf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+EV+HOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQ4x99Hf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+EV+HOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771408660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=//uspxAcdKQl0NBbsDDK4OeRCiJdPlDUYGGqBQXBcNc=;
	b=IQ4x99HfOQv8vGeMWFnh3IuKTRgNze/OOizEDk9cXDC2QI7GCoTrwYtaABcCoUZXLPcZgc
	mb9kCPOBXy9GsaTJSQ6+YDPrw6uw6m1H6z1p83toMh9XhXu2E8zXAAisDgyNp0wL9995Pt
	O75kmysVHjC2F/blJszlvuVTyfkY8Os=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-mjWJy9SwPS-qZkwacRSagw-1; Wed, 18 Feb 2026 04:57:38 -0500
X-MC-Unique: mjWJy9SwPS-qZkwacRSagw-1
X-Mimecast-MFC-AGG-ID: mjWJy9SwPS-qZkwacRSagw_1771408657
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so50187155e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 01:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771408657; x=1772013457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=//uspxAcdKQl0NBbsDDK4OeRCiJdPlDUYGGqBQXBcNc=;
        b=S+EV+HOwXcML8p0VxD2MKBcuonNoxmyFYzZHvzcDPnrk2wkiO2Dh84O71rM8nBgVuP
         nqjmoacRGlILt3TFq9qwjKnR0p16mpS6cso9veyXQKINFiF8+A09XqCltd6jMHfgNYk4
         pzArnu8ElnRxm/x/YdKS3nqwbWstVEKm0IAl/RLWV/iuXftzT7NjESrronXb83dY9V+A
         IMgnmWrlO34HuuqSSBvmX7hF6XbrUyN6rzyTcukBX+CR6R9AkvGHT3bX8k88qdI+3ABp
         qcuFTKBqftLo0LD31WNfnnAVJgRYa+matC2eLHJkVrynGxNoLBulLuy/cTuRznExPEY/
         xYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771408657; x=1772013457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//uspxAcdKQl0NBbsDDK4OeRCiJdPlDUYGGqBQXBcNc=;
        b=EjxwJ3nQqV94kHJijfJqqd6DigvGtAcTf6+C4hKCSVYJpLVHR5FzEPTVclCjjJo3hs
         EhCe9/01O/4RcoCKlVAk1SizKwAaJz9QHhV8Ch4sGmZNzjg1gedIRYWPNDjzrF5vBLnA
         hMp1KsYNIjrHnLh2oWWVwT3v6Wmdnba9L29/HVlSUSwkoO3L/BMQtiz9WMJ7tMrIowyU
         g8ZErlTtlCUzO+fMwvnOAUXwdOnWeE5iyqGIENF43BqlFJ2VMnohBwpTpnwZ9IqZMO82
         iN7/puHFTKE4SL+gZq5wwgWgnX4W38IPnim1BVGBmqVx0ZoTkcCEK0w3YZu6+RKhdZqx
         DGdQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0DpTfdQsXMUj06kXmzZCM9TZGTbiOPDM93Sv1YLWKP0lJH5DaQA5dzk0cNL8NExVt6O8WShZovKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPFI5Y7uQYqFVw7OFTNOS6aJM35vxkfzh6KKrI7yUusGaPEzpb
	eV/ylX+Eqma6VWYaaR+Vt/v0k6lT1EhitzubL2eSujCKcZXQ07APRhWiDXnnONLxrwZFSfpTdFa
	G6rDyhCKzWqes2VLmyc0kOCqojWyn9Zk+Mr8Q5VVhGZVXfcT56sG0rxkymPFR
X-Gm-Gg: AZuq6aLIKaZwep4ITTmzg+QReSQ/X7N01RxD4vzMADsHV8F9/Ji/jr1qedFLDKygUSI
	bEoN5KoaZDST9luKUNnwYvYMj0XQTV3Hk1/nOkfJbvlEtgnNReFd6Ph75keKn/VPvyAAtX4T5aY
	8yYM5a+XcBwf1ylcTLDWJ6zLxOTTO+zwfs2D16SO1ytds4MGLZniAXn4i9pBSjXBf+Tbnkjrrri
	42nTaxH+fobw14MyqL92Xsp813iWQ7jpvpCMMt+Pn0VieM6HA2HpXtBACP0/h4AtZwIW8EOXC5t
	LqyugklEnlX3XfeNySL6O9Xa7878MzdpGLQQ174HSX24c2IxYDHuaPonOQdidFThesFKmaWKf0+
	9tY8SrCkQXZI=
X-Received: by 2002:a05:600c:820f:b0:483:71f7:2797 with SMTP id 5b1f17b1804b1-48379b9f3a3mr224711135e9.14.1771408657373;
        Wed, 18 Feb 2026 01:57:37 -0800 (PST)
X-Received: by 2002:a05:600c:820f:b0:483:71f7:2797 with SMTP id 5b1f17b1804b1-48379b9f3a3mr224710785e9.14.1771408656858;
        Wed, 18 Feb 2026 01:57:36 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b68e5adsm382224275e9.9.2026.02.18.01.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 01:57:36 -0800 (PST)
Date: Wed, 18 Feb 2026 10:57:35 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-29-aalbersh@kernel.org>
 <20260218064429.GC8768@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218064429.GC8768@lst.de>

On 2026-02-18 07:44:29, Christoph Hellwig wrote:
> > +static int
> > +xfs_fsverity_read(
> > +	struct inode	*inode,
> > +	void		*buf,
> > +	size_t		count,
> > +	loff_t		pos)
> > +{
> > +	struct folio	*folio;
> > +	size_t		n;
> > +
> > +	while (count) {
> 
> It might be nice to lift this from ext4/f2fs into common code rather
> than adding yet another duplicate.

sure

> 
> > +static int
> > +xfs_fsverity_write(
> > +	struct file		*file,
> > +	loff_t			pos,
> > +	size_t			length,
> > +	const void		*buf)
> > +{
> > +	int			ret;
> > +	struct iov_iter		iiter;
> > +	struct kvec		kvec = {
> > +		.iov_base	= (void *)buf,
> > +		.iov_len	= length,
> > +	};
> > +	struct kiocb		iocb = {
> > +		.ki_filp	= file,
> > +		.ki_ioprio	= get_current_ioprio(),
> > +		.ki_pos		= pos,
> > +	};
> > +
> > +	iov_iter_kvec(&iiter, WRITE, &kvec, 1, length);
> > +
> > +	ret = iomap_file_buffered_write(&iocb, &iiter,
> > +				   &xfs_buffered_write_iomap_ops,
> > +				   &xfs_iomap_write_ops, NULL);
> > +	if (ret < 0)
> > +		return ret;
> > +	return 0;
> 
> I'd move this to fs/iomap/ as and pass in the ops.

sure

> 
> > +static int
> > +xfs_fsverity_drop_descriptor_page(
> > +	struct inode	*inode,
> > +	u64		offset)
> > +{
> > +	pgoff_t index = offset >> PAGE_SHIFT;
> > +
> > +	return invalidate_inode_pages2_range(inode->i_mapping, index, index);
> > +}
> 
> What is the rationale for this?  Why do ext4 and f2fs get away without
> it?

They don't skip blocks full of zero hashes and then synthesize them.
XFS has holes in the tree and this is handling for the case
fs block size < PAGE_SIZE when these tree holes are in one folio
with descriptor. Iomap can not fill them without getting descriptor
first.

Should I add this to the comment above? Not sure how well it's
described

> 
> > +	pgoff_t			index)
> > +{
> > +	pgoff_t			metadata_idx =
> > +		(fsverity_metadata_offset(inode) >> PAGE_SHIFT);
> > +	pgoff_t			idx = index + metadata_idx;
> > +
> > +	return generic_read_merkle_tree_page(inode, idx);
> 
> I'd write this the same way ext4/f2fs do:
> 
> 	idx += (fsverity_metadata_offset(inode) >> PAGE_SHIFT);
> 	return generic_read_merkle_tree_page(inode, idx);
> 

sure

> 
> 
> > +{
> > +	pgoff_t			metadata_idx =
> > +		(fsverity_metadata_offset(inode) >> PAGE_SHIFT);
> > +	pgoff_t			idx = index + metadata_idx;
> > +
> > +	generic_readahead_merkle_tree(inode, idx, nr_pages);
> 
> Same here.
> 
> > +	if ((i == size) && (size == ip->i_mount->m_sb.sb_blocksize))
> 
> No need for the inner braces.
> 

-- 
- Andrey

