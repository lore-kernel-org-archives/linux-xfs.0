Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CB3C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 16:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiCVQNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiCVQNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 12:13:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50927FE6;
        Tue, 22 Mar 2022 09:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 679FFB81BC2;
        Tue, 22 Mar 2022 16:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AD9C340EC;
        Tue, 22 Mar 2022 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647965498;
        bh=pm3yS6AevpP/elbmng5+vBEXdNLzYAR494GuITiaAyU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=hLvXOvBHlv4fZF0QiSMb2NSAxBif3awaSgxj9+DkUlTwsT+eoTvF8p2M/x1mPOVPg
         SKkNqHYhKM3gMwwG9aO+0l3wN4vnJU1CJIEFz1MZQqIdiZCjInpRe6VEIf4Wt1Kp3g
         xS4H7irJXsH3ZMwlrAs18ETDYDDt5xf1ZDsxz/JhCLgysdXr84f/aWsckY5aZVo6cQ
         CobGccYCC5rcaGVdI6KVu8HAsIxZYLjnmX4O2JZUPtUdi6EqzSsiTTbvZVMfhePF4F
         tPsPbGOZqx/fOLpVToQsu/GDlD8jLXHkgPJecY21+0o3Ro9uiDO+T9Cov+eGfi2yYI
         Ve56P9MwVinIw==
Date:   Tue, 22 Mar 2022 09:11:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/4] xfs/17[035]: fix intermittent failures when
 filesystem metadata gets large
Message-ID: <20220322161137.GO8200@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
 <20220316221326.GF8200@magnolia>
 <20220322071556.6iajo57ilyalwfdi@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322071556.6iajo57ilyalwfdi@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 03:15:56PM +0800, Zorro Lang wrote:
> On Wed, Mar 16, 2022 at 03:13:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > These tests check that the filestreams allocator never shares an AG
> > across multiple streams when there's plenty of space in the filesystem.
> > Recent increases in metadata overhead for newer features (e.g. bigger
> > logs due to reflink) can throw this off, so add another AG to the
> > formatted filesystem to encourage it to avoid the AG with the log.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> 
> 
> >  common/filestreams |    2 +-
> >  tests/xfs/170      |   16 +++++++++++-----
> >  tests/xfs/170.out  |    8 ++++----
> >  tests/xfs/171      |   16 ++++++++++++----
> >  tests/xfs/171.out  |    8 ++++----
> >  tests/xfs/173      |   16 ++++++++++++----
> >  tests/xfs/173.out  |    8 ++++----
> 
> Looks good to me, and test passed after merging this patch. Just one
> tiny question, the subject is "xfs/17[035]: ...", if "17[035]" mean
> 170, 173 and 175, but the files you changed are 170, 171 and 173 as
> above :)

