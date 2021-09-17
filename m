Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5ACC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7744F6113A
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbhIQKaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 06:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242740AbhIQKaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 06:30:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F39C061764;
        Fri, 17 Sep 2021 03:28:58 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y18so11640500ioc.1;
        Fri, 17 Sep 2021 03:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRrA7Vj0jTDK6k7GegYrB6wYpshiy7nXVJ+2YErTGN0=;
        b=AvjfZCZZgyTJGdegXrqt4Dqkmzjwa98IaeYafUJqR5d+CJXrfSUxeLossnR4T5b1B1
         mp+gNcPOvyhv3zE2Voc/yg9OMECQjzkFSmZhI9y3yCVIu4d/qOicfACVJJ5qi1MDJxKg
         pabbCCEdNvMb6aAY9NbhTMFncxxrvhqMS3QEF4dAHnntJPjwm/AkjGwAtsgQfnsL4urA
         ljToQqFTtYc6tWOhbziuf5AImCFE+oISgyxvpKR1z39w/zErcBzjPeGWy0SubDbJ+wnj
         SH3///lWG67uCJijBlp+uD7Kgg85lq7WsF3/Tn2pq5AqTgmLExi+umATmSMUX5dG5cBN
         rlUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRrA7Vj0jTDK6k7GegYrB6wYpshiy7nXVJ+2YErTGN0=;
        b=naIgl49ngDNLDYMzto69gY4u/weT4TSKJ27uiDwmA6KUYJaPkMGg8QYgDg6UeKEr1T
         M/DAdO0hvKuZkEXsCFfrbtNgg+4yNYuaM5Ek8rpQ3TPZBEKFJ+CnzOC1UNTNKRBgdkIz
         cZpX2JiM69EIm2y15/+GOWpyUkvsU0TMelcFlgnYELqn7eJ16MTatbTQVk0s9V8bmdqj
         RN6vhD/AbPQCEjXF/7/gf20gR8uY3TqicrQ42fE+DPBTHFUkM0thRNmP/w/Yh57avQBy
         UcAfcmaBSLKuF9k/aK2UVAVfnlgVAcC34Tn/2wBUJ4+4UAvapLxD1aUzDfq5nCOSmHX/
         DWsg==
X-Gm-Message-State: AOAM531chjGI3hv3iN1VtBxPs8rcf9txt+Z/0b4E1KelgCDwTnZQPX+K
        pdLridKib/4JpWI0Qbx1sTDmSSC9dh1Jymfwa5w=
X-Google-Smtp-Source: ABdhPJwCODBSHlcsK/7slgXbikiIZ/VlMGyJDvsS/+KwPRqlEwvWCg5Mwhsq3VBwwAWTqechNJraIfspWvIgPGDrp4s=
X-Received: by 2002:a6b:f007:: with SMTP id w7mr8065275ioc.112.1631874537591;
 Fri, 17 Sep 2021 03:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <163183918998.953189.9876855385681643134.stgit@magnolia> <163183919544.953189.7870290547648551530.stgit@magnolia>
In-Reply-To: <163183919544.953189.7870290547648551530.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Sep 2021 13:28:46 +0300
Message-ID: <CAOQ4uxh8twcXDWCHJTOiHG9yQhDu6b5k2v3LTt_-j96=7ac08A@mail.gmail.com>
Subject: Re: [PATCH 1/3] new: clean up the group name input code
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 12:57 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Clean up the code that reads group names in from the command line to
> take advantage of the read command's ability to display a prompt.  While
> we're at it, we should abort the script if the group list encounters
> EOF, and we can tighten up some of the other sh-isms too.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  new |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
>
> diff --git a/new b/new
> index 6b7dc5d4..ea7cf25e 100755
> --- a/new
> +++ b/new
> @@ -91,16 +91,13 @@ group_names() {
>         }' doc/group-names.txt
>  }
>
> -if [ $# -eq 0 ]
> -then
> -
> +if [ $# -eq 0 ]; then
> +       prompt="Add to group(s) [other] (separate by space, ? for list): "
>      while true
>      do
> -       echo -n "Add to group(s) [other] (separate by space, ? for list): "
> -       read ans
> -       [ -z "$ans" ] && ans=other
> -       if [ "X$ans" = "X?" ]
> -       then
> +       read -p "${prompt}" ans || exit 1
> +       test -z "${ans}" && ans=other
> +       if [ "${ans}" = "?" ]; then
>             echo $(group_names)
>         else
>             # only allow lower cases, spaces, digits and underscore in group
>
