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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DAEC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E5F6113A
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242490AbhIQKeb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 06:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhIQKea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 06:34:30 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E20C061574;
        Fri, 17 Sep 2021 03:33:09 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a22so11581789iok.12;
        Fri, 17 Sep 2021 03:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xV6mZtAXlm6SyT1BUGHN2e6EX/fynhlz7/2URKp2fqw=;
        b=PJKvzDwq7cvqniJF49+wIpJon4GAzQj/kpeMWDReJZ5p8qE2Jkp6+5EeEYc0tNBdLB
         XWsqePpYmWIk9CLemSFQLenf+H0oPgPuZ4tsnPMY2/8KsMQ/DjjgHxz4dh7nGTGtIDd1
         MqEm8MfjW7Vbo1GlO4cX0gnuHg6PaCsuFzw5HO2MiqdWpNouhH/mFcV8Lq+M1jeu3hIX
         J0HhmDIvhkfekUbp4os+NUhqrCB9h6OSsJPGbH8a7Y1/iXgjpQPCNtplvMs3Jjd1jQwD
         at+hCILWxPbSVFNMKktpfDF1K0/T8BL/jGUKWxk0ByT8bfBR+Ag0Wgcb9v9kYGFwtLVD
         LyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xV6mZtAXlm6SyT1BUGHN2e6EX/fynhlz7/2URKp2fqw=;
        b=j4QM48J+eyU2gGjmSwEWaL9zFqs0UfFc7GiqvH3kzcwWwmjtVWkCe0XfSIntoAYFYa
         lGE+9Hs4IsbUDNRgA2y/0kvGTctO+Fro5VGj+00qt6WTgpju631URx/a/iYBBytJZBHA
         xylw15iufj7NJXJ+0pNEswqFavh8vp8J9/oTTR1fTN9FXgVBdUzClB0Z8/BkprQkBaCS
         kM4YLNk/PjaM8yhFqgodBh4C6QC4it7nqnhOkWdZRY1lLCXMu36n3m71Vhslidbs/1Zq
         jBW58GnODLeTvf8gmShUUXyFperYeRu5nKVMjH/xKfeA6MRa7z0AmXTLF5aASYrWkEE1
         2WjA==
X-Gm-Message-State: AOAM532LVTA0vt9PbKxg/M4T5knsf5hSJGam3+Qcyn1MpCStPIgoah/W
        hMREE9ur+CK613pxfKwQ7ZM+ih5hPw6fJVjwaGM=
X-Google-Smtp-Source: ABdhPJxoEOdFBQgpAHrsnbnF4sszqbZW0GGpCy4OYaUXAYDy/qO/4sgjV1RbeNioF5Woyx4t0GBuGA8v2L+nZN5eGMk=
X-Received: by 2002:a6b:f007:: with SMTP id w7mr8079493ioc.112.1631874788607;
 Fri, 17 Sep 2021 03:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <163183918998.953189.9876855385681643134.stgit@magnolia> <163183920093.953189.1288298157221770906.stgit@magnolia>
In-Reply-To: <163183920093.953189.1288298157221770906.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 17 Sep 2021 13:32:57 +0300
Message-ID: <CAOQ4uxjjuqbUn_F1fgeUwD45tE54C5jcJOjmSJcn+EnUix9mJw@mail.gmail.com>
Subject: Re: [PATCH 2/3] new: standardize group name checking
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
> Use the same group name validation when reading group names from
> standard input or from the command line.  Now that we require all group
> names to be documented, there's no reason to leave these separate
> requirements.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  new |   68 +++++++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 38 insertions(+), 30 deletions(-)
>
>
> diff --git a/new b/new
> index ea7cf25e..3a657d20 100755
> --- a/new
> +++ b/new
> @@ -91,38 +91,46 @@ group_names() {
>         }' doc/group-names.txt
>  }
>
> +# Make sure that the new test's groups fit the correct format and are listed
> +# in the group documentation file.
> +check_groups() {
> +       for g in "$@"; do
> +               local inval="$(echo "${g}" | tr -d '[:lower:][:space:][:digit:]_')"
> +               if [ -n "${inval}" ]; then
> +                       echo "Invalid characters in group(s): ${inval}"
> +                       echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> +                       return 1
> +               elif ! group_names | grep -q -w "${g}"; then
> +                       echo "Warning: group \"${g}\" not defined in documentation"
> +                       return 1
> +               fi
> +       done
> +
> +       return 0
> +}
> +
>  if [ $# -eq 0 ]; then
> +       # interactive mode
>         prompt="Add to group(s) [other] (separate by space, ? for list): "
> -    while true
> -    do
> -       read -p "${prompt}" ans || exit 1
> -       test -z "${ans}" && ans=other
> -       if [ "${ans}" = "?" ]; then
> -           echo $(group_names)
> -       else
> -           # only allow lower cases, spaces, digits and underscore in group
> -           inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
> -           if [ "$inval" != "" ]; then
> -               echo "Invalid characters in group(s): $inval"
> -               echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> -               continue
> -           else
> -               # remove redundant spaces/tabs
> -               ans=`echo "$ans" | sed 's/\s\+/ /g'`
> -               break
> -           fi
> -       fi
> -    done
> +       while true; do
> +               read -p "${prompt}" -a new_groups || exit 1
> +               case "${#new_groups[@]}" in
> +               0)
> +                       new_groups=("other")
> +                       ;;
> +               1)
> +                       if [ "${new_groups[0]}" = "?" ]; then
> +                               echo $(group_names)
> +                               continue
> +                       fi
> +                       ;;
> +               esac
> +               check_groups "${new_groups[@]}" && break
> +       done
>  else
> -    # expert mode, groups are on the command line
> -    #
> -    for g in $*
> -    do
> -       if ! grep -q "^$g" doc/group-names.txt; then
> -           echo "Warning: group \"$g\" not defined in documentation"
> -       fi
> -    done
> -    ans="$*"
> +       # expert mode, groups are on the command line
> +       new_groups=("$@")
> +       check_groups "${new_groups[@]}" || exit 1
>  fi
>
>  echo -n "Creating skeletal script for you to edit ..."
> @@ -139,7 +147,7 @@ cat <<End-of-File >$tdir/$id
>  # what am I here for?
>  #
>  . ./common/preamble
> -_begin_fstest $ans
> +_begin_fstest ${new_groups[@]}
>
>  # Override the default cleanup function.
>  # _cleanup()
>
