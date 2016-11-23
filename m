Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935134AbcKWKdZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Nov 2016 05:33:25 -0500
Date: Wed, 23 Nov 2016 18:33:23 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/3] generic/182: retain existing btrfs behavior when len
 == 0
Message-ID: <20161123103323.GG12442@eguan.usersys.redhat.com>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Nov 22, 2016 at 06:10:54PM -0800, Darrick J. Wong wrote:
> Since btrfs doesn't interpret len=0 as "go to EOF", test for that instead.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/182     |    3 ++-
>  tests/generic/182.out |    2 --
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/tests/generic/182 b/tests/generic/182
> index f484399..dacb989 100755
> --- a/tests/generic/182
> +++ b/tests/generic/182
> @@ -1,7 +1,8 @@
>  #! /bin/bash
>  # FS QA Test No. 182
>  #
> -# Test the convention that dedupe with length == 0 means "to the end of fileA"
> +# Test the convention that dedupe with length == 0 doesn't mean "to the end of
> +# fileA"

If I read the xfs patch and btrfs RFC patch thread correctly, 0 length
means do nothing, right? Should we make it more clear and specific in
the comments instead of "doesn't mean..."? I think that helps people
understand the test.

>  #   - Create a file.
>  #   - Try to dedupe "zero" bytes (which means dedupe to EOF).
>  #   - Check that the dedupe happened.

These comments need fixes too.

Thanks,
Eryu

> diff --git a/tests/generic/182.out b/tests/generic/182.out
> index 049a3ee..9841b76 100644
> --- a/tests/generic/182.out
> +++ b/tests/generic/182.out
> @@ -1,12 +1,10 @@
>  QA output created by 182
>  Create the original files
> -dedupe: Extents did not match.
>  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
>  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
>  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
>  Compare against check files
>  Make the original file almost dedup-able
> -dedupe: Extents did not match.
>  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
>  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
>  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk
> 
