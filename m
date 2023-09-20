Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB4BCE79A8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Sep 2023 01:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjITBHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjITBHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 21:07:46 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA159B3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 18:07:40 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1c1e3a4a06fso50079295ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 18:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695172060; x=1695776860; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GxyH5N/b2miRd+U7J4tiePDIcwN6nLcu4WrsIulPOMo=;
        b=N/Q3JhvCSbLssmXgCxeJE50UsLLcq8mWMGA7lMXgxwXxZ+vNYhMozZCVwoQ05DAKTj
         l/wjmCzfnouG614oMYmNSOc6S7uYkpSYo2LA2Vkc8+KOtKI5UbLML07Lg65ZwR6UQts7
         a22Ceea7Jf7QPUhrlTJ1WPGrprZZNQvQCrqvXmbS8xBWBXmptVignaEVqV6GqPje1dVt
         rOMG8yZTtOy7aIaj+4wYvZFO/I1No1CWRzxZWfa+KpLXIt9iEUtZglm/dmKscw6I3Ld+
         t1uUM6UlX+F2063QhKdZE/bSLqr4jeAFF29GrSxu0nMFRGHug/Autbhr/0dSs7RJor6G
         az+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695172060; x=1695776860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxyH5N/b2miRd+U7J4tiePDIcwN6nLcu4WrsIulPOMo=;
        b=pf/MVgVvohYXrZflLlIxJ7EWWMhHAy/jA0RMUNr/tQ04X47acjTQWvO3mnKDXGE9pK
         yaDTBfnHwu1SiMAeq2sZyrUcqZ4nieHbtv8+B/1FRw5o1WGWeqT4XyFsn/6uS3X+oc2H
         rmYYogqOTEyNGqVymbB4PpQFMNSJSOVQmTjqRpHeeyBZqM2J42vn8lULWftA/SKuMnEL
         BUzYCFqdwpCSj0Lc9zenMpueEAqgX9RiCcpc9T+1xiRrOOdJTTD+0j9jBLI/6dAZyfn5
         fzBM7VLpN2eAavvwnzSyOmVN1rNK641UAfBb4bLtz0G5LEl66oaWAtB27+l50BJKiK42
         +Q7g==
X-Gm-Message-State: AOJu0YyH0GoqaB1YNPc8bG7+JaqNN2dkeCWzV94jGYU5P3ijH5tTbUCf
        J77paYELjEZt+UXY+1swUtThaw==
X-Google-Smtp-Source: AGHT+IFpQJMo9/VYjqogsTu5zDXtAtqVjkYndEQ58AHHkz+GFd0XMgbB8JTQV9IuXC/cTR6miGM23w==
X-Received: by 2002:a17:903:41c5:b0:1c3:eb43:65bf with SMTP id u5-20020a17090341c500b001c3eb4365bfmr1219382ple.32.1695172060186;
        Tue, 19 Sep 2023 18:07:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902ced100b001b8b26fa6c1sm10577333plg.115.2023.09.19.18.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 18:07:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qilgn-0031A1-1M;
        Wed, 20 Sep 2023 11:07:37 +1000
Date:   Wed, 20 Sep 2023 11:07:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <ZQpF2bRLN3lQk1j1@dread.disaster.area>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
 <20230920000058.GF348037@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920000058.GF348037@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 19, 2023 at 05:00:58PM -0700, Darrick J. Wong wrote:
> On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
> > On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> > The XFS clone implementation takes the IOLOCK_EXCL high up, and
> > then lower down it iterates one extent doing the sharing operation.
> > It holds the ILOCK_EXCL while it is modifying the extent in both the
> > source and destination files, then commits the transaction and drops
> > the ILOCKs.
> > 
> > OK, so we have fine-grained ILOCK serialisation during the clone for
> > access/modification to the extent list. Excellent, I think we can
> > make this work.
> > 
> > So:
> > 
> > 1. take IOLOCK_EXCL like we already do on the source and destination
> > files.
> > 
> > 2. Once all the pre work is done, set a "clone in progress" flag on
> > the in-memory source inode.
> > 
> > 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
> > 
> > 4. read IO and the clone serialise access to the extent list via the
> > ILOCK. We know this works fine, because that's how the extent list
> > access serialisation for concurrent read and write direct IO works.
> > 
> > 5. buffered writes take the IOLOCK_EXCL, so they block until the
> > clone completes. Same behaviour as right now, all good.
> 
> I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
> once reflink breaks the layouts, we're good there too?

I think so.

<looks to confirm>

The pnfs code in xfs_fs_map_blocks() will reject mappings on any
inode marked with shared extents, so I think the fact that we
set the inode as having shared extents before we finish
xfs_reflink_remap_prep() will cause pnfs mappings to kick out before
we even take the IOLOCK.

But, regardless of that, both new PNFS mappings and DAX writes use
IOLOCK_EXCL, and xfs_ilock2_io_mmap() breaks both PNFS and DAX
layouts which will force them to finish what they are doing and sync
data before the clone operation grabs the IOLOCK_EXCL. They'll block
on the clone holding the IOLOCK from that point onwards, so I think
we're good here.

hmmmmm.

<notes that xfs_ilock2_io_mmap() calls filemap_invalidate_lock_two()>

Sigh.

That will block buffered reads trying to instantiate new pages
in the page cache. However, this isn't why the invalidate lock is
held - that's being held to lock out lock page faults (i.e. mmap()
access) whilst the clone is running.


We really only need to lock out mmap writes, and the only way to do
that is to prevent write faults from making progress whilst the
clone is running.

__xfs_filemap_fault() currently takes XFS_MMAPLOCK_SHARED for write
faults - I think we need it to look at the "clone in progress" flag
for write faults, too, and use XFS_MMAPLOCK_EXCL in that case.

That would then allow us to demote the invalidate lock on the source
file the same way we do the IOLOCK, allowing buffered reads to
populate the page caceh but have write faults block until the clone
completes (as they do now, same as writes).

Is there anything else I missed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
