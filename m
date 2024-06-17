Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4E79F3
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718587787; cv=none; b=hm/c5JNY0Z4TWRS/ihiN58i/82tawvLH3kG1+apdVWKAQQCHDr/H6fxZJkKqFy2tXCHZh/fAg7mbwELDQY3a5RYdvmRfeNZchUlqZCo0mD6aFAjEZ0PHjH6/8vhFPMcZuAphhz/zQRnVVZrqKcWF41vOdOR9F0a7a5akmQQNmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718587787; c=relaxed/simple;
	bh=X5aRt+LPUsZLXEL4wr7fcShbnt/xSZ8e2tYNBbMPTdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7fFS9M6JrRBYmByE6Af9rLO5yyonEgMYu8+I8KZJBy5qKv+RR7sm8h3CyPeaiqbOpenwcLZFMYIz0l1wKEIS/nO08g+PMma4leJYB0jM2CSG/62UiejvT2eF9BSQca7RZJuL77iH31PqsYgEorSUK0CS8Yo6sJ6RcL9VrdPkeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pHFdfnjb; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pHFdfnjb"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f6b0a40721so28433225ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 16 Jun 2024 18:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718587786; x=1719192586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bqgWAO4mCWwupa+lR9NOrzfPSBggKHunYbwtSEV5JoQ=;
        b=pHFdfnjbc+3sN+PiTupOJiNyZtsOSJcwLnvUHU7H9GJ2EornD4YRHGpju5jH2MGAg/
         c4ZXQYisAo0tj6/L5aiQzDK8EwrJGd5PwNqlmiy3SHELphMmZ4iwTRkJcdqW/qN/2++P
         RPvjZ3h1wfMf7D4OFufbFOft2BKWCQZpwQpJYfUjbg/jJPSM74hpS0ULIFStNW8dpIle
         rRQtHJjS0bhI4Qw+8HqP/yPMI0mE56IRcfaxHl+Nep5C1XUSBEaLSfUxxVb6kMvT32pt
         Sn1EbCQq0VpyBO5F+T3S3d6mqqMEbgYTN5fycNJwEhQ8UiAQmvgV/rCcZa9UJulLF9tR
         g8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718587786; x=1719192586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqgWAO4mCWwupa+lR9NOrzfPSBggKHunYbwtSEV5JoQ=;
        b=OEvdMRLmJAUm298mZb2YrGzjEEmFPStG1+dCoEaPrqcteLp23M/3IBVdkcr09eqj+G
         T4Hl+mwX5IslmoWuIeOjigclxLD2mAJO5WslWcihiTvr9GTdNirG53PCOk0cln3hVDNy
         GmNsDT5w7XMwpGW0AGisTLLxhMeStjy64yAG6ZnKJXDX4+uFAWmJX2aQrpwuHPhS7tDR
         eWMhGRM/YTkvFVDt//1HJjUkW+nOPsoErEFka63j3WHxjAen4eV4S2tYQeX89mjPgalp
         s4lQdKRqonupgRzMuUirltKx2vvUbsTHAM2QscEMvgtgpmuDk4B4scpwHgABMaXpcaiM
         cHrw==
X-Forwarded-Encrypted: i=1; AJvYcCUWLHD30YRSBJSMdu5UAVlq2CQZu+VX5DqujY6MBEOGHxEsM1rWJJUgd8N1EolgDTxes27H84g0PMk1PowqnzLFzs0v04rY+HPn
X-Gm-Message-State: AOJu0YxDYQp/pSnrNEY8qT2Vize/wtVM7G9azyuwYaCDAbOzvvOHy96d
	RG1a1rw1/Rj2AIX+Xn+WjZPp/CiZrUx+SsWXYvial1/4dfK3XWN0q1V17kF733M=
X-Google-Smtp-Source: AGHT+IH2yamUY2L+mg2sDf6W0MYe+fr1/6bICbKfZYn/cmrt+tr3TvVUeXggb8kPWxWwSK9lWhE1Zw==
X-Received: by 2002:a17:902:e88a:b0:1f6:d368:7dd7 with SMTP id d9443c01a7336-1f862b155e2mr101843335ad.45.1718587785415;
        Sun, 16 Jun 2024 18:29:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee80fesm69659525ad.124.2024.06.16.18.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jun 2024 18:29:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sJ1Bm-00124e-1P;
	Mon, 17 Jun 2024 11:29:42 +1000
Date: Mon, 17 Jun 2024 11:29:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, djwong@kernel.org,
	chandan.babu@oracle.com, brauner@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	linux-mm@kvack.org, hare@suse.de, linux-kernel@vger.kernel.org,
	yang@os.amperecomputing.com, Zi Yan <zi.yan@sent.com>,
	linux-xfs@vger.kernel.org, p.raghav@samsung.com,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com,
	cl@os.amperecomputing.com, john.g.garry@oracle.com
Subject: Re: [PATCH v7 11/11] xfs: enable block size larger than page size
 support
Message-ID: <Zm+RhjG6DUoat7lO@dread.disaster.area>
References: <20240607145902.1137853-1-kernel@pankajraghav.com>
 <20240607145902.1137853-12-kernel@pankajraghav.com>
 <20240613084725.GC23371@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613084725.GC23371@lst.de>

On Thu, Jun 13, 2024 at 10:47:25AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 07, 2024 at 02:59:02PM +0000, Pankaj Raghav (Samsung) wrote:
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -3019,6 +3019,11 @@ xfs_ialloc_setup_geometry(
> >  		igeo->ialloc_align = mp->m_dalign;
> >  	else
> >  		igeo->ialloc_align = 0;
> > +
> > +	if (mp->m_sb.sb_blocksize > PAGE_SIZE)
> > +		igeo->min_folio_order = mp->m_sb.sb_blocklog - PAGE_SHIFT;
> > +	else
> > +		igeo->min_folio_order = 0;
> >  }
> 
> The minimum folio order isn't really part of the inode (allocation)
> geometry, is it?

I suggested it last time around instead of calculating the same
constant on every inode allocation. We're already storing in-memory
strunct xfs_inode allocation init values in this structure. e.g. in
xfs_inode_alloc() we see things like this:

	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;

So that we only calculate the default values for the filesystem once
instead of on every inode allocation. This isn't unreasonable
because xfs_inode_alloc() is a fairly hot path.

The only other place we might store it is the struct xfs_mount, but
given all the inode allocation constants are already in the embedded
mp->m_ino_geo structure, it just seems like a much better idea to
put it will all the other inode allocation constants than dump it
randomly into the struct xfs_mount....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
