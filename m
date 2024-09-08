Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2213214D45E
	for <linux-xfs@vger.kernel.org>; Sun,  8 Sep 2024 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725835791; cv=none; b=gd2bUdInF/sOUsqEl4LlqTRyY2bQddt3l1mrlObSqjrFSd1cg3hZt+1GOLU+SQvB6yPCYqv/C/ROdA31NT1Uq1BAc4qQhgGq1Q/tejyG31YwYAhhgygDOyh9C3q4UsfO/1kkTSPArjLdHLp9DaZrDBxFKCDXJSuYcQZrUxvXIOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725835791; c=relaxed/simple;
	bh=bsa+rnV7uBrxI0i9jQrjgili2wj/kL9oQ3CZA5IWysY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1Yu2MH68+nptLrJygykqv3a4IsIXh6FLD4yrbiggUYXLVSsybXLitb0r+lo80mKLQPBqRmE04Y0f3IRrcL2w9+MOGRDkY1tpO/db5C9zbwmz3Lfo8PABusKcO/tzSZzRbtAzGfWCxh73cxGufzJlmCjDNBeywe49srFiBURB/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=24X1ZUeS; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="24X1ZUeS"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7c3ebba7fbbso3016665a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 08 Sep 2024 15:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1725835789; x=1726440589; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3QPsmYILQd/xd8I5FvjxiALY4rS0T+MuhxN623BzYE8=;
        b=24X1ZUeSVKNBIoChvU7lgsA9q89ep3BGRQy4zaT0O+OSntYGdcO3BoGCYqXvhD5W9z
         4nS5DP2Iw9Da0Ihfww7D9uQJGgjTcGOXPF8EFyIxjUBifZ8jC6gFOULUsL4wDCM5ATrP
         i+zXse7tmYaMztEI0nIk6Ylx9HYntj3nHDn6zhHtSR1QGOvdHI4irHpIPQxD5fUSShjx
         P7MQg5YuXEEIs8Zrkexz2nBb9h/eoVgKGgPWE1w/ymoWntZxdqOg2ubvsSefjpc/rSfm
         1RzX8Z0r8Scm+qVRTVVCCyK7tQW/eF3UWvnnVtz2J3StZ8/StWUtNHY/UVCqo/XFIZ6u
         UZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725835789; x=1726440589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QPsmYILQd/xd8I5FvjxiALY4rS0T+MuhxN623BzYE8=;
        b=BtUG9e3jDQHVxOdjrvqWfmFua1k2vcz4JwFb6N3pCy6UunjqUAKkPuLSOk1QHLHmu0
         EhHTOLbaapmp36EF0gVuTXgyZePQUMeh+sUT/NcJoaq6GRZlJN7uJBimanoU0JHQAff6
         qDh/czvhvazz0hKW0tXzFi9C7WISIjRKGZXhpReICI2IyKe69zsdnsafoifg3DmYnvVV
         l/AF7kbUZwwrb5buqbH2DVBpgXRkMnnAyHPVfnifcuFN74dLFca8w/Mm/39v2X/nnNvp
         Rq/HU4+EOXjR508NfNlGuzdLyc5ze8kWl3g+OYwSXT3v1tTSk6B8uJZ1SQxJXC5GBJ6N
         7jsg==
X-Forwarded-Encrypted: i=1; AJvYcCXBXXWA6CFAyJNiLXMGQyGu1HXcV6/TvtD9Z01QOUwxhNAYc2N+/vYIPsFStadamlUam71C6JRCJDM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdl4n9I6AI0mgKwEl0TLTeDeLw27EZKuXUXm6Z/Aw62haFnaaY
	wXSFS/ze08SN8yby9Zg/B/YRbI/AX8TqKUZWDdU2M9QwtY5tka2bT2fDxB5Dues=
X-Google-Smtp-Source: AGHT+IEti9DLUoOJUH5lYfPvZdHn3IUvnN8GoCzu9jtLgyl2DhZKP1ozk/sJ68zA1IyNVSpl3JUsAA==
X-Received: by 2002:a05:6a21:3305:b0:1cf:354e:93df with SMTP id adf61e73a8af0-1cf354e9586mr6624507637.4.1725835789293;
        Sun, 08 Sep 2024 15:49:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d8241bf552sm2796175a12.48.2024.09.08.15.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2024 15:49:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1snQj2-002dFM-1r;
	Mon, 09 Sep 2024 08:49:44 +1000
Date: Mon, 9 Sep 2024 08:49:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, chandan.babu@oracle.com,
	djwong@kernel.org, dchinner@redhat.com, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH v4 00/14] forcealign for xfs
Message-ID: <Zt4qCLL6gBQ1kOFj@dread.disaster.area>
References: <20240813163638.3751939-1-john.g.garry@oracle.com>
 <87frqf2smy.fsf@gmail.com>
 <ZtjrUI+oqqABJL2j@dread.disaster.area>
 <79e22c54-04bd-4b89-b20c-3f80a9f84f6b@oracle.com>
 <Ztom6uI0L4uEmDjT@dread.disaster.area>
 <ce87e4fb-ab5f-4218-aeb8-dd60c48c67cb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce87e4fb-ab5f-4218-aeb8-dd60c48c67cb@oracle.com>

