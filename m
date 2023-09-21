Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3844EE7D0A1
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 23:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjIUXTA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 19:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIUXS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 19:18:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E888F
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 16:18:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-274b3d48e15so1028119a91.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 16:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695338333; x=1695943133; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DD5Hqm2z0U655+27X+hRazrVb9nI1/DEkVjDP8wx9t8=;
        b=QoYMGnSVZFZkHI8snSByQg4xkR/WB34qFcEV8wu0R78li2ZDA/toqoLxwp44qYDaQe
         J4eL2r5SFa2PqlQukwnqOQxVbR4JHmwkYMoVnpD0JFten+kuPgyTeF3fcBRX5ISUxsCz
         qEj5AN1a2TPPm//ei3Cy/0VglpUWxL+/PS504vVtFVhkOU7tepfm+2UuyhcryvgWYjuf
         atzUZLtmrFnBzlbvGk50di4vFR0KdeIdwhEUEoBnIT1lqc8Ojz+se+b5dQYB88mw4hyd
         GD37jaVQueW9UYxcW39AT1sojKbHqcQRk8m6QqE6dj+YbcMGp9BlTaGE6GgdAvtSeuxI
         sbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695338333; x=1695943133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DD5Hqm2z0U655+27X+hRazrVb9nI1/DEkVjDP8wx9t8=;
        b=BIAwRClHpxL61ZuKR9DbHEPTHAQE50xdaj+BAUDLvca+8qqJnolmn2soexhLQNgJPi
         fmlrcgiH1NXF519nH/gRACGfK1MaAyuEupCecuRSRvhO1GyNG7+0VuEBnnjOcGeKhODV
         2gVhp94f4BEKe+YDlPLWa1WNUsdGn8gW1+ZRkGX7+jqnLBEW9bcABYD3ORJBLg5FEUw4
         yTeuWf7RKW5pyGwJtKhX83tHFLEaiW8QiHql5HDPsWbXdquOfPW2p7Us0weAxbeFjFut
         J+Oqc78XqnKmR0nL6bs2N/JFFpzHxySdrNsbOS5Pv4XM3L94Q46DE+4GYYdN87lS86i4
         ddog==
X-Gm-Message-State: AOJu0YyQlLt9U4rDvE34ifW1ZeBI4ORaJtltq/MCMBJ4HMUWZzrPBzKL
        BbfJw3wYL/TtKZHnH59Z61c9aUofF0JWcAbw4qs=
X-Google-Smtp-Source: AGHT+IHkRx0hMlezuD0Y/bWOEchRRXao0AimvfxtBMwYqGlNW60Mkbc0Um/p2HH7V9Uv8vPaCdAuVA==
X-Received: by 2002:a17:90a:514e:b0:276:7e50:a497 with SMTP id k14-20020a17090a514e00b002767e50a497mr6425165pjm.42.1695338332605;
        Thu, 21 Sep 2023 16:18:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 14-20020a17090a004e00b0025dc5749b4csm3970633pjb.21.2023.09.21.16.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 16:18:52 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qjSwa-003rHw-23;
        Fri, 22 Sep 2023 09:18:48 +1000
Date:   Fri, 22 Sep 2023 09:18:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <ZQzPWJ/iojT0Vumi@dread.disaster.area>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
 <ZQk23NIAcY0BDpfI@dread.disaster.area>
 <20230920000058.GF348037@frogsfrogsfrogs>
 <ZQpF2bRLN3lQk1j1@dread.disaster.area>
 <20230921222628.GF11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921222628.GF11391@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 03:26:28PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 20, 2023 at 11:07:37AM +1000, Dave Chinner wrote:
> > On Tue, Sep 19, 2023 at 05:00:58PM -0700, Darrick J. Wong wrote:
> > > On Tue, Sep 19, 2023 at 03:51:24PM +1000, Dave Chinner wrote:
> > > > On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> > > > The XFS clone implementation takes the IOLOCK_EXCL high up, and
> > > > then lower down it iterates one extent doing the sharing operation.
> > > > It holds the ILOCK_EXCL while it is modifying the extent in both the
> > > > source and destination files, then commits the transaction and drops
> > > > the ILOCKs.
> > > > 
> > > > OK, so we have fine-grained ILOCK serialisation during the clone for
> > > > access/modification to the extent list. Excellent, I think we can
> > > > make this work.
> > > > 
> > > > So:
> > > > 
> > > > 1. take IOLOCK_EXCL like we already do on the source and destination
> > > > files.
> > > > 
> > > > 2. Once all the pre work is done, set a "clone in progress" flag on
> > > > the in-memory source inode.
> > > > 
> > > > 3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.
> > > > 
> > > > 4. read IO and the clone serialise access to the extent list via the
> > > > ILOCK. We know this works fine, because that's how the extent list
> > > > access serialisation for concurrent read and write direct IO works.
> > > > 
> > > > 5. buffered writes take the IOLOCK_EXCL, so they block until the
> > > > clone completes. Same behaviour as right now, all good.
> > > 
> > > I think pnfs layouts and DAX writes also take IOLOCK_EXCL, right?  So
> > > once reflink breaks the layouts, we're good there too?
> > 
> > I think so.
> > 
> > <looks to confirm>
> > 
> > The pnfs code in xfs_fs_map_blocks() will reject mappings on any
> > inode marked with shared extents, so I think the fact that we
> > set the inode as having shared extents before we finish
> > xfs_reflink_remap_prep() will cause pnfs mappings to kick out before
> > we even take the IOLOCK.
> > 
> > But, regardless of that, both new PNFS mappings and DAX writes use
> > IOLOCK_EXCL, and xfs_ilock2_io_mmap() breaks both PNFS and DAX
> > layouts which will force them to finish what they are doing and sync
> > data before the clone operation grabs the IOLOCK_EXCL. They'll block
> > on the clone holding the IOLOCK from that point onwards, so I think
> > we're good here.
> > 
> > hmmmmm.
> > 
> > <notes that xfs_ilock2_io_mmap() calls filemap_invalidate_lock_two()>
> > 
> > Sigh.
> > 
> > That will block buffered reads trying to instantiate new pages
> > in the page cache. However, this isn't why the invalidate lock is
> > held - that's being held to lock out lock page faults (i.e. mmap()
> > access) whilst the clone is running.
> > 
> > 
> > We really only need to lock out mmap writes, and the only way to do
> > that is to prevent write faults from making progress whilst the
> > clone is running.
> > 
> > __xfs_filemap_fault() currently takes XFS_MMAPLOCK_SHARED for write
> > faults - I think we need it to look at the "clone in progress" flag
> > for write faults, too, and use XFS_MMAPLOCK_EXCL in that case.
> > 
> > That would then allow us to demote the invalidate lock on the source
> > file the same way we do the IOLOCK, allowing buffered reads to
> > populate the page caceh but have write faults block until the clone
> > completes (as they do now, same as writes).
> > 
> > Is there anything else I missed?
> 
> I think that's it.  I'd wondered how much we really care about reflink
> stalling read faults, but yeah, let's fix both.

Well, it's not so much about mmap as the fact that holding
invalidate lock exclusive prevents adding or removing folios to the
page cache from any path. Hence the change as I originally proposed
would block the buffered read path trying to add pages to the page
cache the same as it will block the read fault path....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
