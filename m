Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0D1C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3411A613A8
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Aug 2021 21:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhHWVLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 17:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhHWVLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Aug 2021 17:11:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAC8C06175F
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:10:22 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y190so16494779pfg.7
        for <linux-xfs@vger.kernel.org>; Mon, 23 Aug 2021 14:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kERAiQoYaUiZLUwWrv4bOyfnlzgpfin7j02w+F9IvyI=;
        b=lt4AXvvtTufuHda/bGjNiZxhwiAm/AnyRlhljPx5+BrAEe34p23FhAtHB3HYEPECjI
         jZJJBRria/KJ2mzQ9LOwyzbCZoSDaOdQR0S9CRFr6soYOqwb/+FUoQUrKf/mlQY4M/No
         ndC3I1GeQjlJMJ/jw/JblYnAZq44iy2TYPyqnbJDRkcgjClk3LC8P4WfyaypwNTJEmKy
         RnigTJKYP/gKvnicdNOGQq68auU7dv4psI4APDrepknd32ykDnbq7z6T5MQJv19mjiWP
         +i8XIcGhUKXqKHEMe1QF0XZeeTc5nlVkb6dsFL2GNpG0DZg+xXbWpj/FUtsMz52eKKbN
         kD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kERAiQoYaUiZLUwWrv4bOyfnlzgpfin7j02w+F9IvyI=;
        b=OJH7mHXVFNzlBZI/8XkzGDhSAauijAsQ6z8vLKX2Uu+d484Orr4fgzsw3Htb2Bshhf
         PKGz++hHFO7qzhteHkVwVSJlBIGrVO1SUAmLe3FEiOW0iQy9l4xwOodWJ20feZvYXowZ
         HdZF+Udxzy33NC8ziiwxs5/JBvY+jGLDDpsqk7VgymtdKZbgOPQP2qubLcGWeFdLz8SQ
         5GtAfH0AJoVPAwxRf+xNsR9J69pN29jD678iBxuTRFp2Cm9dsb0KqDSb8b4OqMg7hKS7
         iGafDrU2pLSIBlOdiETBth4uOCFp0oQCD6OMqhYZpMRjuADtF9IT4ws5xNJrYCLQyCIy
         LNxg==
X-Gm-Message-State: AOAM532vAtjPjSrX0e80NaaNKMGsclhlUzKrMQlAHtnfuA+TTXN5Ejhj
        vnoBlfLPSe9cMUYiNUUNqm5BW+YUxYDD+vdd8Unz/g==
X-Google-Smtp-Source: ABdhPJx+EAx+0+aNllv7PT9bB+oTaqYHbUG37U6GeVa/xR+D4Ew0wB0pvGbJbwzWaANuG+iJwDebQ2Xozd6MWf+fMBg=
X-Received: by 2002:a65:6642:: with SMTP id z2mr21533804pgv.240.1629753021975;
 Mon, 23 Aug 2021 14:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-7-hch@lst.de>
In-Reply-To: <20210823123516.969486-7-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 23 Aug 2021 14:10:11 -0700
Message-ID: <CAPcyv4jHYL=TYW-_wF3uTnfzDbGuLqSm-P5Uw+w+jyd89J11Sw@mail.gmail.com>
Subject: Re: [PATCH 6/9] dax: remove __generic_fsdax_supported
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

On Mon, Aug 23, 2021 at 5:42 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just implement generic_fsdax_supported directly out of line instead of
> adding a wrapper.  Given that generic_fsdax_supported is only supplied
> for CONFIG_FS_DAX builds this also allows to not provide it at all for
> !CONFIG_FS_DAX builds.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
