Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6F4CA9EB6
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 11:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFAF20650
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 11:09:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D55ui1aX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404682AbfJWLJN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:09:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404671AbfJWLJN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 07:09:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571828952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gfXmwu2lhDZC6VCGE5S+M1vLmt9jgw+7cPbOUwKhndM=;
        b=D55ui1aXhyaNN163v6gIvSeKOZZkDPaHorK45iYOJhNaueDrRQHnUz0rj49oujKzIjlkKT
        OHMALFvos9HDZvNmByIF4X01V5pUk329gQ/BcVVnQdAgxBZXDy5jbSa7IcuBH2RilKV1rC
        rp+w6owZvgDb50mQLjHAyIkti4M2/tY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-ETltSF0BN-iy7DLJd69bmQ-1; Wed, 23 Oct 2019 07:09:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70CE980183D;
        Wed, 23 Oct 2019 11:09:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BBF91001B33;
        Wed, 23 Oct 2019 11:09:10 +0000 (UTC)
Date:   Wed, 23 Oct 2019 07:09:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: always rescan allegedly healthy per-ag metadata
 after repair
Message-ID: <20191023110908.GB59518@bfoster>
References: <157063977277.2913625.2221058732448775822.stgit@magnolia>
 <157063978533.2913625.15756257326965494318.stgit@magnolia>
MIME-Version: 1.0
In-Reply-To: <157063978533.2913625.15756257326965494318.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ETltSF0BN-iy7DLJd69bmQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 09:49:45AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> After an online repair function runs for a per-AG metadata structure,
> sc->sick_mask is supposed to reflect the per-AG metadata that the repair
> function fixed.  Our next move is to re-check the metadata to assess
> the completeness of our repair, so we don't want the rebuilt structure
> to be excluded from the rescan just because the health system previously
> logged a problem with the data structure.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/health.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
>=20
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index b2f602811e9d..4865b2180e22 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -220,6 +220,16 @@ xchk_ag_btree_healthy_enough(
>  =09=09return true;
>  =09}
> =20
> +=09/*
> +=09 * If we just repaired some AG metadata, sc->sick_mask will reflect a=
ll
> +=09 * the per-AG metadata types that were repaired.  Exclude these from
> +=09 * the filesystem health query because we have not yet updated the
> +=09 * health status and we want everything to be scanned.
> +=09 */
> +=09if ((sc->flags & XREP_ALREADY_FIXED) &&
> +=09    type_to_health_flag[sc->sm->sm_type].group =3D=3D XHG_AG)
> +=09=09mask &=3D ~sc->sick_mask;
> +
>  =09if (xfs_ag_has_sickness(pag, mask)) {
>  =09=09sc->sm->sm_flags |=3D XFS_SCRUB_OFLAG_XFAIL;
>  =09=09return false;
>=20

