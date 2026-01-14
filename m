Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961A5325709
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768384387; cv=none; b=pACSdRs1e7HtvgdfWUDGJ5ss4p7KaqVTxu9tEkW0yF65Erdwo3dO/msIuK5hS4Yi/a5jLUHuwCwCcCxZ42vhOvE3TNb7awp6mn/AVWqTbUCQbj51RfPYQPe0nVF2ZigR2azqAg07AcK/gsle8RNhm/qHAfD6ONDSrdSBeUtUTz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768384387; c=relaxed/simple;
	bh=j5dIhiNJiGy1Qtc22ykR0iIEoSppbe3oLD7npilDfdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFITvS2MsRQkgKZHDw5q9InJiCVi5R6sL7Rx/ouz8X01314PolNic3OQQSivKRZ6fX+gOSeuIXsknyjaEDAPXVDIPB4wbjWcRVxBKY6zLJotTuCNas8+XosvvpEnPWMQN950gHkcipIKVmObup3QUJbcYYIBOlSchZ5v2dFDQiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PjDjfTps; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXvH81Rp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PjDjfTps";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXvH81Rp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768384385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aSFGgkgkpAF2fQrg8Gq7zIy2TZqVfBWhEA5o4HTAphk=;
	b=PjDjfTpsTWOsBOmTZ7nUGJ0gMKYxueyBwzsCprD0eC1i7Wx02mlKMfd/bGhHJtcP5VxfX+
	3awtW+624kRS3jZeKRIEdOGB6gF5TeND+S22knHbeaOU4ZIO37W3je0NvYy9FG2t2F63rf
	yEkpwHY+y5NQ1NdWTIRI6fcsNw+q2ag=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-wKaSX-L2M0SN5dDWeSwrcA-1; Wed, 14 Jan 2026 04:53:04 -0500
X-MC-Unique: wKaSX-L2M0SN5dDWeSwrcA-1
X-Mimecast-MFC-AGG-ID: wKaSX-L2M0SN5dDWeSwrcA_1768384383
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42fd46385c0so4731931f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 01:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768384383; x=1768989183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aSFGgkgkpAF2fQrg8Gq7zIy2TZqVfBWhEA5o4HTAphk=;
        b=iXvH81RpV/62GVRd7EvSFBHup8D8LC0/TmitVHYA+8uurzjqbaO1LDFN/otyZDiaES
         iOKhlo+AI3PP30gu+ET0Q4dT/YdHkDMfNT1Zv+CiD4eANOquUGxae6x4JmzaAxhDcmwP
         GPgeP9WpZN4WYS7WjeoErv/bv7SH7S5HjSh9gKcNMQTuxi2sfvTjTtX0Uvlc0mHXY4K6
         nXAkhWBvDGn71sA6sQNgopzcgYYzcM2lBCdtxSIkkEMqCz3FYcLTXGKPEuNxaUnFWiKC
         E7JCu79O0znukhJGIn1jbvOVs0nrOh+OoNwTIItByH9TyIWY9vKLoLxHu7c+S45p7YpT
         WJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768384383; x=1768989183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aSFGgkgkpAF2fQrg8Gq7zIy2TZqVfBWhEA5o4HTAphk=;
        b=kWvshhLt0zjnrHq0I12c24IZJuPJ2CPB+wYmOddEbCoT0F71E8biIAqfrZZCt+leX5
         NH1Z8jV/mVCR+e5v66Mgz9/CaB16tsjAR5FTtp0CoE5ImIi1kek3Ws5uAP2DKUqFKaCJ
         tuAE0J49OQKSsg+0E696Lxxs13mn6BPS1FLLul6R4O7z3kYn3Q1NL6vFUPabxgc2iN19
         8HbBmitMw0ZvoegVSZoZuSo62/e6sYUxTR7nd93gC24d9gRZIs18xLyNv41XRVAKf63e
         S3BMrYKIJmr3nCstOYh9Rm9JumggNDdCqZcoUSfoDNN92ur2AYdP3yJ392gQA4feMnMK
         Y6XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhAvt+H+UifUVE8n/5TrFVWZmxRRr9TgihQ9GSKFqmyc0RcVXGQc+L+rZLRIbJM/4nC+9H5N5zzrU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1k3aVT+rKUXuWT23JV3WF7pmeGYO0Sq0BfZ4SMYU2N1Ak/Q51
	uQgT97WY9AYiblDUHk3DDJWOTPCcEp5Sx9EQUXhCQpSXgy6uhdAaoSmYLXxPeM2KhtIJ7E3sEbV
	gLEiEEeJu7DTrxm3se3BJ0QWqjfPgueY2ZU1bvesXC2enHNTPzBlWktfyIoQb
