Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA1B13B2A9
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741137592; cv=none; b=T2Kramw+fUwkG6GFd4TyNYbx8JmfexaKqi2GFupXaBs+djzDELMjPgcgLZmiBqiU5jriqd4pR7BReEvm2UEPYox4THRlkKNIQaLLhbk85ErxtBunsM6XBpPz6rD7wUwsZi8jomfOG6sO912vXdPNn7hybGf5nV0gHPj52e8AhO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741137592; c=relaxed/simple;
	bh=T1D0UqlZtbjIAEcYeH3bL+9/Rhwt5iKWzyArHVZ2rd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ab4PXGzdcNvB4qqAJuJxICoVb0Q3TilM145+zWxwh0nWqu6FYdv+K04/9s7dOswMTpZfzsq6JDk8/dK6F8MB/nmxbLj7WNAEYMIazmz6EzMu1Zne5mRhRqo5CG4cBgYoQlbYzPDvVSbLalQUjDUZ5A2TLxN/BYK74sM3vBe/oO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Mu4oTEKE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Mu4oTEKE"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2234e4b079cso114927005ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 17:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741137590; x=1741742390; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HDeGX06pM1RLaKTpFDMieK0IZgiOy+R0dUCo59PMS84=;
        b=Mu4oTEKEXkk/fncXQPj12qTM7R0MliQhgEb20vxLu6lYkAlaEWQ2MFKejbygJKu0U6
         dbtp4LpP9WNgpCPZQdAJemWdC5kZRwoIpVlpfnPZafESdgrfKcLsJrxWK8fkZ/58bcor
         H7g1Dy444aKcCjzPi18DJSrLbdwRxeni5uGWR+/dVWZmOG7gDFMIItGJhMSsSRQdXi+o
         M/UvGXgMqujoGKY2hA3TojI6cg5n2REwTqTngHZa2xwEoxcJZxLCb/PLY+cH2UabF34T
         NYZO+Xim+icyfRce8F0B+TJh90q/zhN6YLK+FroyxkyItV5CLYv7U1Tw9bisWo7Fe6ml
         SY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741137590; x=1741742390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDeGX06pM1RLaKTpFDMieK0IZgiOy+R0dUCo59PMS84=;
        b=lTLNBaLknYJv8k1PR5UJjo7HVhc+oF71udf1/j+VnIF/2Z+Mj5fm425ruW62mePMbv
         3StDkoy8a9vpD2EoWs1DnfcP9gv/gMUivVeN33BRNE4I/b+84IQpnF//LZ6mBj/q4Llv
         0oeSgV8r9Tlm7Q2ozEpNjlOCAN/TUQIWJX/BYOBBJXwPXF+vLYPaS3x7dL+1OEE+lHOZ
         G0XCdRfJRn8IJcGYieFKBLO8jVxOrWSFdAZcXOI3sCskMUj8oqga0wXl3p0c63hB88JQ
         XUGQwGXcQ7vjspEZtc0iTe12YzydWAOSvu5qtA7W2sMonsF0YJrq4sB2t75CVH7tioJE
         8FWg==
X-Forwarded-Encrypted: i=1; AJvYcCVVTZ+BXY7853vI51ocx2E9SsAe8hjVR5uVjZRVGR8N239eLNBX57ZT+/PcvhYPRMo4McqgLwwa39s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC9QKEveyL/jWq6F67Cfc26NVBA+vtOYO9K3IovXLdA8dPeUp+
	WJmoa0pKaVPx/XEmFfmSRrCNU0eZgMYbaazDtyZueH0XL18alduc9JcV8Kw0Mgs=
X-Gm-Gg: ASbGncuz6gCIJciW0Izn9+vdQi0vBZfZdSQU7IEqPt4Zwoc34zEtCYvmh1iN1fKNhBk
	Yk1xggtZE4YtaRECVxUgAQvRmT4TsLLWj81QbiUNZ5sYQC9m8u13pViJX+3L38PmVpN2fLm1vnW
	ccHCgBmMBYpfgb9cXBcFIUJQfnhmqMj+NnMGy4oKO104uQ4sJHrv+zT7T/x6ZSR3QzZ4AOfiFlY
	1zhdC50yyam7au6b1QySsMdUQqGcoiZVxcuaczmAlZw99tP28oT++0v0pYTo3LCOfYmF1LDfwFW
	YY1lE6821ScZfPG5k8y/PkZZyhJiXk6EVC8G/NKkiGKcwEVXeVMkoDKxCzhZ8KEU3h5+HUzdh2V
	kgLki/oXwCA==
X-Google-Smtp-Source: AGHT+IEYSEaRJWNjHT1mSMe9OLAaH/XQ2Im1sJS6hHV/lUkLx/BJl5WN3GSomkJPz7v2Wa1bAfkxZg==
X-Received: by 2002:a05:6a20:9185:b0:1f3:2c55:8d95 with SMTP id adf61e73a8af0-1f349449752mr2066270637.8.1741137589615;
        Tue, 04 Mar 2025 17:19:49 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7ddf242bsm10725070a12.13.2025.03.04.17.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 17:19:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tpdQI-00000008yUp-0BsL;
	Wed, 05 Mar 2025 12:19:46 +1100
