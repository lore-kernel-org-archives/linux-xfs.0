Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AAEC48BE6
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA3561356
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbhFNUvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 16:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235672AbhFNUvU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 16:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F371F6124B;
        Mon, 14 Jun 2021 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623703757;
        bh=zV0dqEAohcnqRJ8+DZGQOARf3CoDmFOSm1/UEz8Yc70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rg1d15cUPB+5xJvLHi1GSCnd9551UnSDW+jKmsUVFPCQv6P51rfduRJiUVKl2TtAj
         v85aZTaseyn6avHBh7scotDj4Hv6AjY8leueT49wA3hhY9lY2WRnRqvbBlmlUoEDOq
         yM1OIPRbfEg5OhLCqxJLUFqC6gBreN7infxuHd1qHkw/RK557kLaPm5R5lSpjlb9MJ
         Byzs5I4+DhV3Hc2icQcDYj6A310ywaIPhdGKgRRtl+botZTR5jUOS5E7mwx64n41FL
         iTspObYrZDRb8v1D+j9bpb8lXOLFg5Cm2+rB2AgO0uJe1J3ZhT1WuQ+FWw5kin2Ni3
         TeVNZ1tXsMtkg==
Date:   Mon, 14 Jun 2021 13:49:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 13/13] misc: update documentation to reflect
 auto-generated group files
Message-ID: <20210614204916.GB2945720@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317283324.653489.9381968524443830077.stgit@locust>
 <6638e618-3d97-a403-311c-941de3db6320@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6638e618-3d97-a403-311c-941de3db6320@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 12:39:46PM -0700, Allison Henderson wrote:
> 
> 
> On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update the documentation to outline the new requirements for test files
> > so that we can generate group files during build.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Ok, that sounds about right
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Thanks to you and Eric and Chandan for reviewing this!

--D

> 
> > ---
> >   README |   19 ++++++++++++++++---
> >   1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/README b/README
> > index 048491a6..ab298ca9 100644
> > --- a/README
> > +++ b/README
> > @@ -140,7 +140,8 @@ Running tests:
> >       - ./check '*/001' '*/002' '*/003'
> >       - ./check '*/06?'
> >       - Groups of tests maybe ran by: ./check -g [group(s)]
> > -      See the 'group' file for details on groups
> > +      See the tests/*/group.list files after building xfstests to learn about
> > +      each test's group memberships.
> >       - If you want to run all tests regardless of what group they are in
> >         (including dangerous tests), use the "all" group: ./check -g all
> >       - To randomize test order: ./check -r [test(s)]
> > @@ -174,8 +175,8 @@ Test script environment:
> >       When developing a new test script keep the following things in
> >       mind.  All of the environment variables and shell procedures are
> > -    available to the script once the "common/rc" file has been
> > -    sourced.
> > +    available to the script once the "common/preamble" file has been
> > +    sourced and the "_begin_fstest" function has been called.
> >        1. The tests are run from an arbitrary directory.  If you want to
> >   	do operations on an XFS filesystem (good idea, eh?), then do
> > @@ -249,6 +250,18 @@ Test script environment:
> >   	  in the ./new script. It can contain only alphanumeric characters
> >   	  and dash. Note the "NNN-" part is added automatically.
> > +     6. Test group membership: Each test can be associated with any number
> > +	of groups for convenient selection of subsets of tests.  Test names
> > +	can be any sequence of non-whitespace characters.  Test authors
> > +	associate a test with groups by passing the names of those groups as
> > +	arguments to the _begin_fstest function:
> > +
> > +	_begin_fstest auto quick subvol snapshot
> > +
> > +	The build process scans test files for _begin_fstest invocations and
> > +	compiles the group list from that information.  In other words, test
> > +	files must call _begin_fstest or they will not be run.
> > +
> >   Verified output:
> >       Each test script has a name, e.g. 007, and an associated
> > 
