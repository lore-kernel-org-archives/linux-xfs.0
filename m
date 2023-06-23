Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB31EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjFWAru (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 20:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjFWArt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 20:47:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F19B2105
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 17:47:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25e83a63143so22088a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 17:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687481267; x=1690073267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=23/+c77WupXlMjgkTvqk+39eHKg8rnJVlESSfbu3RPI=;
        b=l72LKEX31RvUx4JojwQ8NnJ1DVYDc3D55/ARiDPusyFykxP0KiisC+XRzubSHlLGOj
         DfcycVNV8kLbSVSaDvVTRKWoEn6iMsQODsForZZU+lToK3rPQqtcdCPx159POWLfwiq2
         Joqrq+pwdRhtY/wkrAXVro+vjB4vNS7ZJwJEcFslofVb8SHfECDp79jFD6UyyoqyNirQ
         dsaIk8TngG/Qyj0NqWRR24X384EQDTkUv+1M7+OB2jA+tz7X+NUY0y1GnshxnJ3KMiuU
         kxrScSw0jnuutk5WPB5Mpochy8aGo7gFdI/hWARyGapgl6EZD+MA0GhDwThdhFs4dUT6
         6Cqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687481267; x=1690073267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23/+c77WupXlMjgkTvqk+39eHKg8rnJVlESSfbu3RPI=;
        b=G573a7jSHpS+IPi44LxW/RE8EaUfXgTKgtyTkFgKDb4oA9cPNRsesePRtAW7Fq78GM
         qZv6OQe4hhuJ3BOxKQjXeBEQxQoZrNxlkFihhxutZyYWu0Zr/LrDOAPJm9TY7MUYelrq
         IfqGcmnykuHpiLZ6SNdPx3o/9Jxc1VAUzx6t2WfQtpLZ7KlNSnsvcFx49IRBjizzhBsu
         WA1yYbwzDEEOqQCg1in4BS76En37k0lzq6owDN6BF4Zgb5FgEIY5nx+M7gm9wmaoEKL4
         PTQxDC3Dzw3d8fZC33m3POLMcXcS4+jd+pwrbW1jNdYsrdJsBCBJFN2ygJtPK38vFXjw
         gW3g==
X-Gm-Message-State: AC+VfDxgDiiRaVOn01yt9ilLldRr90k8SCBcGyjGU3pWhg8p7jP0Lxor
        SjXqxSS5wdEvzf2bXgIedOkJF0ZGeFS6fYBHvKM=
X-Google-Smtp-Source: ACHHUZ5gPGMOS5sNUZ0jtG1/+QJZQvKis9JuCjfL+/NTw3dXibLB8LJlkQLrWVKpGV+Q4AX6acLCpA==
X-Received: by 2002:a17:902:6ac5:b0:1ae:3991:e4f9 with SMTP id i5-20020a1709026ac500b001ae3991e4f9mr17612022plt.61.1687481267380;
        Thu, 22 Jun 2023 17:47:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id ja22-20020a170902efd600b001ab2b4105ddsm2207523plb.60.2023.06.22.17.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 17:47:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCUxj-00F34a-1I;
        Fri, 23 Jun 2023 10:47:43 +1000
Date:   Fri, 23 Jun 2023 10:47:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Masahiko Sawada <sawada.mshk@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <ZJTrrwirZqykiVxn@dread.disaster.area>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 02:34:18PM +0900, Masahiko Sawada wrote:
> Hi all,
> 
> When testing PostgreSQL, I found a performance degradation. After some
> investigation, it ultimately reached the attached simple C program and
> turned out that the performance degradation happens on only the xfs
> filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> program alternately does two things to extend a file (1) call
> posix_fallocate() to extend by 8192 bytes

This is a well known anti-pattern - it always causes problems. Do
not do this.

> and (2) call pwrite() to
> extend by 8192 bytes. If I do only either (1) or (2), the program is
> completed in 2 sec, but if I do (1) and (2) alternatively, it is
> completed in 90 sec.

Well, yes. Using fallocate to extend the file has very different
constraints to using pwrite to extend the file.

> $ gcc -o test test.c
> $ time ./test test.1 1
> total   200000
> fallocate       200000
> filewrite       0

No data is written here, so this is just a series of 8kB allocations
and file size extension operations. There are no constraints here
because it is a pure metadata operation.

> real    0m1.305s
> user    0m0.050s
> sys     0m1.255s
> 
> $ time ./test test.2 2
> total   200000
> fallocate       100000
> filewrite       100000
>
> real    1m29.222s
> user    0m0.139s
> sys     0m3.139s

Now we have fallocate extending the file and doing unwritten extent
allocation, followed by writing into that unwritten extent which
then does unwritten extent conversion.

This introduces data vs metadata update ordering constraints to the
workload.

The problem here in that the "truncate up" operation that
fallocate is doing to move the file size. The "truncate up" is going
to move the on-disk file size to the end of the fallocated range via
a journal transaction, and so it will expose the range of the
previous write as containing valid data.

However, the previous data write is still only in memory and not on
disk. The result of journalling the file size change is that if we
crash after the size change is made but the data is not on disk,
we end up with lost data - the file contains zeros (or NULLs) where
the in memory data previously existed.

Go google for "NULL file data exposure" and you'll see this is a
problem we fixed in ~2006, caused by extending the file size on disk
without first having written all the in-memory data into the file.
And even though we fixed the problem over 15 years ago, we still
hear people today saying "XFS overwrites user data with NULLs!" as
their reason for never using XFS, even though this was never true in
the first place..

The result of users demanding that we prevent poorly written
applications from losing their data is that users get poor
performance when their applications are poorly written. i.e. they do
something that triggers the data integrity ordering constraints that
users demand we work within.

So, how to avoid the problem?

With 'posix_fallocate(fd, total_len, 8192);':

$ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 1
total   200000
fallocate       200000
filewrite       0

real    0m2.557s
user    0m0.025s
sys     0m2.531s
$ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 2
total   200000
fallocate       100000
filewrite       100000

real    0m39.564s
user    0m0.117s
sys     0m7.535s


With 'fallocate(fd, FALLOC_FL_KEEP_SIZE, total_len, 8192);':

$ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 1
total   200000
fallocate       200000
filewrite       0

real    0m2.269s
user    0m0.037s
sys     0m2.233s
$ rm /mnt/scratch/foo ; time ./fwtest /mnt/scratch/foo 2
total   200000
fallocate       100000
filewrite       100000

real    0m1.068s
user    0m0.028s
sys     0m1.040s

Yup, just stop fallocate() from extending the file size and leave
that to the pwrite() call that actually writes the data into the
file.

As it is, using fallocate/pwrite like test does is a well known
anti-pattern:

	error = fallocate(fd, off, len);
	if (error == ENOSPC) {
		/* abort write!!! */
	}
	error = pwrite(fd, off, len);
	ASSERT(error != ENOSPC);
	if (error) {
		/* handle error */
	}

Why does the code need a call to fallocate() here it prevent ENOSPC in the
pwrite() call?

The answer here is that it *doesn't need to use fallocate() here*.
THat is, the fallocate() ENOSPC check before the space is allocated
is exactly the same as the ENOSPC check done in the pwrite() call to
see if there is space for the write to proceed.

IOWs, the fallocate() call is *completely redundant*, yet it is
actively harmful to performance in the short term (as per the
issue in this thread) as well as being harmful for file fragmentation
levels and filesystem longevity because it prevents the filesystem
from optimising away unnecessary allocations. i.e. it defeats
delayed allocation which allows filesystem to combine lots of
small sequential write() calls in a single big contiguous extent
allocation when the data is getting written to disk.

IOWs, using fallocate() in the way described in this test is a sign
of applicaiton developers not understanding what preallocation
actually does and the situations where it actually provides some
kinds of benefit.

i.e. fallocate() is intended to allow applications to preallocate
space in large chunks long before it is needed, and still have it
available when the application actually needs to write to it. e.g.
preallocate 10MB at a time, not have to run fallocate again until the
existing preallocated chunk is entirely used up by the next thousand
8KB writes that extend the file.

Using fallocate() as a replacement for "truncate up before write" is
*not a recommended use*.

> Why does it take so long in the latter case? and are there any
> workaround or configuration changes to deal with it?

Let pwrite() do the file extension because it natively handles data
vs metadata ordering without having to flush data to disk and wait
for it. i.e. do not use fallocate() as if it is ftruncate(). Also,
do not use posix_fallocate() - it gives you no control over how
preallocation is done, use fallocate() directly. And if you must use
fallocate() before a write, use fallocate(fd, FALLOC_FL_KEEP_SIZE,
off, len) so that the file extension is done by the pwrite() to
avoid any metadata/data ordering constraints that might exist with
non-data write related file size changes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
