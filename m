Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4051A2DC770
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745978756; cv=none; b=s+dDfISIp5hgr3mm82z7R1T1pSA2GBOC4YE25SeT+BLP143iZNvAlb2P/tIHtfMrBzCKWzBOwcrzH9n4vj6dcPQXBOUNM46GjLE4fnS3Zu7CdEzoABujokiTcEyK0dbhu77UnSWKd+7xyIIGC3PJvpx7H3ienC+kNAZcsqJ7xtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745978756; c=relaxed/simple;
	bh=DMct/huGiCfiD65OsYKIezz7VbjrtRClGTQgEFomFow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPFLIhoQB0B6a/X10vJpip5GBJ0Ugsyl/IpbqkulOP7joJuh6ZcNf+1+zr9BxQa62YJE6UESlWDyUlPksWBIUSNoMc+us007LDD5iIk734chuOCP1Gjiwd+SDw7woqLdXfSDl6mbtijHhL5xAOx2mncsU6xBEo9ajIu680dkTZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=h1sh6FTI; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="h1sh6FTI"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-736c1138ae5so6827598b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Apr 2025 19:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1745978753; x=1746583553; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ivhh2j5ykafhwFZuVZhYJEHHQx1F6zYILuWeaYLILCg=;
        b=h1sh6FTIN4CKnv0yfKMQB5rlEhFppKVjrPcqHgxu26Cj2eHfnzEebQ6BL5MaQGqLO9
         OZrLkC0LYY4PC91mill7QZhI6RPR5k7D5HnBBB0fX4JhLdyftWvk7NcawIahLsjzp/gf
         9eX6+Zdc0jdL+bts30iLttI5P1PN1BlsxayBkpwmuhFV5M9QZy+QrhMyobvwmNniM1LY
         Uz3g689Ol9ZHdybdGAdLdAsC4Fz9ELW9ZyX/a26nJO6y7srAOyZnnMIqbAfKMEpaj+vi
         6ld7w3x5KrtNxET65s+dYnU3WvDZoehk1lNqhpcSo86vpuNfT9ZHN1ND7TD8gn5y4Xc4
         TcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745978753; x=1746583553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ivhh2j5ykafhwFZuVZhYJEHHQx1F6zYILuWeaYLILCg=;
        b=FeO1XAkEjSH3S/TFgdNDbP+jy5ZJQpx07dZT2YToRgO0L8FF8BdSPLgp7COYoYLwqH
         uR56jQM3pvq2SGUuFSN049EdqMi72asO9cR6sz7mAXa/08ycfkbMU/h7IFOMGoCCYYVE
         zsPloH7jLzO4qzNS6+T9OGxo8+Nt4FxKHYICnUOR800HkiB3HkBIIKJHpaKyuW96HsLa
         PJh4baryP3D2XuSPeHq2cgN3RGpx1pkOt0mgloyDCdEkQ46S/91AhQjvcxE09D++A86q
         644yaSwYcFXtdXz1YNo3HlPfn5DROengLFY5APUriBlN3y8u51GaeQQm076fR5PvhW8p
         mQAg==
X-Forwarded-Encrypted: i=1; AJvYcCWjPS0J1VXN7kUTRrqvBrsLKxIFCmNzxmbklgsRA9zo1wh0D6M5JD53DOV79ntrhFz/r6tlT+KTHB4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2DokCip/Me7dQYKYkY2U7/ODeGDXSfr6wGIqpht0VFxV1mBfC
	5B0O4Pnx47QbgsH47pRBnNUuhYY1y69hm0AV0VpAQpX1yS5MMRUvC8y3Fla8VWuuNOMgF9J4dwh
	t
X-Gm-Gg: ASbGncsBsSBu3efT/qnz2oZvCs7RywRR96vN3LbYhI6wjmFz4+32+GeqBG88lGW4SAV
	3aY0v7P/DwRtNnaHL2u7QEUMCXTKAyJrTh73/tKSuOmIZHSbm8Wf0pEq+W53k07x/V7yRHHH8+t
	uKi8pXG8g4zJ1TwfnnXCFV1HJNoo9GWWa7tsG8U3CRtPf2IqNs+E3UJXiNvRU6Vge7Ain5aixLt
	JtETmI+zIT8orBlqGm7utbyPRusSbLKLVCSqdEWV0IOIIpScfQumRbF7yFhbL6Oj8UPb0qg+3rh
	smIf5DXyy7veEC+qw09/BKgHQdD+acbX1NxxSLHGiF9yebfZlZKi48mm5tNT9uMCeQ79mc17RXt
	FWk4QaJOXxzmLZQ==
