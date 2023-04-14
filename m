Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55257C77B76
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 23:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDNXMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 19:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDNXMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 19:12:22 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EB76A4B
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 16:12:20 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id rp27so12425582ejb.12
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 16:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681513939; x=1684105939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQD1oso+8ADTrmZywcy5/ZWb5KiX0kq22/9gdYr2fT0=;
        b=rqz6hoGlruHKPc5t2bxSsCjJ0q8fLUfCjDlhl4Z5UjfIBNLVoqdHRwpUspz3jYAZNl
         f2vofoEu2tP1aZLwxjiF8wqjCmLPyk2fhSgT6bIqpEi5T7lKgWxLmMIvDyPKYYPdytt4
         0nzGQ667jAg9GOBlcF6dDnqE+apDZpaXthStELBKtqOKxcyoTD2j9OXN3rWM9uHm2XUe
         N1V7S4e4JntnuWAJxmosdJjiIoC0YQPvFtLV84JtHYBi/kBrs4jYzueDnngMYASwCDZy
         WtYQLvayq7pTuprvd4phPV8N3kXKSN0VwNR/SuNsTRnEjL4i8iN6/xkGqGgGY6QAAvn2
         cSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681513939; x=1684105939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rQD1oso+8ADTrmZywcy5/ZWb5KiX0kq22/9gdYr2fT0=;
        b=Ks4YJRI4vXxR1ULt3jCilt38H1FMefbYh/1JCGWoEL+BLuBqlfVlTJcgKaVOtKCQHQ
         lQxvOBbqMFRhtF/LPItQlyc5kq/nbj3IESF63JqtmUpIWgOb7APDVclIbPy/Wl7Jn6p6
         QOA64ZN/2BJtpoeLsBKX4gobP8GLhG1+lICzG9IRDwe4s7B6TaYVmNVwgOM5Ki0+DKoW
         5fFqlh/LmSCY+fRbHgk82soJj4o3vBFkl40zhSdTDeA5xi7vMYTeII3Y6uagwYeg/MaM
         fa00u1udbYZmXb1QBE+tnHoJYHzLhBeKXucyRt+VA9vqj+Ul1Vh3OVvt4qHlNaFiTOfL
         mZQg==
X-Gm-Message-State: AAQBX9dsoTU8WyoxVsdubNQqpv94GkUNWVLftb8yo2jXVxAzeMmjDFVZ
        bVhA5Ci4R8+tvltVfeLx3rQBjF8pJS1KfoKmHD9hXA==
X-Google-Smtp-Source: AKy350ZVW/SeKKN7bQaip/vQ/ZivEBvqqS/RV2NR13bc/DeeXMLJdi7ZYfPWAWzE33zqe1KsI8fspxB3C5u2WkZCZxI=
X-Received: by 2002:a17:906:4c49:b0:94b:d619:e773 with SMTP id
 d9-20020a1709064c4900b0094bd619e773mr320456ejw.15.1681513938572; Fri, 14 Apr
 2023 16:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230413104034.1086717-1-yosryahmed@google.com>
 <20230413104034.1086717-4-yosryahmed@google.com> <b7fe839d-d914-80f7-6b96-f5f3a9d0c9b0@redhat.com>
 <CAJD7tkae0uDuRG77nQEtzkV1abGstjF-1jfsCguR3jLNW=Cg5w@mail.gmail.com>
 <20230413210051.GO3223426@dread.disaster.area> <CAJD7tkbzQb+gem-49xo8=1EfeOttiHZpD4X-iiWvHuO9rrHuog@mail.gmail.com>
 <20230414144704.2e411d40887c8e9e25ab2864@linux-foundation.org>
In-Reply-To: <20230414144704.2e411d40887c8e9e25ab2864@linux-foundation.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 14 Apr 2023 16:11:42 -0700
Message-ID: <CAJD7tkZOkd17UubA5FwrphEFTx+ZhXikFVEEXpVt6159QSC4og@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] mm: vmscan: refactor updating current->reclaim_state
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2023 at 2:47=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 13 Apr 2023 14:38:03 -0700 Yosry Ahmed <yosryahmed@google.com> wr=
ote:
>
> > > > I suck at naming things. If you think "reclaimed_non_lru" is better=
,
> > > > then we can do that. FWIW mm_account_reclaimed_pages() was taken fr=
om
> > > > a suggestion from Dave Chinner. My initial version had a terrible
> > > > name: report_freed_pages(), so I am happy with whatever you see fit=
.
> > > >
> > > > Should I re-spin for this or can we change it in place?
> > >
> > > I don't care for the noise all the bikeshed painting has generated
> > > for a simple change like this.  If it's a fix for a bug, and the
> > > naming is good enough, just merge it already, ok?
> >
> > Sorry for all the noise. I think this version is in good enough shape.
> >
> > Andrew, could you please replace v4 with this v6 without patch 2 as
> > multiple people pointed out that it is unneeded? Sorry for the hassle.
>
> I like patch 2!
>
> mm.git presently has the v6 series.  All of it ;)

Thanks Andrew :)
