Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A1EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 23:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244883AbiBOXwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 18:52:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244881AbiBOXwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 18:52:00 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06E13F30
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 15:51:41 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x11so611391pll.10
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 15:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eOQl//KosZ4qvPRlYricOYzhur4w9CDxToybs/1HwUw=;
        b=n0fGEseKpeTJVBRLcU6aOW671FkkrGG1F12nn1nnKRlJSzRZlYdwGVuHrmkdAKwDsH
         2cgJ5x2nv5213DNiH3E5nWepZkSaeaQKiuoAqOILeyvtCV8UCAoqLCu7atcHC0pXWnJR
         x2tovGc4IH5J1oixDaAKekf3001ZtzDQDBFHrtmqFm1lHS1VVhV9AE4yNHV++T1KOkrq
         iIMPbPYw42SG+YdhpVwAMKgFAfvopVFbd2r/lUHxnzCyTokFTZHp7i43RcoioymXx936
         ywuUZN1RyKYYOnf6usErLJkp+q/V3IzojWctav49gN1CbN8yk8vRuUOmjEtrZfhnAGYx
         UYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eOQl//KosZ4qvPRlYricOYzhur4w9CDxToybs/1HwUw=;
        b=lroWgvWcuPbdncARM+2A0XuyxWFQi2PhbyK6+BA3ZsjDlQIuU5FwQE2hVoJ81wxQ5F
         fmXE3Y8JOo6Z+Ao9MB6a27b/ZiIDjeo451cjL81N91G5faRWHXIGYlaUUHsb3C5NE9yB
         8ploygI52WJrQQlbfnMD4Y4WS8hzOMJokWy3rB8erCtgwEp+CXCCAwnDS/mgUe0G2XgJ
         1Q2ZfCPl12Kad63Lwrt57bpK3TcnOWgInyih089qO0xT9JcT31h43r3wcnrmnuQobree
         q6fe4lh0yiMhYoJjv3MNuUkbGi8zKGEBDgHnwsOlfaRHlTQRD3BF/0zGjqhCRczFIWcc
         F04A==
X-Gm-Message-State: AOAM5320KncHXA1QhzGeVtwgqsQacZpFPhNpM+pFlGqBILZ9nqrjcaa5
        hIlSh+pkT0v0iSHXDL8KDno7r/KWSHrzLutKpq+zQw==
X-Google-Smtp-Source: ABdhPJzxjD3vKy3YyT+OCGwXU78ebjUah2EKpMfMibU0VWDXa+asOUJ5+9r/BPJajQyQWY0zQRe+xjGaYgcQFwMYr/U=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr251082pll.132.1644969101356; Tue, 15
 Feb 2022 15:51:41 -0800 (PST)
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-5-ruansy.fnst@fujitsu.com> <YfqBTDp0XEbExOyy@infradead.org>
In-Reply-To: <YfqBTDp0XEbExOyy@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 15 Feb 2022 15:51:35 -0800
Message-ID: <CAPcyv4jFMf_YSSgxoHJk=-0UMZeNO+PHP1sjkvXUmKfXvGaw1A@mail.gmail.com>
Subject: Re: [PATCH v10 4/9] fsdax: fix function description
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
        Jane Chu <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 2, 2022 at 5:04 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> Dan, can you send this to Linus for 5.17 to get it out of the queue?

Sure.
