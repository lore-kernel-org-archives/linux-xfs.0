Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC79C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 01:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F049F60F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Sep 2021 01:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238792AbhIWBTS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 21:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhIWBTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Sep 2021 21:19:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED7FC061574
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 18:17:47 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w19so4196126pfn.12
        for <linux-xfs@vger.kernel.org>; Wed, 22 Sep 2021 18:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PqnMCSlTFVHv+VO0Sbw2IcFVHDdiU24jf3V+0bq7IUM=;
        b=JYiY9knZ+D4IA/xw9LdBe9qhW6scgwdFcL0yYl3y0dx0pnlK5ZK6oaAx/AtEHW0y18
         AB6o0y36plz1cECvcnim0IWsEPJBET4kkBv5j5uzMni2jRKvMMHsEE0BLa48NYQ1WhUM
         ftsCORWkttFQnb5NEeFWVxDNIhlLlkB1H2TaKP77y56xCsJrAIHKzMlVgAHbh0R//Aew
         6vTKFz/hDSgTs5h7QqOHKTtvsPSaLS+S/wFSEb7xJvQ531tJt+CmcOrCmfMEhtJzXuPt
         npRDFiyO9vqRvzpYpIpQD8GdlvxdKSEEL/hcZuWuU8s2DolGggSVaQERe7R+HfermIwZ
         GToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PqnMCSlTFVHv+VO0Sbw2IcFVHDdiU24jf3V+0bq7IUM=;
        b=n7dS+uW72hwuNoAk4V0n7XAtmK+116Sg/69muGQgcY0FqPJZVJ1wRIDkzvwApBh4iu
         wRRDiOnCKhVTLi5ZFOY8R9THGejjRsZnHUh/NE7LuDSsPW0Y0T6SDmIZ4vJ9kJkiOW0a
         e5oOJMb/QBYhjm+g1Djbz9GhSgwXM9Wrdq+nDnNN4ltcFPJkeh0ImtqI6edZ9VZ5EjNJ
         2taOH7FhyaXpCbInjFxmD5zdsS4PSE/aAesFGHwlT6P8/GpboZH029YiOpxWxfHkaUC/
         XULXM4FUZkPw0gIK67hyFpqKlrzUjhDDuNA+0122CmrH0IjPIw17/o/VMR1FPXsRTH5d
         fF5A==
X-Gm-Message-State: AOAM533THtiSHMVzRFFD4Ys8PFcsiNPzp+EZ+4z6QFR0OPg9PP8IaDt9
        hZiCZksMP4VoSqamOLLGFTWiRVAYtWnKKQgnKmzjWBKVcYU=
X-Google-Smtp-Source: ABdhPJwOUgDQpJIJ79YVQdLCz8UX1H4WYKxDvhfzHqtCtQUmDD+os3LI8Xj5ubcod/mYbE2ucuwks0Sk+bxHI9Wj/8k=
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr1754024pge.5.1632359865333;
 Wed, 22 Sep 2021 18:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <163192864476.417973.143014658064006895.stgit@magnolia> <20210923005144.GA570577@magnolia>
In-Reply-To: <20210923005144.GA570577@magnolia>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 22 Sep 2021 18:17:35 -0700
Message-ID: <CAPcyv4iiKbOBt_6gZrOQkgUD2SAXuYtSJkAFeaxEbuah=99XFA@mail.gmail.com>
Subject: Re: [PATCHSET RFC v2 jane 0/5] vfs: enable userspace to reset damaged
 file storage
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jane Chu <jane.chu@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 22, 2021 at 5:52 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> I withdraw the patchset due to spiralling complexity and the need to get
> back to the other hojillion things.
>
> Dave now suggests creating a RWF_CLEAR_POISON/IOCB_CLEAR_POISON flag to
> clear poison ahead of userspace using a regular write to reset the
> storage.  Honestly I only though of zero writes because I though that
> would lead to the least amount of back and forth, which was clearly
> wrong.
>

Sorry Darrick, you really tried to do right by the feedback.

> Jane, could you take over and try that?

Let's just solve the immediate problem for DAX in the easiest way
possible which is just Jane's original patches, but using the existing
dax_zero_page_range() operation in the DAX pwrite() failure path. The
only change would be to make sure that the pwrite() is page aligned,
and punt on the ability to clear poison on sub-page granularity for
now.