Date: Wed, 5 Mar 2025 12:19:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8emslEolstG76A7@dread.disaster.area>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8dsfxVqpv-kqeZy@dread.disaster.area>
 <970ec89d-4161-41f4-b66f-c65ebd4bd583@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970ec89d-4161-41f4-b66f-c65ebd4bd583@gmail.com>

On Tue, Mar 04, 2025 at 10:47:48PM +0000, Pavel Begunkov wrote:
> On 3/4/25 21:11, Dave Chinner wrote:
> > > @@ -374,6 +379,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
> > >   	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
> > >   		dio->iocb->ki_flags &= ~IOCB_HIPRI;
> > > +	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
> > > +
> > > +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
> > > +		/*
> > > +		 * This is nonblocking IO, and we might need to allocate
> > > +		 * multiple bios. In this case, as we cannot guarantee that
> > > +		 * one of the sub bios will not fail getting issued FOR NOWAIT
> > > +		 * and as error results are coalesced across all of them, ask
> > > +		 * for a retry of this from blocking context.
> > > +		 */
> > > +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
> > > +					  BIO_MAX_VECS)
> > > +			return -EAGAIN;
> > > +
> > > +		bio_opf |= REQ_NOWAIT;
> > > +	}
> > 
> > Ok, so this allows a max sized bio to be used. So, what, 1MB on 4kB
> > page size is the maximum IO size for IOCB_NOWAIT now? I bet that's
> > not documented anywhere....
> > 
> > Ah. This doesn't fix the problem at all.
> > 
> > Say, for exmaple, I have a hardware storage device with a max
> > hardware IO size of 128kB. This is from the workstation I'm typing
> > this email on:
> > 
> > $ cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
> > 128
> > $  cat /sys/block/nvme0n1/queue/max_segments
> > 33
> > $
> > 
> > We build a 1MB bio above, set REQ_NOWAIT, then:
> > 
> > submit_bio
> >    ....
> >    blk_mq_submit_bio
> >      __bio_split_to_limits(bio, &q->limits, &nr_segs);
> >        bio_split_rw()
> >          .....
> >          split:
> > 	.....
> >          /*
> >           * We can't sanely support splitting for a REQ_NOWAIT bio. End it
> >           * with EAGAIN if splitting is required and return an error pointer.
> >           */
> >          if (bio->bi_opf & REQ_NOWAIT)
> >                  return -EAGAIN;
> > 
> > 
> > So, REQ_NOWAIT effectively limits bio submission to the maximum
> > single IO size of the underlying storage. So, we can't use
> > REQ_NOWAIT without actually looking at request queue limits before
> > we start building the IO - yuk.
> > 
> > REQ_NOWAIT still feels completely unusable to me....
> 
> Not great but better than not using the async path at all (i.e. executing
> by a kernel worker) as far as io_uring concerned.

I really don't care about what io_uring thinks or does. If the block
layer REQ_NOWAIT semantics are unusable for non-blocking IO
submission, then that's the problem that needs fixing. This isn't a
problem we can (or should) try to work around in the iomap layer.

> It should cover a good
> share of users, and io_uring has a fallback path, so userspace won't even
> know about the error. The overhead per byte is less biting for 128K as well.

That 128kb limit I demonstrated is not a fixed number. Stacking
block devices (e.g. software RAID devices) can split bios at any
sector offset within the submitted bio.

For example: we have RAID5 witha 64kB chunk size, so max REQ_NOWAIT
io size is 64kB according to the queue limits. However, if we do a
64kB IO at a 60kB chunk offset, that bio is going to be split into a
4kB bio and a 60kB bio because they are issued to different physical
devices.....

There is no way the bio submitter can know that this behaviour will
occur, nor should they even be attempting to predict when/if such
splitting may occur.

> The patch already limits the change to async users only, but if you're
> concerned about non-io_uring users, I can try to narrow it to io_uring
> requests only, even though I don't think it's a good way.

I'm concerned about any calling context that sets IOCB_NOWAIT. I
don't care if it's io_uring, AIO or a synchronous
preadv2(RWF_NOWAIT) call: we still have the same issue that
REQ_NOWAIT submission side -EAGAIN is only reported through IO
completion callbacks.

> Are you only concerned about the size being too restrictive or do you
> see any other problems?

I'm concerned abou the fact that REQ_NOWAIT is not usable as it
stands. We've identified bio chaining as an issue, now bio splitting
is an issue, and I'm sure if we look further there will be other
cases that are issues (e.g. bounce buffers).

The underlying problem here is that bio submission errors are
reported through bio completion mechanisms, not directly back to the
submitting context. Fix that problem in the block layer API, and
then iomap can use REQ_NOWAIT without having to care about what the
block layer is doing under the covers.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
