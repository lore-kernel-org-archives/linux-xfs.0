Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F8AC636CB
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 16:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62ED8611AF
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 16:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhGRQ0r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 12:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGRQ0r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 18 Jul 2021 12:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F8CD60249;
        Sun, 18 Jul 2021 16:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626625429;
        bh=tXJr7/BabasvXaOarr67pBHCN1aihmCrWWxT8krj1ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O5jsWd7HvJaJGXpY3pI/BdgP9DAv1Gpi3JokWc0SAb0w3jfpFWrumjNT2aNuVkM/S
         M778uiHtcYJ9A4QqlWNVnzFWzbGefaptkSn6J3I/QHuR2nX8UpSVez8tbYAt0eF42m
         scvuobeMr+obvXBEY1k9LffI1Z+8kIZsS0+5edTA7Si8Xy7x6fiQCBdQa+ZSQ5+9q5
         x8igyppQ1FiBFzToFqBK4uFNUKxlLdo7tR0rMX4Tb0vFaRUQ3CaM1o9Cdb5UW3dO2m
         aFLmqspGCADz4xIQ0frsjMIwckCz8juyqoubcagA8dqXKGw/FMzPNLpzOLsSvyLBU/
         qC9CHSp5a7k9Q==
Date:   Sun, 18 Jul 2021 09:23:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] new: allow users to specify a new test id
Message-ID: <20210718162347.GZ22402@magnolia>
References: <162561725931.543346.16210906692072836195.stgit@locust>
 <162561726493.543346.17291318180978776290.stgit@locust>
 <YPQzOiqnugT4MeNq@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPQzOiqnugT4MeNq@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 18, 2021 at 09:57:14PM +0800, Eryu Guan wrote:
> On Tue, Jul 06, 2021 at 05:21:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Alter the ./new script so that one can set the test id explicitly.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Looks good to me. Mind updating the usage info as well?

Will do and resubmit.  Thanks for reviewing the rest of the patches. :)

--D

> 
> Thanks,
> Eryu
> 
> > ---
> >  new |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/new b/new
> > index 07144399..51111f08 100755
> > --- a/new
> > +++ b/new
> > @@ -26,7 +26,18 @@ usage()
> >  }
> >  
> >  [ $# -eq 0 ] && usage
> > -tdir=tests/$1
> > +
> > +if echo "$1" | grep -q '/'; then
> > +	if [ -e "tests/$1" ]; then
> > +		echo "$1: test already exists."
> > +		exit 1
> > +	fi
> > +	tdir="tests/$(echo "$1" | cut -d '/' -f 1)"
> > +	id="$(echo "$1" | cut -d '/' -f 2)"
> > +else
> > +	tdir=tests/$1
> > +	id="$(basename "$(./tools/nextid "$1")")"
> > +fi
> >  
> >  i=0
> >  line=0
> > @@ -36,7 +47,6 @@ eof=1
> >  export AWK_PROG="$(type -P awk)"
> >  [ "$AWK_PROG" = "" ] && { echo "awk not found"; exit; }
> >  
> > -id="$(basename "$(./tools/nextid "$1")")"
> >  echo "Next test id is $id"
> >  shift
> >  
