Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD65C07E9C
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jul 2021 01:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107A6613D0
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jul 2021 01:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhGJB1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 21:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhGJB1x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 21:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26C8161261;
        Sat, 10 Jul 2021 01:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625880309;
        bh=bv/G+g2o3FYnqlYs42+HT7mvywNUHIGlB53nAi3zoN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hS7m2UVB89fALNy7sE+73UEJCY/TqmKvITZjuW+BzydXtBmNOrh3JybQjv5cYDrAh
         EWbRLCnzblXPyX/O5h+7a6mO2iNLIrB9btUGwgs72H2/VHLwNjuWcWuFpPop2DVghx
         Gd3qHDLKyBHiKzCgEuyXhm1JECc9xs2MxW/ynQdgewJtSpnbylapMgZxmuZGlEWtIf
         tSK2ZVmIoZnXh+K2w/HOGn2TjjnBE7yLP43m6jLmEp2goGNkE4rVqAwsGB7CAdCooH
         9BJ4WsY4/+dZj8DcgIZsHS8mSMpPEX9Qkkbkb8WDQpXxdrEdgaVR49YehBBVQGKiOr
         2+mN1GDz7ZFxQ==
Date:   Fri, 9 Jul 2021 18:25:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/8] generic/561: hide assertions when duperemove is
 killed
Message-ID: <20210710012508.GA11588@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561727795.543423.1496821526582808789.stgit@locust>
 <e600bbe5-1914-5f93-aec8-bab97b16c732@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e600bbe5-1914-5f93-aec8-bab97b16c732@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 09, 2021 at 04:38:46PM -0700, Allison Henderson wrote:
> 
> 
> On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Use some bash redirection trickery to capture in $seqres.full all of
> > bash's warnings about duperemove being killed due to assertions
> > triggering.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   tests/generic/561 |    9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/561 b/tests/generic/561
> > index bfd4443d..85037e50 100755
> > --- a/tests/generic/561
> > +++ b/tests/generic/561
> > @@ -62,8 +62,13 @@ dupe_run=$TEST_DIR/${seq}-running
> >   touch $dupe_run
> >   for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
> >   	while [ -e $dupe_run ]; do
> > -		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
> > -			>>$seqres.full 2>&1
> > +		# Employ shell trickery here so that the golden output does not
> nit:
> I think I'd be more more specific with the commentary:
> 
>                 # We run cmd in a bash shell so that the golden output ...

Ok, fixed.

--D

> > +		# capture assertions that trigger when killall shoots down
> > +		# dupremove processes in an arbitrary order, which leaves the
> > +		# memory in an inconsistent state long enough for the assert
> > +		# to trip.
> > +		cmd="$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir"
> > +		bash -c "$cmd" >> $seqres.full 2>&1
> >   	done 2>&1 | sed -e '/Terminated/d' &
> >   	dedup_pids="$! $dedup_pids"
> >   done
> > 
> Otherwise looks fine to me
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
