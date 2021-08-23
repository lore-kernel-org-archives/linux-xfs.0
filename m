Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5BEC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 20:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722FE61246
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 20:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhHWU6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhHWU6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 16:58:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB0EC06175F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 13:57:59 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y11so16435603pfl.13
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=viPh+0UJyTwjrfYxnKuRCjFXOrg8d7O9dPBV2w1jhQo=;
        b=cCYTzhYCc+5UIWdSxQdJiIdjTBmUrpYexZ+GhELekTQzgUIgY8Dlfd7yL6Ff1yWKSY
         L+naw0dPpc2gr2+htpd2ZMVtVL6fG9Tag9Q1wCFypTa5ZGyxwB0wERVJtqEt63CM5I1I
         B2/BGEenOHr/Rq5xjs8wJco0+TEQyhdAs+Gfmq4gMeNTsBZNEsG2MXlT1mkdZRRAduAC
         q77L00UESyhD7X1PyDfxpaBGhcgkscRLg4DX6W3oRB93x6q+4EXuIszs6+T8iEBSquvY
         3SHmYNQGLqoiA3Afhrvk87/PYGSse1LS7/EARSP3v81J0/t2fvKNUnujNzgNxq8HOJZz
         S1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=viPh+0UJyTwjrfYxnKuRCjFXOrg8d7O9dPBV2w1jhQo=;
        b=IMlJjcm6SIqeh53+PFLzx/xQc/1jel8jktR5QWxucLD9xqtLOTT/TUQIiqXJOYM1b6
         7hK2pvfX/2gGna6F6uRnpK2uqO/xCEOj3sBDRomNIF6C9frixDzpDtaHOgA1rNIkKetP
         4wGm8aP5wHYEcscU9avRdskyASBtaXVplDQdZwYbRJui3c5VoYygDaljxhZzQZ8d7aI9
         0P7Gj6sozbZqzSYuH3kSeePqSCNOzfUJ1FAbS4m6A+aBxTMdOVSa+ZHVklHMJloNj6mV
         m+TQvcMtU7kAYKVzG3outK+xRnhiRzk928M1TV+17TNGnXhLffXeHTQrxmNPi09E57qH
         2qLw==
X-Gm-Message-State: AOAM532Awu/29uc6ztKhR78E8MwEQynRdYOh2lrUe+46GwTwn7Dkto2g
        +NQUh+GJqLvU8zp7VzlJ30XokVvW8GmS8EiDu0bJcA==
X-Google-Smtp-Source: ABdhPJyTkPxH6f09SsHyv6amBiRJE33JmtsdOuXl3/Csrh5zhh/d00ls47dcJWNTFnZBryYWLMz+fEcPv6/HoulPba8=
X-Received: by 2002:a05:6a00:9a4:b0:3e2:f6d0:c926 with SMTP id
 u36-20020a056a0009a400b003e2f6d0c926mr28665609pfg.31.1629752279308; Mon, 23
 Aug 2021 13:57:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-6-hch@lst.de>
In-Reply-To: <20210823123516.969486-6-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 13:57:48 -0700
Message-ID: <CAPcyv4gDm4DQY3KNY04cgdhMCp-0j5gmc9G0E3e68BGw2kHN8A@mail.gmail.com>
Subject: Re: [PATCH 5/9] dax: move the dax_read_lock() locking into dax_supported
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:40 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Move the dax_read_lock/dax_read_unlock pair from the callers into
> dax_supported to make it a little easier to use.

Looks good:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
