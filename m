Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C586241688
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 20:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740602947; cv=none; b=LRxjGDCpxOLoP8IVdCvSlywWMS5Q1e4T1J6Vm7u0nrTy/rsYKXSTyMEG75V3uA6IaG7RhOvsz9SMeeX+KZEJ6jtachghWDswAaGe+rCOnbAQHTBauymSO+09E/xCkn1CHBXdK9nz/EHlYsXQQkSnIVBZ+3r1wyZJbBoAb4kwgf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740602947; c=relaxed/simple;
	bh=qclk0b4WczLTgOcgrRGcu+KMX+qE0RL3BNOM6NOjS+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guB6M7VQ60sNdZyz7aQ5OxH2sD2BHMELnTwlnO5SncKXt4qvKrS+Gp9a9EJRgEZscDfHU62UGnhMebmpMJGwG7N1Oqrli31XGX8OlioptXLX6crbYBeD1rmRHvJ9dp7x4tG/Qok4bEHYasbp0EM1PhlMDyqsl62Sj9RWmzMki6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KIE3u/fN; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KIE3u/fN"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2234e4b079cso1700345ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 12:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1740602944; x=1741207744; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mjphc0mHAAvrQK0ML5Y+/zaRiBObs03G3AToZgygKhw=;
        b=KIE3u/fNWXK3Z1tfTrwGg6vJw/7qcyw3Rns42ACn9dezoSEB7B3Z9lB6hWir253cDi
         6vYsqm8iKLkn/KYlN0MSUTppmeYIuv1x78anivBWO3SHDHScjtvWNlWmTChrcW7cgxiJ
         /w80RbUmqAVARnEd6TmczdAu7MoD10tb43MZLwYvd3I3psx1kczQQ1pwOI4/WYINheVR
         yeFgwrdQ5/3AS0ABbqqKKS4h0bpRQHgR9pdNRvMd24hnmPk9rlQ9PGpJCdSGl+bJRM81
         LSAnA7V8MZN7+azFADMn5A92qoFI12gWPRcx7Bzva8/JFUdKnja3U9IrQ2Zbf/Es7d0p
         RdOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740602944; x=1741207744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjphc0mHAAvrQK0ML5Y+/zaRiBObs03G3AToZgygKhw=;
        b=Egj46Q+M0CLjWnEMUJM1y+iWcnB3wMiwpkjIqFngD/Te6RJB7zW9w9AZgrfqcLF93E
         utyqRwNwE22CQxM6ur9HIlS0vcWsA0ZvDIQKHoIEMdUIJGyAvAwA+4SrschmlJg83BFu
         OpmoaW8e28q27ARrLQZq4Y+bCqiBxNrqgC3/B0pk8Xa2BO7WePNRPiWApkAxwknlcnrD
         6lL4h2+jVKni8naInpIRizONQcO/62kkqPKii5bu3I454hldgOSncgfokghJxMmFAsDr
         /gRlvPZVm2ehj6+Z4iloIIURz6itTIdCgYaH3ST/PIUXoG5i8ednG18mUbXlU06M65oH
         JAMA==
X-Forwarded-Encrypted: i=1; AJvYcCVLom+ypVR2Mz6swsb/FF4yu4J2K9nzyxVlDlPS625tqSu7f71S1I4PU6MM/BAH5yPaDlVPdE8FgFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLkl3+dFEOX6zJ/q9FNwXzzS6ek7qNjqRnZ6MykUkkUWC/dkNV
	UxgSbWmiOl7TzDRNSHbjLiuQA2F6Q+scMkOruBTXMtHEL3tcS84CMz0PJy1cjMI=
