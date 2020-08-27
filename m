Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E614FC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE48A22CBE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 16:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IlpwYQ2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgH0Qr5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 12:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgH0Qr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 12:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598546875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=++InBjskBUT021uU8278WFMqMyljhryA671fVTnvT0Y=;
        b=IlpwYQ2j4ib2qP0rwSkOBXHRxWOawLFYuOdgp1b5+dZIGKyaxBeJifezunYVy4nbk37IzV
        f1ztJvXGBqUsPoXyuPUopzIjFHuxDiU5JAUCma1t9Aicna91z3vAhUqMFYfEbxjXxe9uCR
        8Np4KcfJnrONeTvyfietjH7LAZAyAJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-w_twRgycNF2ie7vPuX5feg-1; Thu, 27 Aug 2020 12:47:50 -0400
X-MC-Unique: w_twRgycNF2ie7vPuX5feg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFCCE801AC2;
        Thu, 27 Aug 2020 16:47:48 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4E55C1C2;
        Thu, 27 Aug 2020 16:47:47 +0000 (UTC)
Date:   Thu, 27 Aug 2020 12:47:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alberto Garcia <berto@igalia.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200827164745.GA434083@bfoster>
References: <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
 <w51zh6oi4en.fsf@maestria.local.igalia.com>
 <20200821170232.GA220086@bfoster>
 <w51d03evrol.fsf@maestria.local.igalia.com>
 <20200825165415.GB321765@bfoster>
 <w51d03etzj8.fsf@maestria.local.igalia.com>
 <20200825194724.GA338144@bfoster>
 <w51wo1l6ytj.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w51wo1l6ytj.fsf@maestria.local.igalia.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 08:34:32PM +0200, Alberto Garcia wrote:
> On Tue 25 Aug 2020 09:47:24 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
> > My fio fallocates the entire file by default with this command. Is that
> > the intent of this particular test? I added --fallocate=none to my test
> > runs to incorporate the allocation cost in the I/Os.
> 
> That wasn't intentional, you're right, it should use --fallocate=none (I
> don't see a big difference in my test anyway).
> 
> >> The Linux version is 4.19.132-1 from Debian.
> >
> > Thanks. I don't have LUKS in the mix on my box, but I was running on a
> > more recent kernel (Fedora 5.7.15-100). I threw v4.19 on the box and
> > saw a bit more of a delta between XFS (~14k iops) and ext4 (~24k). The
> > same test shows ~17k iops for XFS and ~19k iops for ext4 on v5.7. If I
> > increase the size of the LVM volume from 126G to >1TB, ext4 runs at
> > roughly the same rate and XFS closes the gap to around ~19k iops as
> > well. I'm not sure what might have changed since v4.19, but care to
> > see if this is still an issue on a more recent kernel?
> 
> Ok, I gave 5.7.10-1 a try but I still get similar numbers.
> 

Strange.

> Perhaps with a larger filesystem there would be a difference? I don't
> know.
> 

Perhaps. I believe Dave mentioned earlier how log size might affect
things.

I created a 125GB lvm volume and see slight deltas in iops going from
testing directly on the block device, to a fully allocated file on
XFS/ext4 and then to a preallocated file on XFS/ext4. In both cases the
numbers are comparable between XFS and ext4. On XFS, I can reproduce a
serious drop in iops if I reduce the default ~64MB log down to 8MB.
Perhaps you could try increasing your log ('-lsize=...' at mkfs time)
and see if that changes anything?

Beyond that, I'd probably try to normalize and simplify your storage
stack if you wanted to narrow it down further. E.g., clean format the
same bdev for XFS and ext4 and pull out things like LUKS just to rule
out any poor interactions.

Brian

> Berto
> 

