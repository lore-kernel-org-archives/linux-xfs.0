Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8745C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 12:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADD942074A
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 12:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="JXdLEEac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgHYMZM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 08:25:12 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:37174 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgHYMZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 08:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=vEJ72oUvlbdcg4o2id9m0UzjAK8cG0VRRCH/ZBpex8g=;
        b=JXdLEEaccbWpTEp9kni3rB2AlGgnik7+tsM1t/IxvNxXisDwnGJTvPu0sP+hGy44Dl29f98TmXJaiVlypmvbJf90ELsvgYeOwymxJuLY5A7w+fqAaTtktpUyDFBK5WLrpSb22ap0QNw18t3EhRRX1cyEBfl911UTCTo8+byjFiInr80axhFsksYsOBVwjiKq4d0FfeTL3/kialNaS3NUy4OM/XI4lHPkf69ve7GiRq8Uymtl0BSidyou7nr/OLpEgfxJIPcE8401z4sgBlq7r7V7GFihsq1LsspxqYfDvtW5Du4e51T6QwrQtw4x2WGxFuQjQFx/MKIWID+S0/cjyA==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1kAY0Y-0006qR-Uy; Tue, 25 Aug 2020 14:24:58 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1kAY0Y-0000Kq-LT; Tue, 25 Aug 2020 14:24:58 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <20200821170232.GA220086@bfoster>
References: <w518sedz3td.fsf@maestria.local.igalia.com> <20200817155307.GS11402@linux.fritz.box> <w51pn7memr7.fsf@maestria.local.igalia.com> <20200819150711.GE10272@linux.fritz.box> <20200819175300.GA141399@bfoster> <w51v9hdultt.fsf@maestria.local.igalia.com> <20200820215811.GC7941@dread.disaster.area> <20200821110506.GB212879@bfoster> <w51364gjkcj.fsf@maestria.local.igalia.com> <w51zh6oi4en.fsf@maestria.local.igalia.com> <20200821170232.GA220086@bfoster>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Tue, 25 Aug 2020 14:24:58 +0200
Message-ID: <w51d03evrol.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 21 Aug 2020 07:02:32 PM CEST, Brian Foster wrote:
>> I was running fio with --ramp_time=5 which ignores the first 5 seconds
>> of data in order to let performance settle, but if I remove that I can
>> see the effect more clearly. I can observe it with raw files (in 'off'
>> and 'prealloc' modes) and qcow2 files in 'prealloc' mode. With qcow2 and
>> preallocation=off the performance is stable during the whole test.
>
> That's interesting. I ran your fio command (without --ramp_time and
> with --runtime=5m) against a file on XFS (so no qcow2, no zero_range)
> once with sparse file with a 64k extent size hint and again with a
> fully preallocated 25GB file and I saw similar results in terms of the
> delta.  This was just against an SSD backed vdisk in my local dev VM,
> but I saw ~5800 iops for the full preallocation test and ~6200 iops
> with the extent size hint.
>
> I do notice an initial iops burst as described for both tests, so I
> switched to use a 60s ramp time and 60s runtime. With that longer ramp
> up time, I see ~5000 iops with the 64k extent size hint and ~5500 iops
> with the full 25GB prealloc. Perhaps the unexpected performance delta
> with qcow2 is similarly transient towards the start of the test and
> the runtime is short enough that it skews the final results..?

I also tried running directly against a file on xfs (no qcow2, no VMs)
but it doesn't really matter whether I use --ramp_time=5 or 60.

Here are the results:

|---------------+-------+-------|
| preallocation |   xfs |  ext4 |
|---------------+-------+-------|
| off           |  7277 | 43260 |
| fallocate     |  7299 | 42810 |
| full          | 88404 | 83197 |
|---------------+-------+-------|

I ran the first case (no preallocation) for 5 minutes and I said there's
a peak during the first 5 seconds, but then the number remains under 10k
IOPS for the rest of the 5 minutes.

Berto
