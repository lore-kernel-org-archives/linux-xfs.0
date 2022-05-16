Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05DAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 13:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiEPNfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 09:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiEPNfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 09:35:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDF942E08B
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 06:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652708120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wnnpf+semmLcUYk8sM6YqLWfuVNlATgzdus4jw8X8mc=;
        b=epX5EW22h1d6jzv4k1TlUJXs7/XjTyh7L88Xt+lOlyJVkn4eHuvhBMKyOwT1iX8iRTvUDW
        f3nqKqh26ZPCs63EAo3NGo7UtR6HfyI9BgWMRaMPXSvCPa8f+VzexmWVSjeb74Typc+U8S
        YglRJrJjucFEmYt3gHIpeF17t4FcfPo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-ULAV8HySMDabDFdJXbWo5Q-1; Mon, 16 May 2022 09:35:18 -0400
X-MC-Unique: ULAV8HySMDabDFdJXbWo5Q-1
Received: by mail-qv1-f70.google.com with SMTP id o99-20020a0c906c000000b00456332167ffso7671754qvo.13
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 06:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wnnpf+semmLcUYk8sM6YqLWfuVNlATgzdus4jw8X8mc=;
        b=iBgOj54T+n61ALBQ4vL7eBPi8RW9bO7cemn6G4noTtth9y82HTiZ96tIdPbwppYpWl
         lowhOTjsxzkJTk4ADSXHMu8BJoau20iF3kD0/+pn6Vl4AMeojbhg3yZ9bbTwaWe0hsLg
         pHAgwB5AzS1UwRjYL+EdJZCjCpWuOFUiVZDnW41Ok89Z9c33fL5khH3G02Y1vEu6QeF5
         nwTvDqdtXC9afuOGem7LK2vKraWwaqcTf0IRUTX1TcALAkElu7NjQAaeeQe1EzVrU9Sf
         KtUS43K72DKuC4xhfKhcEJ+fwmhY8VudD15b7wyV/JUdYpI+PJeaJiCdCyO6YX8xXL45
         oHdA==
X-Gm-Message-State: AOAM530yKOWoo7jzAL292BTlN7Imwy5MakwyMCN6uLSyM0TCExxBGiIH
        cQ+Jf1GYrHyy4Px7W71BahtKe4evHPArulR7WkaTuwf8u8Cs3XyEY/0Gev4FruuAoLh6eMrEJNQ
        3lpo+FQIPfqrdOnG7O7oL
X-Received: by 2002:a05:622a:285:b0:2f3:ddbd:b632 with SMTP id z5-20020a05622a028500b002f3ddbdb632mr15192106qtw.217.1652708117800;
        Mon, 16 May 2022 06:35:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6rKIcahvtTgxHtSha3a3eyTJ5PywnvzaK/kWxoGF+zy7lBfnp3qDuLKo0Bqik4N0Uny5Mjw==
X-Received: by 2002:a05:622a:285:b0:2f3:ddbd:b632 with SMTP id z5-20020a05622a028500b002f3ddbdb632mr15192072qtw.217.1652708117404;
        Mon, 16 May 2022 06:35:17 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r193-20020a37a8ca000000b0069fc13ce1f1sm5800360qke.34.2022.05.16.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:35:17 -0700 (PDT)
Date:   Mon, 16 May 2022 09:35:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <YoJTEgS939eM1OgN@bfoster>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
 <20220510190212.GC27195@magnolia>
 <20220510220523.GU1098723@dread.disaster.area>
 <YnvaT4TGUhb+94bI@bfoster>
 <20220511222401.GK1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511222401.GK1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 12, 2022 at 08:24:01AM +1000, Dave Chinner wrote:
