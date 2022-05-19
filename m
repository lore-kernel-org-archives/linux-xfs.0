Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B85C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 15:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240964AbiESP2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240923AbiESPZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 11:25:51 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE493B9
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 08:25:50 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu29so9810283lfb.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 08:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25W06mVchCPbnzKsfnIcGoUdJPr+bzBze9f8dfzL7eY=;
        b=CBe7xZqsrDjl/aqV6NdGA/5JqqlKDJbIQg4LjLRHdtUHt6VXRCH284Hg+kOFlhX02J
         m7njjwRIV1GJkAUmdPkoEXR3FLTgzQJMoehvh83sVzq7tmbNF6m9OZWmGTKciMXmlbtm
         Qp0zsJYJdFVsBIl0AgWeloHulck/eT4B5NhvubKYY2tzc8tRCMJxxt64GwwkQC+DES7b
         8FeQC3uUR8YWw6u9QSadwXw2Gl03uR16kONin0I02zfRRH34Ye/hg9qdQo07fBJ5P+pb
         PoIzWosyF9pl0el+c+RLVEJ21/sMlmEKeCbmGsfCWMq1nnGWjWyurzQwMxMlu5wcPEjF
         7EEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25W06mVchCPbnzKsfnIcGoUdJPr+bzBze9f8dfzL7eY=;
        b=UDNw8AFLPzuv0mpzEbshSgFFBKUr4zrnjDUlRIvQqzGLJppw2FPwQiIOvsOGXIgEYw
         sDcZmN1XjWbl6gPcZOMw401zIN43iCL3cRRrwV9dnlyrqbNDPBfBWn6wgz2Uk3zMqL/o
         f8Q//qbZ+5ps8POTMuPZKq0SeUwh+aITyFKDGlpdn2P4ILMp4jHEWJIM/tlYiO5MHPJl
         Dv2l4G58capiyGtp0JvrazvW1FQAZ7m+qZCeBakO5/ZEDnJnyuwhm8N18s9w3o/jJWpO
         O+kcRnEAWT1lwwlFFaFFy3hb32yuoX9A1m9plg3KVFkyDYzfekQrsO/UlijcjINcmrz4
         VU9A==
X-Gm-Message-State: AOAM5300RibOCY2V3HXjfkWQiKVJyqkxy3AOkZWTvMitRJ8X64+CouPL
        tzXDycpnd0KE+jgLQkNu//xOdhrvfV7pNUUlDdSYwQ==
X-Google-Smtp-Source: ABdhPJyVKHZcCAxqRyJwxMZIto53E+HC6JlH98tvw/XrPZ1de/jLnWbniW9A2g2+IwHsGsLU5JEoxoX9cIjJScvg3iM=
X-Received: by 2002:a05:6512:92e:b0:477:a47e:cdf7 with SMTP id
 f14-20020a056512092e00b00477a47ecdf7mr3618674lft.446.1652973948206; Thu, 19
 May 2022 08:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220518065949.GA1237408@onthe.net.au> <20220518070713.GA1238882@onthe.net.au>
 <YoUXxBe1d7b29wif@magnolia> <20220518223606.GA1343027@onthe.net.au> <20220519005014.GS1098723@dread.disaster.area>
In-Reply-To: <20220519005014.GS1098723@dread.disaster.area>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 19 May 2022 11:25:32 -0400
Message-ID: <CAJCQCtR--zWjgGgFDfS5X9qTNn4in0bhFBOpeSxEJu+kWwx1jA@mail.gmail.com>
Subject: Re: fstrim and strace considered harmful?
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        "Darrick J. Wong" <djwong@kernel.org>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 8:50 PM Dave Chinner <david@fromorbit.com> wrote:

> I suspect that it's just that your storage device is really slow at
> small trims. If you didn't set a minimum trim size, XFS will issue
> discards on every free space in it's trees. If you have fragmented
> free space (quite possible if you're using reflink and removing
> files that have been reflinked and modified) then you could have
> millions of tiny free spaces that XFS is now asking the storage to
> free.

Yeah, fstrim man page says minimum-size default is 0, so it'll trim
every filesystem free block. I asked about it a while ago in
linux-block@ list and didn't get a reply, maybe it's the wrong list.
https://lore.kernel.org/linux-block/CAJCQCtRM4Gn_EY_A0Da7qz=MFfmw08+oD=syQEQt=9DrE8_gFw@mail.gmail.com/

If the context includes trim down to SSD hardware, and if the workload
involves lots of small files, and many/most of the mixed used+free
portions of the filesystem blocks look like swiss cheese, then I
suppose 1M granularity means quite a lot isn't trimmed, and ends up
getting needlessly moved around by the firmware's wear leveling? But
oh well? Maybe in that case the discard mount option makes more sense.

But if context is only LVM thin provisioning, and not pass through to
an SSD, then a 4M granularity is adequate (match the LVM logical
extent size). I'm offhand not imagining a benefit to trimming thin
provisioning less than LE size.


--
Chris Murphy