X-Google-Smtp-Source: AGHT+IGoe/6XelXwleh/f8r4zr27zHcIB0CqVXjZbRwv8XJwPHM5clgwxTPlpMXrxuLPSpKCZryPXw==
X-Received: by 2002:a05:6a00:2181:b0:736:4cde:5c0e with SMTP id d2e1a72fcca58-7403a77e9e2mr1262709b3a.10.1745978753458;
        Tue, 29 Apr 2025 19:05:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740398f9ee5sm445532b3a.3.2025.04.29.19.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 19:05:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1u9wpa-0000000F32T-2pBL;
	Wed, 30 Apr 2025 12:05:50 +1000
Date: Wed, 30 Apr 2025 12:05:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chi Zhiling <chizhiling@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [RFC PATCH 0/2] Implement concurrent buffered write with folio
 lock
Message-ID: <aBGFfpyGtYQnK411@dread.disaster.area>
References: <20250425103841.3164087-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425103841.3164087-1-chizhiling@163.com>

On Fri, Apr 25, 2025 at 06:38:39PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> This is a patch attempting to implement concurrent buffered writes.
> The main idea is to use the folio lock to ensure the atomicity of the
> write when writing to a single folio, instead of using the i_rwsem.
> 
> I tried the "folio batch" solution, which is a great idea, but during
> testing, I encountered an OOM issue because the locked folios couldn't
> be reclaimed.
> 
> So for now, I can only allow concurrent writes within a single block.
> The good news is that since we already support BS > PS, we can use a
> larger block size to enable higher granularity concurrency.

I'm not going to say no to this, but I think it's a short term and
niche solution to the general problem of enabling shared buffered
writes. i.e. I expect that it will not exist for long, whilst
experience tells me that adding special cases to the IO path locking
has a fairly high risk of unexpected regressions and/or data
corruption....

> These ideas come from previous discussions:
> https://lore.kernel.org/all/953b0499-5832-49dc-8580-436cf625db8c@163.com/

In my spare time I've been looking at using the two state lock from
bcachefs for this because it looks to provide a general solution to
the issue of concurrent buffered writes.

The two valid IO exclusion states are:

+enum {
+       XFS_IOTYPE_BUFFERED = 0,
+       XFS_IOTYPE_DIRECT = 1,
+};

Importantly, this gives us three states, not two:

1. Buffered IO in progress,
2. Direct IO in progress, and
3. No IO in progress. (i.e. not held at all)

When we do operations like truncate or hole punch, we need the state
to be #3 - no IO in progress.

Hence we can use this like we currently use i_dio_count for
truncate with the correct lock ordering. That is, we order the
IOLOCK before the IOTYPE lock:

Buffered IO:

	IOLOCK_SHARED, IOLOCK_EXCL if IREMAPPING
	  <IREMAPPING excluded>
	  IOTYPE_BUFFERED
	    <block waiting for in progress DIO>
	    <do buffered IO>
	  unlock IOTYPE_BUFFERED
	unlock IOLOCK

IREMAPPING IO:

	IOLOCK_EXCL
	  set IREMAPPING
	  demote to IOLOCK_SHARED
	  IOTYPE_BUFFERED
	    <block waiting for in progress DIO>
	    <do reflink operation>
	  unlock IOTYPE_BUFFERED
	  clear IREMAPPING
	unlock IOLOCK

Direct IO:

	IOLOCK_SHARED
	  IOTYPE_DIRECT
	    <block waiting for in progress buffered, IREMAPPING>
	    <do direct IO>
	<submission>
	  unlock IOLOCK_SHARED
	<completion>
	  unlock IOTYPE_DIRECT

Notes on DIO write file extension w.r.t. xfs_file_write_zero_eof():
- xfs_file_write_zero_eof() does buffered IO.
- needs to switch from XFS_IOTYPE_DIRECT to XFS_IOTYPE_BUFFERED
- this locks out all other DIO, as the current switch to
  IOLOCK_EXCL will do.
