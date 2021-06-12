Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB06C48BE5
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947DD613D9
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhFLAmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 20:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLAmj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 20:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06BC961278;
        Sat, 12 Jun 2021 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623458441;
        bh=9YTsBtyGsfzYK4VN0k8gh+KOqJdjBe+2khFwySXlnAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UlpN9OFHU23x7pjulq+tgArOsSDsvJ2qsISPG2KOImmzxd8ejyJmApei3Bq8ikDpE
         SPWJ1Yo3x9pLrCx8c60gw7tVrkFF92htquLvbvu2ViBVFK5ba7zNmitYat9fSfXX88
         rS/3Py8wUgnMiF05SlPYsU4776JC4UOSgnrH+WChFJQ1+j9acuJl9lRzmtXdejE9zg
         vhuijX8gqmrdsVYDEy88KC1CtSb4CTQyFzfKV1AvSeNm1rvU8u6ksAWwWA8sUfLCPy
         c8w0CweOoehJ3E60cBE0TczJIr2PuyypB7XTK9JqMYQwX4vcF9mLFuxtMddVbRDc7a
         eznthj/ZwksKw==
Date:   Fri, 11 Jun 2021 17:40:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
Message-ID: <20210612004040.GI2945738@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317280590.653489.10114638028601363399.stgit@locust>
 <YMP103PrnZC2QaE3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMP103PrnZC2QaE3@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 04:46:27PM -0700, Eric Biggers wrote:
> On Tue, Jun 08, 2021 at 10:20:05AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Convert the nextid script to use the automatic group file generation to
> > figure out the next available test id.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tools/nextid |    1 -
> >  tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+), 1 deletion(-)
> >  delete mode 120000 tools/nextid
> >  create mode 100755 tools/nextid
> > 
> > 
> > diff --git a/tools/nextid b/tools/nextid
> > deleted file mode 120000
> > index 5c31d602..00000000
> > --- a/tools/nextid
> > +++ /dev/null
> > @@ -1 +0,0 @@
> > -sort-group
> > \ No newline at end of file
> > diff --git a/tools/nextid b/tools/nextid
> > new file mode 100755
> > index 00000000..a65348e8
> > --- /dev/null
> > +++ b/tools/nextid
> > @@ -0,0 +1,39 @@
> > +#!/bin/bash
> > +
> > +# Compute the next available test id in a given test directory.
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
> > +	echo "Usage: $0 test_dir"
> > +	exit 1
> > +fi
> 
> [ $# != 1 ] would be simpler than [ -z "$1" ] || [ -n "$2" ].
> 
> > +line=0
> 
> The 'line' variable isn't needed.

Both fixed.

> 
> > +i=0
> > +eof=1
> > +
> > +while read found other_junk;
> > +do
> > +	line=$((line+1))
> > +	if [ -z "$found" ] || [ "$found" == "#" ]; then
> > +		continue
> > +	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
> > +		# this one is for tests not named by a number
> > +		continue
> > +	fi
> > +	i=$((i+1))
> > +	id=`printf "%03d" $i`
> > +	if [ "$id" != "$found" ]; then
> > +		eof=0
> > +		break
> > +	fi
> > +done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')
> 
> The first token matching $VALID_TEST_NAME already implies that it is non-empty
> and not "#".  Also, this could be handled by piping to grep:
> 
> while read found other_junk; do
> 	i=$((i+1))
> 	id=`printf "%03d" $i`
> 	if [ "$id" != "$found" ]; then
> 		eof=0
> 		break
> 	fi
> done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | \
>          grep "^$VALID_TEST_NAME\>" | tr - ' ')

I'm glad your regexfu is higher than mine.  Thanks for the suggestions!

--D

> 
> - Eric
