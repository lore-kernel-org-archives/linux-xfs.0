Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BABC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 19:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E521610CC
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 19:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbhIMTMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 15:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241529AbhIMTMg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 15:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A6F610CC;
        Mon, 13 Sep 2021 19:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631560279;
        bh=/6iniwcpC4tqAvqcqbLFQNPzbG/BZj4jTDp4yox5teA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mpUxDcJudX8Sbr0xAYoiKjmKySDDo1+3SK3FfqoLPHguUc07eM55TqFNOZO/cbE/7
         2X7cwN2QsNqjwIQRAaQIiqj+7BWTLT1VV3HHI2JbyCLxqR5nNSwCR/fPQJhBaM8iLA
         IRz+LK13jOowd+zhhz2ZLDFfBP9xPM8f2D7dTjjaWtqTgJ07MAl9Ay+zhJXGYsNsjg
         vL9KrF93hg3Sj/M0LcS6iJe9UcB6TeGlvFMij8STSpjuyCcViaklSEw0RlXPV3Z4fa
         Kbr/7XMLQSatbbPFweYsobSR8bzpMfPSdxmYN1aRxLjdMGSXAq/7Moig9loVMw8Z4j
         8+7BNgthCYgyQ==
Date:   Mon, 13 Sep 2021 12:11:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 8/8] new: only allow documented test group names
Message-ID: <20210913191118.GI638503@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
 <163062678708.1579659.15462141943907232473.stgit@magnolia>
 <CAOQ4uxioMargTa9GPppZ0ACvzX4yjm2OdfrT8gShMed7ZWghiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxioMargTa9GPppZ0ACvzX4yjm2OdfrT8gShMed7ZWghiA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 04, 2021 at 11:43:58AM +0300, Amir Goldstein wrote:
> On Fri, Sep 3, 2021 at 5:14 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Now that we require all group names to be listed in doc/group-names.txt,
> > we can use that (instead of running mkgroupfile) to check if the group
> > name(s) supplied by the user actually exist.  This has the secondary
> > effect of being a second nudge towards keeping the description of groups
> > up to date.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  new |   24 +++++++++++-------------
> >  1 file changed, 11 insertions(+), 13 deletions(-)
> >
> >
> > diff --git a/new b/new
> > index 2097a883..6b7dc5d4 100755
> > --- a/new
> > +++ b/new
> > @@ -83,6 +83,14 @@ then
> >      exit 1
> >  fi
> >
> > +# Extract group names from the documentation.
> > +group_names() {
> > +       awk '/^[[:lower:][:digit:]_]/ {
> > +               if ($1 != "" && $1 != "Group" && $2 != "Name:" && $1 != "all")
> > +                       printf("%s\n", $1);
> > +       }' doc/group-names.txt
> > +}
> > +
> >  if [ $# -eq 0 ]
> >  then
> >
> > @@ -93,16 +101,7 @@ then
> >         [ -z "$ans" ] && ans=other
> >         if [ "X$ans" = "X?" ]
> >         then
> > -           for d in $SRC_GROUPS; do
> > -               (cd "tests/$d/" ; ../../tools/mkgroupfile "$tmpfile")
> > -               l=$(sed -n < "$tmpfile" \
> > -                   -e 's/#.*//' \
> > -                   -e 's/$/ /' \
> > -                   -e 's;\(^[0-9][0-9][0-9]\)\(.*$\);\2;p')
> > -               grpl="$grpl $l"
> > -           done
> > -           lst=`for word in $grpl; do echo $word; done | sort| uniq `
> > -           echo $lst
> > +           echo $(group_names)
> >         else
> >             # only allow lower cases, spaces, digits and underscore in group
> >             inval=`echo $ans | tr -d '[:lower:][:space:][:digit:]_'`
> > @@ -120,11 +119,10 @@ then
> >  else
> >      # expert mode, groups are on the command line
> >      #
> > -    (cd "$tdir" ; ../../tools/mkgroupfile "$tmpfile")
> >      for g in $*
> >      do
> > -       if ! grep -q "[[:space:]]$g" "$tmpfile"; then
> > -           echo "Warning: group \"$g\" not defined in $tdir tests"
> > +       if ! grep -q "^$g" doc/group-names.txt; then
> > +           echo "Warning: group \"$g\" not defined in documentation"
> >         fi
> 
> Do you want to warn (or fail) on new uses of the group "other"?

Yeah, I'll add a new patch on the end to do that.

--D

> Thanks,
> Amir.
