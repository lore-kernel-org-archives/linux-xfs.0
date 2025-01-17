Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A41B042D
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jan 2025 22:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737152361; cv=none; b=OjC0oa98vMYqveo+PSgLRXCdjGljaH55ttV/sK61Dp/5x2saILpnOULwUZOE0u7/23a4E2i2ygHcnTqnf5wQBWIIqtJZUIleQm82gycpCYFLtbgPqSGh01Xhd9ewrTKz5TieXAmPRz/v0E9ucNxWYdPSOChk6GBwunXwFcTn+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737152361; c=relaxed/simple;
	bh=+6cXKnUSRRyLn6BjC19R6gzpM73WqTv1bc9Xyr+Hj88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVryBzcZhIclYweSVfrJuPH49N047rYjXXulkHLkA8e9L5BcTqHfjWMCUZeGW6PcAVlmpkevnePq9JY/8OPoA2uMEdNZd/Mjz8jXpsPJMFDEuryp2PZlrPtxI5EBEuujvkNMrR23s5j7lBpIC3og7eHgstSJC9+9hWuIjIqT5PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AQYOo58I; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AQYOo58I"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2efd81c7ca4so3654402a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jan 2025 14:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1737152359; x=1737757159; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y50kgomEgf4VdxVPDqs4rF2Wo4OYuSph1NwX/GbfYV8=;
        b=AQYOo58IBom5Pu8F36p1tslH6Lhhdl7vbq+VyX2tZDGBnWBxidiXt2KpDDWM3T46bO
         esDwHfQnZOvPbUCQn9J+Kbe4E9GboxczQoVft6/qgCBgFDu/VY0e1BZSceIUcBEv7d3I
         xiLou6ebv+ks3ZgQQcvE1jki1E/bUG1sAA2kNS+wSVehzY9kyQaggntX0DQHG54YAM/u
         /E0bNLADdxm3jTuLEo3ickayYiZK3JdylTu4JY7l0HZc1U6fjNS6G6gRU+g3eFn3ASq/
         gWXJyiMppdNLeJT+9na5HXa5LACVKJ9gzJqQvgkcvRPa+K6je7CoZU/advtFezJLppzm
         kWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737152359; x=1737757159;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y50kgomEgf4VdxVPDqs4rF2Wo4OYuSph1NwX/GbfYV8=;
        b=ADYNBV4E6FXxku83q2RNMgEYU/6nw7xFm3kKh6MV3de/IeJ+E6xxmTJuEWs7+tV882
         KT1sm8W+Yyo+nXC7wwE/nWYsF1olPV5HbOmQpwTZv/j78DKcLnUepnt7a1Zz4RJxaOtA
         f1IXjqpoh1xx42xs+KVyI/mM7wy3gtBJoX4nT+2hv5TnOK8OfmfZlvSg66w7MwsrPhMr
         kI/qi7r79rd+TM3O8CxtFiWtzFBVr/rVVqxKg3MpLgpmT95KyAWC6D5g3LqDcrym7nsZ
         3iZ1dIzE75PlEkCc/EnYO+sA11MWcM4FO+buy/may70SQspoZ6L9xMkKIsyZIsnRhPjo
         /bkQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6VL9Fc6CGmrTlDRrQxKCB9JeRAJsz42tRK5dkjU0RJqaLiO9w/kUKqapPdoFeMEYSeLJTib4UgJw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ItYSIJ/InvUBIIM06RFJeK8YNMz+Sxul5vQeRPp8FHckk9Ns
	KocLCP1Y+Q+NIATODp64YDWLQdNHOVt+i8+gUiApbABOxbtu315r0GoeKZlZfujLM+bOwT9rSzv
	1
X-Gm-Gg: ASbGncvDQGMxGr60nhYJXLuLBWfmxvHH0D0RSiLMahCPXzS3FHg88Ma5gJtnKEgcWNC
	3t0kb0ZTP7nvd9vpued+ZVyhegldJK3LTKdCE2tGnnIxqRLl9XJZVGHIUzyX6Fi2KjG26RfSog9
	YITF9DMENasBCaQCvKs/lZiyEv+NYr1RTmVAsE0xT2JomP/5Z075LcN+34MaMNMCRv4+1niA9h2
	58Uj/b9gvVRu10KgriS/4TuiPjFQTwVYNMu2foFPaqyJiF/4xjZpsD3YXwbPu2/z11+HoGrAIXS
	ggJ7TTd5EQjVNnPA5ZaqRjQQKX0DNnYk
X-Google-Smtp-Source: AGHT+IGdg3HYLavV+K8iAAoKFnyWnX8w7v/c2iMhcxMbJzyJwlyLVXNgpNg1QyAG06DsjItSjgy2tw==
X-Received: by 2002:a17:90b:5145:b0:2ef:33a4:ae6e with SMTP id 98e67ed59e1d1-2f782c779edmr7425704a91.12.1737152359241;
        Fri, 17 Jan 2025 14:19:19 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f776154378sm2642522a91.13.2025.01.17.14.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 14:19:18 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tYugN-00000007B2d-2XOs;
	Sat, 18 Jan 2025 09:19:15 +1100
Date: Sat, 18 Jan 2025 09:19:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z4rXY2-fx_59nywH@dread.disaster.area>
References: <953b0499-5832-49dc-8580-436cf625db8c@163.com>
 <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>

