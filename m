Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1208CCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F142087F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 10:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1KjK/Dj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfJ2KDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 06:03:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbfJ2KDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 06:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572343432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIpi4Nmjth6iZ4tF2SyX1cLxjtTzo0pxwNlx4XnTPoY=;
        b=c1KjK/DjgtA0fNS2JiAqVQuYUwf43E/7DIdNTNGQPNhQiJGcPl74wwnkbyn14zIxVS+UAL
        MRBUjoszPrFHofYcG/RIyVj00zLZHqRhpNNx0oWjebAkPEP1C2mXIKd7cQxd0xBrodKMJe
        NoNwovxFABNRfY9R9TUBYQ3T49GEyTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-41WqLou9PqyZ1lCdDTpJEA-1; Tue, 29 Oct 2019 06:03:47 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E21045E6;
        Tue, 29 Oct 2019 10:03:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7677B60863;
        Tue, 29 Oct 2019 10:03:44 +0000 (UTC)
Date:   Tue, 29 Oct 2019 06:03:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029100342.GA41131@bfoster>
References: <20191029034850.8212-1-david@fromorbit.com>
 <20191029041908.GB15222@magnolia>
 <20191029044133.GN4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191029044133.GN4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 41WqLou9PqyZ1lCdDTpJEA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 03:41:33PM +1100, Dave Chinner wrote:
> On Mon, Oct 28, 2019 at 09:19:08PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 29, 2019 at 02:48:50PM +1100, Dave Chinner wrote:
...
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 525b29b99116..865543e41fb4 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -817,6 +817,36 @@ xfs_file_fallocate(
> > >  =09if (error)
> > >  =09=09goto out_unlock;
> > > =20
...
> > > +=09/*
> > > +=09 * Now AIO and DIO has drained we flush and (if necessary) invali=
date
> > > +=09 * the cached range over the first operation we are about to run.
> > > +=09 *
> > > +=09 * We care about zero and collapse here because they both run a h=
ole
> > > +=09 * punch over the range first. Because that can zero data, and th=
e range
> > > +=09 * of invalidation for the shift operations is much larger, we st=
ill do
> > > +=09 * the required flush for collapse in xfs_prepare_shift().
> > > +=09 *
> > > +=09 * Insert has the same range requirements as collapse, and we ext=
end the
> > > +=09 * file first which can zero data. Hence insert has the same
> > > +=09 * flush/invalidate requirements as collapse and so they are both
> > > +=09 * handled at the right time by xfs_prepare_shift().
> > > +=09 */
> > > +=09if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> > > +=09=09    FALLOC_FL_COLLAPSE_RANGE)) {
> >=20
> > Er... "Insert has the same requirements as collapse", but we don't test
> > for that here?  Also ... xfs_prepare_shift handles flushing for both
> > collapse and insert range, but we still have to flush here for collapse=
?
> >
> > <confused but suspecting this has something to do with the fact that we
> > only do insert range after updating the isize?>
>=20
> Yes, exactly.
>=20
> The flush for collapse here is for the hole punch part of collapse,
> before we start shifting extents. insert does not hole punch, so it
> doesn't need flushing here but it still needs flush/inval before
> shifting. i.e.:
>=20
> collapse=09=09=09=09insert
>=20
> flush_unmap(off, len)
> punch hole(off, len)=09=09=09extends EOF
>   writes zeros around (off,len)=09=09  writes zeros around EOF
> collapse(off, len)=09=09=09insert(off, len)
>   flush_unmap(off, EOF)=09=09=09  flush_unmap(off, EOF)
>   shift extents down=09=09=09  shift extents up
>=20
> So once we start the actual extent shift operation (up or down)
> the flush/unmap requirements are identical.
>=20
> > I think the third paragraph of the comment is just confusing me more.
> > Does the following describe what's going on?
> >=20
> > "Insert range has the same range [should this be "page cache flushing"?=
]
> > requirements as collapse.  Because we can zero data as part of extendin=
g
> > the file size, we skip the flush here and let the flush in
> > xfs_prepare_shift take care of invalidating the page cache." ?
>=20
> It's a bit better - that's kinda what I was trying to describe - but
> I'll try to reword it more clearly after I've let it settle in my
> head for a little while....
>=20

I agree the comment is a little confusing because to me, it's just
describing a bit too much for its context. I.e., I read the comment and
have to go look at other code to make sure I grok the comment rather
than the comment helping me grok the code it's associated with.

FWIW, I find something like the following a bit more clear/concise on
the whole:

        /*
+        * Once AIO and DIO has drained we flush and (if necessary) invalid=
ate
+        * the cached range over the first operation we are about to run. W=
e
+        * include zero and collapse here because they both start with a ho=
le
+        * punch over the target range. Insert and collapse both invalidate=
 the
+        * broader range affected by the shift in xfs_prepare_shift().
         */

... because it points out why we special case collapse here, and that
otherwise the prepare shift code is responsible for the rest. Just my
.02 and otherwise the patch looks good to me.

Brian

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

