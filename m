Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9895CC433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CFC62076D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 15:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbhADPHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:07:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbhADPHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 10:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609772766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMYUBSK+6oQZKl/wM9+GaY+0BWTQhAgpsoYND+HSpqE=;
        b=fK2/vw1ge4sfDszU5OoNfh3J6GMRQtQAH34hlgT0XBIBjT8EtTCyqxuD+k4DPoX9l4l9hQ
        SqR4drWDZK9pNKGNLOdUHziKiaYXVQIQTMkx8WkLWPbxojQmleWAmxThpNFOBZnykJ8egR
        WpD6oyOL3YsZZOARppprJPX4i605iRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-I7T50w99N923t7iIfG14nw-1; Mon, 04 Jan 2021 10:06:05 -0500
X-MC-Unique: I7T50w99N923t7iIfG14nw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 036B11005504;
        Mon,  4 Jan 2021 15:06:04 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 994885D751;
        Mon,  4 Jan 2021 15:06:03 +0000 (UTC)
Date:   Mon, 4 Jan 2021 10:06:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Avi Kivity <avi@scylladb.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Disk aligned (but not block aligned) DIO write woes
Message-ID: <20210104150601.GA130750@bfoster>
References: <20ce6a14-94cf-c8ef-8219-7a051fb6e66a@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ce6a14-94cf-c8ef-8219-7a051fb6e66a@scylladb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 28, 2020 at 05:57:29PM +0200, Avi Kivity wrote:
> I observe that XFS takes an exclusive lock for DIO writes that are not block
> aligned:
> 
> 
> xfs_file_dio_aio_write(
> 
> {
> 
> ...
> 
>        /*
>          * Don't take the exclusive iolock here unless the I/O is unaligned
> to
>          * the file system block size.  We don't need to consider the EOF
>          * extension case here because xfs_file_aio_write_checks() will
> relock
>          * the inode as necessary for EOF zeroing cases and fill out the new
>          * inode size as appropriate.
>          */
>         if ((iocb->ki_pos & mp->m_blockmask) ||
>             ((iocb->ki_pos + count) & mp->m_blockmask)) {
>                 unaligned_io = 1;
> 
>                 /*
>                  * We can't properly handle unaligned direct I/O to reflink
>                  * files yet, as we can't unshare a partial block.
>                  */
>                 if (xfs_is_cow_inode(ip)) {
>                         trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos,
> count);
>                         return -ENOTBLK;
>                 }
>                 iolock = XFS_IOLOCK_EXCL;
>         } else {
>                 iolock = XFS_IOLOCK_SHARED;
>         }
> 
> 
> I also see that such writes cause io_submit to block, even if they hit a
> written extent (and are also not size-changing, by implication) and
> therefore do not require a metadata write. Probably due to "|| unaligned_io"
> in
> 
> 
>         ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
>                            &xfs_dio_write_ops,
>                            is_sync_kiocb(iocb) || unaligned_io);
> 
> 
> Can this be relaxed to allow writes to written extents to proceed in
> parallel? I explain the motivation below.
> 

From the above code, it looks as though we require the exclusive lock to
accommodate sub-block zeroing that might occur down in the dio code.
Without it, concurrent sector granular I/Os to the same block could
presumably cause corruption if the data bios and associated zeroing bios
were reordered between two requests.

Looking down in the iomap/dio code, iomap_dio_bio_actor() triggers
sub-block zeroing if the associated range is unaligned and the mapping
is either unwritten or new (i.e. newly allocated for this write). So as
you note above, there is no such zeroing for a pre-existing written
block within EOF. From that, it seems reasonable to me that in principle
the filesystem could check for these conditions in the higher layer and
further restrict usage of the exclusive lock. That said, we'd probably
have to rework the above code to acquire the shared lock first,
read/check the extent state for the start/end blocks of the I/O and then
cycle out to the exclusive lock in the cases where it is required. It's
not immediately clear to me if we'd still want to set the wait flag in
those unaligned-but-no-zeroing cases. Perhaps somebody who knows the dio
code a bit better can chime in further on all of this..

Brian

> 
> My thinking (from a position of blissful ignorance) is that if the extent is
> already written, then no metadata changes and block zeroing are needed. If
> we can detect that favorable conditions exists (perhaps with the extra
> constraint that the mapping be already cached), then we can handle this
> particular case asynchronously.
> 
> 
> My motivation is a database commit log. NVMe drives can serve small writes
> with ridiculously low latency - around 20 microseconds. Let's say a
> commitlog entry is around 100 bytes; we fill a 4k block with 41 entries. To
> achieve that in 20 microseconds requires 2 million records/sec. Even if we
> add artificial delay and commit every 1ms, filling this 4k block require
> 41,000 commits/sec. If the entry write rate is lower, then we will be forced
> to pad the rest of the block. This increases the write amplification,
> impacting other activities using the disk (such as reads).
> 
> 
> 41,000 commits/sec may not sound like much, but in a thread-per-core design
> (where each core commits independently) this translates to millions of
> commits per second for the entire machine. If the real throughput is below
> that, then we are forced to either increase the latency to collect more
> writes into a full block, or we have to tolerate the increased write
> amplification.
> 
> 

