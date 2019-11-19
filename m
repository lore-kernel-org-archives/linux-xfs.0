Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4CFC432C3
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 08:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1690522317
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 08:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxR33jRj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKSIzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 03:55:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59582 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726510AbfKSIzV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 03:55:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574153720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8OB6fCB1y6zlTa1uYexcpvgkBoKI6v48iGviwUiQTo=;
        b=CxR33jRjXFZR3YL/3fECcI30ZotdW68OFRMbJI+tLPk7j59FKzBhRGPoY13KTnKopD1yKB
        SsEa9wAIJkoMu9JGG9/cJLudHHLH+BfGdsNnxUc0vB6D8K0vbRxSgU8VK6ymgzG4qxOQtn
        xWeo6CfPhRYr9Lmedr6xgh/K5K4oPec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-imTtDVtfOrmhV9elyPYRGw-1; Tue, 19 Nov 2019 03:55:17 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48BB1DB61;
        Tue, 19 Nov 2019 08:55:15 +0000 (UTC)
Received: from ming.t460p (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 532532AF82;
        Tue, 19 Nov 2019 08:54:56 +0000 (UTC)
Date:   Tue, 19 Nov 2019 16:54:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: single aio thread is migrated crazily by scheduler
Message-ID: <20191119085452.GA8252@ming.t460p>
References: <20191114113153.GB4213@ming.t460p>
 <20191114235415.GL4614@dread.disaster.area>
 <20191115010824.GC4847@ming.t460p>
 <20191115045634.GN4614@dread.disaster.area>
 <20191115070843.GA24246@ming.t460p>
 <20191115234005.GO4614@dread.disaster.area>
 <20191118162633.GC32306@linux.vnet.ibm.com>
 <20191118211804.GW4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191118211804.GW4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: imTtDVtfOrmhV9elyPYRGw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 19, 2019 at 08:18:04AM +1100, Dave Chinner wrote:
> On Mon, Nov 18, 2019 at 09:56:33PM +0530, Srikar Dronamraju wrote:
> > * Dave Chinner <david@fromorbit.com> [2019-11-16 10:40:05]:
> >=20
> > > On Fri, Nov 15, 2019 at 03:08:43PM +0800, Ming Lei wrote:
> > > > On Fri, Nov 15, 2019 at 03:56:34PM +1100, Dave Chinner wrote:
> > > > > On Fri, Nov 15, 2019 at 09:08:24AM +0800, Ming Lei wrote:
> > > > I can reproduce the issue with 4k block size on another RH system, =
and
> > > > the login info of that system has been shared to you in RH BZ.
> > > >=20
> > > > 1)
> > >=20
> > > Almost all the fio task migrations are coming from migration/X
> > > kernel threads. i.e it's the scheduler active balancing that is
> > > causing the fio thread to bounce around.
> > >=20
> >=20
> > Can we try with the below patch.
>=20
> That makes things much, much worse.

Yeah, it is same with my test result, basically the fio io thread
migration counts is increased from 5k to 8k.

Thanks,
Ming

