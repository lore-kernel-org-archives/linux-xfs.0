Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08CFC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 17:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EB52076C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 17:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="SVrqDkjA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHYRSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 13:18:53 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:38392 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgHYRS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 13:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=NRuZ0LyzRm4DjommZhDcvSlF725dOGlT2jpGRP/6sTE=;
        b=SVrqDkjA5NLym8V/ERjmtPwQdbukrc/bGdB4ViJwrptUP0t2vvDZZ3oaM4NjQMsm3fbNoaEkqyBEdFpMtLlFZe1v9cXuBw4HGJcGZXqLoUh42k0g84pTeAKREk4VgYrWuofXtckK8MDT/t1vMkskcWJQIGiH3DL0Gp2nyRhJLVK4OYAscLWKHAoJ66PHkuKjTAGVo3ptoaplOu9jPDzIybnVPE8oPB1jMb3Vdx+xX1dxOrPPFZnTojsPBp7yfsEpA+uf1MAgo091DN5/wNKAH++smJ97U+kVfM2msiLE2MXgAMMoXT+4ZS4kN5+7pWwCCN/18jtQH70WOE8c/fwpaQ==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1kAcaS-00048N-28; Tue, 25 Aug 2020 19:18:20 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1kAcaR-000403-Ot; Tue, 25 Aug 2020 19:18:19 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <20200825165415.GB321765@bfoster>
References: <w51pn7memr7.fsf@maestria.local.igalia.com> <20200819150711.GE10272@linux.fritz.box> <20200819175300.GA141399@bfoster> <w51v9hdultt.fsf@maestria.local.igalia.com> <20200820215811.GC7941@dread.disaster.area> <20200821110506.GB212879@bfoster> <w51364gjkcj.fsf@maestria.local.igalia.com> <w51zh6oi4en.fsf@maestria.local.igalia.com> <20200821170232.GA220086@bfoster> <w51d03evrol.fsf@maestria.local.igalia.com> <20200825165415.GB321765@bfoster>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Tue, 25 Aug 2020 19:18:19 +0200
Message-ID: <w51d03etzj8.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue 25 Aug 2020 06:54:15 PM CEST, Brian Foster wrote:
> If I compare this 5m fio test between XFS and ext4 on a couple of my
> systems (with either no prealloc or full file prealloc), I end up seeing
> ext4 run slightly faster on my vm and XFS slightly faster on bare metal.
> Either way, I don't see that huge disparity where ext4 is 5-6 times
> faster than XFS. Can you describe the test, filesystem and storage in
> detail where you observe such a discrepancy?

Here's the test:

fio --filename=/path/to/file.raw --direct=1 --randrepeat=1 \
    --eta=always --ioengine=libaio --iodepth=32 --numjobs=1 \
    --name=test --size=25G --io_limit=25G --ramp_time=0 \
    --rw=randwrite --bs=4k --runtime=300 --time_based=1

The size of the XFS filesystem is 126 GB and it's almost empty, here's
the xfs_info output:

meta-data=/dev/vg/test           isize=512    agcount=4, agsize=8248576
blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1,
         rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=32994304, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16110, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The size of the ext4 filesystem is 99GB, of which 49GB are free (that
is, without the file used in this test). The filesystem uses 4KB
blocks, a 128M journal and these features:

Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
                          filetype needs_recovery extent flex_bg
                          sparse_super large_file huge_file uninit_bg
                          dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl

In both cases I'm using LVM on top of LUKS and the hard drive is a
Samsung SSD 850 PRO 1TB.

The Linux version is 4.19.132-1 from Debian.

Berto
