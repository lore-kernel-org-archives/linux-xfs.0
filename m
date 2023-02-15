Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5578EC636D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 15:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjBOPZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Feb 2023 10:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBOPZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2023 10:25:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6B87ED4
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 07:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676474662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wAeLZpnvbBTbG9UK4p7CfJycgCdx8xYVG+XrnN4Ol4w=;
        b=NS64J2OTQ8uukU6kXK9Q/u+2sG3TkG3i7+yYGK3oOdkCfnh4g34EfEEt3Yv98st4i8UCFy
        Ca0DaHmgREJelipev44ldfeybxF/A9Gdn81QH6JkHYeCwkg5XE4qgLN8rUdPtPbK4RI1At
        b7IgeqScNRiJuG0z7dBgzvAqDHqM7To=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-Mkfo-u8IPNazfj6CaBdv2A-1; Wed, 15 Feb 2023 10:24:21 -0500
X-MC-Unique: Mkfo-u8IPNazfj6CaBdv2A-1
Received: by mail-qv1-f70.google.com with SMTP id r10-20020a0562140c8a00b0056ed45f262dso2271290qvr.11
        for <linux-xfs@vger.kernel.org>; Wed, 15 Feb 2023 07:24:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAeLZpnvbBTbG9UK4p7CfJycgCdx8xYVG+XrnN4Ol4w=;
        b=F1Z390jrEle9ubJGmI4d+wkszYyrkiTxucUCBaHw3IcaAKfHXsxzxnLVP3STtuPsCp
         IHIT+r97m/vnUC51SDa1whaV9oihU7bxROseDEnxcWxOEFdC1aSVcqhHjJ2wr4xGNWNw
         H03Dzj5N/ylyDd5HgS4r3VMgbbh1SiZRsY12FpXNfvrniRWGT7CzD0NWY+aHqwgL6jSy
         1mW9UQ73k6gUPbTp7MhZE/O7nJ+kyXaXmQ85AfB+oqR4cCOH9x8yViS2zN48gWVI3gKS
         p8o0HNRSce68zJmJbDXrXHzdrRk/suOlTAbQ2EuX/MqA5t0sdMW6pfR3uN3RJa+rib9Z
         Bb+Q==
X-Gm-Message-State: AO0yUKWZVoZn+UIr58tvU+Zly6Y3FB182VpgfqFOtWJx1DoxcJAULpki
        +QkCrixoJWF1n8stsG5ZbDz3CQUWEv31huSNIk2g+t3Z32RncJ5gZPEtmoh8DjuHauFkWv8KAyr
        rIxDFPNK85Y+9mArLDG99Tn+Z3Q==
X-Received: by 2002:ac8:5b0e:0:b0:3b8:26a7:d608 with SMTP id m14-20020ac85b0e000000b003b826a7d608mr4258921qtw.19.1676474659967;
        Wed, 15 Feb 2023 07:24:19 -0800 (PST)
X-Google-Smtp-Source: AK7set9cq5qRo7+/1KURcl860wG7sIh1sXZLj4Eu0y8tJzwUfDL42dPmrxOszI5mu/nB139yMNLbOQ==
X-Received: by 2002:ac8:5b0e:0:b0:3b8:26a7:d608 with SMTP id m14-20020ac85b0e000000b003b826a7d608mr4258891qtw.19.1676474659675;
        Wed, 15 Feb 2023 07:24:19 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r129-20020a37a887000000b006cec8001bf4sm14225021qke.26.2023.02.15.07.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 07:24:19 -0800 (PST)
Date:   Wed, 15 Feb 2023 10:25:43 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs, iomap: ->discard_folio() is broken so remove it
Message-ID: <Y+z5d5QBeRg3dHVL@bfoster>
References: <20230214055114.4141947-1-david@fromorbit.com>
 <20230214055114.4141947-4-david@fromorbit.com>
 <Y+vOfaxIWX1c/yy9@bfoster>
 <20230214222000.GL360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214222000.GL360264@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 15, 2023 at 09:20:00AM +1100, Dave Chinner wrote:
