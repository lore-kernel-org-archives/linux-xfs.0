Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC13C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 22:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386866AbiBHWYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386942AbiBHVZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 16:25:09 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B497C0612B8
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 13:25:07 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p19so412223ybc.6
        for <linux-xfs@vger.kernel.org>; Tue, 08 Feb 2022 13:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOAUxtQP3mZPMOd1OLLiMYOVL2ZtBeAuXbiunmNeOa4=;
        b=BU7MK3BkKz82lpcnXHDc/1Uyv8nwMHJtqWFB7e3XfOHWlGbu28Ai0BLlbKRjcm885G
         5/3lnFtvH79ulZb+N57FbHJpojIr/I4ddU1NL64ia9JReTtNkaVz3mPmnpGNxYGY8fLo
         3JL0t6YsW/meMkSaU0kbVqOdl7nOiW8trjvsn7++PdG9X1euJbnsqbveE03GyZuhbAsg
         53biwajRJNjl38f3XYVd36DK9r+wtIx5iUoAe/x8BEnzvc+1LThGWmrxHyF5oc0wo68M
         sQHyh9e8XowDaodFXgtGYjW20A6dcJWjiNz7aur9wF5CT9u1MFD5egYS28wvPD5qD5qO
         D2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kOAUxtQP3mZPMOd1OLLiMYOVL2ZtBeAuXbiunmNeOa4=;
        b=Vlfzp4xCSJqCnfFlkoc9X0RTjX8XMR/nBPdzbmn/s7brgU7FOkd9dOziWblmXv/BdC
         3EAN7ihpNMeun58sS9cqh4QcLCbZLCpA7EiHOuqgoouPTAky50M3VghsVEtMEh83IkFg
         spn3LLn8AKOJ5e8m80rRwjpC8dHnQKF3oX5YB45smB9FFH1gHaocz+YdLITErfXXmYfS
         kdj/4oPg8FvotD8os/Fxj5nvGv7UUNlrnYddCDRKj2Uh4c09C5/614RxzjDBht8ATe1d
         6htaDpAJPcw+Oiit68ko3RgIbmNSjOh/O5/c56uTSL4Tg8ctAIfPBhAzeQq2dGGlWsj0
         dkFg==
X-Gm-Message-State: AOAM530Qt4J3oqZ3blbIJ6n3v8AZuoKy5wiAyNXCTpUzV80GXwjmqsbY
        KAqNWEz3hVDFswfkorwagi9yo1XmklU7fC26YDCd2w==
X-Google-Smtp-Source: ABdhPJw+MrXuIfJp1fGt9KPNZ+/r+Gb/B8xc5ZxJJJUYqzFicsuerrtw9OtHeXjoPO5FtrfnAhH/oCs/QrKfvWMUzlI=
X-Received: by 2002:a25:c307:: with SMTP id t7mr6428127ybf.701.1644355506392;
 Tue, 08 Feb 2022 13:25:06 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
 <20220207223352.GG59729@dread.disaster.area> <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
 <20220208015115.GI59729@dread.disaster.area> <CAA43vkXTkCJtM-kQO=GAX=TnAFkD_atygSw4scCwQ8Y-sJZsoQ@mail.gmail.com>
 <20220208205640.GJ59729@dread.disaster.area>
In-Reply-To: <20220208205640.GJ59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Tue, 8 Feb 2022 16:24:55 -0500
Message-ID: <CAA43vkVKEiW7WFOAJy16J89DT0eq3U=48Hyy9N7hz-GQvZ+JrQ@mail.gmail.com>
Subject: Re: XFS disaster recovery
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you so much for your expert consultation on this, Dave. I'm
definitely cognizant of the fact that there may still be inter-file
corruption while metadata is OK as well. It sounds like we've moved
the situation along as much as we can by finding a set of parameters
where xfs_repair will finish without hanging or crashing via
nondestructive testing with the metadata dump and sparse image and we
end up with a product that can be mounted.

We'll move ahead with repairing the filesystem on-disk and copy off
what we can, with the caveat that users will want to go back and check
file integrity once the copies are finished and there may be
additional data loss that isn't captured in what's in lost+found.

Best,

Sean


On Tue, Feb 8, 2022 at 3:56 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Feb 08, 2022 at 10:46:45AM -0500, Sean Caron wrote:
> > Hi Dave,
> >
> > I'm sorry for some imprecise language. The array is around 450 TB raw
> > and I will refer to it as roughly half a petabyte but factoring out
> > RAID parity disks and spare disks it should indeed be around 384 TB
> > formatted.
>
> Ah, OK, looks like it was a complete dump, then.
>
> > I found that if I ran the dev tree xfs_repair with the -P option, I
> > could get xfs_repair to complete a run. It exits with return code 130
> > but the resulting loopback image filesystem is mountable and I see
> > around 27 TB in lost+found which would represent around 9% loss in
> > terms of what was actually on the filesystem.
>
> I'm sure that if that much ended up in lost+found, xfs_repair also
> threw away a whole load of metadata which means data will have been
> lost. And with this much metadata corruption occurring, it tends to
> imply that there will be widespread data corruption, too.  Hence I
> think it's worth pointing out (maybe unnecessarily!) that xfs_repair
> doesn't tell you about (or fix) data corruption - it just rebuilds
> the metadata back into a consistent state.
>
> > Given where we started I think this is acceptable (more than
> > acceptable, IMO, I was getting to the point of expecting to have to
> > write off the majority of the filesystem) and it seems like a way
> > forward to get the majority of the data off this old filesystem.
>
> Yes, but you are still going to have to verify the data you can
> still access is not corrupted - random offsets within files could
> now contain garbage regardless of whether the file was moved to
> lost+found or not.
>
> > Is there anything further I should check or any caveats that I should
> > bear in mind applying this xfs_repair to the real filesystem? Or does
> > it seem reasonable to go ahead, repair this and start copying off?
>
> Seems reasonable to repeat the process on the real filesystem, but
> given the caveat about data corruption above, I suspect that the
> entire dataset on the filesystem might still end up being a complete
> write-off.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
