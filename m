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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4EDC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 08:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB26561051
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 08:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhIDIpL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Sep 2021 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhIDIpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Sep 2021 04:45:10 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B1FC061575;
        Sat,  4 Sep 2021 01:44:09 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h29so1359232ila.2;
        Sat, 04 Sep 2021 01:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rfsW8hgKHWR0AdkGbou6QdpThsKhZeSBbl4YgnsFsgw=;
        b=KGtLMOSPv9Bfh1xAXPWfrRlrYllPLskEGswhezy55xD3IoWbbkCxYKvU4VgTiahje0
         lKvAUWFTmrU+lgrwZLRzQD8x/5XaB/TyB4AuvAPgfZnPQq4HtBXsqIiqkRLuxgrBItmp
         NNAoxoBpJk1inIkejb7jrC3PUtXrNQGzYpKZnaGeqQp5B5hl4H5NXZKelflvrGBdZhqL
         7ylCvqwzPFtbPDNvwChs1PBlD3JSi7kmz8L0tUGwOjzsAIYheqgklMbJMNP8BB7ynsvw
         k5GI54E+J/GXEinJKwj9igtXgfESRl6wD+CGFf9GvPDvwsadM6E5IwVcqjwuYhDDnqft
         9ngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rfsW8hgKHWR0AdkGbou6QdpThsKhZeSBbl4YgnsFsgw=;
        b=YQiyhAGvlaRB+XdGAMn9gj0BPGQbWCClMvMgpb3QGfXUA76cWHoHlRwa33MeU7Q+5h
         9k25B6KGdwSjA0ywmaK0euOKztdQI6JJBtUomGsDGie/NtCFnYPPFITHjTpSMh5JJ25F
         6WluKunzGVuOvqwrmGwFYEAiFah2JNncjiLqq6ekV4YAqW1e+cr3JmEfd/hOwdg9K7/J
         B5Tb9P8Tp0mizbWlzmX8xUrpTNL2AgX/v0JuLElhb7/mpPSfMssH2/Zy8hJOgjW1qCxq
         Yg696W0RAJHk0SoHFjYa8f2q+RQUb/WWq8dU14i18ITfnWVAJSBEA3CE+MTY595b75Mk
         BqaA==
X-Gm-Message-State: AOAM533Yvscj4NjV/DuNTnjDi8MXPZpOi5NYpwXxal5KRfn5LrgVqSl+
        qf5fEd3AxPi9hy+GLbnGAnAOhQLA68UwXavVdfI=
X-Google-Smtp-Source: ABdhPJxGKcnYQGnPs8b1SWTBjlDuG3K0fH22mEDNud3EAyhgli7Uf/Hf4rmWNKJ2UxurYqB0RUdFs0SqAqAjZnAgJlU=
X-Received: by 2002:a92:c80d:: with SMTP id v13mr2124647iln.198.1630745049189;
 Sat, 04 Sep 2021 01:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <163062674313.1579659.11141504872576317846.stgit@magnolia> <163062678708.1579659.15462141943907232473.stgit@magnolia>
In-Reply-To: <163062678708.1579659.15462141943907232473.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 4 Sep 2021 11:43:58 +0300
Message-ID: <CAOQ4uxioMargTa9GPppZ0ACvzX4yjm2OdfrT8gShMed7ZWghiA@mail.gmail.com>
Subject: Re: [PATCH 8/8] new: only allow documented test group names
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 3, 2021 at 5:14 AM Darrick J. Wong <djwong@kernel.org> wrote:
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

Do you want to warn (or fail) on new uses of the group "other"?

Thanks,
Amir.
