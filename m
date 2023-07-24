Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BF8C0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 16:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjGXQtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjGXQsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 12:48:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EDB10F5
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 09:48:47 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-d129edb8261so1220288276.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1690217327; x=1690822127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uw+XohLghVtCiGSKeyi68igmJFzrXC/ki8Vbiy7Xrtc=;
        b=BBex3Ly5/YN6q1aKSFxsy5pI6vMtkyehlBzSB6vAtLDKU1sJXbQfspIWohjXvRwuNE
         Qp2UFjzxprgfAgJIZ3HzieJpFAxvylorM4IOmEb6goaVtkbrT61FVO/mgf/JsCsFVQ8A
         O9RsLphxN0IfGAyKZIH9dPxoapCeM8Yd/2NtOeqkdtiRBWjMHpk6VBYKhUsAarSvfpME
         UwEoFlUXyA3pArnmlvRn2ZzMEhLONBBwS8udbD+BMRFDdpvtGyN6Huuc1fY/6XKDggB2
         trIS4+nB2QmQaTR5scBWjue2/6+xMjvE5zuFBgTVnOY0OEN6lTcv4zizOg8J36CsQNeB
         exgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690217327; x=1690822127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uw+XohLghVtCiGSKeyi68igmJFzrXC/ki8Vbiy7Xrtc=;
        b=e2qC+30VGrYCeWzMrDZ19VebToCc405l1mNLT0C1tV6ofmC8uScRimtzVijBuYvmAm
         4pyQkwqFIq39c5CJ7DeghdHHqq1DX2Hmi87jsdf17/mF1P509kCjp/K7eXARFE6cwTQn
         BtQaxv5fKsMIWObZ8qMPxG75fpR/U6FhVw8xQo8ncT2BYROWYQfOhWTW8zzwIo0GaVci
         Gz3x/nJvt6HXN9qIVk6kffPVlE8e5C6LfIoinD9c8mSlTmry57MVGO4krNj/KROEoL9c
         ZA0LcJ0QWy67re28jYjiFRJi+ENeCfv9xj7Gqt209gfFZEcfql0YBQHrFb0l/JV8KKmF
         z1kA==
X-Gm-Message-State: ABy/qLZLj2/rZkWnaW25IsebGTL9qU1So8UB/M3t7FOqEdxOUoXDhZAF
        JzSWY9sc2cn9YNFHRJrH75VV2K6Wx3RIaxqQLQt0og==
X-Google-Smtp-Source: APBJJlHrHEP3Xu8xMLETOrLzToY6wrT3LbLCWDMMaL1wSC3hhrhC48r6ZgL8n3iw0rRt98ZnZSS0iNTinWr1GQiWfTs=
X-Received: by 2002:a25:5507:0:b0:d01:a2e6:a3be with SMTP id
 j7-20020a255507000000b00d01a2e6a3bemr7232107ybb.5.1690217326963; Mon, 24 Jul
 2023 09:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <2023072438-aftermath-fracture-3dff@gregkh> <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
 <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk> <CAMEGJJ3SjWdJFwzB+sz79ojWqAAMULa2CFAas0tv+JJLJMwoGQ@mail.gmail.com>
 <0ae07b66-956a-bb62-e4e8-85fa5f72362f@kernel.dk>
In-Reply-To: <0ae07b66-956a-bb62-e4e8-85fa5f72362f@kernel.dk>
From:   Phil Elwell <phil@raspberrypi.com>
Date:   Mon, 24 Jul 2023 17:48:36 +0100
Message-ID: <CAMEGJJ0oNGBg=9jRogsstcYCBUVnDGpuijwXVZZQEJr=2awaqA@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg KH <gregkh@linuxfoundation.org>, andres@anarazel.de,
        asml.silence@gmail.com, david@fromorbit.com, hch@lst.de,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Jens,

On Mon, 24 Jul 2023 at 17:08, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/24/23 10:07?AM, Phil Elwell wrote:
> >> Even though I don't think this is an actual problem, it is a bit
> >> confusing that you get 100% iowait while waiting without having IO
> >> pending. So I do think the suggested patch is probably worthwhile
> >> pursuing. I'll post it and hopefully have Andres test it too, if he's
> >> available.
> >
> > If you CC me I'll happily test it for you.
>
> Here it is.

< snip >

Thanks, that works for me on top of 6.5-rc3. Going to 6.1 is a
non-trivial (for me) back-port - the switch from "ret = 0" in 6.5 to
"ret = 1" in 6.1 is surprising.

Phil
