Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1411E50E;
	Tue, 28 Jan 2025 21:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738099401; cv=none; b=D9w9o83ZoXmcqLdiFQ+b/+vZNPT7GnQOnt4ORm5kJi2VPcZSfZU9LOP6XeKiNs9BRDvZ9dgpuTo7sZqP4eMJWi1OPzHZl8VPCe/lBn6bFDpQpBUHNZ0eIElGefOfdujqz1/jRZD1XmS+0yT/U2WVjmMW949yinn/fhd8tu4vP/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738099401; c=relaxed/simple;
	bh=gOQmA0Rye0xiWq+32RnWrCq9X5R1jL0JBKEgmsBH6ls=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ussb0KLjTRdbUG9jADAPN9crcKm7+3YF/x8B3LCANeCdjiZyoYK3Bp8KWQWWvDsYkIyuN20LvaFHACkNiD24DDPrkjs9up2qDnfpbbfIrb3lMx/0LJUOo1pBGT23yo/NX31h5Nf68lgWQ3vklGpER4zhgZ2cQBZhMXyddh8uwfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5JKMXvQ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5JKMXvQ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38a8b17d7a7so3327945f8f.2;
        Tue, 28 Jan 2025 13:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738099398; x=1738704198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+ozDEHLmcNO1CX9NQGjZ1iJcEKvr2B2drcZGRWN3qw=;
        b=K5JKMXvQGLC7rywdBdZUFbITemcaQ8yYqDnx3QTvdoamcCr+toSrMI51vWz9JfyWIb
         NpggDHO1u5UXbkfDfstruypNMCOcZ4FRsGnd2jSI5amCQFA7YuzRNi4+OqgPm80EbwRt
         +vnxXoJYpWAIirFQeJjnH8SSRvroqF9QqjLsZEdm4ObHcHKlC1b+MqKoxP5IIBnXaHIJ
         G0m28V6u2jeF368DfcF8KwLdQNtwr9a9pf9wj3y/un0+nXy7bTwIPHBZOvWp2tVR6YZl
         Uu6mQgX0S0llOo8Wrm9Jre1M+uEwWZGcSTZ1raJjeMS+P3dt98mCWKn1N/eKVHTKm6ko
         brKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738099398; x=1738704198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+ozDEHLmcNO1CX9NQGjZ1iJcEKvr2B2drcZGRWN3qw=;
        b=qUsUTeIQopMa4n2lv1nLrYaszFA88HrTBNCd1MyRnHr228wXIxPoABcg2eZiBamjHj
         Ff6GrXkpx3RCstM2Y2fY6Ixa3ETYqZqupudGBl5VhYuxb7BTdCKAj8wa+HWLXYgUHB1j
         u7exyTE+iZV2SXvc6RtLVfzO5L7giSuxbOOzdSHU8CJXitXwxSH3PPCYrgh8ZNaio3jL
         nrJ9aULUuU3ZVDZR3KIC2rZPJ+RLEbLB8YgnLl4nqCr3f5eRQ5WTua3Vut7mdLY6b4gg
         xkxAJj9u6BnK/MlIOMGk8LZaqsBXBcywoiq03Jkda1sfe6rnN5WIFYmAd31rJy+Fwl0J
         OM5A==
X-Forwarded-Encrypted: i=1; AJvYcCURIC6GIwPXA+6bL+m8cdgfOUj7c1X7fQNE6/mAOEzaReKhDy0udgRFRgCSX0/1iYFg4NYklimPah2P@vger.kernel.org, AJvYcCXdp3acASIv96vJS8+bkUlqrjyeO0glsbwd53xv+DDP+rwbOx6HezDdwVIt5QPXhrt1ACo3wapQJcMl4aw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ri26ZrROyL80eGfAQVpHfUVP6NL3fTPOGP9zv9szybPFDF48
	qs8QKrb4UKAqz291fkA1VrNGyrZY7KgvKl1pkMw2zVf+flKp/acG
