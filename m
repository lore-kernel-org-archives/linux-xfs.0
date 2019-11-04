Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048A8CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB61D206BA
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTZ6Juf7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfKDT6a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:58:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33225 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728377AbfKDT6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572897508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lkBYtSzKV/Kwm8B3nhsv0o/3UX/Nlvg/fNGCU4aCrGk=;
        b=jTZ6Juf7UukIJJHiAlRliZhA6uAD38ovgMIrDgoPgLKxJW5DEw+g/eBsb0TnrPOsdqpmvJ
        gg/POuePWzBeMV1JEO8YLdsf/C7tBgutFilA7LIiAg5Q9Py0JKNKUTV2Yk8RfYw07RwfaK
        HWA6scUD52VBapeJX0RUMwFcBAXYhNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-VjuK4indOtWNMy0qpFSljg-1; Mon, 04 Nov 2019 14:58:25 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6F27107ACC2;
        Mon,  4 Nov 2019 19:58:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 240B75D9E5;
        Mon,  4 Nov 2019 19:58:24 +0000 (UTC)
Date:   Mon, 4 Nov 2019 14:58:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/28] mm: back off direct reclaim on excessive shrinker
 deferral
Message-ID: <20191104195822.GF10665@bfoster>
References: <20191031234618.15403-1-david@fromorbit.com>
 <20191031234618.15403-16-david@fromorbit.com>
MIME-Version: 1.0
In-Reply-To: <20191031234618.15403-16-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: VjuK4indOtWNMy0qpFSljg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 10:46:05AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>=20
> When the majority of possible shrinker reclaim work is deferred by
> the shrinkers (e.g. due to GFP_NOFS context), and there is more work
> defered than LRU pages were scanned, back off reclaim if there are

  deferred

> large amounts of IO in progress.
>=20
> This tends to occur when there are inode cache heavy workloads that
> have little page cache or application memory pressure on filesytems
> like XFS. Inode cache heavy workloads involve lots of IO, so if we
> are getting device congestion it is indicative of memory reclaim
> running up against an IO throughput limitation. in this situation
> we need to throttle direct reclaim as we nee dto wait for kswapd to

=09=09=09=09=09   need to

> get some of the deferred work done.
>=20
> However, if there is no device congestion, then the system is
> keeping up with both the workload and memory reclaim and so there's
> no need to throttle.
>=20
> Hence we should only back off scanning for a bit if we see this
> condition and there is block device congestion present.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/linux/swap.h |  2 ++
>  mm/vmscan.c          | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 72b855fe20b0..da0913e14bb9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -131,6 +131,8 @@ union swap_header {
>   */
>  struct reclaim_state {
>  =09unsigned long=09reclaimed_pages;=09/* pages freed by shrinkers */
> +=09unsigned long=09scanned_objects;=09/* quantity of work done */=20

Trailing whitespace at the end of the above line.

> +=09unsigned long=09deferred_objects;=09/* work that wasn't done */
>  };
> =20
>  /*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 967e3d3c7748..13c11e10c9c5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -570,6 +570,8 @@ static unsigned long do_shrink_slab(struct shrink_con=
trol *shrinkctl,
>  =09=09deferred_count =3D min(deferred_count, freeable_objects * 2);
> =20
>  =09}
> +=09if (current->reclaim_state)
> +=09=09current->reclaim_state->scanned_objects +=3D scanned_objects;

Looks like scanned_objects is always zero here.

> =20
>  =09/*
>  =09 * Avoid risking looping forever due to too large nr value:
> @@ -585,8 +587,11 @@ static unsigned long do_shrink_slab(struct shrink_co=
ntrol *shrinkctl,
>  =09 * If the shrinker can't run (e.g. due to gfp_mask constraints), then
>  =09 * defer the work to a context that can scan the cache.
>  =09 */
> -=09if (shrinkctl->defer_work)
> +=09if (shrinkctl->defer_work) {
> +=09=09if (current->reclaim_state)
> +=09=09=09current->reclaim_state->deferred_objects +=3D scan_count;
>  =09=09goto done;
> +=09}
> =20
>  =09/*
>  =09 * Normally, we should not scan less than batch_size objects in one
> @@ -2871,7 +2876,30 @@ static bool shrink_node(pg_data_t *pgdat, struct s=
can_control *sc)
> =20
>  =09=09if (reclaim_state) {
>  =09=09=09sc->nr_reclaimed +=3D reclaim_state->reclaimed_pages;
> +
> +=09=09=09/*
> +=09=09=09 * If we are deferring more work than we are actually
> +=09=09=09 * doing in the shrinkers, and we are scanning more
> +=09=09=09 * objects than we are pages, the we have a large amount
> +=09=09=09 * of slab caches we are deferring work to kswapd for.
> +=09=09=09 * We better back off here for a while, otherwise
> +=09=09=09 * we risk priority windup, swap storms and OOM kills
> +=09=09=09 * once we empty the page lists but still can't make
> +=09=09=09 * progress on the shrinker memory.
> +=09=09=09 *
> +=09=09=09 * kswapd won't ever defer work as it's run under a
> +=09=09=09 * GFP_KERNEL context and can always do work.
> +=09=09=09 */
> +=09=09=09if ((reclaim_state->deferred_objects >
> +=09=09=09=09=09sc->nr_scanned - nr_scanned) &&

Out of curiosity, what's the reasoning behind the direct comparison
between ->deferred_objects and pages? Shouldn't we generally expect more
slab objects to exist than pages by the nature of slab?

Also, the comment says "if we are scanning more objects than we are
pages," yet the code is checking whether we defer more objects than
scanned pages. Which is more accurate?

Brian

> +=09=09=09    (reclaim_state->deferred_objects >
> +=09=09=09=09=09reclaim_state->scanned_objects)) {
> +=09=09=09=09wait_iff_congested(BLK_RW_ASYNC, HZ/50);
> +=09=09=09}
> +
>  =09=09=09reclaim_state->reclaimed_pages =3D 0;
> +=09=09=09reclaim_state->deferred_objects =3D 0;
> +=09=09=09reclaim_state->scanned_objects =3D 0;
>  =09=09}
> =20
>  =09=09/* Record the subtree's reclaim efficiency */
> --=20
> 2.24.0.rc0
>=20

