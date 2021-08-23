Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A59CAC4320A
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 20:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF9D613A6
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 20:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhHWU5O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhHWU5O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 16:57:14 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FACCC06175F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 13:56:31 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u15so10873772plg.13
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vc/aN0oRmNAXm6mXAGLkDsuBBboDWXtU8orOhuBIg2Q=;
        b=B1PN8/oQCmXbi6l3QVCMPVcI3O4p3WLJA2eJeCS8TyZ/9O3zP1YyDhITU4ZcQUMu9A
         8Jv3FvTsSNw0wedo++tDncepWpg5fNlx5yOWydCxJxO2LvZgmafOowgtsiW33KkmxXri
         JicnY3m49d7Mh7sxoVHfKYR9tR4vxLm0cTOPiz13j1eLGWJpH4EqBXIsByJu+wugislF
         s6cQkVjauCeFLAIH7yrSgJ+rNWkZxDUHqX64XCMW3WAknCaEAVdKpKS94amQp5lRvzVE
         JLGKD1TjCujv8RstgFNxXr4d9/bplk1r3u+5Pw+HrYG4JEKzIAam/KjQAVW3vquIOGjY
         zzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vc/aN0oRmNAXm6mXAGLkDsuBBboDWXtU8orOhuBIg2Q=;
        b=mLvttD/uU8lblQ6T+9VmfWNJvfZcu+l3jZrLUK2TFUwtndrx2z7yXbiPr6RwrYcI2N
         +NcsOoA3jB5X0HUB+AILxKEnQNhvB/zLe3urfSduusp8gk/sJ+e/YG5P6DExTqFVMexE
         FANffTV7eQtUV5xC730FLmRyLpF9pRD6t6q88flehUmjkQKrQSfjqwhNlqnTvcITulSZ
         fk/QL8eA+TEyI17HA0vnec7uVqDp+3RPWA87bkgJo+RvI8thOvzFIhqXwsCSJ+5iMl2e
         dgYg3+yntImeugAwXsJonyq1FPTxIucWHySiB4DdhH2o/UGhQYBIeT6YsSKy9wn9Qka0
         +ATQ==
X-Gm-Message-State: AOAM532wy41RbBEIoE4XHnUzuScqDwFQrZKp2F7/BBXB3UUHt3bqSgN2
        bPGDd2rFRmbZH6LO6c4t34OXGjgQb4RbQyPaZ9pbGg==
X-Google-Smtp-Source: ABdhPJzahdnrNond377llVfK4n8/pb9BvsPDfdsBxiv7TsIPXVvYqFPJnZxVBQsD+DCyRAqPYzTF7GnMCMP9/MlvOFQ=
X-Received: by 2002:a17:902:edd0:b0:135:b351:bd5a with SMTP id
 q16-20020a170902edd000b00135b351bd5amr2063016plk.52.1629752190557; Mon, 23
 Aug 2021 13:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-5-hch@lst.de>
In-Reply-To: <20210823123516.969486-5-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 13:56:19 -0700
Message-ID: <CAPcyv4j2-8OPHDowaH0ogZP5qKM6rkGVgjjPPRt1k2DC_SpnFw@mail.gmail.com>
Subject: Re: [PATCH 4/9] dax: mark dax_get_by_host static
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

On Mon, Aug 23, 2021 at 5:39 AM Christoph Hellwig <hch@lst.de> wrote:
>
> And move the code around a bit to avoid a forward declaration.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
