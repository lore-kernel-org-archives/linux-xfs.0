Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F15C0007A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E8F2207A2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 18:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgLCSFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgLCSFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 13:05:33 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C575AC061A53
        for <linux-xfs@vger.kernel.org>; Thu,  3 Dec 2020 10:04:46 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id 142so3512828ljj.10
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 10:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hyvfbSevo8Se/4y3iGk+lQg5JO2pXQRwoWZK6AVmSCc=;
        b=Gjv1aL6P6xJwooMOiOVXI2rySRClbrUY3HGVe50LjDG6cXh38kZ+sHSB/0xeLOSW+9
         KzfnPdBnHXwJGIJd7YUlF/R7CYA7zxSe6UAPykXdN+th0PqF3iMNmSPkggw3h7OtjYFq
         jXrwfcED6y2TT4DMjNHYAYn4nz6N4tLwE3MVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyvfbSevo8Se/4y3iGk+lQg5JO2pXQRwoWZK6AVmSCc=;
        b=F7kcGsdnaUlg/E9gnyzpKKUhWpdk47h9X9GaBaUd2yyZnipYmQmAYz0oqWH+9ug3U5
         TGIPKmjUx5zHikjsa4ba/jkMnpZFe1TcLn9eHhDCJPXXlRkp8nRgYFQvn0WoKko4MXPC
         +s/st31b23KiJXZC53CU1PyKt1Hnl8wjQ1RpO977fraBJMyEMK6dGMGg7cpWjVXmGDTC
         PAXA0WQO2wfbnGvFUAaUncXwNY0g9EsOCot41DtAajfpAZs/E21C/LHKbviR/AexX6S1
         84S1UZGCSZXkA07T0akHh763g0SRiYJ39dkmwUEP/WR//arDn40NBbemTNUgBKcLWgmE
         IkmA==
X-Gm-Message-State: AOAM5329teeEMC0iUyDIUepZSst8g8UEDgBaZEJ+MUnleA3RfWG6hbvH
        YnmFkkvhH+yC6SeI0XvS2IvHi43dAWIdhQ==
X-Google-Smtp-Source: ABdhPJxXux48TS0LK3/v6K4FqpuPaxUjyrlvIJrgn9nWASuaf8q3PSkivKASjN4Znbmz3x7+JbGD7w==
X-Received: by 2002:a05:651c:1a4:: with SMTP id c4mr1857785ljn.243.1607018684873;
        Thu, 03 Dec 2020 10:04:44 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id f25sm767228lfc.234.2020.12.03.10.04.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 10:04:43 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id o24so3559342ljj.6
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 10:04:42 -0800 (PST)
X-Received: by 2002:a2e:9d83:: with SMTP id c3mr1626934ljj.314.1607018682473;
 Thu, 03 Dec 2020 10:04:42 -0800 (PST)
MIME-Version: 1.0
References: <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com>
 <7027520f-7c79-087e-1d00-743bdefa1a1e@redhat.com> <20201202021633.GA1455219@iweiny-DESK2.sc.intel.com>
 <CAHk-=wjiU5Fq7aG0-H6QN1ZsK-U3Hw1K310N2z_eCPPDTKeysA@mail.gmail.com> <20201203024504.GA1563847@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201203024504.GA1563847@iweiny-DESK2.sc.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 3 Dec 2020 10:04:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=whWC==8VNeVG=_DwT+RT9x1uiseUDH0X9sYKMetrh6c3w@mail.gmail.com>
Message-ID: <CAHk-=whWC==8VNeVG=_DwT+RT9x1uiseUDH0X9sYKMetrh6c3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 2, 2020 at 6:45 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > What would the typical failure cases be in practice?
>
> The failure will be a user not seeing their file operating in DAX mode when
> they expect it to.
>
> I discussed this with Dan Williams today.  He and I agreed the flag is new
> enough that we don't think users have any released code to the API just yet.
> So I think we will be ok.

Ok, thanks for verification. I've applied it locally in my tree, it
will be pushed out later today with other work..

           Linus
