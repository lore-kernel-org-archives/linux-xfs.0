Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BD6C47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 18:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29BF24978
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 18:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HTNNuee0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgEASXd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 14:23:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38041 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730655AbgEASXc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 14:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588357411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O3k5c99Ltj1H6GZiqaOGmNSf/gmDJGmY2cTcm78WYzY=;
        b=HTNNuee03jXixtqLgSR6nIOTQRhCn+LbQ0tHWY+wR035u9cc8CzbyIjhqmRpswMlOMKB6x
        00S7IRatkrLbOk6aJzgBc38lLWpkkj4D+f+XWm98W/To24S4U2OPKIld0cr7ejP45QG+Wd
        FWzxn9JDw4uaa7MIcvnnWY39rjI9LS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-CEWuElhQOUWg171ILwcEwA-1; Fri, 01 May 2020 14:23:19 -0400
X-MC-Unique: CEWuElhQOUWg171ILwcEwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFBD8108BD0D;
        Fri,  1 May 2020 18:23:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FBDE2B4CC;
        Fri,  1 May 2020 18:23:18 +0000 (UTC)
Date:   Fri, 1 May 2020 14:23:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200501182316.GT40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-9-hch@lst.de>
 <20200501155649.GO40250@bfoster>
 <20200501160809.GT6742@magnolia>
 <20200501163809.GA18426@lst.de>
 <20200501165017.GA20127@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200501165017.GA20127@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 06:50:17PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 06:38:09PM +0200, Christoph Hellwig wrote:
> > That being said my approach here was a little too dumb.  Once we are
> > all in the same code base we can stop the stupid patching of the
> > parent and just handle the case directly.  Something like this
> > incremental diff on top of the sent out version (not actually tested)=
.
> >=20
> > Total diffstate with the original patch is:
> >=20
> >  4 files changed, 37 insertions(+), 35 deletions(-)
> >=20
> > and this should also help with online repair while killing a horrible
> > kludge.
>=20
> Btw, =D0=86 wonder if for repair / online repair just skipping the veri=
fiers
> entirely would make more sense.  But I think we can go there
> incrementally and just keep the existing repair behavior for now.
>=20

Can we use another dummy parent inode value in xfs_repair? It looks to
me that we set it to zero in phase 4 if it fails verification and set
the parent to NULLFSINO (i.e. unknown) in repair's in-core tracking.
Phase 6 walks the directory entries and explicitly sets the parent inode
number of entries with an unknown parent (according to the in-core
tracking). IOW, I don't see where we actually rely on the directory
header having a parent inode of zero outside of detecting it in the
custom verifier. If that's the only functional purpose, I wonder if we
could do something like set the bogus parent field of a sf dir to the
root inode or to itself, that way the default verifier wouldn't trip
over it..

Brian

