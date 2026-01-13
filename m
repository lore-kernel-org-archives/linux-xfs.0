Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2347223336
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768306993; cv=none; b=Bq8fXF4kWUSCuKo3BYMrOszo6mXHP90djLpCeRIxGagQzgi96W3H+pFs2GQdqN5suiqxLM5tqtx1l9iNUuYcrNV/44D9u4oj9RW8IRY/C6JEPTIxxeTL8Lyps6i85QfBOvYkN42ich6jHz9s6ufHscRujJs3IOIOEQedj1YZR/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768306993; c=relaxed/simple;
	bh=Tg/j/+VkXSR2euQ1Kk7x1AhIGsUY+p/+rckmcuTxqY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVYjnEqIABh62y4iWTxyVnME0I17bzGao8XEnVkACxf+8uRkUcY7BVymaVNIwAdYQKNoPgb3K5ntY6i3JCaHsi+KZ+PGpBowBE6n6+IE54VRq08+06yDA6HdhikwnEC42Rp8ia9N1alHQjEMen2fBOTQfDJRCMOViMJrJn7p+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+K/JfSE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4hupmd2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+K/JfSE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4hupmd2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768306990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TuVoqMaQZ1pYUPaWYEfmSsILrC0krVKandDz6n8dcw=;
	b=O+K/JfSEZGG2C+3c03NcYtbnfnJcCRqVkym9h7KBE1D+4e3ZLcWhlc6/UoXNe5dFR0zpp8
	ObVFWgsOsDSlN5CwRu8ULWYFRRV+8CP+I6wyTQmpRmi29RBUe04/8VSVRcvaQ9uEicGP0G
	qTzoDpgnAcS6u6MKGWubZESUQK1b854=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-YDHqVCdaMRmhbduP4f-_mQ-1; Tue, 13 Jan 2026 07:23:09 -0500
X-MC-Unique: YDHqVCdaMRmhbduP4f-_mQ-1
X-Mimecast-MFC-AGG-ID: YDHqVCdaMRmhbduP4f-_mQ_1768306989
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477964c22e0so45520935e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 04:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768306988; x=1768911788; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/TuVoqMaQZ1pYUPaWYEfmSsILrC0krVKandDz6n8dcw=;
        b=F4hupmd2A58xwE+7th8f+rw7Kl3fmtKnCy6/j9HDMF64XD9T4y8hl1tuxgzTa83KNA
         /SjJjNy6Uiz5nfOcl9srkDmtYGpjGe0QUT88Vx8eBAAzFCD2s/IRh6YrAJ4L72fQkTcY
         pmdquOSz0L9reOLv4U6h8gpFVL54sSR/YSUraBkoERbaU6069diIzqFFAim1/zt2go1c
         QJr5HVpnjbNzEWmI/MvR4q2GI7E64u+guop4a0tvl4wTl/Vavm8ufJsBq3NU6fBz92Ud
         JRGW/8LZOqWwGpM5nGAaxzH0jfFVJW2S6Sj8W89fCJoLGVYB9bKoP0cD7tsWT2fYuJMK
         ke4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306988; x=1768911788;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TuVoqMaQZ1pYUPaWYEfmSsILrC0krVKandDz6n8dcw=;
        b=CRtkbu/z2++HydGnHY+Lazq1RtkI1Z+MvJk0MOnKMn4GDEmm/npIq/xLkLFAOWAAQd
         kpRpHjyyc4AW8nCQAkognmA4qG0TV3MEEDJKBHXkqXlu6g4f9KbNsC4gIongSsnRBR0H
         YtBvRFmLfai5g+PTfS/+Z4uX0PeDjqRiyVEwIb8zTLj5hjRNW2GnqoRGVhk85V2Xhne2
         9oDmffUWp9ENzeiInqGrr9Jw7HJYcaxCsOQvBokdEi6WODgilA/QX31R0G/HvqtbfkQL
         11l/MYWassR7u/Q0kTEWuG1n25mrdX0rDkWSZBO9mQys4rmXYgyifhWBswUxAwvpId4z
         jvBw==
X-Forwarded-Encrypted: i=1; AJvYcCXegQPWTEZAXsHkoKfRAdWW6WrAVZ8elAR28Xr/UsMm8QgeCJrTzQh+ZPMypa8tRc8maii25AD9Vgc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzcuqhvaf68NNyaR9OtrG/Nu9BSrJ2rQiOhoUgoOiTAmKp9YgBG
	qEgAQZ7pXkq6WY7EDyukRMbHYATPvORbbUZISDBb2QJn/nOsTxsKlaTx6NBAqst4g4dZcbz2rhE
	EXUhCzipy6Slah75P5jw73TI6wpal/ZRiggKSbBR8RpBfSEmbJ4fj87Au8dOHVo4vtGFe
