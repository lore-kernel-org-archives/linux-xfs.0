Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24206C433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 01:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59CA61288
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 01:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhECBNY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 May 2021 21:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhECBNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 May 2021 21:13:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D467AC06174A
        for <linux-xfs@vger.kernel.org>; Sun,  2 May 2021 18:12:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t11-20020a05600c198bb02901476e13296aso2574453wmq.0
        for <linux-xfs@vger.kernel.org>; Sun, 02 May 2021 18:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=euro-domenii-eu.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fANFL7ZVkHY7orcBmd2F9wn3GU9vZzRY8TpKWq/8EdU=;
        b=fKUhVa0D0borck/tQ90zKokXRu2bEM5mc6GW5D9JFNgi0ElIz25W+OkBLDLL0YfQOC
         b3fE0WWekQ6sN6dacFvDj1hEORjslSeIj1+7bWTOaVkfa+oMZOWP8grKmeJY17/saLtH
         NJENNlYTg+yDpljY0vZGcyWoGwLUlfOstqmWz6DxNGYOiAeWIf0j4+/oIUx/OQaybfpq
         R1v/FLRX86PjrWcnjSCcYyrvYUZRK+HT1V6CKjsLLKC9F8r3HmXekrioKbzbIphPBZjL
         /8CHFHnY+yeDW+4nuftYFYYb3V0IlXuuqp0adfREHBBF20Kj3GXmebpvH2k1CHiRrH44
         s+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fANFL7ZVkHY7orcBmd2F9wn3GU9vZzRY8TpKWq/8EdU=;
        b=DCgGoRKbk5QzlOaboapm3InfuXNKbGohxhUNdNPnWpUVVVhzpX+DJSgziF06TDoHPP
         6Q4yzA0amjBqLTHYtYcqpcDv444pNwUp+JtTgNbTsdPVGskaWVessRi3LC55xbAwr3Lv
         5hZE2pgN8iRwErA1WTVFCSqJrDjz54ZGLzawa/J/ee5q6EbFEWFWUaT1XTNtdeBFolHJ
         j+y5Ckg0ED5eDhM3mTxR5PYq/sdlzHahIbCzhObZpZQ9gRbhpum5PYEqSw0z2/Fih5Sj
         zyUNoCj7jgy8yJEp9aS5ZngcQhXnfY1Sy5/ebWb2Hsh78nWnl+QISgPff96vc7GVkYpx
         mqsg==
X-Gm-Message-State: AOAM530IBpD6MVOBJsEeEvFedoFB8lAsroXOgbzAt9SzVnt4cl8OTK0w
        qj7wCU/Dg+6WeCKr3Rgvelt3DHss0emrroymVA2SAzhZQXy+aA==
X-Google-Smtp-Source: ABdhPJyXOJdMomQL+9oEWIGpmqGj3gTFlJv0CSIuRcxd+e8xRopy27iF7pfPNQOc1Rs9HzX7iZCcyr+/E0dG/iOV5uc=
X-Received: by 2002:a1c:21d5:: with SMTP id h204mr18378336wmh.95.1620004346912;
 Sun, 02 May 2021 18:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <CADw2znDxTQX4+GzrYqc6RefL5tcDwdKb0Ppyen8sFMn2fDr1zg@mail.gmail.com>
 <CADw2znDLs6_yky6EHoxmE2P7fRcjoKmYamWnNWj=V+9C_OyD6w@mail.gmail.com> <20210501220731.GH63242@dread.disaster.area>
In-Reply-To: <20210501220731.GH63242@dread.disaster.area>
From:   "EuroDomenii .Eu .Ro Accredited Registrar" <info@euro-domenii.eu>
Date:   Mon, 3 May 2021 04:12:21 +0300
Message-ID: <CADw2znArHXHn--P71BRdZkNzJAGdd6sA7Li-TYWd36AQcMCTEA@mail.gmail.com>
Subject: Re: Roadmap for XFS Send/Receive
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for taking the time to answer over the weekend.
Hopefully, sooner or later you could teach the XFS Old Dog the New
Trick of send/receive  - a kind of play fetch :-)

On Sun, May 2, 2021 at 1:07 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, May 01, 2021 at 03:32:52AM +0300, EuroDomenii .Eu .Ro Accredited Registrar wrote:
> > Hello,
> >
> > What is the roadmap for implementing  Send/Receive in XFS?  I'm
> > talking about the send/receive feature between snapshots via ssh, from
> > ZFS/BTRFS.
>
> None really to speak of. XFS doesn't support snapshots and there's
> no plan to do so any time soon...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
