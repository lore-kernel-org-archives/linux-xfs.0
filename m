Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C02E716A
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 08:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760603001; cv=none; b=Hh8uia4OLll76ShWjgBA8NrQY7b5PfoGwOegeKmzMP4xRER04jWWSK7XUgqSoKzv3X9i/iRvK2VLuXwUBiXVERKJ4Eua1P9yJjvlqxuTFZgKAjMl6SkBKpxSal2Qwe2mOYt5/tQzgyu8lT6Kf0/VwEplOmM8q+miJg00ASQQMI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760603001; c=relaxed/simple;
	bh=JQJvV6yRfBzQ0roNf3+gVAmWUMYqFoc2hs/p+SXZdwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGZgvP5ij0RzPy76r0RoLa+0N7RCs3JODIKlbTAbqB4Ml16Pq66HcYpPb6gT7zDkjdRD+OmzXn5mw/JLPP3HLgQn1q1gBF9CUmtFHFy6amdW/GjsXsVxK9kgNpVMQqgnwpS8bB5RlMLsG4JhuxFca11rt9FFl76HVC+ejNRyHlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Q/uVjoe+; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Q/uVjoe+"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-28832ad6f64so5413515ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 01:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760602999; x=1761207799; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+0VUZMtcOk9KdtskCy8ElFmsJ9tky1TG1GiZcpekt6s=;
        b=Q/uVjoe+BxIRyf3jtZzEd72+e/UbQuImi0I4A/+qNg50aXYchEB0Ouk6ypUfnG3s7W
         pGQzbqsdzpjXQ4hOieAM7FUqsA4A76QLLdjVDAFdWBy0gSlU5XRjx0VzmenXDCHzxjfC
         BqnnTH3T5ZmeWz3wKIPw6NHH7iJep/sr+G820y2KMGmNtNqTqWDTOr+teUkZ0ZDFp1Ho
         HNAeiQNsIiCUZ1vytNSW2xJBZMsmm4KOaeRx4Py3vOIDlOv6qOyzPcGkuKHg8A8Zy+Ya
         /f/40/+IAKfyoTPORaso2zL+CuUskfd1+TeUxW7P8k4n2xzRgXajy2hXXl+opMFCrnMz
         s2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760602999; x=1761207799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0VUZMtcOk9KdtskCy8ElFmsJ9tky1TG1GiZcpekt6s=;
        b=D+iVHbflULa5Ewt9i0mPoeBiW5FJ9COQj49ZPOSkik4n2aRuZehs73S8FDcnYyILUW
         iWL6Ptq3yXQERuRYX8AQKEihnvmyySgS0fxy54ETlGenCVOG7Es+sOkZgz2JhKtwkNpr
         A3mQyGZVRJu0AMACu5rPLPIWP1h1u2/ITs0/3NAKHwEixNcqCxacegpJeGdwK8s0C5F8
         9m/7ozk02B38e6FiRUJr6XmbTP4My4pjdeXFAS6lNu4H7l3ynYX96iVgNGPY1or4lmZI
         lsiC+5sPeKvcAl1IAYETADpssMfzQFjoOLKbqcYUpqMvTv0iaZnIVP8PYq9esR3fwl0R
         gg8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+LXQevKVji/8GarHeX3lBF0Iyxc56AwH5qSWoPU+JbqNNB+mvJ8lMqwpCdRc/OtTf+WHvlPIGNrg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzgfxrij2g/0nAdCpiTPlmNYVa9hacNIE58AD0zRkB1aLm7yWHp
	BJ96Dj1SkEWqdjoyfiwOfZbWkSzP7wfMXRAf/LzTPlXBJiWCNu4AE6ELCwhsJBchALc=
X-Gm-Gg: ASbGncugavnpsBiRvNvkosWpCvGceWO5qXIW7mOuz6kC2x2sHGmalUw7vdkvOqjKtTD
	FTKbJDP19GqufcFthC4NX4QEU8e1SJTpWfHCZjePc6Vcrcwzd71KmCYWTjgV5cn/RCNbLzX7un6
	IRICmTJoILtRIAj65Az1ZW5wWAO5EMi+ckcF8mOCo+WKJszfoQeD/8Zwa9CZFV5cwVG//w55g+E
	TkH8WaRc07TUz1XON+by15n203O/Wc6jeUxE61Nnkt1dRf0vTuc8OmTJ1gJkenW8SrfswRI4qEs
	+9wAhAJAmnin5Gh71ExdonbP+0nNGiyPSVgtQJjZsGjTZQ3+/cFBN9YYpe+r1GTmNjR6vXN2VSb
	N9nHEkjT+sUJF4rEC/+I8jng5W3XCW2HHmOV3cQFsZcQtfJLJZ+fyhWaco0AVFQ3IvYG6eCmR71
	k1X+oMy7QHJ/C46xo9KCRK/h8MUXGEBdMgHgOjA9NlLyn7boIw6eQ3qM6U3hxC6gxdupiRnoWf
X-Google-Smtp-Source: AGHT+IF1CQThIQIcsUYNeKF6zSjisAw+PGIYgUlb6D8gypneTiF3iak1UWrAgN1vx7iI8WrWlF2NeA==
X-Received: by 2002:a17:903:1b4b:b0:26d:353c:75cd with SMTP id d9443c01a7336-290272409c7mr413436515ad.21.1760602998773;
        Thu, 16 Oct 2025 01:23:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930fd3csm21322745ad.12.2025.10.16.01.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 01:23:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v9JGV-0000000FW7S-1kMH;
	Thu, 16 Oct 2025 19:23:15 +1100
Date: Thu, 16 Oct 2025 19:23:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <aPCrc5GvQRkwmTOU@dread.disaster.area>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
 <aPAI0C23NqiON4Uv@dread.disaster.area>
 <20251016043958.GC29905@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016043958.GC29905@lst.de>

On Thu, Oct 16, 2025 at 06:39:58AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 16, 2025 at 07:49:20AM +1100, Dave Chinner wrote:
> > On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> > > The relatively low minimal writeback size of 4MiB leads means that
> > > written back inodes on rotational media are switched a lot.  Besides
> > > introducing additional seeks, this also can lead to extreme file
> > > fragmentation on zoned devices when a lot of files are cached relative
> > > to the available writeback bandwidth.
> > > 
> > > Add a superblock field that allows the file system to override the
> > > default size.
> > 
> > Hmmm - won't changing this for the zoned rtdev also change behaviour
> > for writeback on the data device?  i.e. upping the minimum for the
> > normal data device on XFS will mean writeback bandwidth sharing is a
> > lot less "fair" and higher latency when we have a mix of different
> > file sizes than it currently is...
> 
> In theory it is.  In practice with a zoned file system the main device
> is:
> 
>   a) typically only used for metadata
>   b) a fast SSD when not actually on the same device
> 
> So I think these concerns are valid, but not really worth replacing the
> simple superblock field with a method to query the value.  But I'll write
> a comment documenting these assumptions as that is useful for future
> readers of the code.

That sounds reasonable to me. Eventually we might want to explore
per-device BDIs, but for the moment documenting the trade-off being
made is good enough.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
