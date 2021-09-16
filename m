Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235FCC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EDE611CE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhIPGm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhIPGmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 02:42:25 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBEBC061574;
        Wed, 15 Sep 2021 23:41:05 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id a20so5579177ilq.7;
        Wed, 15 Sep 2021 23:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CmlfEXQ8Spz+++/1wQ2jT6bFtN2Abpcvpwm2IWpITN8=;
        b=ZSM3upghV3h8VrLiLkVU/niIvvb0K6RmZF1xMZrrLLb8sSlhU4hcS5UCOK61nd0D3V
         pY2oKF2zVK2xMuAqW0nAjUf6nBb+CQiPC3uDtFBk9QTbZOBqxSQVhnUZ/NZtDn5m0XPf
         FnrNS3a+/wHuDiLE+pn1F41fvPVFPjWShXDO0OO3VRjRnw7RoRFi+MzEkQZimJHXr/9o
         A6AsZMg9pt/VRJj/MGXYSJn3SS4YMhYg3vvBz3pe9il3MW55KAgaGQT38Dj+PjtFmc9K
         eO5c3IITT57KxXqSV1X3WwZf7k+EjF2DR7xm4VrqPPIaI7eCG3jt9YmnuL7fCi8KuRMJ
         ywEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CmlfEXQ8Spz+++/1wQ2jT6bFtN2Abpcvpwm2IWpITN8=;
        b=MnilbjJ2WOva4RJo1bKk0GOUIGCOmXz/doNhzYNzmOEJ4wHazidm7Z9emk8lpTalV8
         g4fE7ZQFhto44p+cJ/g3tPxsIZu5LowRmrjRW1GUoVzoRMNkYCAtT9HUglWacaB6ZSKO
         X5t8lqNmEEgVQn+s2NvAm9Bdb/BtYlUJfwr1DOt6bWP69LXQCaSLrVZT10j442hJzo00
         UkP3cr6Mk8cWJHy+aPjK/1oWnDLbjXK6CcKsFOEX3jpLdJEA4i1iBmFsIm2f8v/XVGuF
         serHR8N5a0S4kdOvx77Xqhu3aV0uCwhRU/ccKh+sz70UGZzZHtkf3vxZ11VztQ9pX60R
         pIww==
X-Gm-Message-State: AOAM531GgFT4buhygqAyAIUww3GNLM65XtfJp1fDSaZccTWbKnUoAeO9
        pBYOVPmpXzsUAoBkexxVGSXYvwZEtuw941ZjhS8=
X-Google-Smtp-Source: ABdhPJzbs2yCoZUK1Hg/LR5SVbQP7IUuD4ghxAPVWW+da5EYxkwZd/j3TOmLHdecwJBAJuh5K93sKFQ0uq3fRQte0xc=
X-Received: by 2002:a92:d491:: with SMTP id p17mr2917176ilg.107.1631774465066;
 Wed, 15 Sep 2021 23:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174940659.380880.14564845266535022734.stgit@magnolia>
In-Reply-To: <163174940659.380880.14564845266535022734.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 09:40:54 +0300
Message-ID: <CAOQ4uxh6fZNzCX2wAQdhmz4Z+4xGbZMF0zfSkKUZKjS0KZhpOA@mail.gmail.com>
Subject: Re: [PATCH 9/9] new: don't allow new tests in group 'other'
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> The 'other' group is vaguely defined at best -- other than what?  It's
> not clear what tests belong in this group, and it has become a dumping
> ground for random stuff that are classified in other groups.  Don't let
> people create new other group tests.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  new |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
>
> diff --git a/new b/new
> index 6b7dc5d4..5cf96c50 100755
> --- a/new
> +++ b/new
> @@ -96,9 +96,9 @@ then
>
>      while true
>      do
> -       echo -n "Add to group(s) [other] (separate by space, ? for list): "
> +       echo -n "Add to group(s) [auto] (separate by space, ? for list): "
>         read ans
> -       [ -z "$ans" ] && ans=other
> +       [ -z "$ans" ] && ans=auto
>         if [ "X$ans" = "X?" ]
>         then
>             echo $(group_names)
> @@ -109,6 +109,9 @@ then
>                 echo "Invalid characters in group(s): $inval"
>                 echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
>                 continue
> +           elif echo "$ans" | grep -q -w "other"; then
> +               echo "Do not add more tests to group \"other\"."
> +               continue

Should we also filter out "other" from group_names(), so it is not listed
for "?"?
With this patch, "other" does not emit a warning when passed in as a script
command line argument.
If we filter "other" from group_names(), then the warning in "expert mode"
will be a bit confusing (group "other" not defined in documentation).

Also, it is not clear to me if this is intentional behavior that interactive
mode allows non-dcumented groups (with valid chars validation) and
expert mode does not allow non-documented groups?

It may be simpler to use the same helper in both modes (is_group_valid)
to emit the correct warning and either proceed (expert mode) or get
back to prompt (interactive mode).

Thanks,
Amir.
