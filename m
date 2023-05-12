Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3E5C7EE22
	for <linux-xfs@archiver.kernel.org>; Fri, 12 May 2023 01:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbjELB27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 21:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbjELB25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 21:28:57 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164E9171C
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 18:28:56 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64384c6797eso7578902b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 18:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683854935; x=1686446935;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h7cAwZFrzJH6fUKsDz12w3yMSIoMh21e7sJA+yDNsXs=;
        b=XMD3ZSFcqV5wrGEPUOvHN+hzNJnN7hBnmtZ2OJgC1UeiUEVJufTLhTsrFvRrKxpyir
         f+7O3pUnD/1HSaRoSuQWt91pjsTTzWyOCF94fDvcoBSS4+6Q3wfIAW7M11qb7RzoDk0E
         D5/A+q7+cfY3qk25d9OD10rlUBene6T6yeNk0tRBRXk3tBvmtrWZ7sDA46aSb0spnR1f
         irCnHEnLIW2/0ut5+wfEIDJK7o8rmHJzjp5F/g23ZGIlxOLXHlnnERLKhxcU2PDfg7AK
         ORZGMSFkIJ1WhDxo058v2IyI6SIuUFF49Z1J9E5QV5vhJfAY5x/XXbD5pZXJ1sAKTF3Y
         +oBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683854935; x=1686446935;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7cAwZFrzJH6fUKsDz12w3yMSIoMh21e7sJA+yDNsXs=;
        b=iI4gozalzkj23QMJ4LMq3BCY/NpbbDfOIlw4gk4r18S9oj1woxqrwWN+R3wXwPf82i
         e047r/BArnNC4sCQiN2D/fXZu2gVjE+Lc8+m6weqLmMBkwMQHlC5xyI0Hu9+XuQuaDRx
         2ZylvIuJmhqLAj4pmz3TF2jxbrS272IkTkuIMJtBi7Lt0v8ro0ttHZTG0XoQk8ulAJ8a
         Uw+W305UUwCBb4Gp+PSH40FH5qT3XJ37S1P5D3iSuzmneA8j4/pfAwl0U4o5171RkYyc
         yfnSNcnaxh7nf76RfEftrCz8lgUIaWhWfJYyRBa8ngdlZAVnyV02RUmljccBc3T1lX8D
         0/NA==
X-Gm-Message-State: AC+VfDx2iS5wBc5OewliAWF7ZipYWx7XWDKxC4lwvRz2KXtHxGlYHIDO
        Lb8VAuqX9XtXIOpbhRBs6pXX6r4l7A5ynBGoNjc=
X-Google-Smtp-Source: ACHHUZ7A8DtGu8KM3l0qbvlRarFG5nnbJtbAkht3S34MUdJGffgmsuY95Q63ml/43YOjbqMxuZcT1w==
X-Received: by 2002:a05:6a00:2d99:b0:63b:5496:7b04 with SMTP id fb25-20020a056a002d9900b0063b54967b04mr31679982pfb.9.1683854935017;
        Thu, 11 May 2023 18:28:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79251000000b006468222af91sm5922458pfp.48.2023.05.11.18.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 18:28:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pxHaU-00EE1u-Uw; Fri, 12 May 2023 11:28:50 +1000
Date:   Fri, 12 May 2023 11:28:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
Message-ID: <20230512012850.GZ3223426@dread.disaster.area>
References: <20230511015846.GH2651828@dread.disaster.area>
 <20230511020107.GI2651828@dread.disaster.area>
 <CAHk-=wjJ1veddRdTUs5BfofupuPxMoVHBUbAOmHw6p4pXPq5FQ@mail.gmail.com>
 <20230511165029.GE858799@frogsfrogsfrogs>
 <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wh6ze_y5_Q89VOuruDnenSVmN4fL1J-rh-vovmrDkxaQw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 11, 2023 at 12:47:16PM -0500, Linus Torvalds wrote:
> On Thu, May 11, 2023 at 11:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > ...and which version is that?  The build robot report just says ia64
> > without specifying any details about what compiler was running, etc:
> 
> Actually, you should find it if you follow the links to the config.
> 
> We have the compiler version saved in the config file partly exactly
> for reasons like that.
> 
> HOWEVER.
> 
> If it's *this* report:
> 
> > https://lore.kernel.org/linux-xfs/20230510165934.5Zgh4%25lkp@intel.com/T/#u
> 
> then don't even worry about it.
> 
> That's not even a compiler warning - that "ignoring unreachable code"
> is from smatch.
> 
> So if *that* single line of
> 
>    fs/xfs/scrub/fscounters.c:459 xchk_fscounters() warn: ignoring
> unreachable code.
>
> was all this was about, then there are no worries with that pull request.

Yes, that's exactly what I was referring to.

> Those extra warnings (some of them compiler warnings enabled with W=2
> for extra warnings, some from smatch) are not a cause for worry. They
> are janitorial.

Which is a pretty good definition of "harmless warning".

> I thought you had an actual failed build report due to some warning.
> Those we *do* need to fix, exactly because they will affect other
> peoples ability to do basic sanity testing.

In retrospect, next time you might first inquire as to what the
issue being referred to is. If you are going to assume anything,
assume good intentions and that the engineer sending the pull
request has done what they have done for a good reason. Once you
know what that reason is you've got the right context to then
educate the OP about the correct procedure in an amicable manner.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