On Fri, Sep 06, 2024 at 03:31:43PM +0100, John Garry wrote:
> On 05/09/2024 22:47, Dave Chinner wrote:
> > > > >   If the start or end of the extent which needs unmapping is
> > > > >        unaligned then we convert that extent to unwritten and skip,
> > > > >        is it? (__xfs_bunmapi())
> > > > The high level code should be aligning the start and end of the
> > > > file range to be removed via xfs_inode_alloc_unitsize().
> > > Is that the case for something like truncate? There we just say what is the
> > > end block which we want to truncate to in
> > > xfs_itruncate_extents_flags(new_size)  ->
> > > xfs_bunmapi_range(XFS_B_TO_FSB(new_size)), and that may not be alloc unit
> > > aligned.
> > Ah, I thought we had that alignment in xfs_itruncate_extents_flags()
> > already, but if we don't then that's a bug that needs to be fixed.
> 
> AFAICS, forcealign behaviour is same as RT, so then this would be a mainline
> bug, right?

No, I don't think so. I think this is a case where forcealign and RT
behaviours differ, primarily because RT doesn't actually care about
file offset -> physical offset alignment and can do unaligned IO
whenever it wants. Hence having an unaligned written->unwritten
extent state transition doesnt' affect anything for rt files...

> 
> > > We change the space reservation in xfs-setattr_size() for this case
> > (patch 9) but then don't do any alignment there - it relies on
> > xfs_itruncate_extents_flags() to do the right thing w.r.t. extent
> > removal alignment w.r.t. the new EOF.
> > 
> > i.e. The xfs_setattr_size() code takes care of EOF block zeroing and
> > page cache removal so the user doesn't see old data beyond EOF,
> > whilst xfs_itruncate_extents_flags() is supposed to take care of the
> > extent removal and the details of that operation (e.g. alignment).
> 
> So we should roundup the unmap block to the alloc unit, correct? I have my
> doubts about that, and thought that xfs_bunmapi_range() takes care of any
> alignment handling.

The start should round up, yes. And, no, xfs_bunmapi_range() isn't
specifically "taking care" of alignment. It's just marking a partial
alloc unit range as unwritten, which means we now have -unaligned
extents- in the BMBT. 

> 
> > 
> > Patch 10 also modifies xfs_can_free_eofblocks() to take alignment
> > into account for the post-eof block removal, but doesn't change
> > xfs_free_eofblocks() at all. i.e  it also relies on
> > xfs_itruncate_extents_flags() to do the right thing for force
> > aligned inodes.
> 
> What state should the blocks post-EOF blocks be? A simple example of
> partially truncating an alloc unit is:
> 
> $xfs_io -c "extsize" mnt/file
> [16384] mnt/file
> 
> 
> $xfs_bmap -vvp mnt/file
> mnt/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..20479]:      192..20671        0 (192..20671)     20480 000000
> 
> 
> $truncate -s 10461184 mnt/file # 10M - 6FSB
> 
> $xfs_bmap -vvp mnt/file
> mnt/file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..20431]:      192..20623        0 (192..20623)     20432 000000
>    1: [20432..20447]:  20624..20639      0 (20624..20639)      16 010000
>  FLAG Values:
>     0010000 Unwritten preallocated extent
> 
> Is that incorrect state?

Think about it: what happens if you now truncate it back up to 10MB
(i.e. aligned length) and then do an aligned atomic write on it.

First: What happens when you truncate up?

......

Yes, iomap_zero_range() will see the unwritten extent and skip it.
i.e. The unwritten extent stays as an unwritten extent, it's now
within EOF. That written->unwritten extent boundary is not on an
aligned file offset.

Second: What happens when you do a correctly aligned atomic write
that spans this range now?

......

Iomap only maps a single extent at a time, so it will only map the
written range from the start of the IO (aligned) to the start of the
unwritten extent (unaligned).  Hence the atomic write will be
rejected because we can't do the atomic write to such an unaligned
extent.

That's not a bug in the atomic write path - this failure occurs
because of the truncate behaviour doing post-eof unwritten extent
conversion....

Yes, I agree that the entire -physical- extent is still correctly
aligned on disk so you could argue that the unwritten conversion
that xfs_bunmapi_range is doing is valid forced alignment behaviour.
However, the fact is that breaking the aligned physical extent into
two unaligned contiguous extents in different states in the BMBT
means that they are treated as two seperate unaligned extents, not
one contiguous aligned physical extent.

This extent state discontiunity is results in breaking physical IO
across the extent state boundary. Hence such an unaligned extent
state change violates the physical IO alignment guarantees that
forced alignment is supposed to provide atomic writes...

This is the reason why operations like hole punching round to extent
size for forced alignment at the highest level. i.e. We cannot allow
xfs_bunmapi_range() to "take care" of alignment handling because
managing partial extent unmappings with sub-alloc-unit unwritten
extents does not work for forced alignment.

Again, this is different to the traditional RT file behaviour - it
can use unwritten extents for sub-alloc-unit alignment unmaps
because the RT device can align file offset to any physical offset,
and issue unaligned sector sized IO without any restrictions. Forced
alignment does not have this freedom, and when we extend forced
alignment to RT files, it will not have the freedom to use
unwritten extents for sub-alloc-unit unmapping, either.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