- DIO write path no longer needs IOLOCK_EXCL to serialise post-EOF
  block zeroing against other concurrent DIO writes.
- future optimisation target so that it doesn't serialise against
  other DIO (reads or writes) within EOF.

This path looks like:

Direct IO extension:

	IOLOCK_EXCL
	  IOTYPE_BUFFERED
	    <block waiting for in progress DIO>
	    xfs_file_write_zero_eof();
	  demote to IOLOCK_SHARED
	  IOTYPE_DIRECT
	    <block waiting for buffered, IREMAPPING>
	    <do direct IO>
	<submission>
	  unlock IOLOCK_SHARED
	<completion>
	  unlock IOTYPE_DIRECT

Notes on xfs_file_dio_write_unaligned()
- this drains all DIO in flight so it has exclusive access to the
  given block being written to. This prevents races doing IO (read
  or write, buffered or direct) to that specific block.
- essentially does an exclusive, synchronous DIO write after
  draining all DIO in flight. Very slow, reliant on inode_dio_wait()
  existing.
- make the slow path after failing the unaligned overwrite a
  buffered write.
- switching modes to buffered drains all the DIO in flight,
  buffered write data all the necessary sub-block zeroing in memory,
  next overlapping DIO of fdatasync() will flush it to disk.

This slow path looks like:

	IOLOCK_EXCL
	  IOTYPE_BUFFERED
	    <excludes all concurrent DIO>
	    set IOCB_DONTCACHE
	    iomap_file_buffered_write()

Truncate and other IO exclusion code such as fallocate() need to do
this:

	IOLOCK_EXCL
	  <wait for IO state to become unlocked>

The IOLOCK_EXCL creates a submission barrier, and the "wait for IO
state to become unlocked" ensures that all buffered and direct IO
have been drained and there is no IO in flight at all.

Th upside of this is that we get rid of the dependency on
inode->i_dio_count and we ensure that we don't potentially need a
similar counter for buffered writes in future. e.g. buffered
AIO+RWF_DONTCACHE+RWF_DSYNC could be optimised to use FUA and/or IO
completion side DSYNC operations like AIO+DIO+RWF_DSYNC currently
does and that would currently need in-flight IO tracking for truncate
synchronisation. The two-state lock solution avoids that completely.

Some work needs to be done to enable sane IO completion unlocking
(i.e. from dio->end_io). My curent notes on this say:

- ->end_io only gets called once when all bios submitted for the dio
  are complete. hence only one completion, so unlock is balanced
- caller has no idea on error if IO was submitted and completed;
  if dio->end_io unlocks on IO error, the waiting submitter has no
  clue whether it has to unlock or not.
- need a clean submitter unlock model. Alternatives?
  - dio->end_io only unlock on on IO error when
    dio->wait_for_completion is not set (i.e. completing an AIO,
    submitter was given -EIOCBQUEUED). iomap_dio_rw() caller can
    then do:

        if (ret < 0 && ret != -EIOCBQUEUED) {
                /* unlock inode */
        }
  - if end_io is checking ->wait_for_completion, only ever unlock
    if it isn't set? i.e. if there is a waiter, we leave it to them
    to unlock? Simpler rule for ->end_io, cleaner for the submitter
    to handle:

        if (ret != -EIOCBQUEUED) {
                /* unlock inode */
        }
- need to move DIO write page cache invalidation and inode_dio_end()
  into ->end_io for implementations
- if no ->end_io provided, do what the current code does.

There are also a few changes need to avoid inode->i_dio_count in
iomap:
- need a flag to tell iomap_dio_rw() not to account the DIO
- inode_dio_end() may need to be moved to ->dio_end, or we could
  use the "do not account" flag to avoid it.
- However, page cache invalidation and dsync work needs to be done
  before in-flight dio release, so this we likely need to move this
  stuff to ->end_io before we drop the IOTYPE lock...
- probably can be handled with appropriate helpers...

I've implemented some of this already; I'm currently in the process
of making truncate exclusion work correctly. Once that works, I'll
post the code....

-~dave
-- 
Dave Chinner
david@fromorbit.com