X-Gm-Gg: ASbGncuW9ioRgQag4bkAzeNJjS4vLkHC06E/4xus0XaEcxTSaOBRfrvYC5nxW5noPYo
	PC8bbXCT0H0RMOMJULE9T2z9fwFTHud0QDr89wZaW2i6H6K9ymtIAmd86Oe7xgjJINA3jETF9Wa
	9ifmUjmYFq9lxBLAJHjl9VT2gasQd/lkDXVubU3+BsumI9oR6gIaQzkp0Wnh822niZzn94SxGf2
	Zn7IHak0qoSHovH2IKTQHN6yJJofD/SGpPml6HLVUGV5ugqScfxnU+C718bZXy8DRd64QTdogaz
	CdNnIbRjSLwQIfIzwK8/LXaCL9Qx8wbO/7Vz81I2NnGjq9OpbjzD8SDMdITqZvMixSBsggpj30R
	O7Q==
X-Google-Smtp-Source: AGHT+IHjkKZNnGS0pG/zXxkdwmPvjCRFvZfP7g0ivgkDJxNmLHl3RTeBqcQpvhrw778IYD8k4cqvDA==
X-Received: by 2002:a17:902:eccf:b0:21f:6fb9:9299 with SMTP id d9443c01a7336-22307b69880mr126851065ad.27.1740602944396;
        Wed, 26 Feb 2025 12:49:04 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504e19f6sm396175ad.183.2025.02.26.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 12:49:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tnOKy-00000006LNk-45VO;
	Thu, 27 Feb 2025 07:49:00 +1100
Date: Thu, 27 Feb 2025 07:49:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
Message-ID: <Z79-PEZ2YQybCjmi@dread.disaster.area>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <Z76eEu4vxwFIWKj7@dread.disaster.area>
 <7b440d54-b519-4995-9f5f-f3e636c6d477@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b440d54-b519-4995-9f5f-f3e636c6d477@gmail.com>

On Wed, Feb 26, 2025 at 12:33:21PM +0000, Pavel Begunkov wrote:
> On 2/26/25 04:52, Dave Chinner wrote:
> > On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
> > > There are reports of high io_uring submission latency for ext4 and xfs,
> > > which is due to iomap not propagating nowait flag to the block layer
> > > resulting in waiting for IO during tag allocation.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
> > > Reported-by: wu lei <uwydoc@gmail.com>
> > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > ---
> > >   fs/iomap/direct-io.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> > > index b521eb15759e..25c5e87dbd94 100644
> > > --- a/fs/iomap/direct-io.c
> > > +++ b/fs/iomap/direct-io.c
> > > @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
> > >   		WRITE_ONCE(iocb->private, bio);
> > >   	}
> > > +	if (iocb->ki_flags & IOCB_NOWAIT)
> > > +		bio->bi_opf |= REQ_NOWAIT;
> > 
> > ISTR that this was omitted on purpose because REQ_NOWAIT doesn't
> > work in the way iomap filesystems expect IO to behave.
> > 
> > I think it has to do with large direct IOs that require multiple
> > calls to submit_bio(). Each bio that is allocated and submitted
> > takes a reference to the iomap_dio object, and the iomap_dio is not
> > completed until that reference count goes to zero.
> > 
> > hence if we have submitted a series of bios in a IOCB_NOWAIT DIO
> > and then the next bio submission in the DIO triggers a REQ_NOWAIT
> > condition, that bio is marked with a BLK_STS_AGAIN and completed.
> > This error is then caught by the iomap dio bio completion function,
> > recorded in the iomap_dio structure, but because there is still
> > bios in flight, the iomap_dio ref count does not fall to zero and so
> > the DIO itself is not completed.
> > 
> > Then submission loops again, sees dio->error is set and aborts
> > submission. Because this is AIO, and the iomap_dio refcount is
> > non-zero at this point, __iomap_dio_rw() returns -EIOCBQUEUED.
> > It does not return the -EAGAIN state that was reported to bio
> > completion because the overall DIO has not yet been completed
> > and all the IO completion status gathered.
> > 
> > Hence when the in flight async bios actually complete, they drop the
> > iomap dio reference count to zero, iomap_dio_complete() is called,
> > and the BLK_STS_AGAIN error is gathered from the previous submission
> > failure. This then calls AIO completion, and reports a -EAGAIN error
> > to the AIO/io_uring completion code.
> > 
> > IOWs, -EAGAIN is *not reported to the IO submitter* that needs
> > this information to defer and resubmit the IO - it is reported to IO
> > completion where it is completely useless and, most likely, not in a
> > context that can resubmit the IO.
> > 
> > Put simply: any code that submits multiple bios (either individually
> > or as a bio chain) for a single high level IO can not use REQ_NOWAIT
> > reliably for async IO submission.
> 
> I know the issue, but admittedly forgot about it here, thanks for
> reminding! Considering that attempts to change the situation failed
> some years ago and I haven't heard about it after, I don't think
> it'll going to change any time soon.
> 
> So how about to follow what the block layer does and disable multi
> bio nowait submissions for async IO?
> 
> if (!iocb_is_sync(iocb)) {
> 	if (multi_bio)
> 		return -EAGAIN;
> 	bio_opf |= REQ_NOWAIT;
> }

