Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FCE33EE
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 01:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717723036; cv=none; b=gKJk/avIzq7iEean+O6KqYqD+8Wgj3pZtrNdkOSwalQTixlWKR83oAtyfLqZjXRQTObhmf6kyZ8/rDp2q+vwiZ1pdOS27Mb3AQIcbdbIRJMO7EXPZWe2JDhmXB80FGQE56/KZroAT/Q+2HV2gKBUxerHeeYM3ytEtngKykb6ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717723036; c=relaxed/simple;
	bh=DovYnwYT4FzFjJ3w0InElQ6EvbPy+Qb4at2AEQQAMeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8VGnFqaNCwicvJPHuVJ7WDomSrvFtZxZMG8rffnEZnG9kJSVheIg4ZLoSd+9ZkUvAnIyvokvIqatnMhz/ULZLi+YjPLQQoqfvCIZKrcgsoICejUs/vygb3/pdzBOuPI+M097Dfx5PdlFVtfr6LEFltZop3qjOKJ2mvIJvQ6iYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ROep8PmD; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ROep8PmD"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c1fccb7557so1219146a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2024 18:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1717723034; x=1718327834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=olrDnaSNC3Z4ntMBoxthDCPsygKyrFeWKYp2o48rvgU=;
        b=ROep8PmDh7Vc2cDH7JpKJuUjpBh2nOVWw9//L/z+zxgume/5C0GGZWOEHIPl6qLxfB
         n+cyEppe/13pnQxGFjL/Rjlpyfw3sFCc5bG2g1sFl3prZuaMmNmpD8Ig/j3L4KdKqbP5
         PAC7+xtH+UCdNHJFXu/QpIWhkSqWFi7edNy6A0v8/01HAC2IHWTvG5QR040J1Mo4bc3i
         nqu8y+Io4LM7nTOPIC1i5FwvO0zzRgomvjeFW9V1cEpsswhBttCu+2SczbkMi4DNvoMy
         ue3cg9p2TXuY0VMA/9IFWG7GHLu/NXrRycm4jG/83ggfFMkhM1OnMFjQWpVaeWHYRZKv
         RK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717723034; x=1718327834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olrDnaSNC3Z4ntMBoxthDCPsygKyrFeWKYp2o48rvgU=;
        b=ASMsUo2tAr36y+KS+/7ZnqzFRBP/Yirir5P3Fv9yxZCXbjlu1gHxOH5UkUUZXh4mrn
         ViWCQnzy2pyjyMXjJsjISXTdKRNJV9c8AgdtcZ68cy013Pm+5GdItJZQrN3Yc+4KGylV
         KzaFAF/OjzrL8oBFk3uDSyqqv7+9He/hnqHPtoV0Af6zaTPg2ATj2yWrv5No4JB6EYz+
         M4od6MQFcbYxuGrW7sxA3bwQIDXYkmriO5zqIPPebSYUwy7PWOisBdBUJ/zHQseakF5e
         MeQmF5gzQtOLMuieVeHMvgms0uGeiL3NHbWZmXeAVjDjAaYFjdGfjaly8wUJwIBxyxOK
         kZ4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXssTqGL+Jh67opiXkm4vb2/2K7LhvOOe8l14OgmjpmTaUHfN5TjsD2aXCoX9xbvT2NxxjUld9IUrBKmxYYIjM8wzG9YudC1fkG
X-Gm-Message-State: AOJu0YyxdBS6KhsMrEZa7x8WGmZ0UgXp2XKR3wqA0T1JxQumCzUhg/bc
	N3g1nAZQqNCH1COkLhvWhHJ9HAiVDD1hS8z9u37AVroUTFNy7m3i9zTc06mLw2c=
X-Google-Smtp-Source: AGHT+IHE6LiDxuhpJ2q/G+ownXgxj4n5zJ1nRpZcPTGBixeeGJWQQzjMTTpLXQq7vlkoBnS7V/E2ZA==
X-Received: by 2002:a17:90a:66c6:b0:2c0:29d5:350b with SMTP id 98e67ed59e1d1-2c2bcc7b6cemr1199277a91.48.1717723033963;
        Thu, 06 Jun 2024 18:17:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c29c384c8bsm2333845a91.46.2024.06.06.18.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jun 2024 18:17:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sFOEA-006yCT-1E;
	Fri, 07 Jun 2024 11:17:10 +1000
Date: Fri, 7 Jun 2024 11:17:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zack Weinberg <zack@owlfolio.org>
Cc: dm-devel@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: Reproducible system lockup, extracting files into XFS on
 dm-raid5 on dm-integrity on HDD
Message-ID: <ZmJfloJyB4PCaZyK@dread.disaster.area>
References: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>
 <ZmDvT/oWgVBiCw9o@dread.disaster.area>
 <a9625e9f-e08c-4b2e-995d-693b2a992281@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9625e9f-e08c-4b2e-995d-693b2a992281@app.fastmail.com>

