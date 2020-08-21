Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34607C433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 16:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1074920855
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 16:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="NpdT7OOv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHUQJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 12:09:27 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:34150 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgHUQJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 12:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=HKTMsNp5hdfddF2CMEl3UvWb/KifxWfDDcTpl5rgRVU=;
        b=NpdT7OOv3uSjYlG0n1d1NqLGxmDh4/0absUWX1et7DLHJdDyuluOh+MJwNjZkuF+Y5Wv0hNlrO9LIKCMmtw0tyFG7s5IQBPdxuFnz4dQ7kWYZYkHsBFkHKowhJYtvo/Rdr8u0OFsvvfhFwWUDmit3p+QtShaJLkHY75y9LGwzUrS8W3OcjuVO6SopYMo1BztZ6yjGKREIDbDv1krY2oVZigi3tw0BSLVMQjTa39f7Q9+Dtcoeb1N3km3R36sGbQjA8dXKtM58EKN5NVxyrs0zmdi30hHE5PeaSUPl0KNuoAc2HRPC9nlMPbT7WMHm8bA6ti6gUQVhfANvnyuN86SfA==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1k99bR-0000ar-GM; Fri, 21 Aug 2020 18:09:17 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1k99bR-0002JJ-6v; Fri, 21 Aug 2020 18:09:17 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org,
        Max Reitz <mreitz@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <20200820215811.GC7941@dread.disaster.area>
References: <cover.1597416317.git.berto@igalia.com> <20200817101019.GD11402@linux.fritz.box> <w518sedz3td.fsf@maestria.local.igalia.com> <20200817155307.GS11402@linux.fritz.box> <w51pn7memr7.fsf@maestria.local.igalia.com> <20200819150711.GE10272@linux.fritz.box> <20200819175300.GA141399@bfoster> <w51v9hdultt.fsf@maestria.local.igalia.com> <20200820215811.GC7941@dread.disaster.area>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Fri, 21 Aug 2020 18:09:17 +0200
Message-ID: <w51pn7khtg2.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu 20 Aug 2020 11:58:11 PM CEST, Dave Chinner wrote:
>> The virtual drive (/dev/vdb) is a freshly created qcow2 file stored on
>> the host (on an xfs or ext4 filesystem as the table above shows), and
>> it is attached to QEMU using a virtio-blk-pci device:
>> 
>>    -drive if=virtio,file=image.qcow2,cache=none,l2-cache-size=200M
>
> You're not using AIO on this image file, so it can't do
> concurrent IO? what happens when you add "aio=native" to this?

I sent the results on a reply to Brian.

>> cache=none means that the image is opened with O_DIRECT and
>> l2-cache-size is large enough so QEMU is able to cache all the
>> relevant qcow2 metadata in memory.
>
> What happens when you just use a sparse file (i.e. a raw image) with
> aio=native instead of using qcow2? XFS, ext4, btrfs, etc all support
> sparse files so using qcow2 to provide sparse image file support is
> largely an unnecessary layer of indirection and overhead...
>
> And with XFS, you don't need qcow2 for snapshots either because you
> can use reflink copies to take an atomic copy-on-write snapshot of the
> raw image file... (assuming you made the xfs filesystem with reflink
> support (which is the TOT default now)).

To be clear, I'm not trying to advocate for or against qcow2 on xfs, we
were just analyzing different allocation strategies for qcow2 and we
came across these results which we don't quite understand.

>> 1) off: for every write request QEMU initializes the cluster (64KB)
>>         with fallocate(ZERO_RANGE) and then writes the 4KB of data.
>> 
>> 2) off w/o ZERO_RANGE: QEMU writes the 4KB of data and fills the rest
>>         of the cluster with zeroes.
>> 
>> 3) metadata: all clusters were allocated when the image was created
>>         but they are sparse, QEMU only writes the 4KB of data.
>> 
>> 4) falloc: all clusters were allocated with fallocate() when the image
>>         was created, QEMU only writes 4KB of data.
>> 
>> 5) full: all clusters were allocated by writing zeroes to all of them
>>         when the image was created, QEMU only writes 4KB of data.
>> 
>> As I said in a previous message I'm not familiar with xfs, but the
>> parts that I don't understand are
>> 
>>    - Why is (4) slower than (1)?
>
> Because fallocate() is a full IO serialisation barrier at the
> filesystem level. If you do:
>
> fallocate(whole file)
> <IO>
> <IO>
> <IO>
> .....
>
> The IO can run concurrent and does not serialise against anything in
> the filesysetm except unwritten extent conversions at IO completion
> (see answer to next question!)
>
> However, if you just use (4) you get:
>
> falloc(64k)
>   <wait for inflight IO to complete>
>   <allocates 64k as unwritten>
> <4k io>
>   ....
> falloc(64k)
>   <wait for inflight IO to complete>
>   ....
>   <4k IO completes, converts 4k to written>
>   <allocates 64k as unwritten>
> <4k io>

I think Brian pointed it out already, but scenario (4) is rather
falloc(25GB), then QEMU is launched and the actual 4k IO requests start
to happen.

So I would expect that after falloc(25GB) all clusters are initialized
and the end result would be closer to a full preallocation (i.e. writing
25GB worth of zeroes to disk).

> IOWs, typical "write once" benchmark testing indicates the *worst*
> performance you are going to see. As the guest filesytsem ages and
> initialises more of the underlying image file, it will get faster, not
> slower.

Yes, that's clear, once everything is allocation then it is fast (and
really much faster in the case of xfs vs ext4), what we try to optimize
in qcow2 is precisely the allocation of new clusters.

Berto
