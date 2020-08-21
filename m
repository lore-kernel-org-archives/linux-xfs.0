Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2709BC433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 17:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC08320656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 17:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gMth1jke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgHURDt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 13:03:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21900 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728587AbgHURCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 13:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598029358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lwS+kAPJtqLdpQqI1czJvEdFIatqGdZKK7fsajHisA0=;
        b=gMth1jkeraWlQnmaLvLtVyUW6NTc+hAV+VNZgeoraESfnm4QGaSFBS5EROiZzMYQvgtBP5
        zG2obFY+eLJOjbQhsWjA3zzrhFq3vFsUxZMa/czm9k9oLHajPVLcDQCdHajt0NrvW1syI2
        TefZRgg6DwJWfs80NigqecLwecAy0AY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-SF_3072jPQajpoxq_FW_aQ-1; Fri, 21 Aug 2020 13:02:36 -0400
X-MC-Unique: SF_3072jPQajpoxq_FW_aQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D178AEF63;
        Fri, 21 Aug 2020 17:02:35 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34FEE5D9CC;
        Fri, 21 Aug 2020 17:02:33 +0000 (UTC)
Date:   Fri, 21 Aug 2020 13:02:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alberto Garcia <berto@igalia.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200821170232.GA220086@bfoster>
References: <w518sedz3td.fsf@maestria.local.igalia.com>
 <20200817155307.GS11402@linux.fritz.box>
 <w51pn7memr7.fsf@maestria.local.igalia.com>
 <20200819150711.GE10272@linux.fritz.box>
 <20200819175300.GA141399@bfoster>
 <w51v9hdultt.fsf@maestria.local.igalia.com>
 <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
 <w51zh6oi4en.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w51zh6oi4en.fsf@maestria.local.igalia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 21, 2020 at 02:12:32PM +0200, Alberto Garcia wrote:
> On Fri 21 Aug 2020 01:42:52 PM CEST, Alberto Garcia wrote:
> > On Fri 21 Aug 2020 01:05:06 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
> >>> > 1) off: for every write request QEMU initializes the cluster (64KB)
> >>> >         with fallocate(ZERO_RANGE) and then writes the 4KB of data.
> >>> > 
> >>> > 2) off w/o ZERO_RANGE: QEMU writes the 4KB of data and fills the rest
> >>> >         of the cluster with zeroes.
> >>> > 
> >>> > 3) metadata: all clusters were allocated when the image was created
> >>> >         but they are sparse, QEMU only writes the 4KB of data.
> >>> > 
> >>> > 4) falloc: all clusters were allocated with fallocate() when the image
> >>> >         was created, QEMU only writes 4KB of data.
> >>> > 
> >>> > 5) full: all clusters were allocated by writing zeroes to all of them
> >>> >         when the image was created, QEMU only writes 4KB of data.
> >>> > 
> >>> > As I said in a previous message I'm not familiar with xfs, but the
> >>> > parts that I don't understand are
> >>> > 
> >>> >    - Why is (4) slower than (1)?
> >>> 
> >>> Because fallocate() is a full IO serialisation barrier at the
> >>> filesystem level. If you do:
> >>> 
> >>> fallocate(whole file)
> >>> <IO>
> >>> <IO>
> >>> <IO>
> >>> .....
> >>> 
> >>> The IO can run concurrent and does not serialise against anything in
> >>> the filesysetm except unwritten extent conversions at IO completion
> >>> (see answer to next question!)
> >>> 
> >>> However, if you just use (4) you get:
> >>> 
> >>> falloc(64k)
> >>>   <wait for inflight IO to complete>
> >>>   <allocates 64k as unwritten>
> >>> <4k io>
> >>>   ....
> >>> falloc(64k)
> >>>   <wait for inflight IO to complete>
> >>>   ....
> >>>   <4k IO completes, converts 4k to written>
> >>>   <allocates 64k as unwritten>
> >>> <4k io>
> >>> falloc(64k)
> >>>   <wait for inflight IO to complete>
> >>>   ....
> >>>   <4k IO completes, converts 4k to written>
> >>>   <allocates 64k as unwritten>
> >>> <4k io>
> >>>   ....
> >>> 
> >>
> >> Option 4 is described above as initial file preallocation whereas
> >> option 1 is per 64k cluster prealloc. Prealloc mode mixup aside, Berto
> >> is reporting that the initial file preallocation mode is slower than
> >> the per cluster prealloc mode. Berto, am I following that right?
> 
> After looking more closely at the data I can see that there is a peak of
> ~30K IOPS during the first 5 or 6 seconds and then it suddenly drops to
> ~7K for the rest of the test.
> 
> I was running fio with --ramp_time=5 which ignores the first 5 seconds
> of data in order to let performance settle, but if I remove that I can
> see the effect more clearly. I can observe it with raw files (in 'off'
> and 'prealloc' modes) and qcow2 files in 'prealloc' mode. With qcow2 and
> preallocation=off the performance is stable during the whole test.
> 

That's interesting. I ran your fio command (without --ramp_time and with
--runtime=5m) against a file on XFS (so no qcow2, no zero_range) once
with sparse file with a 64k extent size hint and again with a fully
preallocated 25GB file and I saw similar results in terms of the delta.
This was just against an SSD backed vdisk in my local dev VM, but I saw
~5800 iops for the full preallocation test and ~6200 iops with the
extent size hint.

I do notice an initial iops burst as described for both tests, so I
switched to use a 60s ramp time and 60s runtime. With that longer ramp
up time, I see ~5000 iops with the 64k extent size hint and ~5500 iops
with the full 25GB prealloc. Perhaps the unexpected performance delta
with qcow2 is similarly transient towards the start of the test and the
runtime is short enough that it skews the final results..?

Brian

> Berto
> 

