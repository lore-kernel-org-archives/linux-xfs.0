Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EDBC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C9BD206F6
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 12:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KsasfK4s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgEVMd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 08:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEVMd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 08:33:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02474C061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:33:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 79so11163451iou.2
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 05:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jts7QEhMUcBJDSSUMEE/z2/CLsV3G6Pd37DSOU+ofLY=;
        b=KsasfK4sH1qdAJh3eJeKz2k4KlyR6Umz60G4ZtXl61Bh6lRRSp71vn2O6frwjv97i+
         RtXUYND3MaIjkps5UpD5wh1deaUZ851rlhj3Ul6B8Y+bnH7EUC6qlmouItadcrE0rZ1O
         0/SiKMe/42USc+AcCQDiCdjjFlERk6yl2CDJg0YT0VDH+r3gdiC+mN7Z8h34zaeHmnGg
         pEGU8ydO1dpgNY1vfKljHYDQAfvn5X05EYULiThCrVLYH+gd9RN+VtudsTJcJqdoLz3i
         dMgRHPQJCjBOQpbpMi+95kn0PKviZgZDQrWFx334OLrSbQ057dVKyUBa9cwOlmCzRBt+
         cI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jts7QEhMUcBJDSSUMEE/z2/CLsV3G6Pd37DSOU+ofLY=;
        b=rF4oqVHQ3cFKkKBxYM0Jt9cJzv07c2Agy5YgW6jOlB7nEYb9Lhqh7KaJyW9OhZQKRd
         VFzN7CWo5ZwpoouTfXwEPbpdSn4yR/F+XCnheB427cTb0LLtlK0PhSQJe29rjwCtDRMh
         I/Bpvj6ymuf74oLgUfP5IvXQ+w0iyi8d0/LEFAVVReWzvhWXW3X5LDcboNX/BwfEcMnX
         mUdciT4FrHkUQiS4eCS4Q38fN64anglxV2sVDLobys8dpM204GSFmJ1xv7t3I9BVa8dq
         cHjZUC0zIOUkQW8bGgo8GAB9iLDsQFYSO0b9qUsFzs6mk5SbCocP3H/eESEbfoyi/EXA
         PtDQ==
X-Gm-Message-State: AOAM5313AP5YXplDx+9QtxSj6X2tOqBv5GDF7k9S68Wkec5qy5VaoByQ
        3RhNqb4dVBMhsHIm1ux7ZxPs93yvVFYeqVjR6eMNO+kP
X-Google-Smtp-Source: ABdhPJwxlM9Kme7Bl17ziIAUsL6xlTEaz9UJmxL3euBFSzaL8wg51Ey8lqduD6lGmiF5w+Op0XmlxXV2kl1fNbzckos=
X-Received: by 2002:a5d:8c95:: with SMTP id g21mr2876910ion.72.1590150835386;
 Fri, 22 May 2020 05:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-22-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-22-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 15:33:44 +0300
Message-ID: <CAOQ4uxiaHM0HmXTiV7AKBaDzSfPnDcOh0JUc3czVz3wwAZAHTg@mail.gmail.com>
Subject: Re: [PATCH 21/24] xfs: rename xfs_iflush_int()
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:52 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> with xfs_iflush() gone, we can rename xfs_iflush_int() back to
> xfs_iflush(). Also move it up above xfs_iflush_cluster() so we don't
> need the forward definition any more.
>

If it were up to me, I would avoid the code churn involved with moving code
around for the sole purpose of getting rid of forward definition.

BTW, next patch removed the static from xfs_iflush(), but it looks like
a mistake or part of your follow up series. If you are going to make
xfs_iflush() non static it is really pointless to move it around.

But for correctness:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
