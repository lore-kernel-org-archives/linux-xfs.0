Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79631C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C68164E7D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBKRao (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 12:30:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhBKR2t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 12:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364DE61493;
        Thu, 11 Feb 2021 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613064487;
        bh=2dU4Fvykv/3aU3OZgrTPyiKys+ZkrSJtdCPOQTjJAkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CMLqCoPY3Z43NP5+4fWW8CYLhDWHTLPl3TK/3CR+9Rp3rUujw5HTGwH8WUWh2xI0X
         OgWlR8OuAhNhcr06YkeL6iQIXtH1IGCXuHyO7ZBj1GfV6HIi+u0EwHt+J7hwZTXIAZ
         gR8cAEaU8ikpd5A82jvvxqyR/W2+GGOvGJ8lN1Gc53yk37A4sJEohU350BF8JJSSOB
         3IulsQA+7ILKgQByNwA/dtYZQzYFpwTBtAWf0tDfUlGpXhJLd5mTmzND9w/YMHM1EL
         YhO1Cpx6BxjRZf/VIvVQzEK1fS2xdG7/k4mI2XHCHtFrU55TZoLQekqcOh/4XBQ/44
         6ZxOwV3tqHCsg==
Date:   Thu, 11 Feb 2021 09:28:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/6] check: run tests in exactly the order specified
Message-ID: <20210211172806.GJ7190@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292580772.3504537.14460569826738892955.stgit@magnolia>
 <20210211140045.GE222065@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211140045.GE222065@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 09:00:45AM -0500, Brian Foster wrote:
> On Tue, Feb 09, 2021 at 06:56:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Introduce a new --exact-order switch to disable all sorting, filtering
> > of repeated lines, and shuffling of test order.  The goal of this is to
> > be able to run tests in a specific order, namely to try to reproduce
> > test failures that could be the result of a -r(andomize) run getting
> > lucky.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  check |   36 ++++++++++++++++++++++++++++--------
> >  1 file changed, 28 insertions(+), 8 deletions(-)
> > 
> > 
> > diff --git a/check b/check
> > index 6f8db858..106ec8e1 100755
> > --- a/check
> > +++ b/check
> ...
> > @@ -249,17 +251,22 @@ _prepare_test_list()
> >  		trim_test_list $list
> >  	done
> >  
> > -	# sort the list of tests into numeric order
> > -	if $randomize; then
> > -		if type shuf >& /dev/null; then
> > -			sorter="shuf"
> > +	# sort the list of tests into numeric order unless we're running tests
> > +	# in the exact order specified
> > +	if ! $exact_order; then
> > +		if $randomize; then
> > +			if type shuf >& /dev/null; then
> > +				sorter="shuf"
> > +			else
> > +				sorter="awk -v seed=$RANDOM -f randomize.awk"
> > +			fi
> >  		else
> > -			sorter="awk -v seed=$RANDOM -f randomize.awk"
> > +			sorter="cat"
> >  		fi
> > +		list=`sort -n $tmp.list | uniq | $sorter`
> >  	else
> > -		sorter="cat"
> > +		list=`cat $tmp.list`
> 
> Do we want to still filter out duplicates (i.e. uniq) in exact order
> mode? LGTM either way:

I figure --exact-order means to run exactly what the user specified,
duplicates and all.

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  	fi
> > -	list=`sort -n $tmp.list | uniq | $sorter`
> >  	rm -f $tmp.list
> >  }
> >  
> > @@ -304,7 +311,20 @@ while [ $# -gt 0 ]; do
> >  	-udiff)	diff="$diff -u" ;;
> >  
> >  	-n)	showme=true ;;
> > -        -r)	randomize=true ;;
> > +	-r)
> > +		if $exact_order; then
> > +			echo "Cannot specify -r and --exact-order."
> > +			exit 1
> > +		fi
> > +		randomize=true
> > +		;;
> > +	--exact-order)
> > +		if $randomize; then
> > +			echo "Cannnot specify --exact-order and -r."
> > +			exit 1
> > +		fi
> > +		exact_order=true
> > +		;;
> >  	-i)	iterations=$2; shift ;;
> >  	-T)	timestamp=true ;;
> >  	-d)	DUMP_OUTPUT=true ;;
> > 
> 