> On Wed, May 11, 2022 at 11:46:23AM -0400, Brian Foster wrote:
> > On Wed, May 11, 2022 at 08:05:23AM +1000, Dave Chinner wrote:
> > > On Tue, May 10, 2022 at 12:02:12PM -0700, Darrick J. Wong wrote:
> > > > On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> > > > > On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > > > > > that series.
> > > > > >
> > > > > > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > > > > > upgrades for any filesystem with logsize < 64MB?
> > > > > 
> > > > > I think that would make a lot of sense. We do need to reduce the upgrade
> > > > > test matrix as much as we can, at least as a starting point.
> > > > > Our customers would have started with at least 1TB fs, so should not
> > > > > have a problem with minimum logsize on upgrade.
> > > > > 
> > > > > BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> > > > > practice of users to start with a small fs and grow it, which is encouraged by
> > > > > Cloud providers pricing model.
> > > > > 
> > > > > I had asked Ted about the option to resize the ext4 journal and he replied
> > > > > that in theory it could be done, because the ext4 journal does not need to be
> > > > > contiguous. He thought that it was not the case for XFS though.
> > > > 
> > > > It's theoretically possible, but I'd bet that making it work reliably
> > > > will be difficult for an infrequent operation.  The old log would probably
> > > > have to clean itself, and then write a single transaction containing
> > > > both the bnobt update to allocate the new log as well as an EFI to erase
> > > > it.  Then you write to the new log a single transaction containing the
> > > > superblock and an EFI to free the old log.  Then you update the primary
> > > > super and force it out to disk, un-quiesce the log, and finish that EFI
> > > > so that the old log gets freed.
> > > > 
> > > > And then you have to go back and find the necessary parts that I missed.
> > > 
> > > The new log transaction to say "the new log is over there" so log
> > > recovery knows that the old log is being replaced and can go find
> > > the new log and recover it to free the old log.
> > > 
> > > IOWs, there's a heap of log recovery work needed, a new
> > > intent/transaction type, futzing with feature bits because old
> > > kernels won't be able to recovery such a operation, etc.
> > > 
> > > Then there's interesting issues that haven't ever been considered,
> > > like having a discontiguity in the LSN as we physically switch logs.
> > > What cycle number does the new log start at? What happens to all the
> > > head and tail tracking fields when we switch to the new log? What
> > > about all the log items in the AIL which is ordered by LSN? What
> > > about all the active log items that track a specific LSN for
> > > recovery integrity purposes (e.g. inode allocation buffers)? What
> > > about updating the reservation grant heads that track log space
> > > usage? Updating all the static size calculations used by the log
> > > code which has to be done before the new log can be written to via
> > > iclogs.
> > > 
...
> 
> > TBH, if one were to go through the trouble of making the log resizeable,
> > I start to wonder whether it's worth starting with a format change that
> > better accommodates future flexibility. For example, the internal log is
> > already AG allocated space.. why not do something like assign it to an
> > internal log inode attached to the sb?  Then the log inode has the
> > obvious capability to allocate or free (non-active log) extents at
> > runtime through all the usual codepaths without disruption because the
> > log itself only cares about a target device, block offset and size. We
> > already know a bump of the log cycle count is sufficient for consistency
> > across a clean mount cycle because repair has been zapping clean logs by
> > default as such since pretty much forever.
> 
> Putting the log in an inode isn't needed for allocate/free of raw
> extents - we already do that with grow/shrink for the tail of an AG.
> Hence I'm not sure what virtually mapping the log actually gains us
> over just a raw extent pointed to by the superblock?
> 

I'm not sure what virtually mapping the log has to do with anything..?
That seems like something to consider for the future if there's value to
it..

> > That potentially reduces log reallocation to a switchover algorithm that
> > could run at mount time. I.e., a new prospective log extent is allocated
> > at runtime (and maybe flagged with an xattr or something). The next
> > mount identifies a new/prospective log, requires/verifies that the old
> > log is clean, selects the new log extent (based on some currently
> > undefined selection algorithm) and seeds it with the appropriate cycle
> > count via synchronous transactions that release any currently inactive
> > extent(s) from the log inode. Any failure along the way sticks with the
> > old log and releases the still inactive new extent, if it happens to
> > exist. We already do this sort of stale resource clean up for other
> > things like unlinked inodes and stale COW blocks, so the general premise
> > exists.. hm?
> 
> That seems like just as much special case infrastructure as a custom
> log record type to run it online, and overall the algorithm isn't
> much different. And the online change doesn't require an on-disk
> format change...
> 

It seems a lot more simple to me, assuming it's viable, but then again I
don't see a clear enough description of what you're comparing against to
reason about it with certainty. I also don't think it necessarily
depends on a format change. I.e., perhaps an online variant could look
something like the following (pseudo algorithm):

1. Userspace growfs feeds in a tmpfile or some such donor inode via
ioctl() that maps the new/prospective log as a data extent. Assume the
extent is ideally sized/allocated and disk content is properly formatted
as a valid log with an elevated cycle count for the purpose of this
sequence.

2. Quiesce the log, freeze the fs, xfs_log_unmount() the active log and
xfs_log_mount() the new range based on the extent mapped by the donor
inode.

3. Commit changes to the new log range to unmap the current extent (i.e.
the new log) from the donor inode and map the old log range, keeping the
in-core inode pinned/locked so it cannot be written back. At this point
the only changes on disk are to the donor's data extent (still mapped by
the inode). The superblock has not been updated, so any crash/recovery
will see the original log in the quiesced state, recover as normal and
process the donor file as an unlinked inode.

(The filesystem at this point has two recoverable logs. The original log
is unmodified since the quiesce and still referenced by the superblock.
It can be recovered in the event of a log switch failure. The new log
still resides in an inode extent mapping, but contains valid log records
to exchange its own extent mapping with the old log range).

4. Sync update the superblock to point at the new log range and unpin
the donor inode. A crash after this point sees the new log in the sb and
recovers the changes to map the old log into the donor inode. The old
log range is returned to free space upon unlinked inode processing of
the donor inode.

I'm not totally sure that works without prototyping some basic form of
it, but it seems generally sane to me. There are a lot of implementation
details to work through as well of course, such as whether the kernel
allocates the prospective log extent before the quiesce (and seeds it),
whether to support the ability to allocate the new in-core log subsystem
before tearing down the old (for more reliable failure handling and so
it can be activated atomically), how to format changes into the new log,
etc. etc., but that's far more detail than this is intended to cover...

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