X-Gm-Gg: ASbGncuQZYAwWa/B6Km5JVZnBU8WQqPqLsQ4E4PLKdcXKdyJ21VaZPJjGuN6blz1jp2
	eN/ttLnyzg35Dd1U7OilJXJy49loxGmo2jr8/GRJYLAm4OoPlpybrrVOfILSuPVlPUdGWlUxW2c
	VUF9165MNj283DfW4bfwas3WdRjO7cflYlwDrgaPeBqYEfWgF7v+X+8nPDeS8Vy1Tp05kjB1D+e
	C1awaon22HpwhcgRQXPzEptRMbe1NCMO3ec7oCet0L932J7lfqC25Aw3toNeX85aaUIoICDZMw/
	ral6ty7Oh6hnefCQz3fH9CQGYqX2xE07hVnv+fxf0sWZvnajLwE+lw==
X-Google-Smtp-Source: AGHT+IElxSj78erTqKNboOKXrQDQLzu3b2HCeCAk99SIcXOKzPp0pTWv0Bv8VelLQaqgTg0doT/Eug==
X-Received: by 2002:a5d:6d88:0:b0:38a:4b8b:c57a with SMTP id ffacd0b85a97d-38c5209351bmr575281f8f.44.1738099397665;
        Tue, 28 Jan 2025 13:23:17 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a188a85sm14843998f8f.44.2025.01.28.13.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 13:23:17 -0800 (PST)
Date: Tue, 28 Jan 2025 21:23:15 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Chi Zhiling <chizhiling@163.com>,
 Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Chi Zhiling
 <chizhiling@kylinos.cn>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <20250128212316.2bba477e@pumpkin>
In-Reply-To: <Z5hn_cRb_cLzHX4Z@infradead.org>
References: <20250108173547.GI1306365@frogsfrogsfrogs>
	<Z4BbmpgWn9lWUkp3@dread.disaster.area>
	<CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
	<d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
	<20250113024401.GU1306365@frogsfrogsfrogs>
	<Z4UX4zyc8n8lGM16@bfoster>
	<Z4dNyZi8YyP3Uc_C@infradead.org>
	<Z4grgXw2iw0lgKqD@dread.disaster.area>
	<3d657be2-3cca-49b5-b967-5f5740d86c6e@163.com>
	<Z5fxTdXq3PtwEY7G@dread.disaster.area>
	<Z5hn_cRb_cLzHX4Z@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jan 2025 21:15:41 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 28, 2025 at 07:49:17AM +1100, Dave Chinner wrote:
> > > As for why an exclusive lock is needed for append writes, it's because
> > > we don't want the EOF to be modified during the append write.  
> > 
> > We don't care if the EOF moves during the append write at the
> > filesystem level. We set kiocb->ki_pos = i_size_read() from
> > generic_write_checks() under shared locking, and if we then race
> > with another extending append write there are two cases:
> > 
> > 	1. the other task has already extended i_size; or
> > 	2. we have two IOs at the same offset (i.e. at i_size).
> > 
> > In either case, we don't need exclusive locking for the IO because
> > the worst thing that happens is that two IOs hit the same file
> > offset. IOWs, it has always been left up to the application
> > serialise RWF_APPEND writes on XFS, not the filesystem.  
> 
> I disagree.  O_APPEND (RWF_APPEND is just the Linux-specific
> per-I/O version of that) is extensively used for things like
> multi-thread loggers where you have multiple threads doing O_APPEND
> writes to a single log file, and they expect to not lose data
> that way.  The fact that we currently don't do that for O_DIRECT
> is a bug, which is just papered over that barely anyone uses
> O_DIRECT | O_APPEND as that's not a very natural use case for
> most applications (in fact NFS got away with never allowing it
> at all).  But extending racy O_APPEND to buffered writes would
> break a lot of applications.

It is broken in windows :-)
You get two writes to the same file offset and then (IIRC) two advances of EOF
(usually) giving a block of '\0' bytes in the file.

You might get away with doing an atomic update of EOF and then writing
into the gap.
But you have to decide what to do if there is a seg fault on the user buffer
It could be a multi-TB write from an mmap-ed file (maybe even over NFS) that
hits a disk read error.

Actually I suspect that if you let the two writes proceed in parallel you can't
let later ones complete first.
If the returns are sequenced a write can then be redone if an earlier write
got shortened.

	David


