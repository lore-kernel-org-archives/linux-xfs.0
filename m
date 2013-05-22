Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4691C7F52
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:10:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7425AC002
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 07:10:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pJ334kX6JKjfdpPq for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 07:10:32 -0700 (PDT)
Message-ID: <519CD1D9.8050904@sandeen.net>
Date: Wed, 22 May 2013 09:10:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: generic/258 questions (mount issue)...
References: <519C14A1.8000009@gmail.com> <20130522012620.GA29466@dastard>
	<519C3596.7080109@gmail.com>
In-Reply-To: <519C3596.7080109@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 5/21/13 10:03 PM, Michael L. Semon wrote:

...

> From 7dc0667e1f8cd1c98f15ebf412dd0f038b55306e Mon Sep 17 00:00:00 2001
> From: "Michael L. Semon" <mlsemon35@gmail.com>
> Date: Tue, 21 May 2013 22:50:59 -0400
> Subject: [PATCH] Change mount method for generic/258
> 
> Use the built-in _test_mount function from xfstests so it will use
> the correct mount options for xfstests.  The script used a simple
> umount-and-mount sequence, which caused a test failure on an XFS
> filesystem that used both realtime and external log devices.
> 
> Signed-off-by: Michael L. Semon <mlsemon35@gmail.com>

Thanks, this was my fault  :(

Reviewed-by: Eric Sandeen <sandeen@rehat.com>

Want to consider dave's other suggestions in another patch?

> There are a handful of other tests that also unmount the TEST_DEV.
> Perhaps adding a _test_umount() wrapper to common/rc (similar to
> _scratch_umount) would be best. At least shared/243 needs the same
> _test_mount treatment as this test.

Eternal git-log fame would be yours.  ;)

-Eric

> ---
>  tests/generic/258 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/258 b/tests/generic/258
> index fb091ae..3aeb5ce 100755
> --- a/tests/generic/258
> +++ b/tests/generic/258
> @@ -62,7 +62,7 @@ fi
>  # unmount, remount, and check the timestamp
>  echo "Remounting to flush cache"
>  umount $TEST_DEV
> -mount $TEST_DEV $TEST_DIR
> +_test_mount
>  
>  # Should yield -315593940 (prior to epoch)
>  echo "Testing for negative seconds since epoch"
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
