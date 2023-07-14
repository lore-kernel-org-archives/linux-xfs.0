Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853E7EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 21:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbjGNVMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbjGNVMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 17:12:02 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1129D3AA6
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:11:51 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-3460815fde5so11364005ab.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689369110; x=1691961110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ayfaCfucf1IxZUJIkcDY5SpP36oc4XZNJ0S0NWpHZbA=;
        b=gbL6jOhY8wQrE5tNWK7ZqXAvNgNEDetCdx6j7RORAWM+MFpnc9WIF3Rsed5eRscK+k
         hhdfcYcotYpMWpCVC3HTlT/WWVRLA9Jzp+FRTU4fNJ8TUp5MCw8CK486wa4n/8dfW342
         6QNwDJbbfkikENKSdRLChwyBTyvAGgj3UEt6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689369110; x=1691961110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayfaCfucf1IxZUJIkcDY5SpP36oc4XZNJ0S0NWpHZbA=;
        b=UuTtOTjyKqttBH2NYV7JZhmPCN/aAH4YKRKbCmmt1x1Iv7Zo590LQW/usyQ114wmAf
         Sh7ICSKv8nVsJ5jhWqM2KITofT8eEAVDIB2klmv3vlZeAOmhgNLNJ+t06qhGUTgcdlFP
         w+0KajyJlQHR7B1y1W7dHe1ilClWiBEkPiifKpzJ9OSbhCP75+zSKHjSybug4dIXWvLo
         qXNDDhLxFeMkSl+t/CDkrVIOEd5ItU2gta+46pKUMk1hX25pwYjwB7WZg7Iju9BH+qBe
         YqaLrq7YzE30gHpZv8J3dixnCAucBYI7Xh7b5rUN1acXL4qVidBBGa7P0v0OUf+hq7Kf
         PQyw==
X-Gm-Message-State: ABy/qLadjvjXKOB6iD4rLCn3tGIELmkDxhoMUSRG7cVx8bwm2va6T34d
        Y4NrGiU6zP1yYCpibpwTwJnb5WNTIEIsurBDQtQ=
X-Google-Smtp-Source: APBJJlGr8Oc2LLG74ZdvrDP4YE1fyKijec/+1/PGHs+L6u3AygyUEBjOvCXGAnLJKXEMHDgzS0szEQ==
X-Received: by 2002:a92:cd47:0:b0:345:7497:3cb7 with SMTP id v7-20020a92cd47000000b0034574973cb7mr5051138ilq.10.1689369110274;
        Fri, 14 Jul 2023 14:11:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c12-20020a17090a674c00b00265b0268382sm1418656pjm.37.2023.07.14.14.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 14:11:49 -0700 (PDT)
Date:   Fri, 14 Jul 2023 14:11:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCHSET 0/3] xfs: ubsan fixes for 6.5-rc2
Message-ID: <202307141410.A83FB7167@keescook>
References: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 14, 2023 at 07:42:19AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Fix some UBSAN complaints, since apparently they don't allow flex array
> declarations with array[1] anymore.

Thanks for finding the best way to do this! Everything looks sane to me,
and the changes in sizes look correctly identified/checked.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=ubsan-fixes-6.5
> ---
>  fs/xfs/libxfs/xfs_da_format.h |   75 ++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_fs.h        |    4 +-
>  fs/xfs/xfs_ondisk.h           |    5 ++-
>  3 files changed, 71 insertions(+), 13 deletions(-)
> 

-- 
Kees Cook