X-Gm-Gg: AY/fxX5p8V58XWhAFh5GdFuWe2qLo379YMtvgKfowxlFyc98411WKBTqzy5HbGo16ap
	jkRW81eewy1vCNFp2UkzJn2b3A6mjdosGoJOMfXSpRLvPdmSmYgtw1iXyymj1Qw+Hip0jktqij5
	aBv9/Ov3RUOR1XSBXkMnpiiFrFQJjXDITXIoLc8tQcTsF1N6Jhkcb6mAj2irUjB9Pw7jMaRUxnv
	XP0cbppvazlV1MFds20PFNj1+H8J5+aUGggbFuDxe29tKvvY+yPmRb2NPFg/MTUQdk8ziiHX+Ex
	ne/nmpCfc9U5qKPz6nKVekrSyqKEN1cFTUhvp5hF9U3GkWaSBJHwAwZrWjJ7OsHfjWWxHnkex1Y
	=
X-Received: by 2002:a05:600c:c48f:b0:47d:403a:277 with SMTP id 5b1f17b1804b1-47ed7bfd511mr35482125e9.4.1768306988356;
        Tue, 13 Jan 2026 04:23:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEr0RACpmZBlMe7kT+6LC1QjSW7gAHd8MZ6pSzcyVRIgTjA8m3UJl2GbG2kQczOY+RVn3cfeA==
X-Received: by 2002:a05:600c:c48f:b0:47d:403a:277 with SMTP id 5b1f17b1804b1-47ed7bfd511mr35481655e9.4.1768306987799;
        Tue, 13 Jan 2026 04:23:07 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5edd51sm43942503f8f.29.2026.01.13.04.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:23:07 -0800 (PST)
Date: Tue, 13 Jan 2026 13:23:06 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 13/22] xfs: introduce XFS_FSVERITY_REGION_START
 constant
Message-ID: <5ax7476dl472kpg3djnlojoxo2k4pmfbzwzsw4mo4jnaoqumeh@t3l4aesjfhwz>
References: <cover.1768229271.patch-series@thinky>
 <qwtd222f5dtszwvacl5ywnommg2xftdtunco2eq4sni4pyyps7@ritrh57jm2eg>
 <20260112224631.GO15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260112224631.GO15551@frogsfrogsfrogs>

On 2026-01-12 14:46:31, Darrick J. Wong wrote:
> On Mon, Jan 12, 2026 at 03:51:25PM +0100, Andrey Albershteyn wrote:
> > This constant defines location of fsverity metadata in page cache of
> > an inode.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_fs.h | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 12463ba766..b73458a7c2 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -1106,4 +1106,26 @@
> >  #define BBTOB(bbs)	((bbs) << BBSHIFT)
> >  #endif
> >  
> > +/* Merkle tree location in page cache. We take memory region from the inode's
> 
> Dumb nit: new line after opening the multiline comment.
> 
> /*
>  * Merkle tree location in page cache...
> 
> also, isn't (1U<<53) the location of the Merkle tree ondisk in addition
> to its location in the page cache?

yes, it's file offset

> 
> That occurs to me, what happens on 32-bit systems where the pagecache
> can only address up to 16T of data?  Maybe we just don't allow fsverity
> on 32-bit xfs.

hmm right, check in begin_enable() will be probably enough

> 
> > + * address space for Merkle tree.
> > + *
> > + * At maximum of 8 levels with 128 hashes per block (32 bytes SHA-256) maximum
> > + * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in 53
> > + * bits address space.
> > + *
> > + * At this Merkle tree size we can cover 295EB large file. This is much larger
> > + * than the currently supported file size.
> > + *
> > + * For sha512 the largest file we can cover ends at 1 << 50 offset, this is also
> > + * good.
> > + *
> > + * The metadata is stored on disk as follows:
> > + *
> > + *	[merkle tree...][descriptor.............desc_size]
> > + *	^ (1 << 53)     ^ (block border)                 ^ (end of the block)
> > + *	                ^--------------------------------^
> > + *	                Can be FS_VERITY_MAX_DESCRIPTOR_SIZE
> > + */
> > +#define XFS_FSVERITY_REGION_START (1ULL << 53)
> 
> Is this in fsblocks or in bytes?  I think the comment should state that
> explicitly.

sure, will add it

-- 
- Andrey

