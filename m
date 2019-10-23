Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168D3CA9EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 11:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E6121920
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 11:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvpiKoa6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404675AbfJWLJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:09:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391108AbfJWLJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 07:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571828946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9IA8945RsCuYLOBbLvHMiKvUUr1LmedugEbDUkOV8Y=;
        b=hvpiKoa6DXTtfFkaqOxC6KjrasE4EKsWLpVt/m+8EyYZBYc+gL4eskcuHodyoZJS/S5ZbN
        CoSoCOGOnV4Vdr/ruU7Zri7wcUUYHZWBNEhAAmm/EaPktsPmIdXam6rLFx9J5Imf7iTMoc
        lcUhJ9xpbbPoP7v7ge+xP70sTI73FEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-iHNvk4BYPVm5e3OroiM7wQ-1; Wed, 23 Oct 2019 07:09:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B009A80183D;
        Wed, 23 Oct 2019 11:09:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A9135C1D8;
        Wed, 23 Oct 2019 11:09:03 +0000 (UTC)
Date:   Wed, 23 Oct 2019 07:09:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add a repair revalidation function pointer
Message-ID: <20191023110901.GA59518@bfoster>
References: <157063977277.2913625.2221058732448775822.stgit@magnolia>
 <157063977906.2913625.11610063964985485066.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063977906.2913625.11610063964985485066.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: iHNvk4BYPVm5e3OroiM7wQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:39AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Allow repair functions to set a separate function pointer to validate
> the metadata that they've rebuilt.  This prevents us from exiting from a
> repair function that rebuilds both A and B without checking that both A
> and B can pass a scrub test.  We'll need this for the free space and
> inode btree repair strategies.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems reasonable, but perhaps should be placed along with the first
patch that uses the callback..

Brian

>  fs/xfs/scrub/scrub.c |    5 ++++-
>  fs/xfs/scrub/scrub.h |    8 ++++++++
>  2 files changed, 12 insertions(+), 1 deletion(-)
>=20
>=20
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 15c8c5f3f688..0f0b64d7164b 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -495,7 +495,10 @@ xfs_scrub_metadata(
>  =09=09goto out_teardown;
> =20
>  =09/* Scrub for errors. */
> -=09error =3D sc.ops->scrub(&sc);
> +=09if ((sc.flags & XREP_ALREADY_FIXED) && sc.ops->repair_eval !=3D NULL)
> +=09=09error =3D sc.ops->repair_eval(&sc);
> +=09else
> +=09=09error =3D sc.ops->scrub(&sc);
>  =09if (!(sc.flags & XCHK_TRY_HARDER) && error =3D=3D -EDEADLOCK) {
>  =09=09/*
>  =09=09 * Scrubbers return -EDEADLOCK to mean 'try harder'.
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index ad1ceb44a628..94a30637a127 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -27,6 +27,14 @@ struct xchk_meta_ops {
>  =09/* Repair or optimize the metadata. */
>  =09int=09=09(*repair)(struct xfs_scrub *);
> =20
> +=09/*
> +=09 * Re-scrub the metadata we repaired, in case there's extra work that
> +=09 * we need to do to check our repair work.  If this is NULL, we'll us=
e
> +=09 * the ->scrub function pointer, assuming that the regular scrub is
> +=09 * sufficient.
> +=09 */
> +=09int=09=09(*repair_eval)(struct xfs_scrub *sc);
> +
>  =09/* Decide if we even have this piece of metadata. */
>  =09bool=09=09(*has)(struct xfs_sb *);
> =20
>=20

