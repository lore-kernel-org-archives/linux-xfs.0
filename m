Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F69C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 16:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E6DA2075F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 16:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eYV0pmfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHYQy0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 12:54:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726104AbgHYQyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 12:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598374462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wECHHcRasIiEBwmQBh1AMtTtR0cT1Rkt61KaI1O3MeI=;
        b=eYV0pmfOKMC3aDeZPL2bi0WBLYXRKzSRJNT9usAwyv20PtF/y6NkmDNtFk9xLPcrjYQcGr
        Ck4824bwMie6d9o0OJ0bm1DcjDuM33bZ+GjgCmSvcf9kdAO527U31Rf/4Z7YhEsPJCGbEl
        ePSYO/6II9BE+hADrWhKWlMQ0G7rpug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-5OBC34NzOBubylbRk_5iZQ-1; Tue, 25 Aug 2020 12:54:20 -0400
X-MC-Unique: 5OBC34NzOBubylbRk_5iZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B6E2189E607;
        Tue, 25 Aug 2020 16:54:19 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67E35747D1;
        Tue, 25 Aug 2020 16:54:17 +0000 (UTC)
Date:   Tue, 25 Aug 2020 12:54:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alberto Garcia <berto@igalia.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200825165415.GB321765@bfoster>
References: <w51pn7memr7.fsf@maestria.local.igalia.com>
 <20200819150711.GE10272@linux.fritz.box>
 <20200819175300.GA141399@bfoster>
 <w51v9hdultt.fsf@maestria.local.igalia.com>
 <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
 <w51zh6oi4en.fsf@maestria.local.igalia.com>
 <20200821170232.GA220086@bfoster>
 <w51d03evrol.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w51d03evrol.fsf@maestria.local.igalia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 02:24:58PM +0200, Alberto Garcia wrote:
> On Fri 21 Aug 2020 07:02:32 PM CEST, Brian Foster wrote:
> >> I was running fio with --ramp_time=5 which ignores the first 5 seconds
> >> of data in order to let performance settle, but if I remove that I can
> >> see the effect more clearly. I can observe it with raw files (in 'off'
> >> and 'prealloc' modes) and qcow2 files in 'prealloc' mode. With qcow2 and
> >> preallocation=off the performance is stable during the whole test.
> >
> > That's interesting. I ran your fio command (without --ramp_time and
> > with --runtime=5m) against a file on XFS (so no qcow2, no zero_range)
> > once with sparse file with a 64k extent size hint and again with a
> > fully preallocated 25GB file and I saw similar results in terms of the
> > delta.  This was just against an SSD backed vdisk in my local dev VM,
> > but I saw ~5800 iops for the full preallocation test and ~6200 iops
> > with the extent size hint.
> >
> > I do notice an initial iops burst as described for both tests, so I
> > switched to use a 60s ramp time and 60s runtime. With that longer ramp
> > up time, I see ~5000 iops with the 64k extent size hint and ~5500 iops
> > with the full 25GB prealloc. Perhaps the unexpected performance delta
> > with qcow2 is similarly transient towards the start of the test and
> > the runtime is short enough that it skews the final results..?
> 
> I also tried running directly against a file on xfs (no qcow2, no VMs)
> but it doesn't really matter whether I use --ramp_time=5 or 60.
> 
> Here are the results:
> 
> |---------------+-------+-------|
> | preallocation |   xfs |  ext4 |
> |---------------+-------+-------|
> | off           |  7277 | 43260 |
> | fallocate     |  7299 | 42810 |
> | full          | 88404 | 83197 |
> |---------------+-------+-------|
> 
> I ran the first case (no preallocation) for 5 minutes and I said there's
> a peak during the first 5 seconds, but then the number remains under 10k
> IOPS for the rest of the 5 minutes.
> 

I don't think we're talking about the same thing. I was referring to the
difference between full file preallocation and the extent size hint in
XFS, and how the latter was faster with the shorter ramp time but that
swapped around when the test ramped up for longer. Here, it looks like
you're comparing XFS to ext4 writing direct to a file..

If I compare this 5m fio test between XFS and ext4 on a couple of my
systems (with either no prealloc or full file prealloc), I end up seeing
ext4 run slightly faster on my vm and XFS slightly faster on bare metal.
Either way, I don't see that huge disparity where ext4 is 5-6 times
faster than XFS. Can you describe the test, filesystem and storage in
detail where you observe such a discrepancy?

Brian

