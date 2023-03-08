Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A1EC678D5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 20:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCHUYu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCHUYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 15:24:49 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3C198EA1
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 12:24:47 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j11so51098699edq.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 12:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678307085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJfFbUmgGUScXMrHUtC6nJ4LuBCrcr+wpYFFKWYzLa4=;
        b=o/nsGMQwyJSyGnHOaJZ06vhDo7pQRTGJnGgRc2GkdIX8tL/JrJNihRgGtItCqra05u
         Mpglt4V8nw2Y0N7HHUcfHaU6DSqbI5Esby3sZnLHFwDug6+f+ERSBO1kDAvlWUcLy4Iz
         EUjxKYQJU4dp7dvauql5hEfgt92xodqjfo1EbgWHP/i5VfOd9guQwgfOqrN6AmwpylOS
         cAn9CH52xfCJFsW2smQjZlDx52NZKSQJxKXKf+N5j2lwS4Fg/w3T8gwLYKVLBuwTEqLK
         WwFPcyDpny2UQ3ih/aa3+qnG02G20L8Qs86UMI0J4RosGpmcUBFIc+kvPPSYcbT4LudJ
         sKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678307085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJfFbUmgGUScXMrHUtC6nJ4LuBCrcr+wpYFFKWYzLa4=;
        b=YqPu4TBkYpWgMZ5IXxMd6ro3hCIaTOVgOIWgiuIldEkNe4d3XMYd8xheip8f3hXgoe
         Ni23VHVs9ODovhLm8jHSPIgi4U/yIPUFx7zeTIsRoGDFh3CbX38JLvABLKJnpo2cNB/8
         c29i1V7JkA79riLhG13Ca7PRSbYcoUf/xWLtiMyiczTfcI385TcZAz0udKK6QfElcKDL
         79oOJArEaenoDTumd8HHO89FaQaSJEwuSEM7z2pMeouR/WcH7yFqPLFeR8AIxDn1x545
         qTTwpGApPD5EFX9iDp0bGnn6CoHri77OMz2AKc3jyUsyavhC09LpsPVTO6uzOID0vY51
         5IWg==
X-Gm-Message-State: AO0yUKX0W3+n04FwJcEvd7N9K9Jk/yMs4AiS9LPWHjUn1JHfhi9wdsE2
        2E258B4Nj5eNcNdKyxXfLpFxXgmrY16GCvOdjneQig==
X-Google-Smtp-Source: AK7set+DV9RxenSdhDCOFgakZZcsnB5QX/El2Wvkj9fjCVlQsjhbhU0QFrcMSUEA/hLFDWBIFA8W0HOSXVt6Xx+KiFY=
X-Received: by 2002:a17:906:b11a:b0:8f8:edfc:b68b with SMTP id
 u26-20020a170906b11a00b008f8edfcb68bmr9931531ejy.6.1678307085464; Wed, 08 Mar
 2023 12:24:45 -0800 (PST)
MIME-Version: 1.0
References: <20230228085002.2592473-1-yosryahmed@google.com>
 <20230308160056.GA414058@cmpxchg.org> <CAJD7tka=6b-U3m0FdMoP=9nC8sYuJ9thghb9muqN5hQ5ZMrDag@mail.gmail.com>
 <20230308201629.GB476158@cmpxchg.org>
In-Reply-To: <20230308201629.GB476158@cmpxchg.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 8 Mar 2023 12:24:08 -0800
Message-ID: <CAJD7tkbDN2LUG_EZHV8VZd3M4-wtY9TCO5uS2c5qvqEWpoMvoA@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Ignore non-LRU-based reclaim in memcg reclaim
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 8, 2023 at 12:16=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Wed, Mar 08, 2023 at 10:01:24AM -0800, Yosry Ahmed wrote:
> > On Wed, Mar 8, 2023 at 8:00=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.=
org> wrote:
> > >
> > > Hello Yosry,
> > >
> > > On Tue, Feb 28, 2023 at 08:50:00AM +0000, Yosry Ahmed wrote:
> > > > Reclaimed pages through other means than LRU-based reclaim are trac=
ked
> > > > through reclaim_state in struct scan_control, which is stashed in
> > > > current task_struct. These pages are added to the number of reclaim=
ed
> > > > pages through LRUs. For memcg reclaim, these pages generally cannot=
 be
