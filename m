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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A861DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C5D611CA
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbhIQKnx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 06:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhIQKnx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 06:43:53 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68297C061574;
        Fri, 17 Sep 2021 03:42:31 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id m4so9808272ilj.9;
        Fri, 17 Sep 2021 03:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B59WIn6lLpW+T3exh+AhWXJEftTYi0iejRxBk6P7bvk=;
        b=fmHMlfsAcIjVDJ+V9aw6JMVWUJWea+pDPnOwO/6XJQPfJ2jcw4EDbMwKmeLCCjncG4
         A3lY1XAONnNQMgj5RioisVSdb7g02h2P+EHYbYva2Njw8YOWFrNE9iFHvKF7fIXP/MBR
         TadqD9XVhebwgGG4sotww0+BtetEc3+2oZ6E6VkQN7dvzSJVsqi/gKiWWQugF1RKjDud
         yafhv08c8h4mrfS7k9gth8t0lAmBrCjOGr6jknE+e/GUjgyrUfGkSAisK7ILIKYUXpPc
         KbIM+aJY7WAIdOpd+Aih0CVDMpzIawfDYJspB3KQZf8CleSYyMgAhBXqQmt0jrC4/Yuc
         1Qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B59WIn6lLpW+T3exh+AhWXJEftTYi0iejRxBk6P7bvk=;
        b=Q5XW2owO5M+JQEPVAsPlPrl8zXeSTTxKlE+6xNe+oOtDbE1XYULIql4uzkkl+YulL6
         Wiqj6P+PSDhfpkp0jwJHRePsj/nc3WNHUDNYgUeJGE0naBYiZuQsxJcbC0EZnWEilmxz
         gjwZfEiUnBh9wCOMVzbfXXVonhg1E8vAzlUVD4eLP9LwOBEZhPIuNwg+WVCt9OdDZVE9
         Qy7Px6jLpYXlLHsiZ0EITvzrUDDmGxg+fH4kYO1EgwBeqw/k70G2W0B7JyVNi9JLWbUi
         3JXGHuLehQVxu7xZX/jFyZboDNgIZgOf7eEIILSovdGIVr1+YV5+vd0piL/zRxUH+CUI
         mAxw==
X-Gm-Message-State: AOAM530u5oVY5yDU4EYaheoYHGmNQzjZrniZ5HO0EBa2n8nFUns19RK4
        uChKy2HO4JCqYaiDJPpNld52Y/w1ySfVCakaz0w=
X-Google-Smtp-Source: ABdhPJzPEQJY44CpnTx6w2g5NQ1AThmD4Cf5x9UjRKefkfIwkABnmVPfyfB4KT5wFBXtPEwVLNaykfVKa+j661imoqY=
X-Received: by 2002:a05:6e02:1a67:: with SMTP id w7mr7435498ilv.24.1631875350690;
 Fri, 17 Sep 2021 03:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <163183918998.953189.9876855385681643134.stgit@magnolia> <163183920637.953189.13037781612178012211.stgit@magnolia>
In-Reply-To: <163183920637.953189.13037781612178012211.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Sep 2021 13:42:19 +0300
Message-ID: <CAOQ4uxiTu-b2HAQiFrtbziUKKxKwKjJe2fVnKiVM=AAm_9bXyg@mail.gmail.com>
Subject: Re: [PATCH 3/3] new: don't allow new tests in group 'other'
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
> The 'other' group is vaguely defined at best -- other than what?  It's
> not clear what tests belong in this group, and it has become a dumping
> ground for random stuff that are classified in other groups.  Don't let
> people create new other group tests.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  new |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
>
> diff --git a/new b/new
> index 3a657d20..9651e0e0 100755
> --- a/new
> +++ b/new
> @@ -100,6 +100,9 @@ check_groups() {
>                         echo "Invalid characters in group(s): ${inval}"
>                         echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
>                         return 1
> +               elif [ "${g}" = "other" ]; then
> +                       echo "Do not add more tests to group \"other\""
> +                       return 1
>                 elif ! group_names | grep -q -w "${g}"; then
>                         echo "Warning: group \"${g}\" not defined in documentation"
>                         return 1
> @@ -111,16 +114,16 @@ check_groups() {
>
>  if [ $# -eq 0 ]; then
>         # interactive mode
> -       prompt="Add to group(s) [other] (separate by space, ? for list): "
> +       prompt="Add to group(s) [auto] (separate by space, ? for list): "
>         while true; do
>                 read -p "${prompt}" -a new_groups || exit 1
>                 case "${#new_groups[@]}" in
>                 0)
> -                       new_groups=("other")
> +                       new_groups=("auto")
>                         ;;
>                 1)
>                         if [ "${new_groups[0]}" = "?" ]; then
> -                               echo $(group_names)
> +                               echo $(group_names | grep -v -w 'other')
>                                 continue
>                         fi
>                         ;;
>

Darrick,

Thanks for the first cleanup and for this extra cleanup.
I wanted to point out that with this patch there is no implication
to filtering out "other" in group_names() SHOULD you think
this is better. I definitely have no problem with the patch as is!

Thanks,
Amir.
