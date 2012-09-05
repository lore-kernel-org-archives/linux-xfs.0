Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85MPkd3146216 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 17:25:46 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	J0xml6GhfBGEeMVa for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 15:26:44 -0700 (PDT)
Date: Thu, 6 Sep 2012 08:26:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/10] xfstests: rework large filesystem testing - add
	golden output
Message-ID: <20120905222641.GJ15292@dastard>
References: <20120831194326.741195404@sgi.com>
	<1343291989-14987-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Fri, Aug 31, 2012 at 02:43:27PM -0500, rjohnston@sgi.com wrote:
> Patch "rework large filesystem testing" introduces a new option --large-fs
> which creates a new file $SCRATCH_MNT/.use_space.  If this 10 part patchset is
> applied, the following tests will fail:
> 	019 026 027 028 046 047 050 056 059 060 062 063 064 065 066

That's a lot more tests than I see failing. 

> This patch accounts for the following new output when testing xfs filesystems with
> the --large-fs option by creating new output file to compare against
> ($seq.largefs.out):

Creating new output files is the absolute last resort.  Indeed, what
happens when you get different output for tests that already select
an output file based on, say, platform or some other criteria? We
get a combinatorial explosion of golden output files, and that is
simply not manageable.

The usual thing to do is update the necessary filters or change the
way the tests run to avoid trivial output file differences e.g. use
a subdir rather than SCRATCH_MNT directly. Or, for example the
filters that munge different standard error messages from different
platforms to be the same...

> 1. The following four lines appear in test 019. 
> 	 File: "./.use_space"
> 	 Size: 6312890368 Filetype: Regular File
> 	Mode: (0600/-rw-------) Uid: (0) Gid: (0)
> 	Device: <DEVICE> Inode: <INODE> Links: 1

This test doesn't really need to be run for large filesystems -
running it on large filesystems doesn't improve the coverage of or
our confidence in the code it is testing, so I'd just add a
_require_no_large_scratch_dev to it.

> 2. When the nodump attribute is set, the xfsdump -e option will cause the
>    following additional lines to appear.
> 	xfsdump: NOTE: pruned 1 files: skip attribute set
> 	Only in SCRATCH_MNT: .use_space
> 	SCRATCH_MNT/.use_space

Ok, those are the errors I haven't seen - not sure why. I'll have to
look into that.

However, this is definitely a case of updating the dump output
filter to remove these messages from the output stream.  The
alternative is to change the common dump code to use a subdirectory
rather than the root directory so it doesn't see these files at all.

> 3. Number of files off by one.
> 	xfsrestore: # directories and (off by 1) entries processed

That would be fixed by using a subdir for the dump tests. I don't
recommend that the number should be filtered, as having dump report
the correct number of files scanned is important.

> 	[ROOT] 0 0 0 00 [--------] (off by 1) 0 0 00 [--------] 0 0 0 00 [--------]

Perhaps the usre/group of the use_space file needs to be changed so
it doesn't impact on the test results. Alternatively, a filter could
be written/modified to fix the number appropriately.

> This patch also modifies check and common.quota to use the new output file
> $seq.largefs.out when the --large-fs option is used (LARGE_SCRATCH_DEV = yes)
> or  $seq.out when the --large-fs option is NOT used (LARGE_SCRATCH_DEV != yes).
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  019.largefs.out |    5 +++
>  026.largefs.out |    4 ++-
>  027.largefs.out |    2 -
>  028.largefs.out |    5 +++
>  046.largefs.out |    3 +-
>  047.largefs.out |    5 +++
>  050.largefs.out |   72 ++++++++++++++++++++++++++++----------------------------
>  056.largefs.out |    3 +-
>  059.largefs.out |    2 +
>  060.largefs.out |    4 ++-
>  062.largefs.out |    2 +
>  063.largefs.out |    3 +-
>  064.largefs.out |   41 ++++++++++++++++---------------
>  065.largefs.out |   29 +++++++++++-----------
>  066.largefs.out |    3 +-
>  check           |   12 +++++++--
>  common.quota    |   20 ++++++++++-----
>  17 files changed, 128 insertions(+), 87 deletions(-)

FWIW, this patch is supposed to add these *.largefs.out files, right? The
patch, however:

> Index: b/019.largefs.out
> ===================================================================
> --- a/019.largefs.out
> +++ b/019.largefs.out
> @@ -9,6 +9,11 @@ Wrote 2048.00Kb (value 0x2c)
>   Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
>  Device: <DEVICE> Inode: <INODE> Links: 3 
>  
> + File: "./.use_space"
> + Size: 6312890368 Filetype: Regular File
> + Mode: (0600/-rw-------) Uid: (0) Gid: (0)
> +Device: <DEVICE> Inode: <INODE> Links: 1
> +
>   File: "./bigfile"
>   Size: 2097152 Filetype: Regular File
>   Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)

... assumes they already exist...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