> On Tue, Feb 14, 2023 at 01:10:05PM -0500, Brian Foster wrote:
> > On Tue, Feb 14, 2023 at 04:51:14PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Ever since commit e9c3a8e820ed ("iomap: don't invalidate folios
> > > after writeback errors") XFS and iomap have been retaining dirty
> > > folios in memory after a writeback error. XFS no longer invalidates
> > > the folio, and iomap no longer clears the folio uptodate state.
> > > 
> > > However, iomap is still been calling ->discard_folio on error, and
> > > XFS is still punching the delayed allocation range backing the dirty
> > > folio.
> > > 
> > > This is incorrect behaviour. The folio remains dirty and up to date,
> > > meaning that another writeback will be attempted in the near future.
> > > THis means that XFS is still going to have to allocate space for it
> > > during writeback, and that means it still needs to have a delayed
> > > allocation reservation and extent backing the dirty folio.
> > > 
> > 
> > Hmm.. I don't think that is correct. It looks like the previous patch
> > removes the invalidation, but writeback clears the dirty bit before
> > calling into the fs and we're not doing anything to redirty the folio,
> > so there's no guarantee of subsequent writeback.
> 
> Ah, right, I got confused with iomap_do_writepage() which redirties
> folios it performs no action on. The case that is being tripped here
> is "count == 0" which means no action has actually been taken on the
> folio and it is not submitted for writeback. We don't mark the folio
> with an error on submission failure like we do for errors reported
> to IO completion, so the folio is just left in it's current state
> in the cache.
> 
> > Regardless, I can see how this prevents this sort of error in the
> > scenario where writeback fails due to corruption, but I don't see how it
> > doesn't just break error handling of writeback failures not associated
> > with corruption.
> 
> What other cases in XFS do we have that cause mapping failure? We
> can't get ENOSPC here because of delalloc reservations. We can't get
> ENOMEM because all the memory allocations are blocking. That just
> leaves IO errors reading metadata, or structure corruption when
> parsing and modifying on-disk metadata.  I can't think (off the top
> of my head) of any other type of error we can get returned from
> allocation - what sort of non-corruption errors were you thinking
> of here?
> 
> > fails due to some random/transient error, delalloc is left around on a
> > !dirty page (i.e. stale), and reclaim eventually comes around and
> > results in the usual block accounting corruption associated with stale
> > delalloc blocks.
> 
> The first patches in the series fix those issues. If we get stray
> delalloc extents on a healthy inode, then it will still trigger all
> the warnings/asserts that we have now. But if the inode has been
> marked sick by a corruption based allocation failure, it will clean
> up in reclaim without leaking anything or throwing any new warnings.
> 

Those warnings/asserts that exist now indicate something is wrong and
that free space accounting is likely about to become corrupted, because
an otherwise clean inode is being reclaimed with stale delalloc blocks.

I see there's an error injection knob (XFS_ERRTAG_REDUCE_MAX_IEXTENTS)
tied to the max extent count checking stuff in the delalloc conversion
path. You should be able to add some (10+) extents to a file and then
turn that thing all the way up to induce a (delalloc conversion)
writeback failure and see exactly what I'm talking about [1].

Brian

[1] The following occurs with this patch, but not on mainline because the
purpose of ->discard_folio() is to prevent it.

(/mnt/file has 10+ preexisting extents beyond the 0-5k range)

# echo 1 > /sys/fs/xfs/vdb1/errortag/reduce_max_iextents
# xfs_io -fc "pwrite 0 5k" -c fsync /mnt/file
wrote 5120/5120 bytes at offset 0
5 KiB, 5 ops; 0.0000 sec (52.503 MiB/sec and 53763.4409 ops/sec)
fsync: File too large
# umount /mnt/
#
Message from syslogd@localhost at Feb 15 09:47:41 ...                                                                                                           kernel:XFS: Assertion failed: 0, file: fs/xfs/xfs_icache.c, line: 1818

Message from syslogd@localhost at Feb 15 09:47:41 ...
 kernel:XFS: Assertion failed: xfs_is_shutdown(mp) || percpu_counter_sum(&mp->m_delalloc_blks) == 0, file: fs/xfs/xfs_super.c, line: 1068
#
# xfs_repair -n /dev/vdb1 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
sb_fdblocks 20960174, counted 20960186
...

> > This is easy enough to test/reproduce (just tried it
> > via error injection to delalloc conversion) that I'm kind of surprised
> > fstests doesn't uncover it. :/
> 
> > > Failure to retain the delalloc extent (because xfs_discard_folio()
> > > punched it out) means that the next writeback attempt does not find
> > > an extent over the range of the write in ->map_blocks(), and
> > > xfs_map_blocks() triggers a WARN_ON() because it should never land
> > > in a hole for a data fork writeback request. This looks like:
> > > 
> > 
> > I'm not sure this warning makes a lot of sense either given most of this
> > should occur around the folio lock. Looking back at the code and the
> > error report for this, the same error injection used above on a 5k write
> > to a bsize=1k fs actually shows the punch remove fsb offsets 0-5 on a
> > writeback failure, so it does appear to be punching too much out.  The
> > cause appears to be that the end offset is calculated in
> > xfs_discard_folio() by rounding up the start offset to 4k (folio size).
> > If pos == 0, this results in passing end_fsb == 0 to the punch code,
> > which xfs_iext_lookup_extent_before() then changes to fsb == 5 because
> > that's the last block of the delalloc extent that covers fsb 0.
> 
> And that is the bug I could not see in commit 7348b322332d ("xfs:
> xfs_bmap_punch_delalloc_range() should take a byte range") which is
> what this warning was bisected down to. Thank you for identifying
> the reason the bisect landed on that commit. Have you written a
> fix to test out you reasoning that you can post?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

