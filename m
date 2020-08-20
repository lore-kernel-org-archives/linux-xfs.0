Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2E2C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 20:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 828F3207BB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 20:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="eib2wX3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHTUhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 16:37:23 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:57786 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgHTUhW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 16:37:22 -0400
X-Greylist: delayed 2040 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 16:37:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=FBmh43oHM1E23Eh1cS4UpORoJitJGaSH3+r5hSYb2S0=;
        b=eib2wX3FlFGPUZdl6D5um7Grh1wfetgdRbxYaful7/y4tr79MELroOqVB4olFgPCa6kd/rZaFJzpyKjnSUdPNYoMf9RmB9QBmsUuXR9uDZdOVUPi26D7iPPLynH1At/znh25pZQNZcC+/y6yaD56WGHyYIDoLFFEEb1XJkb7BS1cvNsPrR1ThOiSJYrxeZe3mc/kcR5wd+W7BxSugXB3wnW0ZNAyeoz5qQpXungccA3eIx1qGR8BwCfh770rHirmaNynLTxVk0EE+cf/rfMUPYaOFMpz1DFzAA8ABcGChCv9ZJ/8kvmkOOyltgQJAPpGq08LMFINZslv2WIVzl+Amg==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1k8qmE-0007Np-Uh; Thu, 20 Aug 2020 22:03:11 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1k8qmE-0000MG-L0; Thu, 20 Aug 2020 22:03:10 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Brian Foster <bfoster@redhat.com>, Kevin Wolf <kwolf@redhat.com>
Cc:     qemu-devel@nongnu.org, qemu-block@nongnu.org,
        Max Reitz <mreitz@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <20200819175300.GA141399@bfoster>
References: <cover.1597416317.git.berto@igalia.com> <20200817101019.GD11402@linux.fritz.box> <w518sedz3td.fsf@maestria.local.igalia.com> <20200817155307.GS11402@linux.fritz.box> <w51pn7memr7.fsf@maestria.local.igalia.com> <20200819150711.GE10272@linux.fritz.box> <20200819175300.GA141399@bfoster>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Thu, 20 Aug 2020 22:03:10 +0200
Message-ID: <w51v9hdultt.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Cc: linux-xfs

On Wed 19 Aug 2020 07:53:00 PM CEST, Brian Foster wrote:
> In any event, if you're seeing unclear or unexpected performance
> deltas between certain XFS configurations or other fs', I think the
> best thing to do is post a more complete description of the workload,
> filesystem/storage setup, and test results to the linux-xfs mailing
> list (feel free to cc me as well). As it is, aside from the questions
> above, it's not really clear to me what the storage stack looks like
> for this test, if/how qcow2 is involved, what the various
> 'preallocation=' modes actually mean, etc.

(see [1] for a bit of context)

I repeated the tests with a larger (125GB) filesystem. Things are a bit
faster but not radically different, here are the new numbers:

|----------------------+-------+-------|
| preallocation mode   |   xfs |  ext4 |
|----------------------+-------+-------|
| off                  |  8139 | 11688 |
| off (w/o ZERO_RANGE) |  2965 |  2780 |
| metadata             |  7768 |  9132 |
| falloc               |  7742 | 13108 |
| full                 | 41389 | 16351 |
|----------------------+-------+-------|

The numbers are I/O operations per second as reported by fio, running
inside a VM.

The VM is running Debian 9.7 with Linux 4.9.130 and the fio version is
2.16-1. I'm using QEMU 5.1.0.

fio is sending random 4KB write requests to a 25GB virtual drive, this
is the full command line:

fio --filename=/dev/vdb --direct=1 --randrepeat=1 --eta=always
    --ioengine=libaio --iodepth=32 --numjobs=1 --name=test --size=25G
    --io_limit=25G --ramp_time=5 --rw=randwrite --bs=4k --runtime=60
  
The virtual drive (/dev/vdb) is a freshly created qcow2 file stored on
the host (on an xfs or ext4 filesystem as the table above shows), and
it is attached to QEMU using a virtio-blk-pci device:

   -drive if=virtio,file=image.qcow2,cache=none,l2-cache-size=200M

cache=none means that the image is opened with O_DIRECT and
l2-cache-size is large enough so QEMU is able to cache all the
relevant qcow2 metadata in memory.

The host is running Linux 4.19.132 and has an SSD drive.

About the preallocation modes: a qcow2 file is divided into clusters
of the same size (64KB in this case). That is the minimum unit of
allocation, so when writing 4KB to an unallocated cluster QEMU needs
to fill the other 60KB with zeroes. So here's what happens with the
different modes:

1) off: for every write request QEMU initializes the cluster (64KB)
        with fallocate(ZERO_RANGE) and then writes the 4KB of data.

2) off w/o ZERO_RANGE: QEMU writes the 4KB of data and fills the rest
        of the cluster with zeroes.

3) metadata: all clusters were allocated when the image was created
        but they are sparse, QEMU only writes the 4KB of data.

4) falloc: all clusters were allocated with fallocate() when the image
        was created, QEMU only writes 4KB of data.

5) full: all clusters were allocated by writing zeroes to all of them
        when the image was created, QEMU only writes 4KB of data.

As I said in a previous message I'm not familiar with xfs, but the
parts that I don't understand are

   - Why is (4) slower than (1)?
   - Why is (5) so much faster than everything else?

I hope I didn't forget anything, tell me if you have questions.

Berto

[1] https://lists.gnu.org/archive/html/qemu-block/2020-08/msg00481.html
