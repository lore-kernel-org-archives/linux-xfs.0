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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F1FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82B7611C8
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 06:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhIPGLe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 02:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhIPGLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 02:11:34 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC55C061574;
        Wed, 15 Sep 2021 23:10:14 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h20so5486772ilj.13;
        Wed, 15 Sep 2021 23:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46IQBGcmswUosE/ngUiyEuvBOFmoV3KfwjFmkV8bi5E=;
        b=dpCDcxPnpKkJNga2ChP/U9U1Tpa4E3m11JCcpnACsyyp4U822GnWdtbkfEfri2/VFz
         KM61xwomPksQZTXYmaLplRUD4xvC01dlsO1L/yyBColfw80uP6WILRIfKio9fmy6XvbX
         xGTsj0OSCt19mANkGfLjx/7kpt7/IKjSEqoD84PK5NGLKORWA+1fcwZP8MRHUnRz4ODv
         HzsVbdgqFrkz5tI2a9xDlkQu8uhMnDsc2nTAiyIJu5ZzWQaGMrLsfFxvd8vOFmfLbbMU
         ZJRe+HeJ1Le8d+I1N1OR2PVKIEfMNZPAt4U5Dwz2Nd8ZaLmJPrOTtcHGnwARo8qgoeSM
         nL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46IQBGcmswUosE/ngUiyEuvBOFmoV3KfwjFmkV8bi5E=;
        b=rh+rDrvnmxSkTwN7ZH+fw8gFgc+Bp9XXuXkTwUb/MPWXE1bwTTEvH6x0Zps6PuonEr
         BLnB4iCVWV+JRKmJ8KWPK/d2sdYD1XnlXNN4yiuDGU1vFFo+EUQw1JcAyb2jMAukeebO
         S7o6rL1ZoS0nZFol7RreWt0IAzcjW3Z5CkSNEfHZF1KpNER2NQPkSI8jlFqJnoYMbgPx
         id6QoNjhZpYjCHRWYqlWEx6YnBr2eMIUIOlHUlWXqOaMt1BWFe9jYaVFXWIu3lTCUJqz
         GHDkA2DZczb7fEeiMkFp6RhP1HEx5pXrQWr/wYMCQK6xpfUIgcMTU0xHo2MYjiAKe48n
         fiPg==
X-Gm-Message-State: AOAM530YjSiXqOnrHEwuIZaCoJg7lLEcnAbofsgPSJRoURHxmIBJUicU
        P66v9q24n9uuGsMrJjFhOXiE38pIXGBq+OsFjQ65wGCb8zI=
X-Google-Smtp-Source: ABdhPJwcXSlPk0fMMmBNF817simmpZ6pNpcIyGjZUHeOUE1nIhYNVO8ya6gM99ag+H0NowjgZWtJKga9mqiLy5cpWuY=
X-Received: by 2002:a92:d752:: with SMTP id e18mr2861701ilq.254.1631772613676;
 Wed, 15 Sep 2021 23:10:13 -0700 (PDT)
MIME-Version: 1.0
References: <163174935747.380880.7635671692624086987.stgit@magnolia> <163174940111.380880.3160888950588893158.stgit@magnolia>
In-Reply-To: <163174940111.380880.3160888950588893158.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Sep 2021 09:10:02 +0300
Message-ID: <CAOQ4uxh-B8kvbchVxYBWHPxYuaeObyx3e-yEkVeOwHb6B-8JRA@mail.gmail.com>
Subject: Re: [PATCH 8/9] new: only allow documented test group names
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, Christoph Hellwig <hch@lst.de>,
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
> Now that we require all group names to be listed in doc/group-names.txt,
> we can use that (instead of running mkgroupfile) to check if the group
> name(s) supplied by the user actually exist.  This has the secondary
> effect of being a second nudge towards keeping the description of groups
> up to date.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  new |   24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
>
>
> diff --git a/new b/new
> index 2097a883..6b7dc5d4 100755
> --- a/new
> +++ b/new
> @@ -83,6 +83,14 @@ then
>      exit 1
>  fi
>
> +# Extract group names from the documentation.
> +group_names() {
> +       awk '/^[[:lower:][:digit:]_]/ {
> +               if ($1 != "" && $1 != "Group" && $2 != "Name:" && $1 != "all")
> +                       printf("%s\n", $1);
> +       }' doc/group-names.txt
> +}
> +
>  if [ $# -eq 0 ]
>  then
>
> @@ -93,16 +101,7 @@ then
>         [ -z "$ans" ] && ans=other
>         if [ "X$ans" = "X?" ]
>         then
> -           for d in $SRC_GROUPS; do
> -               (cd "tests/$d/" ; ../../tools/mkgroupfile "$tmpfile")
> -               l=$(sed -n < "$tmpfile" \
> -                   -e 's/#.*//' \
> -                   -e 's/$/ /' \
> -                   -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
> -               grpl="$grpl $l"
> -           done
> -           lst=`for word in $grpl; do echo $word; done | sort| uniq `
> -           echo $lst
> +           echo $(group_names)
>         else
>             # only allow lower cases, spaces, digits and underscore in group
>             inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
> @@ -120,11 +119,10 @@ then
>  else
>      # expert mode, groups are on the command line
>      #
> -    (cd "$tdir" ; ../../tools/mkgroupfile "$tmpfile")
>      for g in $*
>      do
> -       if ! grep -q "[[:space:]]$g" "$tmpfile"; then
> -           echo "Warning: group \"$g\" not defined in $tdir tests"
> +       if ! grep -q "^$g" doc/group-names.txt; then
> +           echo "Warning: group \"$g\" not defined in documentation"
>         fi
>      done
>      ans="$*"
>
