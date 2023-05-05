Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A7AC77B75
	for <linux-xfs@archiver.kernel.org>; Fri,  5 May 2023 19:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjEEToP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 May 2023 15:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbjEEToO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2023 15:44:14 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD2D2112
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2023 12:44:12 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b9a7e639656so3345919276.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 May 2023 12:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683315851; x=1685907851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvDT8zkuC4gVi0fnTc8i/Bkqd4YLxVEG0sioBwkCD+U=;
        b=CIPVHcOLQdhTXogN62Mw/fCOLjlOwNM45thZp55/G0Y+4E4NexnUvB3vOtM2suLjdz
         T1rh3EKQF9Q7DLBvkrQA96HMuJKK6ljz6sUoadVwmvME6+Lo2jBkjnaE4Kk2rVIFv44B
         GTEHr7cll/pqo289odi2h8zMjdKiN7hEFK7aVA5CoC+HI1oO5ICufh8JDIXrvRDAevnP
         hUDV1hbROSBKB8pVoWmLqfwYKVjSxXq1DDuUre5iez9QOh1dhd88hO/po3v9f9cizadN
         32jf30WJaDhnMzH+nura2GGWCByQoFHbfZBMyldKQhm6BHH1vM5Us1DoF2dmrL50knMa
         moaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683315851; x=1685907851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RvDT8zkuC4gVi0fnTc8i/Bkqd4YLxVEG0sioBwkCD+U=;
        b=QJUod2tTnCEXs3bwMS7DByU1sqDbAfZ8H8F4m+cwy+moeVTDJor7oB02JXIn4rI/KA
         nzgrFcI42qgKLUwRmVce8EyZnRpZ3sTzxANZIPsG1ZZIrj+y5BwTKFffCrw83nj0FYMu
         vcil7/QoffEwUrNYlKnxpnrnCG/DT1TVxc1+35eKysafrDreKIn8Ewh4gOuzgEGxToBv
         dncd6UyhX41PO3R+N1JkZ6vlyCyvOwqS6sXYs77aquvBx8gLR8DALvhZl5IDkW0h05ol
         XB8dcjJCYauG6SVrCiFa0y3Ib+iRiA1NflVKtiZNhKbRGOkSeEHnlSSBkIw514+vLCn4
         2rVA==
X-Gm-Message-State: AC+VfDz5Hu1OpUEb+xNIdRloqnmZNh4ZmMjI107WX6VOGWsP4fzISxSq
        YCyMpt35c8XmseoRei6OACQWEDR9MrD1zDZ7sJyMDQ==
X-Google-Smtp-Source: ACHHUZ47iup2wUFCWjaUVQFxudnhr3YZeYNUuAbCUUGTy47k/MsRgf5289v6Uo7/8hYFN/Owo0us95zjRkpUK8gmZes=
X-Received: by 2002:a05:6902:100e:b0:b9e:5008:1773 with SMTP id
 w14-20020a056902100e00b00b9e50081773mr3418662ybt.15.1683315851287; Fri, 05
 May 2023 12:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <4b9fc9c6-b48c-198f-5f80-811a44737e5f@suse.cz> <CAANmLtwGS75WJ9AXfmqZv73pNdHJn6zfrrCCWjKK_6jPk9pWRg@mail.gmail.com>
 <951d364a-05c0-b290-8abe-7cbfcaeb2df7@suse.cz> <CAANmLtzQmVN_EWLv1UxXwZu5X=TwpcMQMYArKNUxAJL3PnfO2Q@mail.gmail.com>
 <19acbdbb-fc2f-e198-3d31-850ef53f544e@suse.cz>
In-Reply-To: <19acbdbb-fc2f-e198-3d31-850ef53f544e@suse.cz>
From:   Binder Makin <merimus@google.com>
Date:   Fri, 5 May 2023 15:44:00 -0400
Message-ID: <CAANmLty+yVqN74p_w8VX6=LBTioVKS+b6SHMwoJonoUXgqeXng@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] SLOB+SLAB allocators removal and future SLUB improvements
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org,
        bpf@vger.kernel.org, linux-xfs@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Here are the results of my research.
One doc is an overview fo the data and the other is a pdf of the raw data.

https://drive.google.com/file/d/1DE8QMri1Rsr7L27fORHFCmwgrMtdfPfu/view?usp=
=3Dshare_link

https://drive.google.com/file/d/1UwnTeqsKB0jgpnZodJ0_cM2bOHx5aR_v/view?usp=
=3Dshare_link

On Thu, Apr 27, 2023 at 4:29=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 4/5/23 21:54, Binder Makin wrote:
> > I'm still running tests to explore some of these questions.
> > The machines I am using are roughly as follows.
> >
> > Intel dual socket 56 total cores
> > 192-384GB ram
> > LEVEL1_ICACHE_SIZE                 32768
> > LEVEL1_DCACHE_SIZE                 32768
> > LEVEL2_CACHE_SIZE                  1048576
> > LEVEL3_CACHE_SIZE                  40370176
> >
> > Amd dual socket 128 total cores
> > 1TB ram
> > LEVEL1_ICACHE_SIZE                 32768
> > LEVEL1_DCACHE_SIZE                 32768
> > LEVEL2_CACHE_SIZE                  524288
> > LEVEL3_CACHE_SIZE                  268435456
> >
> > Arm single socket 64 total cores
> > 256GB rma
> > LEVEL1_ICACHE_SIZE                 65536
> > LEVEL1_DCACHE_SIZE                 65536
> > LEVEL2_CACHE_SIZE                  1048576
> > LEVEL3_CACHE_SIZE                  33554432
>
> So with "some artifact of different cache layout" I didn't mean the
> different cache sizes of the processors, but possible differences how
> objects end up placed in memory by SLAB vs SLUB causing them to collide i=
n
> the cache of cause false sharing less or more. This kind of interference =
can
> make interpreting (micro)benchmark results hard.
>
> Anyway, how I'd hope to approach this topic would be that SLAB removal is
> proposed, and anyone who opposes that because they can't switch from SLAB=
 to
> SLUB would describe why they can't. I'd hope the "why" to be based on
> testing with actual workloads, not just benchmarks. Benchmarks are then o=
f
> course useful if they can indeed distill the reason why the actual worklo=
ad
> regresses, as then anyone can reproduce that locally and develop/test fix=
es
> etc. My hope is that if some kind of regression is found (e.g. due to lac=
k
> of percpu array in SLUB), it can be dealt with by improving SLUB.
>
> Historically I recall that we (SUSE) objected somwhat to SLAB removal as =
our
> distro kernels were using it, but we have switched since. Then networking
> had concerns (possibly related to the lack percpu array) but seems bulk
> allocations helped and they use SLUB these days [1]. And IIRC Google was
> also sticking to SLAB, which led to some attempts to augment SLUB for tho=
se
> workloads years ago, but those were never finished. So I'd be curious if =
we
> should restart those effors or can just remove SLAB now.
>
> [1] https://lore.kernel.org/all/93665604-5420-be5d-2104-17850288b955@redh=
at.com/
>
>
