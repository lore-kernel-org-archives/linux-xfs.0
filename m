Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6A7CA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0297205C9
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 12:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iWEUt+Kx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfJUMO0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 08:14:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728356AbfJUMO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 08:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571660065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLPtTy5w3D9+qiURB9rvHhPetGmz+/6ojEVJPkxN/zo=;
        b=iWEUt+Kxg36TBOFkLLm8d0zaHB8Cs9ounXsDT2pL6wFH64SrmEA17epKNwLEktEHZl1SwW
        q+TBLXmddc2tCfDaP0BAU0gxePujYh3N7lTKhCOuUavMxYWZcwcy/+Rezu8lWmmLIMBoQf
        q5TJedc8jAP/lh/gFZ82eZPL9VakJEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-5jVqBaieOvax-vJXODHI5w-1; Mon, 21 Oct 2019 08:14:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5851A1800DD0;
        Mon, 21 Oct 2019 12:14:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30EDD60BE2;
        Mon, 21 Oct 2019 12:14:18 +0000 (UTC)
Date:   Mon, 21 Oct 2019 08:14:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 0/2] xfs: rely on minleft instead of total for
 bmbt res
Message-ID: <20191021121416.GA2953@bfoster>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20191018171720.GB6719@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191018171720.GB6719@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 5jVqBaieOvax-vJXODHI5w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 18, 2019 at 10:17:20AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 12, 2019 at 10:32:21AM -0400, Brian Foster wrote:
> > Hi all,
> >=20
> > This is a repost of a couple patches I posted a few months ago[1]. Ther=
e
> > are no changes other than a rebase to for-next. Any thoughts on these? =
I
> > think Carlos had also run into some related generic/223 failures fairly
> > recently...
> >=20
> > Carlos,
> >=20
> > Any chance you could give these a try?
>=20
> Any progress on this in the last month?  I /think/ this is related to
> the unaligned allocations that Dan's complaining about this morning.
>=20

Not that I'm aware of. It looks similar and IIRC all that is really
needed here is a tweak to Carlos' and Dave's patch 1 that Carlos posted
(which replaces patch 1 of this series) added with patch 2 of this
series. I've just reposted a v2 series with that combination (including
links/references to hopefully reduce confusion).

Brian

> --D
>=20
> > Brian
> >=20
> > [1] https://lore.kernel.org/linux-xfs/20190501140504.16435-1-bfoster@re=
dhat.com/
> >=20
> > Brian Foster (2):
> >   xfs: drop minlen before tossing alignment on bmap allocs
> >   xfs: don't set bmapi total block req where minleft is sufficient
> >=20
> >  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
> >  fs/xfs/xfs_bmap_util.c   |  4 ++--
> >  fs/xfs/xfs_dquot.c       |  4 ++--
> >  fs/xfs/xfs_iomap.c       |  4 ++--
> >  fs/xfs/xfs_reflink.c     |  4 ++--
> >  fs/xfs/xfs_rtalloc.c     |  3 +--
> >  6 files changed, 18 insertions(+), 14 deletions(-)
> >=20
> > --=20
> > 2.20.1
> >=20

