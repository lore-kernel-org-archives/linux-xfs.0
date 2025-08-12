Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406A13B284
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 00:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958151; cv=none; b=aYmOIEq33IpIoHk8PxHQqQi7lNOX0uDQzXSPUX+v+S39A/IYWc3eYtU1KKzB6DVAODqUzq74zkOp74w0WF8xEptNjgJBZdNYbiPCN1ZSvNcicWCtz6TnQ4hOYs6NWs+sAHuGXlhTApP0o8+h4lu27A9qnDnpyoUyk6W++esfnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958151; c=relaxed/simple;
	bh=4vV6mJEZwu6rjyk3+ILiQM6xYpQgWeouFAWsYzr4qUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2qq8Ea+HLTHdUZ5T9obKp9q8mweKjdMMEOzPJxJ9gBaWz2M21OmC1TQ5Fs/9wJa+kka381C8ajsY6Kq5rTJrnILqrsXZz0uDYdh9Kke61l31xeQ2pd6O7Mkxh+YyVRLaM7aBDkF+6SijkPanuaLz7v+9pVivEHjZPG8obPihmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=uh+Z1GZE; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="uh+Z1GZE"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76c18568e5eso5481438b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 17:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1754958148; x=1755562948; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVmXRLsnGW3cFHXuVJBTWBFI9qQhZmPZ+bs1wEjG9L4=;
        b=uh+Z1GZEzcKTRUChpq5MFwh2uQWcEW8FUKxjl/dSLbEmUjywM4vm2LNsaH8rjRmZ6b
         Sgc1SxdNvQIOBvY164cgkpDrnGLRNy8VmAEXhjaalaKsep8uZ/rw+NTpumdkfR/d3CEd
         tVVB0N1eXlWr0bMpHaQN1UcIQaQUKFDUub/3gDs6HfK9qDTnetpdEfu9H4X3ktMRVDQ8
         qiI2XfIQdIeA66qNSDxUvJBu9XMGzPILtOTAFgMVdVjRMzD2rRoCHwac6NdsYFF4VY7n
         H3inaIJ9UDadMJHHM1zNkKBIBEUymCx3Guybmf7AbMqyIvuBJAF3GMRw4++BatUrs7e9
         c8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754958148; x=1755562948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVmXRLsnGW3cFHXuVJBTWBFI9qQhZmPZ+bs1wEjG9L4=;
        b=U8TGdjIwhuHEgNDOG38E7wlzX1LTUW20Pr014XfAE6xfmYCmkQzTxpHXPtp77iyVKj
         3etTKJmMRsyPiaOixtUv/QXl5Ao603rCJ5l//V8SiF89EaTAY+8Sz9gDP6R3RMbHXt6D
         GF42PI1QAvScWknG9wx4iSYsz1NOKEzjQ4plwG++YzaRsHzyqMvZQ4rJxAaDohEVrTup
         gHPL0fIW0lfxlRr13qadH19e/sEK2FMW4H+KSprKZK2+TdklrJIs6W5lr07AX76kCdoI
         ZdmeuCdtD+xdapVoW3j9zPpdRo4t6M046azZW5LRBKFLBDsoD5+J+QGmy8+2ZsZNN8Uf
         s+jg==
X-Forwarded-Encrypted: i=1; AJvYcCXI+KkkHn4+Q+k5IXeAcI3BmPQ3aJ2ZUVTcWOHTB9j8snpqfQ1/COQOxW1JnTOZJ68ljwBtahlWfuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YySyk9FBZr48pQkGIVJSGngF+MWW6pTsILscP2dxq28Hxw7PvjS
	sAoaR2wrmmRFh6kj93SjCFfQKwTOSLDrO4Idiiez2rJBQoyYFWCdK2kWzz4he1sRuZhk6XcskhL
	2GYNe
X-Gm-Gg: ASbGncsx2WAEuPj45StiMechXdvBcDqI4VOVh4hPPNry9rdyS8ly0QoD7MCN5bMK1fk
	b+2hjVWmbMnAsO7tEsL/YPp7hqjNSlNTIDBmmHWoseGH4hjvDm0Nb/42Nf0XdSjpiq+P/ygNKkC
	HOtRbI2/ynEyrkzyBRggbCQSaRfFOM43O3CeLh1QGuPGTkmiYG+m/9XgtiBqbfFZSdqoLegBeeJ
	zROG5UFgTjGkMS4Ztb31FIFird+jg9idaFhs2mhIzjsglKY0apoQXHVipy1sLt3P1EGnpXxz95a
	toTk4x27nYAy7VenRicywve/6UGuIBGUyG/w9HiQqXGUcUBIZFUPM4J94N+iF5q296JNv6EjHme
	208mSEk2z2OBAIZ4eG1Ol+XYCgSu5Jc0TX2Kln7Gr8TUZl39j5P0G1UVDk3UWJ2hsFoMYTPkRrA
	==
