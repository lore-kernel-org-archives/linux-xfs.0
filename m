Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DFBC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 01:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245540AbiBPBh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 20:37:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245537AbiBPBh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 20:37:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE54E19C2B
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:46 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so1023720pjm.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 17:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7vZVv1ogxeGB/tMAdmK5at+J4W8ez8n3jP7SjDQ5qgg=;
        b=cMc473ICFpscrz6Kg2TEINUfuiiCr7n79NNtBniP8KGkOAF9b9J6ETkih1Hf2OjAaY
         zra7/J1LRD1WVCT266kbSOhNePQTQlSfBQLJZxrHOBeKJGQTbkktK4afhTx62f9qaxUt
         M3bS42hVoqOTo+uWBcluZdMV2jxZLwDujKeQj034WXVqpgt0IyZn1+CxFAH7VvntEie7
         NERFRXNHElKR54xfwdMvbtorHfsJcITMYqzhJ/9/IL3SNbXXflV/aIJBKhjKQFEFApQ7
         RGyj8lNGy2O9KfPT9ksA0Nr0Xxft2xo3mbl4FQaPh8pNq66yD3XEDCxjjKAu4dHCbhFh
         ZxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7vZVv1ogxeGB/tMAdmK5at+J4W8ez8n3jP7SjDQ5qgg=;
        b=8ExGHe+TIPMshk0r75urVNNYR2LSjJQWWmNdWyxCHXvIH1/NWKhUz5SuKvEt2qMPvh
         WME2/KQUQimXn1iqIQIJjePyak93UOtHDY49u39qWdr/9fv7R+GvnJOyx2jAtyjdrSJR
         Fd8/qUD+xg+RVY3gw5ZrLAQCkl5GD/Kh/aRmueOQnLd7fik9kC6fSTjPCRZq71GzEEzE
         eEYza565XRcVlIniOrMqEhZCuVvaEEYzRyYrNr6j+tDXlsK0JmxPIv8hcGtdQGKPldnf
         NSTTfieSfzjlFNPi5qcuZZQxW3W9E01O2TGilRz9/YbN5VxZ2JIIyGK29wMspcnQJhN0
         V/sQ==
X-Gm-Message-State: AOAM532UQg3+KKl5GIi1Nn6angE9ABBlZF24W2ARZXZkeqa6wMIkLHNm
        UA8509sWt2UGznlcXlvG9xX3kD6TlsxR9o3WKCgNug==
X-Google-Smtp-Source: ABdhPJyfbGOj2LEZYcd2Uhpx0um1C9tckAPR54JZv8aduFLaOPEJOttLOkO5/aF3ENQOMFJJx594Yf87mhQv1RvvLQI=
X-Received: by 2002:a17:90a:f28d:b0:1b9:975f:1a9f with SMTP id
 fs13-20020a17090af28d00b001b9975f1a9fmr265331pjb.220.1644975466504; Tue, 15
 Feb 2022 17:37:46 -0800 (PST)
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com> <20220127124058.1172422-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20220127124058.1172422-7-ruansy.fnst@fujitsu.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 15 Feb 2022 17:37:40 -0800
Message-ID: <CAPcyv4iJnOYfdc41nNtteidMtvt0fLS5RxZkRfk4Y=9vx_pf4A@mail.gmail.com>
Subject: Re: [PATCH v10 6/9] mm: move pgoff_address() to vma_pgoff_address()
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Since it is not a DAX-specific function, move it into mm and rename it
> to be a generic helper.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
