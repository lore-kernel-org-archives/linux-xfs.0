Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18153C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345328AbiDKWJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiDKWJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:09:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E4020F42
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 15:07:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d15so15035899pll.10
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 15:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uGTALhbZONK07EnTqNzLb5OFo7sOJ1WnH/JS/fksxZ4=;
        b=qW44w090em7gPbYvbMftkAX4Kvke2EP4xsZopvyQYxJet+uD2q9FrkvME10M9tUtmO
         X0ArALnU4GOM4RpFLYtr4bx0MpBZA554kHWbufBfTUNaqHhLHDjr51XHQdOPMxkQgCXg
         NV0mdNXOuzxeZUNmauE//Xw4ily3/UjO/MvX7UN7+CVRdmJUV6HF15N4VgrrGumDREwQ
         mQr7NBQxJVjAKI7QuaN+TbxUCnrDwve7/GDCashxgzsy+utUcS00v8RMdQzi18ZQO+sj
         C3gytJIJs+P+LCAmm5F7B8ZgvVAvSUSOeGPK1NcM/2jE17EGM2aXjbAO22u5NH5fWlQJ
         NrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uGTALhbZONK07EnTqNzLb5OFo7sOJ1WnH/JS/fksxZ4=;
        b=20n0DMpq993zIW3dpNuC3q5VqVSiqnP4zxYRqvKPQGiW9XlmZPziOc8VPQC/nqxqfY
         gXOlkMRZxljtw5g4iWfTrd/FSwOYCMJCSXdCYS6zKCQ7mSbyfVvwFy3iR4fX6/nYFNtf
         5XyfLsJVqjrYGCQSa4iXkgocNGay2OSV8ObQ7v7qEiVtzzIWyXJx4GEYLz9dPBwrmuHt
         gjGQVrzG5rWNH9h6HL9rRGkAlKoSs2oEuGuXTxLAqCs9TC4DdqhCpQAWNTRoUKad481n
         ZYrnQvddPWD9c4D6vzFiMk7TJlo75CJcHYbYSKY7p8zHVxbVlZFRZRlMIwJE3G5Iwmww
         Fhrg==
X-Gm-Message-State: AOAM530rN6dPnYqO7ojibFr9fGCMSEl8hvQ+jdSVuRZy+7AcUNZ02H0k
        4L22mr/FVA7u31cJ1jLmMlBUyOPH1oNNZyfjyO6hbQ==
X-Google-Smtp-Source: ABdhPJynx2l3cB2Gnxdh26yL6kd+AAVfXhzzqC3Ft2s9qeSNSOaR3yfL83lS+0+wlt4mWc4yp2miJE+sHJq1HcNQSls=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr11070951plg.147.1649714840717; Mon, 11
 Apr 2022 15:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-2-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-2-jane.chu@oracle.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 11 Apr 2022 15:07:10 -0700
Message-ID: <CAPcyv4gr7YzrmqNhA-S8h-nRhpr8OHhUkn16c8jiL1U3ypp1wQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] x86/mm: fix comment
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

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> There is no _set_memory_prot internal helper, while coming across
> the code, might as well fix the comment.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index abf5ed76e4b7..38af155aaba9 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> --
> 2.18.4
>
