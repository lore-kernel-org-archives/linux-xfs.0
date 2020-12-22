Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA902C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C72D23133
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 13:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgLVNFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 08:05:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726557AbgLVNFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 08:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608642245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQkuILmwlIeMX24ohcb+Gf5miy+iAFU7MB2sZ0XZ2+A=;
        b=a0+y+THRhPGuLkPeVcZa8hWNSesOQOkhqPIjJz+lyq7mhWMvPPdBi4LfGitvo/sv5LhNti
        0n1D7e6grcfEkNebOJWHyRKfFn6u/OmdNCw+ux0ito3HDZehSh0QJI/FNrsAoqA87D00m+
        DutZXfZglcjK+jnkoxDiEPgL/08qJ+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-iKu5nKHCNsSC8cIhFrjXig-1; Tue, 22 Dec 2020 08:04:02 -0500
X-MC-Unique: iKu5nKHCNsSC8cIhFrjXig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98D29800D53;
        Tue, 22 Dec 2020 13:04:01 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35EC45D6A8;
        Tue, 22 Dec 2020 13:04:01 +0000 (UTC)
Date:   Tue, 22 Dec 2020 08:03:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Extreme fragmentation ho!
Message-ID: <20201222130359.GA2805699@bfoster>
References: <20201221215453.GA1886598@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221215453.GA1886598@onthe.net.au>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 22, 2020 at 08:54:53AM +1100, Chris Dunlop wrote:
> Hi,
> 
> I have a 2T file fragmented into 841891 randomly placed extents. It takes
> 4-6 minutes (depending on what else the filesystem is doing) to delete the
> file. This is causing a timeout in the application doing the removal, and
> hilarity ensues.
> 
> The fragmentation is the result of reflinking bits and bobs from other files
> into the subject file, so it's probably unavoidable.
> 
> The file is sitting on XFS on LV on a raid6 comprising 6 x 5400 RPM HDD:
> 
> # xfs_info /home
> meta-data=/dev/mapper/vg00-home  isize=512    agcount=32, agsize=244184192 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1
> data     =                       bsize=4096   blocks=7813893120, imaxpct=5
>          =                       sunit=128    swidth=512 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> I'm guessing the time taken to remove is not unreasonable given the speed of
> the underlying storage and the amount of metadata involved. Does my guess
> seem correct?
> 
> I'd like to do some experimentation with a facsimile of this file, e.g.  try
> the remove on different storage subsystems, and/or with a external fast
> journal etc., to see how they compare.
> 
> What is the easiest way to recreate a similarly (or even better,
> identically) fragmented file?
> 
> One way would be to use xfs_metadump / xfs_mdrestore to create an entire
> copy of the original filesystem, but I'd really prefer not taking the
> original fs offline for the time required. I also don't have the space to
> restore the whole fs but perhaps using lvmthin can address the restore
> issue, at the cost of a slight(?) performance impact due to the extra layer.
> 

Note that xfs_metadump doesn't include file data, only metadata, so it
might actually be the most time and space efficient way to replicate the
large file. You would need a similarly sized block device to restore to
and would not be able to change filesystem geometry and whatnot. The
former can be easily worked around by restoring the image to a file on a
smaller fs though, which may or may not interfere with whatever
performance testing you're doing.

> Is it possible to using the output of xfs_bmap on the original file to drive
> ...something, maybe xfs_io, to recreate the fragmentation? A naive test
> using xfs_io pwrite didn't produce any fragmentation - unsurprisingly, given
> the effort XFS puts into reducing fragmentation.
> 

fstests has a helper program (xfstests-dev/src/punch-alternating) that
helps create fragmented files. IIRC, you create a fully allocated file
in advance and it will punch out alternating ranges based on the
offset/size parameters. You might have to wait a bit for it to complete,
but it's pretty easy to use (and you can always create a metadump image
from the result for quicker restoration).

Yet another option might be to try a write workload that attempts to
defeat the allocator heuristics. For example, do direct I/O or falloc
requests in reverse order and in small sizes across a file. xfs_io has a
couple flags you can pass to pwrite (i.e., -B, -R) to make that easier,
but that's more manual and you may have to play around with it to get
the behavior you want.

Brian

> Cheers,
> 
> Chris
> 

