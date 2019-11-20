Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E616C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 22:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBF9620672
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 22:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DmZUR+Qy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfKTWD3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 17:03:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26342 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725936AbfKTWD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 17:03:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574287407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6C29Osq+JMxMyTsFEFeFdTV5O5zf4w1ZtFWoHQvhHQ=;
        b=DmZUR+QysllpJRKa5v9RQt+0hHAZS694g22Fyq3YITnsYaa7NKQrcq7NmE8E53JVGdGmI+
        gt/WLnmr7I0s7+wn2N77hLnnV38My6aWkLuIaFJLzylH73QBhxRVWfVmFTU9EXp/dXm+hJ
        SEssoLyoZ45TKcd9neTk6y9+EgLX+aY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-cttqolrQN5ynM6c2_mDL9Q-1; Wed, 20 Nov 2019 17:03:24 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DCE801E5D;
        Wed, 20 Nov 2019 22:03:22 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 544F853C20;
        Wed, 20 Nov 2019 22:03:15 +0000 (UTC)
Date:   Wed, 20 Nov 2019 17:03:13 -0500
From:   Phil Auld <pauld@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191120220313.GC18056@pauld.bos.csb>
References: <20191114113153.GB4213@ming.t460p>
 <20191114235415.GL4614@dread.disaster.area>
 <20191115010824.GC4847@ming.t460p>
 <20191115045634.GN4614@dread.disaster.area>
 <20191115070843.GA24246@ming.t460p>
 <20191115234005.GO4614@dread.disaster.area>
 <20191118092121.GV4131@hirez.programming.kicks-ass.net>
 <20191118204054.GV4614@dread.disaster.area>
 <20191120191636.GI4097@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20191120191636.GI4097@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: cttqolrQN5ynM6c2_mDL9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Peter,

On Wed, Nov 20, 2019 at 08:16:36PM +0100 Peter Zijlstra wrote:
> On Tue, Nov 19, 2019 at 07:40:54AM +1100, Dave Chinner wrote:
> > On Mon, Nov 18, 2019 at 10:21:21AM +0100, Peter Zijlstra wrote:
>=20
> > > We typically only fall back to the active balancer when there is
> > > (persistent) imbalance and we fail to migrate anything else (of
> > > substance).
> > >=20
> > > The tuning mentioned has the effect of less frequent scheduling, IOW,
> > > leaving (short) tasks on the runqueue longer. This obviously means th=
e
> > > load-balancer will have a bigger chance of seeing them.
> > >=20
> > > Now; it's been a while since I looked at the workqueue code but one
> > > possible explanation would be if the kworker that picks up the work i=
tem
> > > is pinned. That would make it runnable but not migratable, the exact
> > > situation in which we'll end up shooting the current task with active
> > > balance.
> >=20
> > Yes, that's precisely the problem - work is queued, by default, on a
> > specific CPU and it will wait for a kworker that is pinned to that
>=20
> I'm thinking the problem is that it doesn't wait. If it went and waited
> for it, active balance wouldn't be needed, that only works on active
> tasks.

Since this is AIO I wonder if it should queue_work on a nearby cpu by=20
default instead of unbound. =20

>=20
> > specific CPU to dispatch it. We've already tested that queuing on a
> > different CPU (via queue_work_on()) makes the problem largely go
> > away as the work is not longer queued behind the long running fio
> > task.
> >=20
> > This, however, is not at viable solution to the problem. The pattern
> > of a long running process queuing small pieces of individual work
> > for processing in a separate context is pretty common...
>=20
> Right, but you're putting the scheduler in a bind. By overloading the
> CPU and only allowing the one task to migrate, it pretty much has no
> choice left.
>=20
> Anyway, I'm still going to have try and reproduce -- I got side-tracked
> into a crashing bug, I'll hopefully get back to this tomorrow. Lastly,
> one other thing to try is -next. Vincent reworked the load-balancer
> quite a bit.
>=20

I've tried it with the lb patch series. I get basically the same results.
With the high granularity settings I get 3700 migrations for the 30=20
second run at 4k. Of those about 3200 are active balance on stock 5.4-rc7.
With the lb patches it's 3500 and 3000, a slight drop.=20

Using the default granularity settings 50 and 22 for stock and 250 and 25.
So a few more total migrations with the lb patches but about the same activ=
e.


On this system I'm getting 100k migrations using 512 byte blocksize. Almost
all not active. I haven't looked into that closely yet but it's like 3000
per second looking like this:

...
64.19641 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19694 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19746 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19665 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19718 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19772 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19800 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19828 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19856 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19882 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19909 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19937 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.19967 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.19995 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.20023 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.20053 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.20079 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.20107 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.20135 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.20163 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
64.20192 386     386     kworker/15:1    sched_migrate_task fio/2784 cpu 15=
->19=20
64.20221 389     389     kworker/19:1    sched_migrate_task fio/2784 cpu 19=
->15=20
...

Which is roughly equal to the number if iops it's doing.=20

Cheers,
Phil

--=20