On Thu, Jun 06, 2024 at 11:48:57AM -0400, Zack Weinberg wrote:
> On Wed, Jun 5, 2024, at 7:05 PM, Dave Chinner wrote:
> > On Wed, Jun 05, 2024 at 02:40:45PM -0400, Zack Weinberg wrote:
> >> I am experimenting with the use of dm-integrity underneath dm-raid,
> >> to get around the problem where, if a RAID 1 or RAID 5 array is
> >> inconsistent, you may not know which copy is the good one.  I have
> >> found a reproducible hard lockup involving XFS, RAID 5 and dm-
> >> integrity.
> >
> > I don't think there's any lockup or kernel bug here - this just looks
> > to be a case of having a really, really slow storage setup and
> > everything waiting for a huge amount of IO to complete to make
> > forwards progress.
> ...
> > Userspace stalls on on writes because there are too many dirty pages
> > in RAM. It throttles all incoming writes, waiting for background
> > writeback to clean dirty pages.  Data writeback requires block
> > allocation which requires metadata modification. Metadata modification
> > requires journal space reservations which block waiting for metadata
> > writeback IO to complete. There are hours of metadata writeback needed
> > to free journal space, so everything pauses waiting for metadata IO
> > completion.
> 
> This makes a lot of sense.
> 
> > RAID 5 writes are slow with spinning disks. dm-integrity makes writes
> > even slower.  If you storage array can sustain more than 50 random 4kB
> > writes a second, I'd be very surprised. It's going to be -very slow-.
> 
> I wiped the contents of the filesystem and ran bonnie++ on it in direct

Wow, that's is sooooo 2000's :) 

> I/O mode with 4k block writes, skipping the one-character write and
> small file creation tests.  This is what I got:
> 
> Version  2.00       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Name:Size etc        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> 64G:4k::65536                 15.8m  19 60.5m  26            218m  31 279.1  13
> Latency                         659ms     517ms             61146us    3052ms
> 
> I think this is doing seek-and-read, not seek-and-write, but 300 random
> reads per second is still really damn slow compared to the sequential
> performance.  And it didn't lock up (with unchanged hung task timeout of
> two minutes) so that also tends to confirm your hypothesis -- direct I/O
> means no write backlog.
> 
> (Do you know of a good way to benchmark seek-and-write
> performance, ideally directly on a block device instead of having
> a filesystem present?)

fio.

Use it with direct=1, bs=4k, rw=randwrite and you can point it at
either a file or a block device.

> I don't actually care how slow it is to write things to this array,
> because (if I can ever get it working) it's meant to be archival
> storage, written to only rarely.  But I do need to get this tarball
> unpacked, I'd prefer it if the runtime of 'tar' would correspond closely
> to the actual time required to get the data all the way to stable
> storage, and disabling the hung task timeout seems like a kludge.

The hung task timeout is intended to capture deadlocks that are
forever, not something that is blocking because it has to wait for
a hundred thousand IOs to complete at 50 IOPS. When you have storage
this slow and data sets this big, you have to tune these detectors
so they don't report false positives. What you are doing is so far
out of the "normal operation" window that it's no surprise that
you're getting false positive ahng detections like this.

> ...
> > So a 1.6GB journal can buffer hundreds of thousands of dirty 4kb
> > metadata blocks with writeback pending. Once the journal is full,
> > however, the filesystem has to start writing them back to make space
> > in the journal for new incoming changes. At this point, the filesystem
> > with throttle incoming metadata modifications to the rate at which it
> > can remove dirty metadata from the journal. i.e. it will throttle
> > incoming modifications to the sustained random 4kB write rate of your
> > storage hardware.
> >
> > With at least a quarter of a million random 4kB writes pending in the
> > journal when it starts throttling, I'd suggest that you're looking at
> > several hours of waiting just to flush the journal, let alone complete
> > the untar process which will be generating new metadata all the
> > time....
> 
> This reminds me of the 'bufferbloat' phenomenon over in networking land.

Yes, exactly.

Storage has a bandwidth delay product, just like networks, and when
you put huge buffers in front of something with low bandwidth and
long round trip latencies to try to maintain high throughput, it
generally goes really bad the moemnt interactivity is required.

> Would it help to reduce the size of the journal to something like 6MB,
> which (assuming 50 random writes per second) would take only 30s to
> flush?

That's taking journal sizes to the other extreme.

> Is a journal that small, for a filesystem this large, likely to
> cause other problems?

Definitely. e.g. not having enough journal space to allow
aggregation of changes to the same structures in
memory before they are written to disk. this alone will increase the
required journal bandwidth for any given workload by 1-2 orders of
magnitude. It will also increase the amount of metadata writeback by
similar amounts because the window for relogging already dirty
objects is now tiny compared to the dataset you are creating.

IOWs, when you have low bandwidth, seek limited storage, making the
journal too small can be much worse for performance than having a
really large journal and hitting the problems you are seeing.

A current mkfs.xfs defaults to a minimum log size of 64MB - that's
probably a good choice for this particular storage setup as it's
large enough to soak up short bursts of metadata activity, but no so
large it pins GBs of dirty metadata in RAM that stuff will stall on.

> Are there any other tuning knobs you can think of
> that might restrict the rate of incoming metadata modifications from
> 'tar' to a sustainable level from the get-go, instead of barging ahead
> and then hitting a wall?

> I'm inclined to doubt that VM-level writeback
> controls (as suggested elsethread) will help much, since they would not
> change how much data can pile up in the filesystem's journal, but I
> could be wrong.

No matter what you do you are going to have the workload throttled
to disk speed -somewhere-. Reducing the dirty limits on the page
cache will help in the same way that reducing the journal size will,
and that should help improve interactivity a bit. But,
fundamentally, the data set is much larger than RAM and so it
will get written at disk speed and that means worst case latencies
for anything the kernel does can be very high.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
