Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C282C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 13:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35D9F207BB
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 13:00:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZTVDvXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgHUNA2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:00:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46729 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727793AbgHUNAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Aug 2020 09:00:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598014822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+LQ8GTLmp2P5ctZzLR7WCdxL3glFXWbr1uNxQsx5Svs=;
        b=NZTVDvXveqIxrvjpRyyMLuDqdMnR3PsfmHRfpggeGArlko2zYn55eJkCdh2HNI7hkvtA4b
        ThVdV5XBQxpjdR1kKfb9UPV8iO+Syy7WoKlpo0mY3mkQU7tz8HIwRJGc2BK0t7VDJhjM+8
        FCG92bGH9g4TBzVLQslJU9iiiJwl/nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-cHYLhd90Ne227NVuRmo9Ng-1; Fri, 21 Aug 2020 09:00:19 -0400
X-MC-Unique: cHYLhd90Ne227NVuRmo9Ng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B43301008228;
        Fri, 21 Aug 2020 12:59:46 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB2E119D6C;
        Fri, 21 Aug 2020 12:59:45 +0000 (UTC)
Date:   Fri, 21 Aug 2020 08:59:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alberto Garcia <berto@igalia.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org,
        Max Reitz <mreitz@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200821125944.GC212879@bfoster>
References: <20200817101019.GD11402@linux.fritz.box>
 <w518sedz3td.fsf@maestria.local.igalia.com>
 <20200817155307.GS11402@linux.fritz.box>
 <w51pn7memr7.fsf@maestria.local.igalia.com>
 <20200819150711.GE10272@linux.fritz.box>
 <20200819175300.GA141399@bfoster>
 <w51v9hdultt.fsf@maestria.local.igalia.com>
 <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w51364gjkcj.fsf@maestria.local.igalia.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 21, 2020 at 01:42:52PM +0200, Alberto Garcia wrote:
> On Fri 21 Aug 2020 01:05:06 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
> >> > 1) off: for every write request QEMU initializes the cluster (64KB)
> >> >         with fallocate(ZERO_RANGE) and then writes the 4KB of data.
> >> > 
> >> > 2) off w/o ZERO_RANGE: QEMU writes the 4KB of data and fills the rest
> >> >         of the cluster with zeroes.
> >> > 
> >> > 3) metadata: all clusters were allocated when the image was created
> >> >         but they are sparse, QEMU only writes the 4KB of data.
> >> > 
> >> > 4) falloc: all clusters were allocated with fallocate() when the image
> >> >         was created, QEMU only writes 4KB of data.
> >> > 
> >> > 5) full: all clusters were allocated by writing zeroes to all of them
> >> >         when the image was created, QEMU only writes 4KB of data.
> >> > 
> >> > As I said in a previous message I'm not familiar with xfs, but the
> >> > parts that I don't understand are
> >> > 
> >> >    - Why is (4) slower than (1)?
> >> 
> >> Because fallocate() is a full IO serialisation barrier at the
> >> filesystem level. If you do:
> >> 
> >> fallocate(whole file)
> >> <IO>
> >> <IO>
> >> <IO>
> >> .....
> >> 
> >> The IO can run concurrent and does not serialise against anything in
> >> the filesysetm except unwritten extent conversions at IO completion
> >> (see answer to next question!)
> >> 
> >> However, if you just use (4) you get:
> >> 
> >> falloc(64k)
> >>   <wait for inflight IO to complete>
> >>   <allocates 64k as unwritten>
> >> <4k io>
> >>   ....
> >> falloc(64k)
> >>   <wait for inflight IO to complete>
> >>   ....
> >>   <4k IO completes, converts 4k to written>
> >>   <allocates 64k as unwritten>
> >> <4k io>
> >> falloc(64k)
> >>   <wait for inflight IO to complete>
> >>   ....
> >>   <4k IO completes, converts 4k to written>
> >>   <allocates 64k as unwritten>
> >> <4k io>
> >>   ....
> >> 
> >
> > Option 4 is described above as initial file preallocation whereas
> > option 1 is per 64k cluster prealloc. Prealloc mode mixup aside, Berto
> > is reporting that the initial file preallocation mode is slower than
> > the per cluster prealloc mode. Berto, am I following that right?
> 
> Option (1) means that no qcow2 cluster is allocated at the beginning of
> the test so, apart from updating the relevant qcow2 metadata, each write
> request clears the cluster first (with fallocate(ZERO_RANGE)) then
> writes the requested 4KB of data. Further writes to the same cluster
> don't need changes on the qcow2 metadata so they go directly to the area
> that was cleared with fallocate().
> 
> Option (4) means that all clusters are allocated when the image is
> created and they are initialized with fallocate() (actually with
> posix_fallocate() now that I read the code, I suppose it's the same for
> xfs?). Only after that the test starts. All write requests are simply
> forwarded to the disk, there is no need to touch any qcow2 metadata nor
> do anything else.
> 

Ok, I think that's consistent with what I described above (sorry, I find
the preallocation mode names rather confusing so I was trying to avoid
using them). Have you confirmed that posix_fallocate() in this case
translates directly to fallocate()? I suppose that's most likely the
case, otherwise you'd see numbers more like with preallocation=full
(file preallocated via writing zeroes).

> And yes, (4) is a bit slower than (1) in my tests. On ext4 I get 10%
> more IOPS.
> 
> I just ran the tests with aio=native and with a raw image instead of
> qcow2, here are the results:
> 
> qcow2:
> |----------------------+-------------+------------|
> | preallocation        | aio=threads | aio=native |
> |----------------------+-------------+------------|
> | off                  |        8139 |       7649 |
> | off (w/o ZERO_RANGE) |        2965 |       2779 |
> | metadata             |        7768 |       8265 |
> | falloc               |        7742 |       7956 |
> | full                 |       41389 |      56668 |
> |----------------------+-------------+------------|
> 

So this seems like Dave's suggestion to use native aio produced more
predictable results with full file prealloc being a bit faster than per
cluster prealloc. Not sure why that isn't the case with aio=threads. I
was wondering if perhaps the threading affects something indirectly like
the qcow2 metadata allocation itself, but I guess that would be
inconsistent with ext4 showing a notable jump from (1) to (4) (assuming
the previous ext4 numbers were with aio=threads).

> raw:
> |---------------+-------------+------------|
> | preallocation | aio=threads | aio=native |
> |---------------+-------------+------------|
> | off           |        7647 |       7928 |
> | falloc        |        7662 |       7856 |
> | full          |       45224 |      58627 |
> |---------------+-------------+------------|
> 
> A qcow2 file with preallocation=metadata is more or less similar to a
> sparse raw file (and the numbers are indeed similar).
> 
> preallocation=off on qcow2 does not have an equivalent on raw files.
> 

It sounds like preallocation=off for qcow2 would be roughly equivalent
to a raw file with a 64k extent size hint (on XFS).

Brian

> Berto
> 