oops.  Clearly I suck at regex. :(

Subject: xfs/17*: fix filestreams test failures when...

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> 
> 
> >  7 files changed, 48 insertions(+), 26 deletions(-)
> > 
> > diff --git a/common/filestreams b/common/filestreams
> > index 8165effe..62acb47c 100644
> > --- a/common/filestreams
> > +++ b/common/filestreams
> > @@ -80,7 +80,7 @@ _check_for_dupes()
> >  
> >  _test_streams() {
> >  
> > -	echo "# testing $* ...."
> > +	echo "# testing $* ...." | tee -a $seqres.full
> >  	local agcount="$1"
> >  	local agsize="$2" # in MB
> >  	local stream_count="$3"
> > diff --git a/tests/xfs/170 b/tests/xfs/170
> > index 5e622d24..b9ead341 100755
> > --- a/tests/xfs/170
> > +++ b/tests/xfs/170
> > @@ -25,11 +25,17 @@ _check_filestreams_support || _notrun "filestreams not available"
> >  # test small stream, multiple I/O per file, 30s timeout
> >  _set_stream_timeout_centisecs 3000
> >  
> > -# test streams does a mkfs and mount
> > -_test_streams 8 22 4 8 3 0 0
> > -_test_streams 8 22 4 8 3 1 0
> > -_test_streams 8 22 4 8 3 0 1
> > -_test_streams 8 22 4 8 3 1 1
> > +# This test checks that the filestreams allocator never allocates space in any
> > +# given AG into more than one stream when there's plenty of space on the
> > +# filesystem.  Newer feature sets (e.g. reflink) have increased the size of
> > +# the log for small filesystems, so we make sure there's one more AG than
> > +# filestreams to encourage the allocator to skip whichever AG owns the log.
> > +#
> > +# Exercise 9x 22MB AGs, 4 filestreams, 8 files per stream, and 3MB per file.
> > +_test_streams 9 22 4 8 3 0 0
> > +_test_streams 9 22 4 8 3 1 0
> > +_test_streams 9 22 4 8 3 0 1
> > +_test_streams 9 22 4 8 3 1 1
> >  
> >  status=0
> >  exit
> > diff --git a/tests/xfs/170.out b/tests/xfs/170.out
> > index e71515e9..16dcb795 100644
> > --- a/tests/xfs/170.out
> > +++ b/tests/xfs/170.out
> > @@ -1,20 +1,20 @@
> >  QA output created by 170
> > -# testing 8 22 4 8 3 0 0 ....
> > +# testing 9 22 4 8 3 0 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 22 4 8 3 1 0 ....
> > +# testing 9 22 4 8 3 1 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 22 4 8 3 0 1 ....
> > +# testing 9 22 4 8 3 0 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 8 22 4 8 3 1 1 ....
> > +# testing 9 22 4 8 3 1 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> > diff --git a/tests/xfs/171 b/tests/xfs/171
> > index 4412fe2f..f93b6011 100755
> > --- a/tests/xfs/171
> > +++ b/tests/xfs/171
> > @@ -29,10 +29,18 @@ _check_filestreams_support || _notrun "filestreams not available"
> >  # 100 = 78.1% full, should reliably succeed
> >  _set_stream_timeout_centisecs 12000
> >  
> > -_test_streams 64 16 8 100 1 1 0
> > -_test_streams 64 16 8 100 1 1 1
> > -_test_streams 64 16 8 100 1 0 0
> > -_test_streams 64 16 8 100 1 0 1
> > +# This test tries to get close to the exact point at which the filestreams
> > +# allocator will start to allocate space from some AG into more than one
> > +# stream.  Newer feature sets (e.g. reflink) have increased the size of the log
> > +# for small filesystems, so we make sure there's one more AG than filestreams
> > +# to encourage the allocator to skip whichever AG owns the log.
> > +#
> > +# This test exercises 64x 16MB AGs, 8 filestreams, 100 files per stream, and
> > +# 1MB per file.
> > +_test_streams 65 16 8 100 1 1 0
> > +_test_streams 65 16 8 100 1 1 1
> > +_test_streams 65 16 8 100 1 0 0
> > +_test_streams 65 16 8 100 1 0 1
> >  
> >  status=0
> >  exit
> > diff --git a/tests/xfs/171.out b/tests/xfs/171.out
> > index 89407cb2..73f73c90 100644
> > --- a/tests/xfs/171.out
> > +++ b/tests/xfs/171.out
> > @@ -1,20 +1,20 @@
> >  QA output created by 171
> > -# testing 64 16 8 100 1 1 0 ....
> > +# testing 65 16 8 100 1 1 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 64 16 8 100 1 1 1 ....
> > +# testing 65 16 8 100 1 1 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 64 16 8 100 1 0 0 ....
> > +# testing 65 16 8 100 1 0 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 64 16 8 100 1 0 1 ....
> > +# testing 65 16 8 100 1 0 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> > diff --git a/tests/xfs/173 b/tests/xfs/173
> > index bce6ac51..6b18d919 100755
> > --- a/tests/xfs/173
> > +++ b/tests/xfs/173
> > @@ -26,10 +26,18 @@ _check_filestreams_support || _notrun "filestreams not available"
> >  # be less than or equal to half the AG count so we don't run out of AGs.
> >  _set_stream_timeout_centisecs 12000
> >  
> > -_test_streams 64 16 33 8 2 1 1 fail
> > -_test_streams 64 16 32 8 2 0 1
> > -_test_streams 64 16 33 8 2 0 0 fail
> > -_test_streams 64 16 32 8 2 1 0
> > +# This test checks the exact point at which the filestreams allocator will
> > +# start to allocate space from some AG into more than one stream.  Newer
> > +# feature sets (e.g. reflink) have increased the size of the log for small
> > +# filesystems, so we make sure there's one more AG than filestreams to
> > +# encourage the allocator to skip whichever AG owns the log.
> > +#
> > +# Exercise 65x 16MB AGs, 32/33 filestreams, 8 files per stream, and 2MB per
> > +# file.
> > +_test_streams 65 16 34 8 2 1 1 fail
> > +_test_streams 65 16 32 8 2 0 1
> > +_test_streams 65 16 34 8 2 0 0 fail
> > +_test_streams 65 16 32 8 2 1 0
> >  
> >  status=0
> >  exit
> > diff --git a/tests/xfs/173.out b/tests/xfs/173.out
> > index 21493057..705c352a 100644
> > --- a/tests/xfs/173.out
> > +++ b/tests/xfs/173.out
> > @@ -1,20 +1,20 @@
> >  QA output created by 173
> > -# testing 64 16 33 8 2 1 1 fail ....
> > +# testing 65 16 34 8 2 1 1 fail ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + expected failure, matching AGs
> > -# testing 64 16 32 8 2 0 1 ....
> > +# testing 65 16 32 8 2 0 1 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + passed, streams are in seperate AGs
> > -# testing 64 16 33 8 2 0 0 fail ....
> > +# testing 65 16 34 8 2 0 0 fail ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> >  + expected failure, matching AGs
> > -# testing 64 16 32 8 2 1 0 ....
> > +# testing 65 16 32 8 2 1 0 ....
> >  # streaming
> >  # sync AGs...
> >  # checking stream AGs...
> > 
> 