X-Google-Smtp-Source: AGHT+IGzh+uMSU7BHhpxFeer+HEFeBpAKaXldU9vx5byQlHklHYY4EDhPqfwtXepqgMjD7P4DJSHFQ==
X-Received: by 2002:a05:6a20:1611:b0:238:351a:6438 with SMTP id adf61e73a8af0-2409a9b58c3mr2190335637.44.1754958148226;
        Mon, 11 Aug 2025 17:22:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6fe4bsm27839370b3a.9.2025.08.11.17.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 17:22:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1ulcmW-00000005DMv-3nr9;
	Tue, 12 Aug 2025 10:22:24 +1000
Date: Tue, 12 Aug 2025 10:22:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: liuhuan01@kylinos.cn
Cc: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] xfs: prevent readdir infinite loop with billions
 subdirs
Message-ID: <aJqJQIvFO1H2QYrR@dread.disaster.area>
References: <20250801084145.501276-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801084145.501276-1-liuhuan01@kylinos.cn>

On Fri, Aug 01, 2025 at 04:41:46PM +0800, liuhuan01@kylinos.cn wrote:
> From: liuh <liuhuan01@kylinos.cn>
> 
> When a directory contains billions subdirs, readdir() repeatedly
> got same data and goes to infinate loop.

FWIW, we don't support "billions of dirents in a directory" in XFS.
The max capacity is 1.43 billion dirents, and much less than that is
filenames are anything but minimum length to encode 1.43 billion
unique names.

e.g. if we limit outselves to ascii hex (e.g. for hash based
filenames in an object store), we need 31 characters to encode
enough entries to fill the entire directory data space (32GB).
At this point, the dirent size is 48 bytes (instead of 24 for the
minimum length encoding), and so the maximum
number of entries ends up being around 700 million.

In this case, we'd hit the looping problem at about 350 million
entries into the getdents operation.

The issue is that when we start filling the upper 16GB of the data
segment, the dataptr exceeds 2^31 in length and that high bit is
then filtered off, even on 64 bit systems.

IOWs, the problem is not triggered by the number of entries, but by
the amount of space being consumed in the directory data segment.

Thing is, the kernel directory context uses a loff_t for the dirent
position (i.e. the readdir cookie). So, in the kernel, it is always
64 bits because:

typedef long long       __kernel_loff_t;

And so the low level directory iteration code in XFS does not need
to truncate the dir_context->pos value to 31 bits, especially as
the position is always a 32 bit value.

> @@ -491,9 +491,9 @@ xfs_dir2_leaf_getdents(
>  	 * All done.  Set output offset value to current offset.
>  	 */
>  	if (curoff > xfs_dir2_dataptr_to_byte(XFS_DIR2_MAX_DATAPTR))
> -		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
> +		ctx->pos = XFS_DIR2_MAX_DATAPTR;

I think that code is wrong to begin with: if the curoff is beyond
32GB, something is badly wrong with the directory structure. i.e.
we've had a directory data segement overrun.

This can only happen if there's been a corruption we haven't caught
or some kind of bug was tripped over.  This condition should result
in failing the operation and returning -EFSCORRUPTED, not truncating
the directory offset....

This also points out the big problem with the seekdir/telldir APIs
on 32 bit systems. telldir returns a signed long for the dirent
cookie, and whilst the man page says:

	Application programs should treat this strictly as an opaque
	value, making no assumptions about its contents.

Despite this, the value of -1 (0xffffffffff on 32 bit systems) is
not allowed to be used as the dir cookie on 32 bit systems as this
is the indicator that telldir() uses to inform the application that
it encountered an error.

Hence we cannot return XFS_DIR2_MAX_DATAPTR as a valid file position
during getdents on 32 bit systems, nor should we accept it from
seekdir() operations on directories.....

Similarly, seekdir() on a 32 bit system won't support cookie
values over 2^31 (i.e. negative 32 bit values) because XFS doesn't
set FOP_UNSIGNED_OFFSET for directory file objects. Hence seekdir()
will fail with -EINVAL as the offset gets interpretted as being less
than zero...

IOWs, 32 bit APIs are a mess w.r.t. unsigned 32 bit dir cookies,
and so the filtering of the high bit was an attempt to avoid those
issues. Using hundreds of millions of entries in a single directory
is pretty much always a bad idea, so this really hasn't been an
issue that anyone has cared about in production systems.

If we want to fix it, the handling of 32 bit offset overflows stuff
should really be moved to a higher level (e.g. to xfs_file_readdir()
and, perhaps, new directory llseek functions). We probably should
also be configuring directory files on 32 bit systems with
FOP_UNSIGNED_OFFSET so that everything knows that we are using the
whole 32 bit cookie space with seekdir/telldir...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
