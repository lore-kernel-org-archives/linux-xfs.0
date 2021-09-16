Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68688C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 22:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BC961241
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 22:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbhIPWy2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 18:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241276AbhIPWy1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 18:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAE46120D;
        Thu, 16 Sep 2021 22:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631832786;
        bh=citTwsml1XSO/t1QTQ4k2wyZwIF8oGSYYQ6E9+rnQyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hW+vw2Lf1whk0SInRDqqLh14cZeFpoghVko0tE6jNEKRtvnbiAJOleWY6DsEvA5l7
         zaXtY2dERD1FpxR81bXcmtJzoQ1ms4p6qFVTRdhZVFx6Iz6AeruUz206BAjZpohfgN
         Bieh+RnINhWSV8ZeTV66fftfsyABbpxN1Nuyczh0k3oJkErQekaqivfHviBhh7ez1q
         BtDTd1mhgUrJ9QC++uld7Xnr2tQG3yPY+uGwrDD4sXiEfze9BOp6xpL/AfxeK/f9dP
         qslIOcsqS9/gdBqjGuv9GN78sVOEob+J9Y2TgrwqGccyJIZrdghLIY4cz9qzJ+W/0Z
         LRSO6aBmql8gQ==
Date:   Thu, 16 Sep 2021 15:53:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 9/9] new: don't allow new tests in group 'other'
Message-ID: <20210916225306.GB34846@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
 <163174940659.380880.14564845266535022734.stgit@magnolia>
 <CAOQ4uxh6fZNzCX2wAQdhmz4Z+4xGbZMF0zfSkKUZKjS0KZhpOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh6fZNzCX2wAQdhmz4Z+4xGbZMF0zfSkKUZKjS0KZhpOA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 09:40:54AM +0300, Amir Goldstein wrote:
> On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > The 'other' group is vaguely defined at best -- other than what?  It's
> > not clear what tests belong in this group, and it has become a dumping
> > ground for random stuff that are classified in other groups.  Don't let
> > people create new other group tests.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  new |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> >
> > diff --git a/new b/new
> > index 6b7dc5d4..5cf96c50 100755
> > --- a/new
> > +++ b/new
> > @@ -96,9 +96,9 @@ then
> >
> >      while true
> >      do
> > -       echo -n "Add to group(s) [other] (separate by space, ? for list): "
> > +       echo -n "Add to group(s) [auto] (separate by space, ? for list): "
> >         read ans
> > -       [ -z "$ans" ] && ans=other
> > +       [ -z "$ans" ] && ans=auto
> >         if [ "X$ans" = "X?" ]
> >         then
> >             echo $(group_names)
> > @@ -109,6 +109,9 @@ then
> >                 echo "Invalid characters in group(s): $inval"
> >                 echo "Only lower cases, digits and underscore are allowed in groups, separated by space"
> >                 continue
> > +           elif echo "$ans" | grep -q -w "other"; then
> > +               echo "Do not add more tests to group \"other\"."
> > +               continue
> 
> Should we also filter out "other" from group_names(), so it is not listed
> for "?"?

No; there are drawbacks to that, as you point out below.

> With this patch, "other" does not emit a warning when passed in as a script
> command line argument.

Done.

> If we filter "other" from group_names(), then the warning in "expert mode"
> will be a bit confusing (group "other" not defined in documentation).

I will filter it out in the specific case case that the interactive user
specified "?" to list the groups.

> Also, it is not clear to me if this is intentional behavior that interactive
> mode allows non-dcumented groups (with valid chars validation) and
> expert mode does not allow non-documented groups?

Probably not.

> It may be simpler to use the same helper in both modes (is_group_valid)
> to emit the correct warning and either proceed (expert mode) or get
> back to prompt (interactive mode).

This is getting farther afield from where I wanted this thing to go.
Very well, I'll split the ./new cleanups into its own series, but TBH
I've gotten tired of people asking for more and more cleanups out of me.

--D

> Thanks,
> Amir.