How do we know it's going to be multi-bio before we actually start
packing the data into the bios? More below, because I kinda pointed
out how this might be solved...

> Is there anything else but io_uring and AIO that can issue async
> IO though this path?

We can't assume anything about the callers in the lower layers.
Anything that can call the VFS read/write paths could be using async
IO.

> > We have similar limitations on IO polling (IOCB_HIPRI) in iomap, but
> > I'm not sure if REQ_NOWAIT can be handled the same way. i.e. only
> > setting REQ_NOWAIT on the first bio means that the second+ bio can
> > still block and cause latency issues.

Please have a look at how IOCB_HIPRI is handled by iomap for
multi-bio IOs. I -think- the same can be done with IOMAP_NOWAIT
bios, because the bio IO completion for the EAGAIN error will be
present on the iomap_dio by the time submit_bio returns. i.e.
REQ_NOWAIT can be set on the first bio in the submission chain,
but only on the first bio.

i.e. if REQ_NOWAIT causes the first bio submission to fail with
-EAGAIN being reported to completion, we abort the submission or
more bios because dio->error is now set. As there are no actual bios
in flight at this point in time, the only reference to the iomap_dio
is held by the iomap submission code.  Hence as we finalise the
aborted DIO submission, __iomap_dio_rw() drops the last reference
and iomap_dio_rw() calls iomap_dio_complete() on the iomap_dio. This
then gathers the -EAGAIN error that was stashed in the iomap_dio
and returns it to the caller.

i.e. I *think* this "REQ_NOWAIT only for the first bio" method will
solve most of the issues that cause submission latency (especially
for apps doing small IOs), but still behave correctly when large,
multi-bio DIOs are submitted.

Confirming that the logic is sound and writing fstests that exercise
the functionality to demonstrate your eventual kernel change works
correctly (and that we don't break it in future) is your problem,
though.

> > So, yeah, fixing this source of latency is not as simple as just
> > setting REQ_NOWAIT. I don't know if there is a better solution that
> > what we currently have, but causing large AIO DIOs to
> > randomly fail with EAGAIN reported at IO completion (with the likely
> > result of unexpected data corruption) is far worse behaviour that
> > occasionally having to deal with a long IO submission latency.
> 
> By the end of the day, it's waiting for IO, the first and very thing
> the user don't want to see for async IO, and that's pretty much what
> makes AIO borderline unusable.  We just can't have it for an asynchronous
> interface.

Tough cookies. Random load related IO errors that can result in
unexpected user data corruption is a far worse outcome than an
application suffering from a bit of unexpected latency. You are not
going to win that argument, so don't bother wasting time on it.

> If we can't fix it up here, the only other option I see
> is to push all such io_uring requests to a slow path where we can
> block, and that'd be quite a large regression.

Don't be so melodramatic. Async IO has always been, and will always
be, -best effort- within the constraints of filesystem
implementation, data integrity and behavioural correctness.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
