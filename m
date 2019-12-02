Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC14C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F49D206ED
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MaNUiHwj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfLBVWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:22:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbfLBVWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 16:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575321740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNy5mzrbFUfF+VYedCZNaTyj28AJmYDxC867Fp4tmD4=;
        b=MaNUiHwjSfyvj0/YdTuNSf4Jcybr1VFBnTE7FATZ4IblM4CtQaeQInhmw1r056mhbHdvL0
        HFzvrcmv7tKpiGr7V/djoi+MF4+R75De/fJ/KGMJm0CNmbkSO2GPiTNbMvT9m7CiJuDvug
        tkI+EEe3fAXy5qq3Ivfw7Cv3iFlKFoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-uh2s1mFnOQ66DD7AEEL6HA-1; Mon, 02 Dec 2019 16:22:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1FE11005502;
        Mon,  2 Dec 2019 21:22:15 +0000 (UTC)
Received: from lorien.usersys.redhat.com (ovpn-117-37.phx2.redhat.com [10.3.117.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C41C5D6A7;
        Mon,  2 Dec 2019 21:22:12 +0000 (UTC)
Date:   Mon, 2 Dec 2019 16:22:10 -0500
From:   Phil Auld <pauld@redhat.com>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Dave Chinner <david@fromorbit.com>, Ming Lei <ming.lei@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-fs <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Rong Chen <rong.a.chen@intel.com>, Tejun Heo <tj@kernel.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191202212210.GA32767@lorien.usersys.redhat.com>
References: <20191114113153.GB4213@ming.t460p>
 <20191114235415.GL4614@dread.disaster.area>
 <20191115010824.GC4847@ming.t460p>
 <20191115045634.GN4614@dread.disaster.area>
 <20191115070843.GA24246@ming.t460p>
 <20191128094003.752-1-hdanton@sina.com>
 <CAKfTPtA23ErKGCEJVmg6vk-QoufkiUM3NbXd31mZmKnuwbTkFw@mail.gmail.com>
 <20191202024625.GD24512@ming.t460p>
 <20191202040256.GE2695@dread.disaster.area>
 <CAKfTPtD8Q97qJ_+hdCXQRt=gy7k96XrhnFmGYP1G88YSFW0vNA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKfTPtD8Q97qJ_+hdCXQRt=gy7k96XrhnFmGYP1G88YSFW0vNA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: uh2s1mFnOQ66DD7AEEL6HA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Vincent,

On Mon, Dec 02, 2019 at 02:45:42PM +0100 Vincent Guittot wrote:
> On Mon, 2 Dec 2019 at 05:02, Dave Chinner <david@fromorbit.com> wrote:

...

> > So, we can fiddle with workqueues, but it doesn't address the
> > underlying issue that the scheduler appears to be migrating
> > non-bound tasks off a busy CPU too easily....
>=20
> The root cause of the problem is that the sched_wakeup_granularity_ns
> is in the same range or higher than load balance period. As Peter
> explained, This make the kworker waiting for the CPU for several load
> period and a transient unbalanced state becomes a stable one that the
> scheduler to fix. With default value, the scheduler doesn't try to
> migrate any task.

There are actually two issues here.   With the high wakeup granularity
we get the user task actively migrated. This causes the significant
performance hit Ming was showing. With the fast wakeup_granularity
(or smaller IOs - 512 instead of 4k) we get, instead, the user task
migrated at wakeup to a new CPU for every IO completion.

This is the 11k migrations per sec doing 11k iops.  In this test it
is not by itself causing the measured performance issue. It generally
flips back and forth between 2 cpus for large periods. I think it is
crossing cache boundaries at times (but I have not looked closely
at the traces compared to the topology, yet).

The active balances are what really hurts in thie case but I agree
that seems to be a tuning problem.


Cheers,
Phil


>=20
> Then, I agree that having an ack close to the request makes sense but
> forcing it on the exact same CPU is too restrictive IMO. Being able to
> use another CPU on the same core should not harm the performance and
> may even improve it. And that may still be the case while CPUs share
> their cache.
>=20
> >
> > -Dave.
> >
> > [*] Pay attention to the WQ_POWER_EFFICIENT definition for a work
> > queue: it's designed for interrupt routines that defer work via work
> > queues to avoid doing work on otherwise idle CPUs. It does this by
> > turning the per-cpu wq into an unbound wq so that work gets
> > scheduled on a non-idle CPUs in preference to the local idle CPU
> > which can then remain in low power states.
> >
> > That's the exact opposite of what using WQ_UNBOUND ends up doing in
> > this IO completion context: it pushes the work out over idle CPUs
> > rather than keeping them confined on the already busy CPUs where CPU
> > affinity allows the work to be done quickly. So while WQ_UNBOUND
> > avoids the user task being migrated frequently, it results in the
> > work being spread around many more CPUs and we burn more power to do
> > the same work.
> >
> > --
> > Dave Chinner
> > david@fromorbit.com
>=20

--=20