> > > > linked to the memcg under reclaim and can cause an overestimated co=
unt
> > > > of reclaimed pages. This short series tries to address that.
> > >
> > > Could you please add more details on how this manifests as a problem
> > > with real workloads?
> >
> > We haven't observed problems in production workloads, but we have
> > observed problems in testing using memory.reclaim when sometimes a
> > write to memory.reclaim would succeed when we didn't fully reclaim the
> > requested amount. This leads to tests flaking sometimes, and we have
> > to look into the failures to find out if there is a real problem or
> > not.
>
> Ah, that would be great to have in the cover letter. Thanks!

Will do in the next version.

>
> Have you also tested this patch against prod without memory.reclaim?
> Just to make sure there are no problems with cgroup OOMs or
> similar. There shouldn't be, but, you know...

Honestly, no. I was debugging a test flake and I spotted that this was
the cause, came up with patches to address it, and sent it to the
mailing list for feedback. We did not want to merge it internally if
it's not going to land upstream -- with the rationale that making the
test more tolerant might be better than maintaining the patch
internally, although that is not ideal of course (as it can hide
actual failures from different sources).

>
> > > > Patch 1 is just refactoring updating reclaim_state into a helper
> > > > function, and renames reclaimed_slab to just reclaimed, with a comm=
ent
> > > > describing its true purpose.
> > >
> > > Looking through the code again, I don't think these helpers add value=
.
> > >
> > > report_freed_pages() is fairly vague. Report to who? It abstracts onl=
y
> > > two lines of code, and those two lines are more descriptive of what's
> > > happening than the helper is. Just leave them open-coded.
> >
> > I agree the name is not great, I am usually bad at naming things and
> > hope people would point that out (like you're doing now). The reason I
> > added it is to contain the logic within mm/vmscan.c such that future
> > changes do not have to add noisy diffs to a lot of unrelated files. If
> > you have a better name that makes more sense to you please let me
> > know, otherwise I'm fine dropping the helper as well, no strong
> > opinions here.
>
> I tried to come up with something better, but wasn't happy with any of
> the options, either. So I defaulted to just leaving it alone :-)
>
> It's part of the shrinker API and the name hasn't changed since the
> initial git import of the kernel tree. It should be fine, churn-wise.

Last attempt, just update_reclaim_state() (corresponding to
flush_reclaim_state() below). It doesn't tell a story, but neither
does incrementing a counter in current->reclaim_state. If that doesn't
make you happy I'll give up now and leave it as-is :)

>
> > > add_non_vmanscan_reclaimed() may or may not add anything. But let's
> > > take a step back. It only has two callsites because lrugen duplicates
> > > the entire reclaim implementation, including the call to shrink_slab(=
)
> > > and the transfer of reclaim_state to sc->nr_reclaimed.
> > >
> > > IMO the resulting code would overall be simpler, less duplicative and
> > > easier to follow if you added a common shrink_slab_reclaim() that
> > > takes sc, handles the transfer, and documents the memcg exception.
> >
> > IIUC you mean something like:
> >
> > void shrink_slab_reclaim(struct scan_control *sc, pg_data_t *pgdat,
> > struct mem_cgroup *memcg)
> > {
> >     shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
> >
> >     /* very long comment */
> >     if (current->reclaim_state && !cgroup_reclaim(sc)) {
> >         sc->nr_reclaimed +=3D current->reclaim_state->reclaimed;
> >         current->reclaim_state->reclaimed =3D 0;
> >     }
> > }
>
> Sorry, I screwed up, that doesn't actually work.
>
> reclaim_state is used by buffer heads freed in shrink_folio_list() ->
> filemap_release_folio(). So flushing the count cannot be shrink_slab()
> specific. Bummer. Your patch had it right by making a helper for just
> flushing the reclaim state. But add_non_vmscan_reclaimed() is then
> also not a great name because these frees are directly from vmscan.
>
> Maybe simply flush_reclaim_state()?

Sounds good and simple enough, I will use that for the next version.

>
> As far as the name reclaimed_slab, I agree it's not optimal, although
> 90% accurate ;-) I wouldn't mind a rename to just 'reclaimed'.

Got it.
