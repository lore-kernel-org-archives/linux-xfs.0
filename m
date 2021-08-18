Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAE9C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 21:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA19B610E7
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 21:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhHRVCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbhHRVCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 17:02:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A23C0613D9
        for <linux-xfs@vger.kernel.org>; Wed, 18 Aug 2021 14:01:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 7so3450667pfl.10
        for <linux-xfs@vger.kernel.org>; Wed, 18 Aug 2021 14:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsxhBVRZlO9and7DhCBUruAlzXa20bXVaKImjY48c7o=;
        b=zGGJKW23TpE7PPFJ4/n391OFSE+ePfB6XhKYr42xqQdacaGLoy/MLGcJOB9KJclibB
         29yQ1DLoZOq7YUGzImZJ1hjNXdcN4bUgBPPOpNCAUpQuExc321UUpjfAEZalmz/yrEmp
         QMBCgYswdRECqSZZszyKnB1/zOj6k9++ko8k9sPqN4YI0mQ+MpWE8w90ykG4GHsvonXj
         +NKnoDJPWaGnOUjnABohDzuGK/EN0y6cm+wAyrcNscAwRna0z/xgPtNqS+mR4HhFrKCd
         yR/73F6u/b1hWv+BHa6yM7WRf5HOfuotX6pcWtI2uqTJ6KkhqyfixiY4MEVxCLYod6oS
         Jj2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsxhBVRZlO9and7DhCBUruAlzXa20bXVaKImjY48c7o=;
        b=hqk4jzqNB9rdTPiN6vpCvGS09gAh+mgw5kfQe5AGGLHWM5M/HaOVzfmbZUj0sd13vP
         9D54IRg5jPBjzAAclD2hea/QRNHQsBL6fS6Gs+lFSIZuuKcyjft9YJH5UQK12w8Qsj4q
         j9Xh20jPf7hBej37OBcieq+bei/A8nR0DGQEhOz9ly3eIHB6kfBQtXRBUCmZjyu51YNN
         XimAMIPDeJMilxIrPFg51krLx0aeg2TSFyyKZvwsRXxuKAfwwOSHFUmpXO5RwNBRc+O/
         rpyn/2fqnU3C6b2uj0uYZKSf1UpcBhrTtcxUBbtD1iducRFJ/1RWsgCR92bLPBQ8fTGM
         ShbA==
X-Gm-Message-State: AOAM532Fs4Q2NIJL36dir1cNltrhgA8cCNMI4QP/QVW5pO1pVsmHun03
        nKkiEuREBeK/mlH3+L6Dh/A1PdzQlxlqpCA5lxTlWA==
X-Google-Smtp-Source: ABdhPJyC7TVzou7MS10S9DHd4c6rf2rdDWgmDabraG+KHQy+8QVQinJv59B8c4LqBnwh3oILNYKei6BontbTyhivPwk=
X-Received: by 2002:a63:dd0e:: with SMTP id t14mr9090412pgg.279.1629320486279;
 Wed, 18 Aug 2021 14:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-2-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 18 Aug 2021 14:01:15 -0700
Message-ID: <CAPcyv4jUDGDK5nXiVhEgw_Pwkjf8D=O4Nbw0Gd1YdWUJEoifpQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/8] fsdax: Output address in dax_iomap_pfn() and
 rename it
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        david <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 15, 2021 at 11:04 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Add address output in dax_iomap_pfn() in order to perform a memcpy() in
> CoW case.  Since this function both output address and pfn, rename it to
> dax_iomap_direct_access().
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
