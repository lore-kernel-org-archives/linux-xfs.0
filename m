Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KFqbEZ017396 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 09:52:37 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] [RFC] xfstests: deprecate busted log printing tests
Date: Wed, 20 Jan 2010 09:53:27 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69A1@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1263967158-7685-1-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> Tests 018, 081 and 082 read the contents of the log and assume that the
> contents will always be the same. They are trying to ensure that the
> contents of the log don't change for a given fixed load.
> 
> This has several problems - high level changes to the filesystem and
> VFS code can change the order and contents of the log. Changes to
> the way we sync the filesystem will change the contents of the log.
> background writeback occurring in the middle of the test will change
> the contents of the log by allowing the tail to move. Even changes
> to the default mkfs parameters can break them!
> 
> The tests also assume that unmount leaves a dirty log behind. We've
> fixed lots of problems in sync and the unmount paths over recent
> times, so now a clean unmount leaves a clean log behind. That is,
> there is nothing left in the log print output for these tests to
> check. IOWs, major surgery is required for these tests to be
> returned to their former break-when-something-changes behaviour.
> 
> However, these tests are a maintenance nightmare. They spend more
> time broken and failing than they do passing, and then it's not long
> before they get broken again. They have to cover all sorts of
> different permutations of log configurations and that will continue
> to grow and increase the complexity of making these tests continue
> to work. And to top it all off, I can't remember a bug actually ever
> being found by these tests. Hence I think we should just stop using
> them altogether.
> 
> So this patch deprecates 018, 081 and 082 rather than fixes them.
> It introduces a "deprecated" test group and puts them in it. That
> means the tests can still be run on older systems where they may
> have some use, but will not be run automatically any more, nor
> will any attempt be made to keep them up to date or working.

I think this is a reasonable thing to do.  My only thought
is that it might be good to somehow indicate *when* or *why*
something got deprecated.  I.e., suppose a new feature BLAH_ASYNC
makes a test no longer produce output in a well-defined order.
It might be nice if, along with "deprecated" it was somehow
indicated that the absense of BLAH_ASYNC allows the test to
still function.

Having said that, it sounds too complicated to me.  If it
becomes a real issue we can address it, for starters by just
documenting it in the comments or something.

					-Alex


> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  group |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/group b/group
> index 3de9354..342ac89 100644
> --- a/group
> +++ b/group
> @@ -104,6 +104,10 @@ atime
>  # Test preallocation calls
>  prealloc
> 
> +# Old tests that we won't spend any effort trying to run and make work
> +# on current systems
> +deprecated
> +
>  #
>  # test-group association ... one line per test
>  #
> @@ -124,7 +128,7 @@ prealloc
>  015 other auto quick
>  016 rw auto quick
>  017 mount auto quick
> -018 log logprint v2log auto quick
> +018 deprecated # log logprint v2log
>  019 mkfs auto quick
>  020 metadata attr udf auto quick
>  021 db attr auto quick
> @@ -187,8 +191,8 @@ prealloc
>  078 growfs auto quick
>  079 acl attr ioctl metadata auto quick
>  080 rw ioctl
> -081 log logprint quota auto quick
> -082 log logprint v2log auto quick
> +081 deprecated # log logprint quota
> +082 deprecated # log logprint v2log
>  083 rw auto
>  084 ioctl rw auto
>  085 log auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