On Fri, Jan 17, 2025 at 02:27:46PM +0100, Amir Goldstein wrote:
> On Wed, Jan 15, 2025 at 10:41 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Jan 14, 2025 at 09:55:21PM -0800, Christoph Hellwig wrote:
> > > On Mon, Jan 13, 2025 at 08:40:51AM -0500, Brian Foster wrote:
> > > > Sorry if this is out of left field as I haven't followed the discussion
> > > > closely, but I presumed one of the reasons Darrick and Christoph raised
> > > > the idea of using the folio batch thing I'm playing around with on zero
> > > > range for buffered writes would be to acquire and lock all targeted
> > > > folios up front. If so, would that help with what you're trying to
> > > > achieve here? (If not, nothing to see here, move along.. ;).
> > >
> > > I mostly thought about acquiring, as locking doesn't really have much
> > > batching effects.  That being said, no that you got the idea in my mind
> > > here's my early morning brainfart on it:
> > >
> > > Let's ignore DIRECT I/O for the first step.  In that case lookup /
> > > allocation and locking all folios for write before copying data will
> > > remove the need for i_rwsem in the read and write path.  In a way that
> > > sounds perfect, and given that btrfs already does that (although in a
> > > very convoluted way) we know it's possible.
> >
> > Yes, this seems like a sane, general approach to allowing concurrent
> > buffered writes (and reads).
> >
> > > But direct I/O throws a big monkey wrench here as already mentioned by
> > > others.  Now one interesting thing some file systems have done is
> > > to serialize buffered against direct I/O, either by waiting for one
> > > to finish, or by simply forcing buffered I/O when direct I/O would
> > > conflict.
> >
> > Right. We really don't want to downgrade to buffered IO if we can
> > help it, though.
> >
> > > It's easy to detect outstanding direct I/O using i_dio_count
> > > so buffered I/O could wait for that, and downgrading to buffered I/O
> > > (potentially using the new uncached mode from Jens) if there are any
> > > pages on the mapping after the invalidation also sounds pretty doable.
> >
> > It's much harder to sanely serialise DIO against buffered writes
> > this way, because i_dio_count only forms a submission barrier in
> > conjunction with the i_rwsem being held exclusively. e.g. ongoing
> > DIO would result in the buffered write being indefinitely delayed.
> 
> Isn't this already the case today with EX vs. SH iolock?

No. We do not hold the i_rwsem across async DIO read or write, so
we can have DIO in flight whilst a buffered write grabs and holds
the i_rwsem exclusive. This is the problem that i_dio_count solves
for truncate, etc. i.e. the only way to actually ensure there is no
DIO in flight is to grab the i_rwsem exclusive and then call
inode_dio_wait() to ensure all async DIO in flight completes before
continuing.

> I guess the answer depends whether or not i_rwsem
> starves existing writers in the face of ongoing new readers.

It does not. If the lock is held for read and there is a pending
write, new readers are queued behind the pending write waiters
(see rwsem_down_read_slowpath(), which is triggered if there are
pending waiters on an attempt to read lock).

> > > I don't really have time to turn this hand waving into, but maybe we
> > > should think if it's worthwhile or if I'm missing something important.
> >
> > If people are OK with XFS moving to exclusive buffered or DIO
> > submission model, then I can find some time to work on the
> > converting the IO path locking to use a two-state shared lock in
> > preparation for the batched folio stuff that will allow concurrent
> > buffered writes...
> 
> I won't object to getting the best of all worlds, but I have to say,
> upfront, this sounds a bit like premature optimization and for
> a workload (mixed buffered/dio write)

Say what? The dio/buffered exclusion change provides a different
data coherency and correctness model that is required to then
optimising the workload you care about - mixed buffered read/write.

This change doesn't optimise either DIO or buffered IO, nor is a
shared-exclusive BIO/DIO lock isn't going to improve performance of
such mixed IO workloads in any way.  IOWs, it's pretty hard to call
a locking model change like this "optimisation", let alone call it
"premature".

> that I don't think anybody
> does in practice and nobody should care how it performs.
> Am I wrong?

Yes and no. mixed buffered/direct IO worklaods are more common than
you think. e.g. many backup programs use direct IO and so inherently
mix DIO with buffered IO for the majority of files the backup
program touches. However, all we care about in this case is data
coherency, not performance, and this change should improve data
coherency between DIO and buffered IO...

> For all practical purposes, we could maintain a counter in inode
> not for submitted DIO, but for files opened O_DIRECT.
> 
> The first open O_DIRECT could serialize with in-flight
> buffered writes holding a shared iolock and then buffered writes
> could take SH vs. EX iolock depending on folio state and on
> i_dio_open_count.

I don't see how this can be made to work w.r.t. sane data coherency
behaviour. e.g. how does this model serialise a new DIO write that
is submitted after a share-locked buffered write has just started
and passed all the "i_dio_count == 0" checks that enable it to use
shared locking? i.e. we now have potentially overlapping buffered
writes and DIO writes being done concurrently because the buffered
write may not have instantiated folios in the page cache yet....

> I would personally prefer a simple solution that is good enough
> and has a higher likelihood for allocating the development, review
> and testing resources that are needed to bring it to the finish line.

Have you looked at how simple the bcachefs buffered/dio exclusion
implementation is? The lock mechanism itself is about 50 lines of
code, and there are only 4 or 5 places where the lock is actually
needed. It doesn't get much simpler than that.

And, quite frankly, the fact the bcachefs solution also covers AIO
DIO in flight (which i_rwsem based locking does not!) means it is a
more robust solution than trying to rely on racy i_dio_count hacks
and folio residency in the page cache...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
