Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15F1EF0AE
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733260332; cv=none; b=XHAClVAk4L6IzNBV9fRKXUvCtbJM8DV22Y5sAAGtA7h/zjkYEHPE0I8X63tgiEXe0LptHlAL+inOLYgEBDNgX2hYQGM3ghI3wZg5hHeQ/L76CpFM6p3upBQYYVb9OsglFh7snPCMqno/NK3X5LOxamrhWTvlG4k8b6xb34l2uAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733260332; c=relaxed/simple;
	bh=5sQ+r+gbaqUsvU0ZrDznyVUb0oZpkSP9jGY029J7Grc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjpPszgKBiOVnXalIxOFsa4MGvb3JGvh14vrFerw+CidttXTPEszfyjtgd/AvsaSwdVIUDvwhtTlo5WFDlg+bfDAVyqNAD9YG1dZHmh1hCSqzd2xU7Tg7L+P2DRzaYVazQsY3R3rTk1H3q3IT7gZEEnPeP+POfNpNloamQy4gP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uVAtYIn3; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uVAtYIn3"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-215513ea198so1712745ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 03 Dec 2024 13:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1733260329; x=1733865129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+ODrYc33qbZzhbzDaQ4IUD7ZD8/LSAYfpty7Q0W2PI=;
        b=uVAtYIn31bZs1eqet+AO3VkNAKhBwjFLEi6sXX0yQpWURq/rQIc+KUKsX09d/hL8C9
         qZeK0HhydbdS58L8QiimOP5roGmhGp9sPsHkeURVhxfXwGjyzHlwh4sXRy0qIhYy9iTu
         F9oXT6+RvJqwCSAHiAZbdLcdCmWYufNidsR2hLmkqJrHqpqUfgxMdXRifc5D01UZEmql
         HcGBkTgJk6CMfOVkMJ19qSUp8JPREGPH/22w5BYIXe20aywKiIPN0a1RGhpjzzr2cts4
         DVXuc0MEq39FZPgqiz0jOjVCXbX7XmSB8l/g0kK+JpGNjBA/dU6W2RtQqwA9g7MuBQvk
         lC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733260329; x=1733865129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+ODrYc33qbZzhbzDaQ4IUD7ZD8/LSAYfpty7Q0W2PI=;
        b=ftwBbb9ug3n2cTwjD7PryYLy9NzAmId39X8uoILxIF0YTOPmUB0Ei0KZpo5/JtRr/3
         si0ZmF0yrKbOHioo80Nok35Rrrf7wf5Es8AtoOI02hn2jOtyaqN/fIQLCpXH/U8WeqfD
         Tj9X4H2R52uuD2foMN1mKZvGP1H7rNnWFlsbAoO6K+Sn2o6lsHhFA9X7Wf7v76fScX33
         KKQlRn2gEcHoXt6ap80ys7sE07IyBS/dfZNE2I/RL4swTRrPjmB5qtPwDjtkHISlXCzz
         tnowOMfakyByDSfoAm7YpGjyoqnuQXu3rzswPeie3RnbRKIrLQM+CwP5+N693F+QPThN
         7n/w==
X-Forwarded-Encrypted: i=1; AJvYcCUNp6l6xc25HytIB8wjua29mbQZvCrJCr4MZw9+JiC4jM8o//aNclNkXEtj+dfw6jnwatvNfvQtYcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvWi0v4/T8XErC55c9QTZqBwnGccyalvEhm2S5cBjF7G2C3XFk
	zH7UmBizjZ3aue4iUAxZq1Mdyq6ZPceuP6JeFiKNslcWgXfaV483338ga7/T/SE=
X-Gm-Gg: ASbGncsPMhkBCjbCNH5ni6wT24iDt8KUUsOpidy+yb9v2dhCaMLdj3TSKRSUYHT7bRR
	rVKt7QujTQZu9m+OsKov80oXpE41kbASPsta7idE0tph8mCrv1EeufcrX2dnSNm1G1EBf9yjvaA
	zZthdKDJ3yrfem+InUYpaBor32aQhEEUPmgAdMEUXwIkLP4oZCvzrSmCs56oZ7KYd1+K9VtRyxs
	OtfMQPHx/D+ECCnVDeDnS6/Gu9SghkTtQAo5r+4XNWq39GhToALaILeap9npIl9xrgyaDfxVZEs
	sXPzssAXjqiIXDI/ZFXaTxhIaQ==
