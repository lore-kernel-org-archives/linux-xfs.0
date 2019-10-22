Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B17FCA9EA0
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A9321872
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 11:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P63/Q5qR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfJVLGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 07:06:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729458AbfJVLGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 07:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571742366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6jvQo3W0ytldCAS/7ynaKYGhj7OwHmCh6LT9fVtlvc=;
        b=P63/Q5qRpU9pRSE0z5h7h/2rgVPMSA5yx4jnJO+MZWUbBHhoUMhhK4N4LLo9axjJknxTlI
        qOTOiceWh6dVPFfGg8vIE6ISMPYtccnmXZmPAvOagyczwwbk3o1f+h9piJBxKoUDQ5lzxF
        e8h35uBcFmys6Y3A+vvFQ/ngF0/KufY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-jlUK3McBNNeRRvzZFUsVTQ-1; Tue, 22 Oct 2019 07:06:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69BE1476;
        Tue, 22 Oct 2019 11:06:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71A955D6A5;
        Tue, 22 Oct 2019 11:06:02 +0000 (UTC)
Date:   Tue, 22 Oct 2019 07:06:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     vbendel@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: xfs_buftarg_isolate(): "Correctly invert xfs_buftarg LRU
 isolation logic"
Message-ID: <20191022110600.GA50656@bfoster>
References: <CC133B1B9D9B46AFAB2D35A366BF7DC4@alyakaslap>
 <20191021124714.GA26105@bfoster>
 <CAOcd+r1cwsoGD5=VtJjRwmh5Sp9MVmSv9xRq8S9STs=cUyMH+Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOcd+r1cwsoGD5=VtJjRwmh5Sp9MVmSv9xRq8S9STs=cUyMH+Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: jlUK3McBNNeRRvzZFUsVTQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 22, 2019 at 09:49:56AM +0300, Alex Lyakas wrote:
> Hi Brian,
>=20
> Thank you for your response.
>=20
> On Mon, Oct 21, 2019 at 3:47 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Sun, Oct 20, 2019 at 05:54:03PM +0300, Alex Lyakas wrote:
> > > Hello Vratislav, Brian,
> > >
> > > This is with regards to commit "xfs: Correctly invert xfs_buftarg LRU
> > > isolation logic" [1].
> > >
> > > I am hitting this issue in kernel 4.14. However, after some debugging=
, I do
> > > not fully agree with the commit message, describing the effect of thi=
s
> > > defect.
> > >
> > > In case b_lru_ref > 1, then indeed this xfs_buf will be taken off the=
 LRU
> > > list, and immediately added back to it, with b_lru_ref being lesser b=
y 1
> > > now.
> > >
> > > In case b_lru_ref=3D=3D1, then this xfs_buf will be similarly isolate=
d (due to a
> > > bug), and xfs_buf_rele() will be called on it. But now its b_lru_ref=
=3D=3D0. In
> > > this case, xfs_buf_rele() will free the buffer, rather than re-adding=
 it
> > > back to the LRU. This is a problem, because we intended for this buff=
er to
> > > have another trip on the LRU. Only when b_lru_ref=3D=3D0 upon entry t=
o
> > > xfs_buftarg_isolate(), we want to free the buffer. So we are freeing =
the
> > > buffer one trip too early in this case.
> > >
> > > In case b_lru_ref=3D=3D0 (somehow), then due to a bug, this xfs_buf w=
ill not be
> > > removed off the LRU. It will remain sitting in the LRU with b_lru_ref=
=3D=3D0. On
> > > next shrinker call, this xfs_buff will also remain on the LRU, due to=
 the
> > > same bug. So this xfs_buf will be freed only on unmount or if
> > > xfs_buf_stale() is called on it.
> > >
> > > Do you agree with the above?
> > >
> >
> > I'm not really sure how you're inferring what cases free the buffer vs.
> > what don't based on ->b_lru_ref. A buffer is freed when its reference
> > count (->b_hold) drops to zero unless ->b_lru_ref is non-zero, at which
> > point the buffer goes on the LRU and the LRU itself takes a ->b_hold
> > reference to keep the buffer from being freed. This reference is not
> > associated with how many cycles through the LRU a buffer is allowed
> > before it is dropped from the LRU, which is what ->b_lru_ref tracks.
> >
> > Since the LRU holds a (single) reference to the buffer just like any
> > other user of the buffer, it doesn't make any direct decision on when t=
o
> > free a buffer or not. In other words, the bug fixed by this patch is
> > related to when we decide to drop the buffer from the LRU based on the
> > LRU ref count. If the LRU ->b_hold reference happens to be the last on
> > the buffer when it is dropped from the LRU, then the buffer is freed.
>=20
> I apologize for the confusion. By "freed" I really meant "taken off
> the LRU". I am aware of the fact that b_hold is controlling whether
> the buffer will be freed or not.
>=20

Ok.

> What I meant is that the commit description does not address the issue
> accurately. From the description one can understand that the only
> problem is the additional trip through the LRU.
> But in fact, due to this issue, buffers will spend one cycle less in
> the LRU than intended. If we initialize b_lru_ref to X, we intend the
> buffer to survive X shrinker calls, and on the X+1'th call to be taken
> off the LRU (and maybe freed). But with this issue, the buffer will be
> taken off the LRU and immediately re-added back. But this will happen
> X-1 times, because on the X'th time the b_lru_ref will be 0, and the
> buffer will not be readded to the LRU. So the buffer will survive X-1
> shrinker calls and not X as intended.
>=20

That sounds like a reasonable description of behavior to me. Personally,
I also think the commit log description is fine because I read it
generically as just pointing out the logic is backwards. Your
description above is more detailed and probably more technically
accurate, but I'm not sure if/why it matters at this point for anything
beyond just attempting to understand a historical bug (for stable
backport purposes?).

Brian

> Furthermore, if somehow we end up with the buffer sitting on the LRU
> and having b_lru_ref=3D=3D0, this buffer will never be taken off the LRU,
> due to the bug. I am not sure this can happen, because by default
> b_lru_ref is set to 1.
>=20
>=20
> >
> > > If so, I think this fix should be backported to stable kernels.
> > >
> >
> > Seems reasonable to me. Feel free to post a patch. :)
> Will do.
>=20
> Thanks,
> Alex.
>=20
>=20
> >
> > Brian
> >
> > > Thanks,
> > > Alex.
> > >
> > > [1]
> > > commit 19957a181608d25c8f4136652d0ea00b3738972d
> > > Author: Vratislav Bendel <vbendel@redhat.com>
> > > Date:   Tue Mar 6 17:07:44 2018 -0800
> > >
> > >    xfs: Correctly invert xfs_buftarg LRU isolation logic
> > >
> > >    Due to an inverted logic mistake in xfs_buftarg_isolate()
> > >    the xfs_buffers with zero b_lru_ref will take another trip
> > >    around LRU, while isolating buffers with non-zero b_lru_ref.
> > >
> > >    Additionally those isolated buffers end up right back on the LRU
> > >    once they are released, because b_lru_ref remains elevated.
> > >
> > >    Fix that circuitous route by leaving them on the LRU
> > >    as originally intended.
> > >
> > >    Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> > >    Reviewed-by: Brian Foster <bfoster@redhat.com>
> > >    Reviewed-by: Christoph Hellwig <hch@lst.de>
> > >    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> >

