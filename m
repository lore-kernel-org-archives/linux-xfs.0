Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91633C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 19:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6372074D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 19:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZkb0ejq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHYTrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 15:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHYTre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 15:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598384853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kpNcf7z1kt5bCNe5xLbtO4jyioxa3rzabBYBmt8aO2c=;
        b=ZZkb0ejqL3yIYpzXCOGbb7Ld49JISNUS5Num/Y8N7IkjJnSxo56/eJgwqDWOdyffWP4ZbZ
        C/GoefXOfurD096MwidNyt+INGHv7Hjc8jBiEJlUNJUUM4GUOQy2rhNt3Fxd7mi3WYm44f
        GBa7+kcYH8HJq+IlrJyIM5PvhbrsTj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-PrCzxna_NCSqLNv5WZdDWw-1; Tue, 25 Aug 2020 15:47:30 -0400
X-MC-Unique: PrCzxna_NCSqLNv5WZdDWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C4EAF6C0C;
        Tue, 25 Aug 2020 19:47:27 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77B1B6198E;
        Tue, 25 Aug 2020 19:47:26 +0000 (UTC)
Date:   Tue, 25 Aug 2020 15:47:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alberto Garcia <berto@igalia.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200825194724.GA338144@bfoster>
References: <20200819175300.GA141399@bfoster>
 <w51v9hdultt.fsf@maestria.local.igalia.com>
 <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
 <w51zh6oi4en.fsf@maestria.local.igalia.com>
 <20200821170232.GA220086@bfoster>
 <w51d03evrol.fsf@maestria.local.igalia.com>
 <20200825165415.GB321765@bfoster>
 <w51d03etzj8.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w51d03etzj8.fsf@maestria.local.igalia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 07:18:19PM +0200, Alberto Garcia wrote:
> On Tue 25 Aug 2020 06:54:15 PM CEST, Brian Foster wrote:
> > If I compare this 5m fio test between XFS and ext4 on a couple of my
> > systems (with either no prealloc or full file prealloc), I end up seeing
> > ext4 run slightly faster on my vm and XFS slightly faster on bare metal.
> > Either way, I don't see that huge disparity where ext4 is 5-6 times
> > faster than XFS. Can you describe the test, filesystem and storage in
> > detail where you observe such a discrepancy?
> 
> Here's the test:
> 
> fio --filename=/path/to/file.raw --direct=1 --randrepeat=1 \
>     --eta=always --ioengine=libaio --iodepth=32 --numjobs=1 \
>     --name=test --size=25G --io_limit=25G --ramp_time=0 \
>     --rw=randwrite --bs=4k --runtime=300 --time_based=1
> 

My fio fallocates the entire file by default with this command. Is that
the intent of this particular test? I added --fallocate=none to my test
runs to incorporate the allocation cost in the I/Os.

> The size of the XFS filesystem is 126 GB and it's almost empty, here's
> the xfs_info output:
> 
> meta-data=/dev/vg/test           isize=512    agcount=4, agsize=8248576
> blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1,
>          rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=32994304, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16110, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The size of the ext4 filesystem is 99GB, of which 49GB are free (that
> is, without the file used in this test). The filesystem uses 4KB
> blocks, a 128M journal and these features:
> 
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index
>                           filetype needs_recovery extent flex_bg
>                           sparse_super large_file huge_file uninit_bg
>                           dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> 
> In both cases I'm using LVM on top of LUKS and the hard drive is a
> Samsung SSD 850 PRO 1TB.
> 
> The Linux version is 4.19.132-1 from Debian.
> 

Thanks. I don't have LUKS in the mix on my box, but I was running on a
more recent kernel (Fedora 5.7.15-100). I threw v4.19 on the box and saw
a bit more of a delta between XFS (~14k iops) and ext4 (~24k). The same
test shows ~17k iops for XFS and ~19k iops for ext4 on v5.7. If I
increase the size of the LVM volume from 126G to >1TB, ext4 runs at
roughly the same rate and XFS closes the gap to around ~19k iops as
well. I'm not sure what might have changed since v4.19, but care to see
if this is still an issue on a more recent kernel?

Brian

> Berto
> 

