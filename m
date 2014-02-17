Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CF867F66
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 19:19:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1301AC05D
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:19:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UDdGSgMexSNGXAQm for <xfs@oss.sgi.com>;
	Sun, 16 Feb 2014 17:19:33 -0800 (PST)
Date: Mon, 17 Feb 2014 12:19:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: add regression test for btrfs incremental
	send
Message-ID: <20140217011929.GA13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392596438-6509-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392596438-6509-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 17, 2014 at 12:20:38AM +0000, Filipe David Borba Manana wrote:
> Test for a btrfs incremental send issue where we end up sending a
> wrong section of data from a file extent if the corresponding file
> extent is compressed and the respective file extent item has a non
> zero data offset.
> 
> Fixed by the following linux kernel btrfs patch:
> 
>    Btrfs: use right clone root offset for compressed extents
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
>     hole punch implementation leaving hole file extent items when we punch
>     beyond the file's current size.
> V3: Filter xfs_io output and make less use of the run_check function, as
>     suggested by Dave Chinner.

Awesome. Thanks for the quick turn around.

>  common/rc           |    5 +++
>  tests/btrfs/040     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/040.out |    9 ++++
>  tests/btrfs/group   |    1 +
>  4 files changed, 134 insertions(+)
>  create mode 100755 tests/btrfs/040
>  create mode 100644 tests/btrfs/040.out
> 
> diff --git a/common/rc b/common/rc
> index e91568b..27be009 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2207,6 +2207,11 @@ run_check()
>  	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>  }
>  
> +_run_btrfs_util_prog()
> +{
> +	run_check $BTRFS_UTIL_PROG $*
> +}

Can you do a cleanup of all the other btrfs tests that can use this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
