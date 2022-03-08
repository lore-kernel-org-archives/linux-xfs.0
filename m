Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3063C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Mar 2022 00:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbiCHAGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240159AbiCHAGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 19:06:11 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960CC36161
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 16:05:15 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y22so3195252eds.2
        for <linux-xfs@vger.kernel.org>; Mon, 07 Mar 2022 16:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=CMGxfMY3JwRxKQXtzVyzeVqGfgrGP4KNDnepmTa/HOM=;
        b=WqChe1GpY5y3MQ+KKkZec3CMollaFVRmokz4RLvAOvbFpiHgRVepM7IF39ppjFAKjS
         29ykl18HyMJAziYfSaJBKYoyugxL8dcKiwVxz9tCpjMV6jw+RO3YPW9gI808SoRuzyvx
         7AuEPtjGyx8amRrbuqtp7gs5OVzjjLFFPP+X4A+swtsqiEjiPIeCCHvZFlkVQwXrvISm
         JloXViPE12Hyhd13GiHl1dqkExlem0eFQBW+Yckn2mE+7sEdD2IRSzJpzqW8Bj2kLt/y
         Hb2MSRSatdcxCDHkwX6OjyqjKTxFtKOfkXMuyJlGyZypZeXtIEyd6D1r1GxbZgEPxqoh
         h8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=CMGxfMY3JwRxKQXtzVyzeVqGfgrGP4KNDnepmTa/HOM=;
        b=ogLyYZhM5oNl0WGg7o9u79orEYnmU8zCicNqpS3ixXfg2K8ltXLmduQFT5ZYlm/czH
         pC2kkgNXxVLY3BJVAL3UMEqof2q6qQIiObYAhciz0zhzksgpO64dSRDQ1VdNVKOQbogF
         e4lEEZd9XSc5khdtyw1et7eraumEPs8SQ4HRXoAlCZPlN5/u+HOrqZ3QGY+SIjwNtgM8
         8N1y9B/dxnOd1YeaCuOLzHcpwypr0fQrdsJhGjMItKeR+YhFl3vkoH2d+WGQ98kpoo4I
         osKtoCDiKRiSd0btkbxdR8To94ruoijl8O3ihACnopYLYid6GXy6yK7jF5vFKaEJdGIM
         JEng==
X-Gm-Message-State: AOAM531o0RXhk2tw7unIMCFTT+H9c85eczNQTlEBr6/bBw4qsM2WpD3E
        WVbg6aKtlAOGZCm8OEvsiCvs/gKgd5IsCRFAwt4=
X-Google-Smtp-Source: ABdhPJwozcuxIAAEI5K6gWwMxf4hmrG9vw+ESZt1mLYI7glfyJgFc8UOX5Qk0YINNRKjUF/lZvmeCmZYWblOl8AMkiw=
X-Received: by 2002:a05:6402:14d3:b0:415:f935:66b2 with SMTP id
 f19-20020a05640214d300b00415f93566b2mr13670804edx.330.1646697913930; Mon, 07
 Mar 2022 16:05:13 -0800 (PST)
MIME-Version: 1.0
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local> <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com> <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area> <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
In-Reply-To: <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
From:   David Dal Ben <dalben@gmail.com>
Date:   Tue, 8 Mar 2022 08:04:47 +0800
Message-ID: <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
To:     Dave Chinner <david@fromorbit.com>,
        David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

OK, thanks.  I'll take this up with the Unraid tech team directly.
Thanks for the advice and pointers.

On Tue, 8 Mar 2022 at 07:51, Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>
> On Tue, Mar 08, 2022 at 10:31:32AM +1100, Dave Chinner wrote:
> > On Tue, Mar 08, 2022 at 06:46:58AM +0800, David Dal Ben wrote:
> > > This is where I get out of my depth. I added the drives to unraid, it
> > > asked if I wanted to format them, I said yes, when that was completed
> > > I started migrating data.
> > >
> > > I didn't enter any XFS or disk commands from the CLI.
> >
> > Is there any sort of verbose logging you can turn on from the
> > applicance web interface?
> >
> > >
> > > What I can tell you is that there are a couple of others who have
> > > reported this alert on the Unraid forums, all seem to have larger
> > > disks, over 14tb.
> >
> > I'd suggest that you ask Unraid to turn off XFS shrinking support in
> > the 6.10 release. It's not ready for production release, and
> > enabling it is just going to lead to user problems like this.
> >
> > Indeed, this somewhat implies that Unraid haven't actually tested
> > shrink functionality at all, because otherwise the would have
> > noticed just how limited the current XFS shrink support is and
> > understood that it simply cannot be used in a production environment
> > yet.
> >
> > IOWs, if Unraid want to support shrink in their commercial products
> > right now, their support engineers need to be testing, triaging and
> > reporting shrink problems to upstream and telling us exactly what is
> > triggering those issues. Whilst the operations and commands they are
> > issuing remains hidden from Unraid users, there's not a huge amount
> > we can do upstream to triage the issue...
>
> I'm not sure if it can reproduce on other distribution or it's just a
> specific behavior with unraid distribution, and it seems that this
> distribution needs to be paid with $ to get more functionality, so I
> assume it has a professional support team which can investigate more,
> at least on the userspace side.
>
> In the beginning, we've discussed informally if we needed to add
> another "-S" option to xfs_growfs to indicate the new shrink behavior
> for users. And the conclusion was unnecessary. And I think for the case
> mentioned in the original thread, it didn't actually do anything.
>
> Thanks,
> Gao Xiang
>
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
