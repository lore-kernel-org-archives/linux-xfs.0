Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB68C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 02:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiDNCEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiDNCEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 22:04:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060863DA73
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 19:02:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j8so3468075pll.11
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 19:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z/AZcNPpuzZDgumlPPShqA1y0wj8q3uDg5REQ7nWe+g=;
        b=CwUaIxkVnLJ5l46nXB2s1sou59hINQM/ZRPp8PgQSytaOTFdj5NPDAXKC18NHxovTf
         CNDUOsT39v7D12dS5ZQ5VyZCYQgsubRrs6eE1p6NOiKJwAVQat/29+jKEAzO88iWgLjp
         HPfJAccDb5kf57+DK4SqQvGN9fk4p69oMWY/rZMpZW5mukjDtmuPneOpczL+g866T1zU
         8H97LSBoYZFA4oXZ1O7XIzloSk/4XvVfoFgijXJAOAP7uz+a0wUxgTYGwM3ohg2+IOV1
         xRawiPehfXvAI+97iMxaM4Bw3aLd8i2lcauheW1rlBaAIR435lzflqVSUD5yc2Jx95Ia
         w1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z/AZcNPpuzZDgumlPPShqA1y0wj8q3uDg5REQ7nWe+g=;
        b=kYYzkdQTWsucBnZ3pGwKTzpNsvzs87fioPYvVclqWIxgwK63DECd4OSlNj4SO+trLY
         cyHUoi+ytZNVR6gTER30qHJkhZcs/zQw/uQqJHBjf444an57J5Ygv2mZ3jjVyXWVKUvl
         qIqvNtoiou9t7azstSfX8hHI0maUi1dO6vpCCv8eFy73ufGOYgFnFCY7t6VckcrmAwGF
         Yn/YmJdPeEX6/FAxv2LCf3Gmj9U8TxxUF43NNRAAIAI/kFhuBwd4iLi2SwGe/erqo63a
         aF55xLFbGM5Z4eAPmLeb5CMc8ZYy+gQ+ZhMEctCrw2kgBSGp03u/AvZSZ2WbjwhaUieM
         wdjQ==
X-Gm-Message-State: AOAM533sztnHPJDmF2i1oxvSDoxVuaLh+c8Oq1JgyCr9ycqgc6pQj5Ra
        EJOGO8yis+wqKfSqUyCM7bXAz7dyo/TyPRTj92JHDw==
X-Google-Smtp-Source: ABdhPJwLDKKH3DT9JFgarja/Tnh6p2mmAGJ/wOpJuSGyolYLRI59NHTREVIMzFOVSkYOQVAxzofLTctfLriOkXyPajc=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr1171605pjd.220.1649901734577; Wed, 13
 Apr 2022 19:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-6-jane.chu@oracle.com>
 <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com> <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
In-Reply-To: <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 13 Apr 2022 19:02:03 -0700
Message-ID: <CAPcyv4jrtUDf0zPB8aefVs2MsV8tW2Kmx2yq3D4ze2wr7SshsA@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
To:     Jane Chu <jane.chu@oracle.com>
Cc:     david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 13, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/11/2022 9:26 PM, Dan Williams wrote:
> > On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> Refactor the pmem_clear_poison() in order to share common code
> >> later.
> >>
> >
> > I would just add a note here about why, i.e. to factor out the common
> > shared code between the typical write path and the recovery write
> > path.
>
> Okay.
>
> >
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> >> ---
> >>   drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
> >>   1 file changed, 52 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index 0400c5a7ba39..56596be70400 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
> >>          return to_nd_region(to_dev(pmem)->parent);
> >>   }
> >>
> >> -static void hwpoison_clear(struct pmem_device *pmem,
> >> -               phys_addr_t phys, unsigned int len)
> >> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
> >>   {
> >> +       return (pmem->phys_addr + offset);
> >
> > Christoph already mentioned dropping the unnecessary parenthesis.
> >
> >> +}
> >> +
> >> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> >> +{
> >> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
> >> +}
> >> +
> >> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> >> +{
> >> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
> >> +}
> >> +
> >> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> >> +               unsigned int len)
> >
> > Perhaps now is a good time to rename this to something else like
> > pmem_clear_mce_nospec()? Just to make it more distinct from
> > pmem_clear_poison(). While "hwpoison" is the page flag name
> > pmem_clear_poison() is the function that's actually clearing the
> > poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
> > toggling the page back into service.
>
> I get your point. How about calling the function explicitly
> pmem_mkpage_present()?

Sure, I like pmem_mkpage_present().