X-Gm-Gg: AY/fxX6vevGw5eGaNhKtsUlirnYbwwtSACSfAye4x3FUq1+0DG/9qKQK3nY4HNKBjxg
	94uvfQcDHZCorF75rRY6bMCKjfiXRMbEmiUAEBAUAl9J43Z7Z79N7JglO2FUNXp0HyoV0Drs0ma
	mHusjDI+8wsl33lJHz7PIrpat5LLqTKB++ndb0c4dyiPpqkVqxmx7wrrAsoEh1ZQI16SQ3tC1ID
	b7pAdVaihgqpAZtbdLamrtSFWl6lH7sr2JFcH+lr4eqZrlt/mdryDnc2ASSOcl7uNn/cLTX+mqm
	3GzsD0DBM4E30RiLky2kG7FynWnWyeWD2Ajj8VUJjppCm5ksrWfSrivuiNVN3VBekAx0JL2MTg4
	=
X-Received: by 2002:a5d:584e:0:b0:430:f790:99d7 with SMTP id ffacd0b85a97d-4342c504f28mr2510669f8f.27.1768384383081;
        Wed, 14 Jan 2026 01:53:03 -0800 (PST)
X-Received: by 2002:a5d:584e:0:b0:430:f790:99d7 with SMTP id ffacd0b85a97d-4342c504f28mr2510645f8f.27.1768384382674;
        Wed, 14 Jan 2026 01:53:02 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e19bfsm48777428f8f.18.2026.01.14.01.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 01:53:01 -0800 (PST)
Date: Wed, 14 Jan 2026 10:53:00 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	aalbersh@kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 0/23] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <6r24wj3o3gctl3vz4n3tdrfjx5ftkybdjmmye2hejdcdl6qseh@c2yvpd5d4ocf>
References: <cover.1768229271.patch-series@thinky>
 <aWZ0nJNVTnyuFTmM@casper.infradead.org>
 <op5poqkjoachiv2qfwizunoeg7h6w5x2rxdvbs4vhryr3aywbt@cul2yevayijl>
 <aWci_1Uu5XndYNkG@casper.infradead.org>
 <20260114061536.GG15551@frogsfrogsfrogs>
 <5z5r6jizgxqz5axvzwbdmtkadehgdf7semqy2oxsfytmzzu6ik@zfvhexcp3fz2>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5z5r6jizgxqz5axvzwbdmtkadehgdf7semqy2oxsfytmzzu6ik@zfvhexcp3fz2>

On 2026-01-14 09:20:34, Andrey Albershteyn wrote:
> On 2026-01-13 22:15:36, Darrick J. Wong wrote:
> > On Wed, Jan 14, 2026 at 05:00:47AM +0000, Matthew Wilcox wrote:
> > > On Tue, Jan 13, 2026 at 07:45:47PM +0100, Andrey Albershteyn wrote:
> > > > On 2026-01-13 16:36:44, Matthew Wilcox wrote:
> > > > > On Mon, Jan 12, 2026 at 03:49:44PM +0100, Andrey Albershteyn wrote:
> > > > > > The tree is read by iomap into page cache at offset 1 << 53. This is far
> > > > > > enough to handle any supported file size.
> > > > > 
> > > > > What happens on 32-bit systems?  (I presume you mean "offset" as
> > > > > "index", so this is 1 << 65 bytes on machines with a 4KiB page size)
> > > > > 
> > > > it's in bytes, yeah I missed 32-bit systems, I think I will try to
> > > > convert this offset to something lower on 32-bit in iomap, as
> > > > Darrick suggested.
> > > 
> > > Hm, we use all 32 bits of folio->index on 32-bit plaftorms.  That's
> > > MAX_LFS_FILESIZE.  Are you proposing reducing that?
> > > 
> > > There are some other (performance) penalties to using 1<<53 as the lowest
> > > index for metadata on 64-bit.  The radix tree is going to go quite high;
> > > we use 6 bits at each level, so if you have a folio at 0 and a folio at
> > > 1<<53, you'll have a tree of height 9 and use 17 nodes.
> > > 
> > > That's going to be a lot of extra cache misses when walking the XArray
> > > to find any given folio.  Allowing the filesystem to decide where the
> > > metadata starts for any given file really is an important optimisation.
> > > Even if it starts at index 1<<29, you'll almost halve the number of
> > > nodes needed.
> 
> Thanks for this overview!
> 
> > 
> > 1<<53 is only the location of the fsverity metadata in the ondisk
> > mapping.  For the incore mapping, in theory we could load the fsverity
> > anywhere in the post-EOF part of the pagecache to save some bits.
> > 
> > roundup(i_size_read(), 1<<folio_max_order)) would work, right?
> 
> Then, there's probably no benefits to have ondisk mapping differ,
> no?

oh, the fixed ondisk offset will help to not break if filesystem
would be mounted by machine with different page size.

-- 
- Andrey

