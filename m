Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6F3B2BF
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705925125; cv=none; b=l42w+8k2FS52s31jgIzQMBDzsDqtG78vp0yrs2DUucOb/eVbJfyYZZFDU65rXdAZog65M3cGpk8iVqsXiFF2Xs49FPG1b+zJoyhBFoAQBPzcGNbuj1Z+IdCDi6UxPZtBfRYsLEb3A0UczuOSu7Ilp1kkJX9hzUjwZkfUdTrD6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705925125; c=relaxed/simple;
	bh=tbOANJLd8sNZkcmJYQBlaZEkR9k1Bhbx6JyR9EkJLGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmj6NXOLdv43rZ5O52aXc2p6q5SD2bXVoBzGHKdeVWXfLOg95/IcCWfmR4uXQ1UNp/h/smTPEDBelL0pqyGRNcqlVL72R2DY0fRUTwSNBY4qKZ01nr0lirLYw057/pQyk2G0pPfNACgSM8REwNorZxJTTp+DD8R0mW5ZvDA0iGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uk64DR9y; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uk64DR9y"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5cf6d5117f9so1406843a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 04:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705925124; x=1706529924; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CdsFYs1hbqJTJhEkF6HJtvK9MoHRmN5ij98nFDbYWBw=;
        b=uk64DR9ywjcmXXRxb9HhPUFn3oL1jEf4Ob4dbDXKzHrhRPCGhFc4ihURekznoPBFX9
         ui3wAq1hvxpSYQR6zTO1MRdZ9UQXg8qcwDOGZcJFJpt2i02iV3+5IRmd5KDjAPPW+C4f
         1vQwq3EYhIfWNRoyOQ7hxkffQqOnXDObhh/0x9tXgDaJ2zheBxW+jhHT/jthCOSD/NxG
         LmIgjNLJKhwjL9DB5OspntGzw7bgSELJjimcVyABHQXQkM8F3kNkGO2/jiqUl4ms6Sur
         C2RuZ2cLjjv9pqN2n72uZmt9Wcp8osgJ1rDJF/mTNy6x4yOtULbu3GrFC1bhfgyLxdfV
         axhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705925124; x=1706529924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdsFYs1hbqJTJhEkF6HJtvK9MoHRmN5ij98nFDbYWBw=;
        b=Sie8cfjbf5XCe3SzSyVbmhnk+SqBy0ay65x5+DNywiS6nkfHQDHW74Ta0XUX+j4Pzu
         8KCRzoo4rlfYbgioQ8BsShoqQjEGYU8UwMN3CXPAwJamaF1XHmneNt+sQNq656/RWMo+
         WlJ1k/bdkUwGwcbhlXLYYKJnmZmz+rs3cybrqvM6vB4bCGq2Ni8z8Hwi8aMkT1Cx0Dkm
         2iMm00A3Ho2bso/TRpG5l8Q9eLfhSjajVyb/Jvmh118ebGdxa+yvYX/U9niHh7WVDHwR
         7H4FfVQH/PVm+fstSQUuNr/64nMRvp3NzE1gCp2psgWRjWJhCQp5H3r2Y/5WuDI60j48
         PdCA==
X-Gm-Message-State: AOJu0YwmdpdSEEEYEaxHD+nP2+bRebNvXzWqLqP5vHYSwJAOIh0sFA7K
	3Jy9JZ7Z3fmnVvlBGa0SsVxk61iQ/3u+5R1jjNhnvNet8gIIsZbjp/3AdT2GbBg=
X-Google-Smtp-Source: AGHT+IFaZdDR5Pz7mFXHXwCTmHCx1vERlQUzFnEideqvy0ruWoG5uG365Ld/X4lB8t51oT9ZUdIKoA==
X-Received: by 2002:a17:90a:c0f:b0:28e:754e:b3f2 with SMTP id 15-20020a17090a0c0f00b0028e754eb3f2mr1104331pjs.62.1705925123860;
        Mon, 22 Jan 2024 04:05:23 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id st13-20020a17090b1fcd00b0028cf59fea33sm9319349pjb.42.2024.01.22.04.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 04:05:23 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRt3I-00DlLj-2Z;
	Mon, 22 Jan 2024 23:05:20 +1100
Date: Mon, 22 Jan 2024 23:05:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: use folios in the buffer cache
Message-ID: <Za5aANHuptzLrS6Z@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-3-david@fromorbit.com>
 <20240119012624.GQ674499@frogsfrogsfrogs>
 <Za4NkMYRhYrVnb1l@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za4NkMYRhYrVnb1l@infradead.org>

On Sun, Jan 21, 2024 at 10:39:12PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 18, 2024 at 05:26:24PM -0800, Darrick J. Wong wrote:
> > Ugh, pointer casting.  I suppose here is where we might want an
> > alloc_folio_bulk_array that might give us successively smaller
> > large-folios until b_page_count is satisfied?  (Maybe that's in the next
> > patch?)
> > 
> > I guess you'd also need a large-folio capable vm_map_ram. 
> 
> We need to just stop using vm_map_ram, there is no reason to do that
> even right now.  It was needed when we used the page cache to back
> pagebuf, but these days just sing vmalloc is the right thing for
> !unmapped buffers that can't use large folios. 

I haven't looked at what using vmalloc means for packing the buffer
into a bio - we currently use bio_add_page(), so does that mean we
have to use some variant of virt_to_page() to break the vmalloc
region up into it's backing pages to feed them to the bio? Or is
there some helper that I'm unaware of that does it all for us
magically?

> And I'm seriously
> wondering if we should bother with unmapped buffers in the long run
> if we end up normally using larger folios or just consolidate down to:
> 
>  - kmalloc for buffers < PAGE_SIZE
>  - folio for buffers >= PAGE_SIZE
>  - vmalloc if allocation a larger folios is not possible

Yeah, that's kind of where I'm going with this. Large folios already
turn off unmapped buffers, and I'd really like to get rid of that
page straddling mess that unmapped buffers require in the buffer
item dirty region tracking. That means we have to get rid of
unmapped buffers....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
