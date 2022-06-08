Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33022C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiFHJsJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiFHJrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:47:39 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304CB63BD;
        Wed,  8 Jun 2022 02:15:14 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id e7so8746822vkh.2;
        Wed, 08 Jun 2022 02:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0+308ulm68wV+CwEewB3MMxVjY/l40HE9EmEM2AkgA=;
        b=Jya+ReEEYRtYhAGFgVceuqKS0i1jU3yRwGSjGOh0wriZD3HVxLpxaHJ6FKB4qDCAJL
         PKbhQQ+wQc3kD6VwGSb1JUd6m6wDpX+nQR74M+xi2zLiBaIoE6XHF7PUjb7Na3vJCKJl
         +jQGxIHg9pizAETIaKLFx+exI5W3kosxyueZjvFSC30tlbCyAKFQKtjJwjcSSn5ulurH
         4ua/lexpl4Tngtou90GOOfHesvNRUoYYlAkScij0EE4kyRO9rIGYjXTe/susMGtlo/zc
         wCHpRi3X8J74i7TKSoFKsVSwI8Ju4EN7T89px1oVikmNAYdsnJu/FbAMbdbqQcfqawhI
         1/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0+308ulm68wV+CwEewB3MMxVjY/l40HE9EmEM2AkgA=;
        b=HD6bs++jQlNJzkJBMPqfUby/GFWb5zdFOtfZQHUvSH6bXrzsohFVM0WdneZBYNzjy6
         /fCHVoZrAkMMRfPInR66Ov4fkN0F3n/MKg6FnujbyCDu3LraRgB5xlGDBZCfqrPCluyH
         jSXGwLTBreMsmGrFrOPxrbj2WUO0vYYpj2qrNKS2f4fHytm310EO0/YOt3TSjhlPWio5
         ofuaO2T9pEqWCc7/oH1xDdw3xfx0xB/jsU7gaViot28xnFd9sZydjCx4KQzy1N6cSovs
         lp6G/kRsds9QLxMG+O7KLWU7659YTAa0G9GU+2JAPdFk5rajfLH7sJPJGXQFJLyn4tOU
         5KbA==
X-Gm-Message-State: AOAM533G2/SkdE5ll8ORgy2JDXX7dOQ9eR7CfyNh4L5oMUutqNH4r0r9
        CM13aW0YqVkcyIhnjoJlteg9v8GjHtsugLNufeA=
X-Google-Smtp-Source: ABdhPJxYJ1RINSsTIdxpjKxfTgdxpznW4uNzdR6MXBWUv93p3oNGURXnASgdAk4JdS0ltu4V9yDIzARLTt8B2fJ+JL0=
X-Received: by 2002:a05:6122:2205:b0:321:230a:53e1 with SMTP id
 bb5-20020a056122220500b00321230a53e1mr18340511vkb.25.1654679713274; Wed, 08
 Jun 2022 02:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220601104547.260949-1-amir73il@gmail.com> <20220601104547.260949-2-amir73il@gmail.com>
 <20220602005238.GK227878@dread.disaster.area> <CAOQ4uxjcumjxeWypahgYd9wLExLuipd9MTCc_8vfq6SFY7L4dA@mail.gmail.com>
 <20220602103149.gc6b5hzkense5nrs@wittgenstein> <CAOQ4uxjJBCw7bzK6TAuVd2hs+cs_86z97F06q7k9BE7yVP-Cvw@mail.gmail.com>
 <20220608082654.GA16753@lst.de>
In-Reply-To: <20220608082654.GA16753@lst.de>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jun 2022 12:15:02 +0300
Message-ID: <CAOQ4uxg4=m9zEFbDAKXx7CP7HYiMwtsYSJvq076oKpy-OhK1uw@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 1/8] xfs: fix up non-directory creation in
 SGID directories
To:     Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 8, 2022 at 11:26 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Jun 08, 2022 at 11:25:10AM +0300, Amir Goldstein wrote:
> > TBH, I am having a hard time following the expected vs. actual
> > behavior in all the cases at all points in time.
> >
> > Christoph,
> >
> > As the author of this patch, do you have an opinion w.r.t backporting
> > this patch alongs with vs. independent of followup fixes?
> > wait for future fixes yet to come?
>
> To me backporting it seems good and useful, as it fixes a relatively
> big problem.  The remaining issues seem minor compared to that.
>

Thanks!

Dave,

I am not seeing any progress with the remaining VFS issues,
so rather not hold up fixing this "big problem" on future changes.

Do the two opinions from Christian and Christoph help you
ease your mind about the concerns that you raised?

Anyway, I now have these two patches queued and tests so
I can send them along in the same batch, whenever that is:

e014f37db xfs: use setattr_copy to set vfs inode attributes
01ea173e1 xfs: fix up non-directory creation in SGID directories

The setattr_copy patch is also part of Leah's candidates for 5.15,
so if you approve, I will include both patches above in my
next posting (after part 3) to align with Leah's 5.15 candidates.

Thanks,
Amir.
