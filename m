Return-Path: <SRS0=3CCN=ZH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29ACBC43215
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 20:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0234020732
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Nov 2019 20:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JyPzatW/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKOU0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Nov 2019 15:26:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39107 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726323AbfKOU0L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Nov 2019 15:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573849570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bYyZAMiEfGQqfQDWxBcObl5DnDYfiFtCAqpH216cVZ0=;
        b=JyPzatW/pVsOu4Md6RnZq2BemL3his7q3FFMrJrmgXOa1XfLFc1JMRS5ZiIA2ryWKjHEC+
        kTBFyIch86RAeIYhWWkfX72QGNb7ZNDpZtXbOTq60EN2CVSF3F73RAw4Hs/KxG49+dF8RX
        FqUK4CY6S6MzsnQcS6USz4fGf7FliJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-Dvs50AKpNF6P88B6yucy0A-1; Fri, 15 Nov 2019 15:26:07 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C52802682;
        Fri, 15 Nov 2019 20:26:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E401966093;
        Fri, 15 Nov 2019 20:26:05 +0000 (UTC)
Date:   Fri, 15 Nov 2019 15:26:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix attr leaf header freemap.size underflow
Message-ID: <20191115202604.GD55854@bfoster>
References: <20191115114137.55415-1-bfoster@redhat.com>
 <20191115185955.GP6219@magnolia>
MIME-Version: 1.0
In-Reply-To: <20191115185955.GP6219@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Dvs50AKpNF6P88B6yucy0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 10:59:55AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 15, 2019 at 06:41:37AM -0500, Brian Foster wrote:
> > The leaf format xattr addition helper xfs_attr3_leaf_add_work()
> > adjusts the block freemap in a couple places. The first update drops
> > the size of the freemap that the caller had already selected to
> > place the xattr name/value data. Before the function returns, it
> > also checks whether the entries array has encroached on a freemap
> > range by virtue of the new entry addition. This is necessary because
> > the entries array grows from the start of the block (but end of the
> > block header) towards the end of the block while the name/value data
> > grows from the end of the block in the opposite direction. If the
> > associated freemap is already empty, however, size is zero and the
> > subtraction underflows the field and causes corruption.
> >=20
> > This is reproduced rarely by generic/070. The observed behavior is
> > that a smaller sized freemap is aligned to the end of the entries
> > list, several subsequent xattr additions land in larger freemaps and
> > the entries list expands into the smaller freemap until it is fully
> > consumed and then underflows. Note that it is not otherwise a
> > corruption for the entries array to consume an empty freemap because
> > the nameval list (i.e. the firstused pointer in the xattr header)
> > starts beyond the end of the corrupted freemap.
> >=20
> > Update the freemap size modification to account for the fact that
> > the freemap entry can be empty and thus stale.
> >=20
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
>=20
> Hm.  freemap.size =3D=3D 0 means the freemap entry is stale and therefore
> anything looking for free space in the leaf will ignore the entry, right?
>=20

Yep, at least that's my understanding from the code in the caller that
explicitly checks for and skips freemaps where size =3D=3D 0.

> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20

Thanks!

Brian

> (Urk, there are still a lot of ASSERT-on-metadata in the dir/attr
> code...)
>=20
> --D
>=20
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_lea=
f.c
> > index 85ec5945d29f..86155260d8b9 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -1510,7 +1510,9 @@ xfs_attr3_leaf_add_work(
> >  =09for (i =3D 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
> >  =09=09if (ichdr->freemap[i].base =3D=3D tmp) {
> >  =09=09=09ichdr->freemap[i].base +=3D sizeof(xfs_attr_leaf_entry_t);
> > -=09=09=09ichdr->freemap[i].size -=3D sizeof(xfs_attr_leaf_entry_t);
> > +=09=09=09ichdr->freemap[i].size -=3D
> > +=09=09=09=09min_t(uint16_t, ichdr->freemap[i].size,
> > +=09=09=09=09=09=09sizeof(xfs_attr_leaf_entry_t));
> >  =09=09}
> >  =09}
> >  =09ichdr->usedbytes +=3D xfs_attr_leaf_entsize(leaf, args->index);
> > --=20
> > 2.20.1
> >=20
>=20