X-Google-Smtp-Source: AGHT+IHFTpAHjz3EovSN28pXHU1iJT+oStk7lktwtXwZ4u08NHEMzBz0zDgs2fVQX/+3WWAVHowaRw==
X-Received: by 2002:a17:903:1d2:b0:215:b01a:6288 with SMTP id d9443c01a7336-215be5fd866mr64834825ad.21.1733260328811;
        Tue, 03 Dec 2024 13:12:08 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21548aec039sm78008175ad.113.2024.12.03.13.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 13:12:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tIaBh-00000006HX4-1lgM;
	Wed, 04 Dec 2024 08:12:05 +1100
Date: Wed, 4 Dec 2024 08:12:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Brian Foster <bfoster@redhat.com>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v5 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Z090Jd06yjgh_Q-y@dread.disaster.area>
References: <20241127063503.2200005-1-leo.lilong@huawei.com>
 <Z0sVkSXzxUDReow7@localhost.localdomain>
 <Z03RlpfdJgsJ_glO@bfoster>
 <Z05oJqT7983ifKqv@dread.disaster.area>
 <Z08bsQ07cilOsUKi@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z08bsQ07cilOsUKi@bfoster>

On Tue, Dec 03, 2024 at 09:54:41AM -0500, Brian Foster wrote:
> On Tue, Dec 03, 2024 at 01:08:38PM +1100, Dave Chinner wrote:
> > On Mon, Dec 02, 2024 at 10:26:14AM -0500, Brian Foster wrote:
> > > On Sat, Nov 30, 2024 at 09:39:29PM +0800, Long Li wrote:
> > We hold the MMAP_LOCK (filemap_invalidate_lock()) so no new pages
> > can be instantiated over the range whilst we are running
> > xfs_itruncate_extents(). hence once truncate_setsize() returns, we
> > are guaranteed that there will be no IO in progress or can be
> > started over the range we are removing.
> > 
> > Really, the issue is that writeback mappings have to be able to
> > handle the range being mapped suddenly appear to be beyond EOF.
> > This behaviour is a longstanding writeback constraint, and is what
> > iomap_writepage_handle_eof() is attempting to handle.
> > 
> > We handle this by only sampling i_size_read() whilst we have the
> > folio locked and can determine the action we should take with that
> > folio (i.e. nothing, partial zeroing, or skip altogether). Once
> > we've made the decision that the folio is within EOF and taken
> > action on it (i.e. moved the folio to writeback state), we cannot
> > then resample the inode size because a truncate may have started
> > and changed the inode size.
> > 
> > We have to complete the mapping of the folio to disk blocks - the
> > disk block mapping is guaranteed to be valid for the life of the IO
> > because the folio is locked and under writeback - and submit the IO
> > so that truncate_pagecache() will unblock and invalidate the folio
> > when the IO completes.
> > 
> > Hence writeback vs truncate serialisation is really dependent on
> > only sampling the inode size -once- whilst the dirty folio we are
> > writing back is locked.
> > 
> 
> Not sure I see how this is a serialization dependency given that
> writeback completion also samples i_size.

Ah, I didn't explain what I meant very clearly, did I?

What I mean was we can't sample i_size in the IO path without
specific checking/serialisation against truncate operations. And
that means once we have partially zeroed the contents of a EOF
straddling folio, we can't then sample the EOF again to determine
the length of valid data in the folio as this can race with truncate
and result in a different size for the data in the folio than we
prepared it for.

> But no matter, it seems a
> reasonable implementation to me to make the submission path consistent
> in handling eof.

Yes, the IO completion path does sample it again via xfs_new_eof().
However, as per above, it has specific checking for truncate down
races and handles them:

/*
 * If this I/O goes past the on-disk inode size update it unless it would
 * be past the current in-core inode size.
 */
static inline xfs_fsize_t
xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
{
        xfs_fsize_t i_size = i_size_read(VFS_I(ip));

>>>>    if (new_size > i_size || new_size < 0)
>>>>            new_size = i_size;
        return new_size > ip->i_disk_size ? new_size : 0;
}

If we have a truncate_setsize() called for a truncate down whilst
this IO is in progress, then xfs_new_eof() will see the new, smaller
inode isize. The clamp on new_size handles this situation, and we
then only triggers an update if the on-disk size is still smaller
than the new truncated size (i.e. the IO being completed is still
partially within the new EOF from the truncate down).

So I don't think there's an issue here at all at IO completion;
it handles truncate down races cleanly...

> I wonder if this could just use end_pos returned from
> iomap_writepage_handle_eof()?

Yeah, that was what I was thinking, but I haven't looked at the code
for long enough to have any real idea of whether that is sufficient
or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
