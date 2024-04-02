Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C475715AAA7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093196; cv=none; b=eaGIJK5cpbs/NYmcpOry+lij7cOKUInjFFi3L9GQ8DxtBhI1rijhL6CfvCFHklymc3RkAQEZsd+EMkY69mtw3xI9A/9tMJ+HuNUX3NpAtxcDv528HwxJNUWxk30ejsNTmX+28TniCAxswJOc2YbZDTo6J9Ts/+oq2uZ7lRnybHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093196; c=relaxed/simple;
	bh=Usxkw4VvUR39Bow/055WWjQFKD6J5UdAkTBZrOzBcQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJTO319u5uZ4cNklCXvLL2gtDNSR54p2MTijRUS20jVN4vNnemo/RpweWFV5RNK3mRrvhOBHS6vf/6W9LZkyDXTBqojkKvtOqN36diGGY7eCBdJXcBX33SNO84k7WTOT+zPdvnYKH/CwUp/79fe5dctl1XMU2k6nLFU8vV8SwVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cdMyifU2; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cdMyifU2"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5d4a1e66750so3346915a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093194; x=1712697994; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yJ+MpWrAm/yV4C8xPtf1zGd3dcExtS3YCwkcl5R0q/Q=;
        b=cdMyifU2YDa72eRI+Q905zqOf2o7SOpU9ksbb45R5Y8sbbyw2XD+9I7cLTtcHqWauA
         OJKjA6+JgCeIkA6blukcNgPiHCpag0hi7lrW8MPX+UxOHajn1+oUctkF43OhS/25Ufn0
         nNOY9PsEdbqy/VGTxICrpr7OJST2r8gICx5aaUgjMZeNEO9Zpx6YVP+z4LJrQYGbt1AV
         lOPV3q5IBjR2JON78TWFu+HnA1qgXBGp+GuQxYA1tnXpRfzHpUDPSlsOZ4e5/V5LZaKz
         Y8L1RVLcg7DdzTVWZYYwjGSPZ7TCqNpDf15rc6pxP8b6aZeV6VtH3Q9jFdvhEz+BPyg8
         Cmlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093194; x=1712697994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJ+MpWrAm/yV4C8xPtf1zGd3dcExtS3YCwkcl5R0q/Q=;
        b=gKlVXx2KY1xq4gAqwZEyrVQv2UDawOB9TzJjEQBaj29+g4dRQsb53fcfCM0DEKS2rE
         OlirBVy6mCphVlZLwO4j2VfebTQIqG6lfSlhx21EqB5Crbat8J4dXMyXAVMYR2ZTtOIr
         SKtu/DRU/Z9KAd+rXVx+ekEtv4npWmpSSphbwheS01i9zgGiWsB+KMtkRnpZRFzlFUJ/
         3yQJzYRaCOp+c0/C0urRG/vWL945OYTXKa969Q1HRJv3npzg+9QxsH6RHKFUvJxG6pB1
         98WigjaQPBt99LC9h/nTHGLSyJVNBGbpyW0UDUZsua+jdlGaRld8RKJ9xE6vb2yvZ2pp
         sZLQ==
X-Gm-Message-State: AOJu0YxVnBlLvtvM9BzKiZ9o+jwQ0xPjsBqzHOdktIwHILpXKlUjNcdu
	4fbTtH5BIQjI7dvdxa1GYBun9G4n/PHbl9P/3va6Cc5QIdS/OJ7Rt7HStKTveot+QDBqLrpoDBp
	9
X-Google-Smtp-Source: AGHT+IHkzjTLFqni+IByv1LCeRp7AUf8HgdIMowk+tGKtFyhMLNjxaT/u+CKJo2jVZsL3GwsRC5+zA==
X-Received: by 2002:a05:6a20:3d81:b0:1a5:6e14:369 with SMTP id s1-20020a056a203d8100b001a56e140369mr14519313pzi.6.1712093193914;
        Tue, 02 Apr 2024 14:26:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id o3-20020a056a00214300b006e6288ef4besm10224435pfk.54.2024.04.02.14.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:26:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rrleI-001mfw-2t;
	Wed, 03 Apr 2024 08:26:30 +1100
Date: Wed, 3 Apr 2024 08:26:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH 1/3] xfs: simplify extent allocation alignment
Message-ID: <Zgx4BhcW9/6XAiq9@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
 <20240306053048.1656747-2-david@fromorbit.com>
 <9f511c42-c269-4a19-b1a5-21fe904bcdfb@oracle.com>
 <ZfpnfXBU9a6RkR50@dread.disaster.area>
 <9cc5d4da-c1cd-41d3-95d9-0373990c2007@oracle.com>
 <ZgueamvcnndUUwYd@dread.disaster.area>
 <11ba4fca-2c89-406a-83e3-cb8d20f72044@oracle.com>
 <fd9f99a3-35ef-477e-ad64-08f71223d36b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9f99a3-35ef-477e-ad64-08f71223d36b@oracle.com>

On Tue, Apr 02, 2024 at 04:11:20PM +0100, John Garry wrote:
> On 02/04/2024 08:49, John Garry wrote:
> > Update:
> > So I have some more patches from trying to support both truncate and
> > fallocate + punch/insert/collapse for forcealign.
> > 
> > I seem to have at least 2x problems:
> > - unexpected -ENOSPC in some case
> 
> This -ENOSPC seems related to xfs_bmap_select_minlen() again.
> 
> I find that it occurs when calling xfs_bmap_select_minlen() and blen ==
> maxlen again, like:
> blen=64 args->alignment=16, minlen=0, maxlen=64
> 
> And then this gives:
> args->minlen=48 blen=64

Which is perfectly reasonable - it fits the bounds specified just
fine, and we'll get a 64 block allocation if that free space is
exactly aligned. Otherwise we'll get a 48 block allocation.

> But xfs_alloc_vextent_start_ag() -> xfs_alloc_vextent_iterate_ags() does not
> seem to find something suitable.

Entirely possible. The AGFL might have needed refilling, so there
really wasn't enough blocks remaining for an aligned allocation to
take place after doing that. That's a real ENOSPC condition, despite
the best length sampling indicating that the allocation could be
done.

Remember, bestlen sampling is racy - it does not hold the AGF
locked from the point of sampling to the point of allocation. Hence
when we finally go to do the allocation after setting it all up, we
might have raced with another allocation that took the free space
sampled during the bestlen pass and so then the allocation fails
despite the setup saying it should succeed.

Fundamentally, if the filesystem's best free space length is the
same size as the requested allocation, *failure is expected* and the
fallback attempts progressively remove restrictions (such as
alignment) to allow sub-optimal extents to be allocated down to
minlen in size. Forced alignment turns off these fallbacks, so you
are going to see hard ENOSPC errors the moment the filesystem runs
out of contiguous free space extents large enough to hold aligned
allocations.

This can happen a -long- way away from a real enospc condition -
depending on alignment constraints, you can start seeing this sort
of behaviour (IIRC my math correctly) at around 70% full. The larger
the alignment and the older the filesystem, the earlier this sort of
ENOSPC event will occur.

Use `xfs_spaceman -c 'freesp'` to dump the free space extent size
histogram. That will quickly tell you if there is no remaining free
extents large enough for an aligned 48 block allocation to succeed.
With an alignment of 16 blocks, this requires at least a 63 block
free space extent to succeed.

IOWs, we should expect ENOSPC to occur long before the filesystem
reports that it is out of space when we are doing forced alignment
allocation.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
